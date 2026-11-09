import 'package:flutter/material.dart';

import '../panduan_style.dart';

/// Kartu menu accordion (Figma 369x60, radius 23):
/// Berisi baris judul (ikon, judul, deskripsi, chevron berputar)
/// dan konten anak [child] yang tampil di bawahnya saat dibuka.
class PanduanMenuCard extends StatefulWidget {
  const PanduanMenuCard({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.description,
    this.child,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
  });

  final String iconAsset;
  final String title;
  final String description;
  final Widget? child;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<PanduanMenuCard> createState() => _PanduanMenuCardState();
}

class _PanduanMenuCardState extends State<PanduanMenuCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onExpansionChanged?.call(_isExpanded);
    if (_isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.05,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(23));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Semantics(
        container: true,
        button: true,
        label: widget.title,
        hint: _isExpanded ? 'Buka, ketuk untuk menutup' : widget.description,
        excludeSemantics: true,
        onTap: _toggleExpanded,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: PanduanStyle.cardBorder),
            gradient: const LinearGradient(
              begin: Alignment(-0.7, -0.7), // linear-gradient 135deg
              end: Alignment(0.7, 0.7),
              colors: [Colors.white, Color(0xFFFAFCFF)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(54, 131, 226, 0.03),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header kartu (selalu terlihat)
                InkWell(
                  borderRadius: _isExpanded
                      ? const BorderRadius.vertical(top: Radius.circular(23))
                      : radius,
                  onTap: _toggleExpanded,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Image.asset(
                            widget.iconAsset,
                            width: 38,
                            height: 38,
                            fit: BoxFit.contain,
                            excludeFromSemantics: true,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3, bottom: 3),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: PanduanStyle.menuTitle,
                                  ),
                                  const SizedBox(height: 3),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 223,
                                    ),
                                    child: Text(
                                      widget.description,
                                      style: PanduanStyle.menuDescription,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 14),
                            child: AnimatedRotation(
                              turns: _isExpanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 24,
                                color: PanduanStyle.chevronBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Isi kartu accordion (terbuka di bawah header)
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: _isExpanded && widget.child != null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: PanduanStyle.cardBorder,
                              indent: 20,
                              endIndent: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                14,
                                16,
                                16,
                              ),
                              child: widget.child!,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
