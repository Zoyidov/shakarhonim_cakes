import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shakarhonim_cakes/domain/model/cake_category.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../infrastructure/demo_data/demo_data.dart';
import '../catalog_page/catalog_page.dart';
import '../custom_cake_order_page/custom_cake_order_page.dart';

class ShakarhonimHomePage extends StatefulWidget {
  const ShakarhonimHomePage({super.key});

  @override
  State<ShakarhonimHomePage> createState() => _ShakarhonimHomePageState();
}

class _ShakarhonimHomePageState extends State<ShakarhonimHomePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _catalogKey = GlobalKey();
  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _customOrderKey = GlobalKey();
  final GlobalKey _footerKey = GlobalKey();

  String _selectedMenu = 'Bosh sahifa';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(GlobalKey key, String menu) async {
    setState(() => _selectedMenu = menu);

    final context = key.currentContext;
    if (context == null) return;

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
      alignment: 0.1,
    );
  }

  void _openCustomOrderScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CustomCakeOrderPage(),
      ),
    );
  }

  void _onCreateCustomCake() {
    _openCustomOrderScreen();
  }

  void _onBrowseCollection() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Browse Collection bosildi ✨'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _scrollTo(_galleryKey, 'Katalog');
  }

  void _onStartOrder() {
    _openCustomOrderScreen();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1100;
    final isTablet = screenWidth >= 700 && screenWidth < 1100;
    final horizontalPadding = isDesktop ? 140.0 : isTablet ? 40.0 : 20.0;

    final topBarHeight = isDesktop ? 80.0 : 72.0;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFBFD),
                    Color(0xFFFFF7FA),
                  ],
                ),
              ),
            ),
          ),

          /// Scroll qilinadigan content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: topBarHeight),
              ),

              SliverToBoxAdapter(
                child: Container(
                  key: _homeKey,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isDesktop ? 34 : 26,
                  ),
                  child: _HeroSection(
                    isDesktop: isDesktop,
                    isTablet: isTablet,
                    onCreateCustomCake: _onCreateCustomCake,
                    onBrowseCollection: _onBrowseCollection,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  key: _catalogKey,
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    isDesktop ? 58 : 42,
                    horizontalPadding,
                    isDesktop ? 70 : 48,
                  ),
                  child: const _WhyChooseUsSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  key: _galleryKey,
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 20,
                  ),
                  child: const _PreviewGallerySection(),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  key: _customOrderKey,
                  margin: const EdgeInsets.only(top: 16),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isDesktop ? 76 : 54,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: _CtaSection(onStartOrder: _onStartOrder),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  key: _footerKey,
                  color: AppColors.footerBackground,
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    isDesktop ? 50 : 36,
                    horizontalPadding,
                    28,
                  ),
                  child: _FooterSection(
                    onMenuTap: (menu) {
                      switch (menu) {
                        case 'Bosh sahifa':
                          _scrollTo(_homeKey, menu);
                          break;
                        case 'Afzalliklar':
                          _scrollTo(_catalogKey, menu);
                          break;
                        case 'Katalog':
                          _scrollTo(_galleryKey, menu);
                          break;
                        case 'Maxsus buyurtma':
                          _scrollTo(_customOrderKey, menu);
                          break;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          /// Fixed TopBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: _TopBar(
                selectedMenu: _selectedMenu,
                onMenuTap: (menu) {
                  switch (menu) {
                    case 'Bosh sahifa':
                      _scrollTo(_homeKey, menu);
                      break;
                    case 'Afzalliklar':
                      _scrollTo(_catalogKey, menu);
                      break;
                    case 'Katalog':
                      _scrollTo(_galleryKey, menu);
                      break;
                    case 'Maxsus buyurtma':
                      _scrollTo(_customOrderKey, menu);
                      break;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.selectedMenu,
    required this.onMenuTap,
  });

  final String selectedMenu;
  final ValueChanged<String> onMenuTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1100;
    final isTablet = screenWidth >= 700 && screenWidth < 1100;
    final horizontalPadding = isDesktop ? 140.0 : isTablet ? 40.0 : 20.0;
    final menuItems = ['Bosh sahifa', 'Afzalliklar', 'Katalog', 'Maxsus buyurtma'];

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: isDesktop ? 80 : 72,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFDFF).withValues(alpha: 0.72),
            border: const Border(
              bottom: BorderSide(color: Color(0xFFF4DEE7)),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x14C85A93),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const _BrandLogo(),
              const Spacer(),
              if (screenWidth >= 760)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: menuItems
                        .map(
                          (item) => _AnimatedNavItem(
                        title: item,
                        isSelected: selectedMenu == item,
                        onTap: () => onMenuTap(item),
                      ),
                    )
                        .toList(),
                  ),
                )
              else
                PopupMenuButton<String>(
                  color: const Color(0xFFFFFDFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: onMenuTap,
                  itemBuilder: (context) => menuItems
                      .map(
                        (item) => PopupMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.38),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.32),
                      ),
                    ),
                    child: const Icon(
                      Icons.menu_rounded,
                      color: AppColors.primary,
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

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.isDesktop,
    required this.isTablet,
    required this.onCreateCustomCake,
    required this.onBrowseCollection,
  });

  final bool isDesktop;
  final bool isTablet;
  final VoidCallback onCreateCustomCake;
  final VoidCallback onBrowseCollection;

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return SizedBox(
        height: 560,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Expanded(flex: 11, child: _HeroTextContent(onCreateCustomCake: onCreateCustomCake, onBrowseCollection: onBrowseCollection),),
            const SizedBox(width: 40),
            Expanded(
              flex: 10,
              child: _AnimatedHeroCard(
                height: 490,
                onCreateCustomCake: onCreateCustomCake,
                onBrowseCollection: onBrowseCollection,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroTextContent(onCreateCustomCake: onCreateCustomCake, onBrowseCollection: onBrowseCollection),
        const SizedBox(height: 28),
        Center(
          child: _AnimatedHeroCard(
            height: isTablet ? 460 : 360,
            onCreateCustomCake: onCreateCustomCake,
            onBrowseCollection: onBrowseCollection,
          ),
        ),
      ],
    );
  }
}

class _HeroTextContent extends StatelessWidget {
  const _HeroTextContent({
    required this.onCreateCustomCake,
    required this.onBrowseCollection,
  });

  final VoidCallback onCreateCustomCake;
  final VoidCallback onBrowseCollection;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 700;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * -24, 0),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.softPinkBorder),
              color: Colors.white.withValues(alpha: 0.7),
            ),
            child: const Text(
              '✨ Nafis Maxsus Tortlar',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 28),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                height: 1.05,
                fontWeight: FontWeight.w800,
                fontSize: isMobile ? 44 : 68,
                letterSpacing: -1.4,
                fontFamily: 'sans-serif',
              ),
              children: const [
                TextSpan(
                  text: 'Orzularingizdagi Tort\n',
                  style: TextStyle(color: AppColors.primary),
                ),
                TextSpan(
                  text: 'Endi Haqiqatga aylanadi',
                  style: TextStyle(color: AppColors.textDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: const Text(
                'Bayramlaringizni nafis va mazali tortlarimiz bilan yanada unutilmas qiling. Har bir tort — o‘ziga xos did va mahorat bilan yaratilgan san’at asari bo‘lib, sizning eng muhim lahzalaringizni yanada yorqin qiladi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  height: 1.75,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 34),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _GradientActionButton(
                label: 'Maxsus Tort Buyurtma Qilish',
                onTap: onCreateCustomCake,
              ),
              _OutlineActionButton(
                label: 'Tortlar To‘plamini Ko‘rish',
                onTap: onBrowseCollection,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GradientActionButton extends StatefulWidget {
  const _GradientActionButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  State<_GradientActionButton> createState() => _GradientActionButtonState();
}

class _GradientActionButtonState extends State<_GradientActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _hovered ? 1.03 : 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                color: Color(0x29F850A0),
                blurRadius: 28,
                offset: Offset(0, 14),
              ),
            ],
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
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

class _OutlineActionButton extends StatefulWidget {
  const _OutlineActionButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  State<_OutlineActionButton> createState() => _OutlineActionButtonState();
}

class _OutlineActionButtonState extends State<_OutlineActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFFFFF3F8) : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.primary.withValues(alpha: .35)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class _AnimatedHeroCard extends StatefulWidget {
  const _AnimatedHeroCard({
    required this.height,
    required this.onCreateCustomCake,
    required this.onBrowseCollection,
  });

  final double height;
  final VoidCallback onCreateCustomCake;
  final VoidCallback onBrowseCollection;

  @override
  State<_AnimatedHeroCard> createState() => _AnimatedHeroCardState();
}

class _AnimatedHeroCardState extends State<_AnimatedHeroCard>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _scaleController;

  late final Animation<double> _floatAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10,
      end: 12,
    ).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.985,
      end: 1.015,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(
      begin: -0.01,
      end: 0.01,
    ).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = width >= 1100 ? 500.0 : width >= 700 ? 520.0 : width * .92;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 950),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final safeOpacity = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: safeOpacity,
          child: Transform.translate(
            offset: Offset((1 - value) * 36, 0),
            child: child,
          ),
        );
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_floatController, _scaleController]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Transform.rotate(
              angle: _rotateAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            ),
          );
        },
        child: SizedBox(
          width: cardWidth,
          height: widget.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1D76445D),
                        blurRadius: 32,
                        offset: Offset(0, 20),
                      ),
                    ],
                  ),
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(34),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          "https://png.pngtree.com/thumb_back/fw800/background/20251112/pngtree-a-festive-and-elegant-birthday-celebration-setup-featuring-pink-tiered-cake-image_20297963.webp",
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;

                            return Container(
                              color: Colors.pink.shade50,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              "https://images.unsplash.com/photo-1551024506-0bccd828d307",
                              fit: BoxFit.cover,
                            );
                          },
                        ),

                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.12),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              Positioned(
                right: -18,
                bottom: -35,
                child: _AnimatedTiltedTag(
                  title: 'Mehr bilan',
                  subtitle: 'Yaratilgan',
                  color: const Color(0xFFF8DAEB),
                  icon: Icons.favorite_rounded,
                ),
              ),
              Positioned(
                left: -18,
                top: -35,
                child: _AnimatedTiltedTag(
                  title: '5 Yulduzli',
                  subtitle: 'Baholar',
                  color: const Color(0xFFF8DAEB),
                  icon: Icons.star,
                  iconColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulsingFloatingBadge extends StatefulWidget {
  const _PulsingFloatingBadge({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  State<_PulsingFloatingBadge> createState() => _PulsingFloatingBadgeState();
}

class _PulsingFloatingBadgeState extends State<_PulsingFloatingBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.08,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .8),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12A84F7D),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Icon(widget.icon, color: AppColors.primary, size: 26),
          ),
        ),
      ),
    );
  }
}


class _AnimatedTiltedTag extends StatefulWidget {
  const _AnimatedTiltedTag({
      required this.color,
      required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor =  Colors.red,

  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final Color iconColor;


  @override
  State<_AnimatedTiltedTag> createState() => _AnimatedTiltedTagState();
}

class _AnimatedTiltedTagState extends State<_AnimatedTiltedTag>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: -0.08,
      end: -0.03,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _offsetAnimation = Tween<double>(
      begin: 0,
      end: 6,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offsetAnimation.value),
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: widget.color,
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 24),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class _WhyChooseUsSection extends StatelessWidget {
  const _WhyChooseUsSection();

  @override
  Widget build(BuildContext context) {
    final items = [
      const _FeatureCardData(
        imageUrl:
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1200&q=80',
        title: 'Sifatli va mazali mahsulotlar',
        description: 'Har bir tort eng sara mahsulotlar asosida tayyorlanadi.',
        icon: CupertinoIcons.chart_bar_alt_fill,
        color: Colors.green
      ),
      const _FeatureCardData(
        imageUrl:
        'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?auto=format&fit=crop&w=1200&q=80',
        title: 'Mehr bilan tayyorlanadi',
        description: 'Har bir buyurtmaga alohida e’tibor va did bilan yondashamiz.',
        icon: CupertinoIcons.info
      ),
      const _FeatureCardData(
        imageUrl:
        'https://images.unsplash.com/photo-1535141192574-5d4897c12636?auto=format&fit=crop&w=1200&q=80',
        title: 'Didingizga mos dizayn',
        description: 'Siz xohlagan uslub va ko‘rinishda maxsus tortlar yaratamiz.',
        icon: CupertinoIcons.pencil_outline,
          color: Colors.pinkAccent
      ),
      const _FeatureCardData(
        imageUrl:
        'https://images.unsplash.com/photo-1486427944299-d1955d23e34d?auto=format&fit=crop&w=1200&q=80',
        title: 'Unutilmas bayram uchun',
        description: 'Bayramingizga mos nafis va zamonaviy tortlar taklif qilamiz.',
        icon: CupertinoIcons.heart_fill,
        color: Colors.red,
      ),
    ];

    return Column(
      children: [
        const Text(
          'Nega Aynan Biz?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 54,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          "Biz san’at va mazani uyg‘unlashtirib, sizning unutilmas lahzalaringiz uchun mukammal tortlar yaratamiz."
              ,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 42),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            int crossAxisCount = 4;
            if (width < 1200) crossAxisCount = 2;
            if (width < 680) crossAxisCount = 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: width < 680 ? 1.5 : 1.08,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
              itemBuilder: (context, index) => _FeatureCard(data: items[index]),
            );
          },
        ),
      ],
    );
  }
}

class _GalleryItem {
  const _GalleryItem({
    required this.title,
    required this.imageUrl,
    required this.category,
  });

  final String title;
  final String imageUrl;
  final CakeCategory category;
}

class _PreviewGallerySection extends StatelessWidget {
  const _PreviewGallerySection();

  @override
  Widget build(BuildContext context) {
    final gallery = [
      _GalleryItem(
        title: 'Tug‘ilgan kun tortlari',
        imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1200&q=80',
        category: cakeCategories[0],
      ),
      _GalleryItem(
        title: 'To‘y uchun maxsus tortlar',
        imageUrl: 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?auto=format&fit=crop&w=1200&q=80',
        category: cakeCategories[1],
      ),
      _GalleryItem(
        title: 'Bolalar uchun ertakona tortlar',
        imageUrl: 'https://images.unsplash.com/photo-1535141192574-5d4897c12636?auto=format&fit=crop&w=1200&q=80',
        category: cakeCategories[2],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Tortlar To‘plami',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Biz tayyorlagan nafis va mazali tortlarning ayrim namunalarini shu yerda ko‘rishingiz mumkin.',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            int crossAxisCount = 3;
            if (width < 1000) crossAxisCount = 2;
            if (width < 680) crossAxisCount = 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gallery.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.15,
              ),
                itemBuilder: (context, index) {
                  final item = gallery[index];

                  return _GalleryCard(
                    title: item.title,
                    imageUrl: item.imageUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CatalogMasonryPage(
                            title: item.title,
                            items: item.category.products,
                          ),
                        ),
                      );
                    },
                  );
                }
            );
          },
        ),
      ],
    );
  }
}

class _CtaSection extends StatelessWidget {
  const _CtaSection({required this.onStartOrder});

  final VoidCallback onStartOrder;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.96 + (value * 0.04),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Column(
        children: [
          const Text(
            'Orzuyingizdagi Tortni Yaratishga Tayyormisiz?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 58,
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 18),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 760),
            child: Text(
              'Keling, bayramingiz uchun mukammal tortni birgalikda yaratamiz. Bizning mohir qandolatchilarimiz siz tasavvur qilgan tortni nafis va unutilmas ko‘rinishda tayyorlab beradi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                height: 1.6,
                color: Color(0xFFFFF8FB),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _WhiteActionButton(onTap: onStartOrder),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection({required this.onMenuTap});

  final ValueChanged<String> onMenuTap;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 920;

    return Column(
      children: [
        isWide
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 3, child: _FooterBrandBlock()),
            const SizedBox(width: 40),
            Expanded(
              flex: 2,
              child: _FooterLinksBlock(onMenuTap: onMenuTap),
            ),
            const SizedBox(width: 40),
            const Expanded(flex: 3, child: _FooterContactBlock()),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FooterBrandBlock(),
            const SizedBox(height: 26),
            _FooterLinksBlock(onMenuTap: onMenuTap),
            const SizedBox(height: 26),
            const _FooterContactBlock(),
          ],
        ),
        const SizedBox(height: 28),
        Container(height: 1, color: const Color(0xFFF0D8E2)),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 12,
          spacing: 18,
          children: const [
            Text(
              '© 2026 Shakarhonim. Barcha huquqlar himoyalangan. 💕 va shirinlik bilan yaratilgan.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

          ],
        ),
      ],
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x30F54DA1),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.cake_rounded, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        const Text(
          'Shakarhonim',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class _AnimatedNavItem extends StatefulWidget {
  const _AnimatedNavItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: widget.isSelected
              ? const [
            BoxShadow(
              color: AppColors.primary,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ]
              : null,
          gradient: widget.isSelected
              ? const LinearGradient(
            colors: [AppColors.pageBackground, AppColors.pageBackground],
          )
              : null,
          color: !widget.isSelected && _hovered
              ? AppColors.softPinkBorder
              : Colors.transparent,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Text(
                widget.title,
                style: TextStyle(
                  color: widget.isSelected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CartButton extends StatefulWidget {
  const _CartButton({required this.cartCount, required this.onTap});

  final int cartCount;
  final VoidCallback onTap;

  @override
  State<_CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<_CartButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _hovered ? 1.05 : 1,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x30F652A0),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 21,
                  color: Colors.white,
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${widget.cartCount}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
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


class _FeatureCardData {
  const _FeatureCardData({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.icon,
    this.color = const Color(0xFFF7D9EA),

  });

  final String imageUrl;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({required this.data});

  final _FeatureCardData data;

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..translate(0.0, _hovered ? -10.0 : 0.0)
          ..scale(_hovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? const Color(0x26D85A9D)
                  : const Color(0x14000000),
              blurRadius: _hovered ? 32 : 18,
              offset: Offset(0, _hovered ? 20 : 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.data.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF9D7E8),
                          Color(0xFFF2B7D9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF9D7E8),
                          Color(0xFFF2B7D9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  );
                },
              ),

              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.08),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.18),
                        Colors.black.withValues(alpha: 0.55),
                      ],
                      stops: const [0.0, 0.35, 0.65, 1.0],
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
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                       gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFF8A9CF).withValues(alpha: _hovered ? 0.34 : 0.28),
                            const Color(0xFFE97CB8).withValues(alpha: _hovered ? 0.30 : 0.24),
                            const Color(0xFFD84A9B).withValues(alpha: _hovered ? 0.26 : 0.20),
                          ],
                       ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.data.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.data.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.white.withValues(alpha: 0.92),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 16,
                right: 16,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: _hovered ? 0.28 : 0.18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child:  Icon(
                    widget.data.icon,
                    color: widget.data.color,
                    size: 28,
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



class _GalleryCard extends StatefulWidget {
  const _GalleryCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  State<_GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<_GalleryCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;

  late final AnimationController _controller;
  late final Animation<double> _imageScale;
  late final Animation<double> _cardLift;
  late final Animation<double> _contentLift;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _imageScale = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _cardLift = Tween<double>(
      begin: 0,
      end: -10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _contentLift = Tween<double>(
      begin: 0,
      end: -8,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );


  }

  void _onEnter(PointerEvent event) {
    setState(() => _hovered = true);
    _controller.forward();
  }

  void _onExit(PointerEvent event) {
    setState(() => _hovered = false);
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..translate(0.0, _cardLift.value)
                ..scale(_hovered ? 1.01 : 1.0),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: _hovered
                          ? const Color(0x26D86AA2)
                          : const Color(0x14000000),
                      blurRadius: _hovered ? 30 : 16,
                      offset: Offset(0, _hovered ? 20 : 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Transform.scale(
                        scale: _imageScale.value,
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;

                            return Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFCE0EC),
                                    Color(0xFFF3C2DD),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1200&q=80',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),

                      Positioned.fill(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(
                                  alpha: _hovered ? 0.06 : 0.03,
                                ),
                                Colors.transparent,
                                Colors.black.withValues(
                                  alpha: _hovered ? 0.16 : 0.10,
                                ),
                                Colors.black.withValues(
                                  alpha: _hovered ? 0.58 : 0.48,
                                ),
                              ],
                              stops: const [0.0, 0.32, 0.65, 1.0],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 18,
                        right: 18,
                        bottom: 18 + _contentLift.value,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: _hovered ? 20 : 16,
                              sigmaY: _hovered ? 20 : 16,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFF8A9CF).withValues(alpha: _hovered ? 0.34 : 0.28),
                                    const Color(0xFFE97CB8).withValues(alpha: _hovered ? 0.30 : 0.24),
                                    const Color(0xFFD84A9B).withValues(alpha: _hovered ? 0.26 : 0.20),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: _hovered ? 0.24 : 0.18),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD85B9E).withValues(alpha: 0.22),
                                    blurRadius: _hovered ? 26 : 18,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleBlur(hovered: _hovered),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.98),
                                            fontSize: 23,
                                            fontWeight: FontWeight.w800,
                                            height: 1.15,
                                            letterSpacing: -0.2,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withValues(alpha: 0.16),
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Nafis va mazali maxsus tortlar',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.88),
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w500,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  CircleBlur(hovered: _hovered),
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
          },
        ),
      ),
    );
  }
}

class CircleBlur extends StatelessWidget {
  const CircleBlur({
    super.key,
    required bool hovered,
  }) : _hovered = hovered;

  final bool _hovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: _hovered ? 50 : 46,
      height: _hovered ? 50 : 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.34),
            Colors.white.withValues(alpha: 0.16),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      // child: Transform.translate(
      //   offset: Offset(_arrowShift.value, 0),
      //   child: const Icon(
      //     Icons.arrow_forward_rounded,
      //     color: Colors.white,
      //     size: 22,
      //   ),
      // ),
    );
  }
}

class _WhiteActionButton extends StatefulWidget {
  const _WhiteActionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_WhiteActionButton> createState() => _WhiteActionButtonState();
}

class _WhiteActionButtonState extends State<_WhiteActionButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _controller;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 18,
      end: 30,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return AnimatedScale(
            duration: const Duration(milliseconds: 180),
            scale: _hovered ? 1.03 : 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x20FFFFFF),
                    blurRadius: _glowAnimation.value,
                    offset: const Offset(0, 10),
                  ),
                  const BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 22,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: widget.onTap,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                    child: Text(
                      'Maxsus buyurtma',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FooterBrandBlock extends StatelessWidget {
  const _FooterBrandBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _BrandLogo(),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: const Text(
            'Biz nafis va betakror tortlarimiz bilan unutilmas lahzalarni yaratamiz. Har bir bayram ozgina shirinlik va nafislikka loyiq.',
            style: TextStyle(
              color: AppColors.textMuted,
              height: 1.7,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            _SocialButton(
              icon: FontAwesomeIcons.instagram,
              onTap: () async => AppLaunchers.openInstagram(),
            ),
            const SizedBox(width: 12),
            _SocialButton(
              icon: FontAwesomeIcons.telegram,
              onTap: () async => AppLaunchers.openTelegramProfile(),
            ),
            const SizedBox(width: 12),
            _SocialButton(
              icon: FontAwesomeIcons.phone,
              onTap: () async => AppLaunchers.callPhone(),
            ),
            const SizedBox(width: 12),
            _SocialButton(
              icon: FontAwesomeIcons.locationArrow,
              onTap: () async => AppLaunchers.openLocation(),
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterLinksBlock extends StatelessWidget {
  const _FooterLinksBlock({required this.onMenuTap});

  final ValueChanged<String> onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tezkor Havolalar',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 18),
        ...['Bosh sahifa', 'Afzalliklar', 'Katalog', 'Maxsus buyurtma'].map(
              (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => onMenuTap(item),
              child: Text(
                item,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterContactBlock extends StatelessWidget {
  const _FooterContactBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bog‘lanish',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 18),
        _ContactRow(
          icon: Icons.location_on_outlined,
          text: 'Q9H3+XWP Андижан, Узбекистан',
          onTap: () async => AppLaunchers.openLocation(),
        ),
        const SizedBox(height: 14),
        _ContactRow(
          icon: Icons.phone_outlined,
          text: '+998 (50) 507-11-19',
          onTap: () async => AppLaunchers.callPhone(),
        ),
        const SizedBox(height: 14),
        _ContactRow(
          icon: Icons.telegram,
          text: '@MrsSobirovaa',
          onTap: () async => AppLaunchers.openTelegramProfile(),
        ),
      ],
    );
  }
}


class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.icon,
    required this.onTap,
  });

  final FaIconData icon;
  final VoidCallback onTap;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? const Color(0x1ED86FA5)
                    : const Color(0x10000000),
                blurRadius: _hovered ? 18 : 10,
                offset: Offset(0, _hovered ? 10 : 5),
              ),
            ],
          ),
          child: Center(
            child: FaIcon(
              widget.icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.text,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 2),
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class AppLaunchers {
  AppLaunchers._();

  static const String instagramUrl = 'https://instagram.com/shakar_honim';
  static const String telegramUsername = 'MrsSobirovaa';
  static const String phoneNumber = '+998505071119';

  static const double latitude = 40.779966;
  static const double longitude = 72.354833;

  static Future<void> openInstagram() async {
    await _launchExternal(Uri.parse(instagramUrl));
  }

  static Future<void> openTelegramProfile() async {
    await _launchExternal(Uri.parse('https://t.me/$telegramUsername'));
  }

  static Future<void> callPhone() async {
    await _launchPlatformDefault(Uri.parse('tel:$phoneNumber'));
  }

  static Future<void> openLocation() async {
    await _launchExternal(
      Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      ),
    );
  }

  static Future<void> openTelegramChatWithText(String message) async {
    final encoded = Uri.encodeComponent(message);

    final nativeUri = Uri.parse(
      'tg://resolve?domain=$telegramUsername&text=$encoded',
    );

    final webUri = Uri.parse(
      'https://t.me/$telegramUsername?text=$encoded',
    );

    final openedNative = await launchUrl(
      nativeUri,
      mode: LaunchMode.externalApplication,
    );

    if (openedNative) return;

    await _launchExternal(webUri);
  }

  static Future<void> _launchExternal(Uri uri) async {
    final success = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!success) {
      throw Exception('Havola ochilmadi: $uri');
    }
  }

  static Future<void> _launchPlatformDefault(Uri uri) async {
    final success = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
    );

    if (!success) {
      throw Exception('Havola ochilmadi: $uri');
    }
  }
}




class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFF34FA1);
  static const Color secondary = Color(0xFFE2A8D7);
  static const Color pageBackground = Color(0xFFFFFAFC);
  static const Color footerBackground = Color(0xFFFFF4F8);
  static const Color textDark = Color(0xFF423545);
  static const Color textMuted = Color(0xFF8D7F8D);
  static const Color softPinkBorder = Color(0xFFF4D7E6);
}
