import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../domain/model/cake_category.dart';
import '../home_page/home_page.dart';

import 'dart:ui';

class CatalogMasonryPage extends StatelessWidget {
  const CatalogMasonryPage({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<CakeCatalogItem> items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 1200
        ? 80.0
        : width >= 800
        ? 32.0
        : 16.0;

    int crossAxisCount = 3;
    if (width < 1100) crossAxisCount = 2;
    if (width < 700) crossAxisCount = 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F1F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8F1F4),
        surfaceTintColor: const Color(0xFFF8F1F4),
        iconTheme: const IconThemeData(color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mazali va nafis katalog',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'O‘zingizga yoqqan tortni tanlang, keyin buyurtma ma’lumotlarini kiriting.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: MasonryGridView.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 22,
                crossAxisSpacing: 22,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _CatalogMasonryCard(
                    item: item,
                    height: _cardHeight(index, crossAxisCount),
                    onTap: () => _showCakeDetails(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _cardHeight(int index, int crossAxisCount) {
    if (crossAxisCount == 1) return 360;
    final heights = [620.0, 540.0, 300.0, 360.0, 280.0, 390.0];
    return heights[index % heights.length];
  }

  void _showCakeDetails(BuildContext context, CakeCatalogItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withValues(alpha: 0.18),
      barrierColor: Colors.black.withValues(alpha: 0.22),
      builder: (_) => CakeOrderBottomSheet(item: item),
    );
  }
}



class _CatalogMasonryCard extends StatefulWidget {
  const _CatalogMasonryCard({
    required this.item,
    required this.height,
    required this.onTap,
  });

  final CakeCatalogItem item;
  final double height;
  final VoidCallback onTap;

  @override
  State<_CatalogMasonryCard> createState() => _CatalogMasonryCardState();
}

class _CatalogMasonryCardState extends State<_CatalogMasonryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: widget.height,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..translate(0.0, _hovered ? -8.0 : 0.0)
          ..scale(_hovered ? 1.015 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? const Color(0x26D95A9C)
                  : const Color(0x12000000),
              blurRadius: _hovered ? 28 : 16,
              offset: Offset(0, _hovered ? 16 : 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.pink.shade100,
                  child: const Icon(
                    Icons.image,
                    size: 46,
                    color: Colors.white,
                  ),
                ),
              ),

              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.05),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.18),
                        Colors.black.withValues(alpha: 0.62),
                      ],
                      stops: const [0.0, 0.28, 0.58, 1.0],
                    ),
                  ),
                ),
              ),

              if (widget.item.featured)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.06),
                          AppColors.primary.withValues(alpha: 0.14),
                          AppColors.primary.withValues(alpha: 0.26),
                          AppColors.primary.withValues(alpha: 0.42),
                        ],
                      ),
                    ),
                  ),
                ),

              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 12),

                          _GlassInfoRow(
                            icon: Icons.scale_outlined,
                            label: 'Hajmi',
                            value: widget.item.size,
                          ),
                          const SizedBox(height: 8),
                          _GlassInfoRow(
                            icon: Icons.groups_2_outlined,
                            label: 'Kishilik',
                            value: widget.item.serves,
                          ),
                          const SizedBox(height: 8),
                          _GlassInfoRow(
                            icon: Icons.schedule_outlined,
                            label: 'Tayyor bo‘lishi',
                            value: widget.item.prepTime,
                          ),

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.item.price,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: widget.onTap,
                                  borderRadius: BorderRadius.circular(30),
                                  child: Ink(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 11,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.shopping_bag_outlined,
                                          color: AppColors.primary,
                                          size: 18,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Buyurtma',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassInfoRow extends StatelessWidget {
  const _GlassInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white.withValues(alpha: 0.92),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.96),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}



class CakeOrderBottomSheet extends StatefulWidget {
  const CakeOrderBottomSheet({
    super.key,
    required this.item,
  });

  final CakeCatalogItem item;

  @override
  State<CakeOrderBottomSheet> createState() => _CakeOrderBottomSheetState();
}

class _CakeOrderBottomSheetState extends State<CakeOrderBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _personsController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _personsController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: now.add(const Duration(days: 1)),
    );

    if (picked != null) {
      _dateController.text =
      '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
      setState(() {});
    }
  }

  String _buildOrderText() {
    return '''
🎂 Tort buyurtmasi

📌 Nomi: ${widget.item.title}
📝 Tavsif: ${widget.item.description}
⚖️ Hajmi: ${widget.item.size}
💵 Narxi: ${widget.item.price}
⏳ Tayyor bo‘lish vaqti: ${widget.item.prepTime}
👥 Standart kishilik: ${widget.item.serves}

📅 Kerakli sana: ${_dateController.text.trim()}
👨‍👩‍👧‍👦 Buyurtma necha kishilik: ${_personsController.text.trim()}
📍 Yetkazib berish manzili: ${_addressController.text.trim()}
✨ Qo‘shimcha izoh: ${_notesController.text.trim()}

🖼 Rasm: ${widget.item.imageUrl}
''';
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final message = _buildOrderText();

    try {
      await Clipboard.setData(ClipboardData(text: message));
      await AppLaunchers.openTelegramChatWithText(message);

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Telegram chat ochildi, buyurtma matni tayyor turibdi ✨',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Telegram ochilmadi: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.92),
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.95)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.34),
          width: 1.2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.red.shade200,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.red.shade200,
          width: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.24),
                  Colors.white.withValues(alpha: 0.14),
                  AppColors.primary.withValues(alpha: 0.10),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 30,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      errorStyle: TextStyle(
                        color: Colors.red.shade100,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 54,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.60),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      const SizedBox(height: 18),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          children: [
                            Image.network(
                              item.imageUrl,
                              height: 190,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 190,
                                color: Colors.pink.shade100,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.white,
                                  size: 42,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.03),
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.30),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 14,
                              top: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.94),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item.price,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.90),
                          fontSize: 14.5,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          _GlassMiniInfoPill(
                            icon: Icons.scale_outlined,
                            text: item.size,
                          ),
                          _GlassMiniInfoPill(
                            icon: Icons.groups_2_outlined,
                            text: item.serves,
                          ),
                          _GlassMiniInfoPill(
                            icon: Icons.schedule_outlined,
                            text: item.prepTime,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: _pickDate,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(
                          'Qachonga tayyor bo‘lsin?',
                          Icons.calendar_month_outlined,
                        ),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Sanani tanlang'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _personsController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(
                          'Necha kishilik?',
                          Icons.groups_2_outlined,
                        ),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Kishilar sonini kiriting'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(
                          'Qayerga yetkaziladi?',
                          Icons.location_on_outlined,
                        ),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Manzilni kiriting'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(
                          'Qo‘shimcha izoh',
                          Icons.edit_note_outlined,
                        ),
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.30),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _submitOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'Telegram orqali buyurtma berish',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassMiniInfoPill extends StatelessWidget {
  const _GlassMiniInfoPill({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.95)),
              const SizedBox(width: 7),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.96),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



