import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../home_page/home_page.dart';

class CustomCakeOrderPage extends StatefulWidget {
  const CustomCakeOrderPage({super.key});

  @override
  State<CustomCakeOrderPage> createState() => _CustomCakeOrderPageState();
}

class _CustomCakeOrderPageState extends State<CustomCakeOrderPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cakeTypeController = TextEditingController();
  final _personsController = TextEditingController();
  final _weightController = TextEditingController();
  final _dateController = TextEditingController();
  final _addressController = TextEditingController();
  final _designController = TextEditingController();
  final _textOnCakeController = TextEditingController();
  final _extraController = TextEditingController();

  String _selectedFlavor = 'Vanilli';
  String _selectedCream = 'Krem-chiz';

  final List<String> _flavors = [
    'Vanilli',
    'Shokoladli',
    'Qulupnayli',
    'Red Velvet',
    'Medovik',
  ];

  final List<String> _creams = [
    'Krem-chiz',
    'Shokolad krem',
    'Smetanali',
    'Mascarpone',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cakeTypeController.dispose();
    _personsController.dispose();
    _weightController.dispose();
    _dateController.dispose();
    _addressController.dispose();
    _designController.dispose();
    _textOnCakeController.dispose();
    _extraController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: now.add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _dateController.text = DateFormat('dd.MM.yyyy').format(picked);
      setState(() {});
    }
  }

  String _buildTelegramMessage() {
    return '''
🎂 Maxsus tort buyurtmasi

👤 Ism: ${_nameController.text.trim()}
📞 Telefon: ${_phoneController.text.trim()}
🍰 Tort turi: ${_cakeTypeController.text.trim()}
👥 Necha kishilik: ${_personsController.text.trim()}
⚖️ Taxminiy og'irligi: ${_weightController.text.trim()}
🥄 Biskvit/ta'm: $_selectedFlavor
🧁 Krem turi: $_selectedCream
📅 Kerakli sana: ${_dateController.text.trim()}
📍 Yetkazib berish manzili: ${_addressController.text.trim()}
🎨 Dizayn tavsifi: ${_designController.text.trim()}
📝 Tort ustiga yozuv: ${_textOnCakeController.text.trim()}
✨ Qo'shimcha istaklar: ${_extraController.text.trim()}
''';
  }



  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final message = _buildTelegramMessage();

    try {
      await Clipboard.setData(ClipboardData(text: message));
      await AppLaunchers.openTelegramChatWithText(message);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Telegram chat ochildi, matn tayyor joylandi ✨',
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


  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: AppColors.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: AppColors.softPinkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: AppColors.softPinkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 860;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.pageBackground,
        surfaceTintColor: AppColors.pageBackground,
        title: const Text(
          'Maxsus tort buyurtmasi',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 24,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Buyurtma ma’lumotlarini kiriting',
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Barcha maydonlarni to‘ldiring. Yuborish tugmasidan keyin buyurtma matni copy bo‘ladi va Telegram ochiladi.',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 24),

                        if (isWide)
                          Row(
                            children: [
                              Expanded(child: _buildNameField()),
                              const SizedBox(width: 16),
                              Expanded(child: _buildPhoneField()),
                            ],
                          )
                        else ...[
                          _buildNameField(),
                          const SizedBox(height: 16),
                          _buildPhoneField(),
                        ],

                        const SizedBox(height: 16),

                        if (isWide)
                          Row(
                            children: [
                              Expanded(child: _buildCakeTypeField()),
                              const SizedBox(width: 16),
                              Expanded(child: _buildPersonsField()),
                            ],
                          )
                        else ...[
                          _buildCakeTypeField(),
                          const SizedBox(height: 16),
                          _buildPersonsField(),
                        ],

                        const SizedBox(height: 16),

                        if (isWide)
                          Row(
                            children: [
                              Expanded(child: _buildWeightField()),
                              const SizedBox(width: 16),
                              Expanded(child: _buildDateField()),
                            ],
                          )
                        else ...[
                          _buildWeightField(),
                          const SizedBox(height: 16),
                          _buildDateField(),
                        ],

                        const SizedBox(height: 16),

                        if (isWide)
                          Row(
                            children: [
                              Expanded(child: _buildFlavorDropdown()),
                              const SizedBox(width: 16),
                              Expanded(child: _buildCreamDropdown()),
                            ],
                          )
                        else ...[
                          _buildFlavorDropdown(),
                          const SizedBox(height: 16),
                          _buildCreamDropdown(),
                        ],

                        const SizedBox(height: 16),
                        _buildAddressField(),
                        const SizedBox(height: 16),
                        _buildDesignField(),
                        const SizedBox(height: 16),
                        _buildTextOnCakeField(),
                        const SizedBox(height: 16),
                        _buildExtraField(),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'Telegram orqali yuborish',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: _inputDecoration('Ismingiz', icon: Icons.person_outline),
      validator: (value) =>
      value == null || value.trim().isEmpty ? 'Ismingizni kiriting' : null,
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration('Telefon raqamingiz', icon: Icons.phone_outlined),
      validator: (value) =>
      value == null || value.trim().isEmpty ? 'Telefon raqamni kiriting' : null,
    );
  }

  Widget _buildCakeTypeField() {
    return TextFormField(
      controller: _cakeTypeController,
      decoration: _inputDecoration('Tort turi', icon: Icons.cake_outlined),
      validator: (value) =>
      value == null || value.trim().isEmpty ? 'Tort turini kiriting' : null,
    );
  }

  Widget _buildPersonsField() {
    return TextFormField(
      controller: _personsController,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration('Necha kishilik', icon: Icons.groups_2_outlined),
      validator: (value) => value == null || value.trim().isEmpty
          ? 'Necha kishilikligini kiriting'
          : null,
    );
  }

  Widget _buildWeightField() {
    return TextFormField(
      controller: _weightController,
      decoration: _inputDecoration('Taxminiy og‘irligi (kg)', icon: Icons.scale_outlined),
      validator: (value) =>
      value == null || value.trim().isEmpty ? 'Og‘irlikni kiriting' : null,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      onTap: _pickDate,
      decoration: _inputDecoration('Kerakli sana', icon: Icons.calendar_month_outlined),
      validator: (value) =>
      value == null || value.trim().isEmpty ? 'Sanani tanlang' : null,
    );
  }

  Widget _buildFlavorDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedFlavor,
      decoration: _inputDecoration('Biskvit / ta’m', icon: Icons.icecream_outlined),
      items: _flavors
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedFlavor = value);
        }
      },
    );
  }

  Widget _buildCreamDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCream,
      decoration: _inputDecoration('Krem turi', icon: Icons.bakery_dining_outlined),
      items: _creams
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedCream = value);
        }
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      maxLines: 2,
      decoration: _inputDecoration('Yetkazib berish manzili', icon: Icons.location_on_outlined),
      validator: (value) =>
      value == null || value.trim().isEmpty ? 'Manzilni kiriting' : null,
    );
  }

  Widget _buildDesignField() {
    return TextFormField(
      controller: _designController,
      maxLines: 3,
      decoration: _inputDecoration('Dizayn tavsifi', icon: Icons.draw_outlined),
      validator: (value) =>
      value == null || value.trim().isEmpty ? 'Dizayn haqida yozing' : null,
    );
  }

  Widget _buildTextOnCakeField() {
    return TextFormField(
      controller: _textOnCakeController,
      decoration: _inputDecoration('Tort ustiga yozuv', icon: Icons.edit_note_outlined),
    );
  }

  Widget _buildExtraField() {
    return TextFormField(
      controller: _extraController,
      maxLines: 3,
      decoration: _inputDecoration('Qo‘shimcha istaklar', icon: Icons.auto_awesome_outlined),
    );
  }
}