import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:html' as html;
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MNRPetrolApp());
}

// Router yapılandırması
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/hakkimizda',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const AboutPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
  ],
);

class MNRPetrolApp extends StatelessWidget {
  const MNRPetrolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MNR Petrol',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        primaryColor: const Color(0xFFD71920),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
          displayMedium: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Color(0xFF4A4A4A),
            height: 1.6,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFF4A4A4A),
            height: 1.6,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _contactKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 102 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 102 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
    
    // Query parametresini kontrol et ve scroll yap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = GoRouterState.of(context).uri;
      if (uri.queryParameters['scrollTo'] == 'contact') {
        Future.delayed(const Duration(milliseconds: 400), () {
          _scrollToContact();
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToContact() {
    final context = _contactKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  void _sendEmail() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final subject = _subjectController.text;
    final message = _messageController.text;
    
    final emailBody = '''
İsim: $name
E-posta: ${email.isNotEmpty ? email : '-'}
Telefon: ${phone.isNotEmpty ? phone : '-'}

Mesaj:
$message
    ''';
    
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'ugurunluer@gmail.com',
      query: 'subject=$subject&body=${Uri.encodeComponent(emailBody)}',
    );
    
    // Web için window.open kullanılacak
    html.window.open(emailUri.toString(), '_blank');
    
    // Formu temizle
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _subjectController.clear();
    _messageController.clear();
    
    // Form state'ini resetle
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Spacer for fixed top bar and header
              const SliverToBoxAdapter(
                child: SizedBox(height: 142), // 42px top bar + 100px header
              ),
              // Hero Section
              SliverToBoxAdapter(
                child: _buildHeroSection(context),
              ),
              // Products Section
              SliverToBoxAdapter(
                child: _buildProductsSection(context),
              ),
              // Brands Section
              SliverToBoxAdapter(
                child: _buildBrandsSection(context),
              ),
              // Contact Section
              SliverToBoxAdapter(
                child: _buildContactSection(context),
              ),
              // Footer
              SliverToBoxAdapter(
                child: _buildFooter(context),
              ),
            ],
          ),
          // Fixed Top Info Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopInfoBar(),
          ),
          // Floating Header
          Positioned(
            top: 42,
            left: 0,
            right: 0,
            child: _buildFloatingHeader(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingHeader(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.06),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo ve Şirket İsmi
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFF8F9FA),
                        Colors.white,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/mnr-petrol.jpg',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MNR Petrol Tarım İnş. San. Tic. Ltd. Şti.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        letterSpacing: 0.3,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Antalya Madeni Yağ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280),
                        letterSpacing: 0.2,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Navigation
            Row(
              children: [
                _buildNavItem(context, 'Ana Sayfa', 0, true),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Ürünler', 1, false),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Markalar', 2, false),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Hakkımızda', 3, false),
                const SizedBox(width: 32),
                _buildNavItem(context, 'İletişim', 4, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, int section, bool isActive) {
    // Ürünler için dropdown menü
    if (title == 'Ürünler') {
      return _ProductsDropdownNavItem(
        isActive: isActive,
        onProductSelected: (productName) {
          // Ana sayfaya git ve ürünler bölümüne scroll yap
          context.go('/');
        },
      );
    }
    
    // Markalar için dropdown menü
    if (title == 'Markalar') {
      return _BrandsDropdownNavItem(
        isActive: isActive,
        onBrandSelected: (brandName) {
          // Ana sayfaya git ve markalar bölümüne scroll yap
          context.go('/');
        },
      );
    }
    
    return _ModernNavItem(
      title: title,
      isActive: isActive,
      onTap: () {
        if (title == 'Hakkımızda') {
          context.go('/hakkimizda');
        } else if (title == 'Ana Sayfa') {
          context.go('/');
        } else if (title == 'İletişim') {
          // Önce ana sayfaya git, sonra scroll yap
          context.go('/');
          Future.delayed(const Duration(milliseconds: 400), () {
            _scrollToContact();
          });
        }
      },
    );
  }
}

class _ModernNavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const _ModernNavItem({
    required this.title,
    required this.onTap,
    required this.isActive,
  });

  @override
  State<_ModernNavItem> createState() => _ModernNavItemState();
}

class _ModernNavItemState extends State<_ModernNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: widget.isActive 
                ? const Border(
                    bottom: BorderSide(
                      color: Color(0xFFD71920),
                      width: 2,
                    ),
                  )
                : null,
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w600,
              color: _isHovered 
                  ? const Color(0xFFD71920) 
                  : (widget.isActive ? const Color(0xFF111827) : const Color(0xFF1F2937)),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

// Ürünler Dropdown Menü Widget'ı
class _ProductsDropdownNavItem extends StatefulWidget {
  final bool isActive;
  final Function(String) onProductSelected;

  const _ProductsDropdownNavItem({
    required this.isActive,
    required this.onProductSelected,
  });

  @override
  State<_ProductsDropdownNavItem> createState() => _ProductsDropdownNavItemState();
}

class _ProductsDropdownNavItemState extends State<_ProductsDropdownNavItem> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isDropdownHovered = false;
  bool _isNestedHovered = false;
  OverlayEntry? _overlayEntry;
  OverlayEntry? _nestedOverlay;
  final LayerLink _layerLink = LayerLink();
  String? _hoveredProduct;
  late AnimationController _closeController;
  
  final List<Map<String, String>> _products = [
    {'name': 'Motor Yağları', 'icon': 'motor-yaglari.png'},
    {'name': 'Motorsiklet Yağları', 'icon': 'motorsiklet-yaglari.png'},
    {'name': 'Motor Bakım Ürünleri', 'icon': 'motor-bakim.png'},
    {'name': 'Antifrizler', 'icon': 'antifiriz.png'},
    {'name': 'Şanzıman ve Dişli Yağları', 'icon': 'sanziman.png'},
    {'name': 'Sarf Malzemeler', 'icon': 'sarf-malzemeler.png'},
  ];
  
  final Map<String, List<String>> _subMenus = {
    'Sarf Malzemeler': ['Fren Hidrolik Sıvıları', 'Katkı Maddeleri'],
  };

  @override
  void initState() {
    super.initState();
    _closeController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _closeController.dispose();
    _removeOverlay();
    _removeNestedOverlay();
    super.dispose();
  }

  void _checkAndClose() {
    // Hiçbir alanda değilse kapat
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && !_isHovered && !_isDropdownHovered && !_isNestedHovered) {
        _removeOverlay();
        _removeNestedOverlay();
      }
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 250,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(-20, 36),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 200),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.95 + (0.05 * value),
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Material(
              color: Colors.transparent,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isDropdownHovered = true;
                }),
                onExit: (_) {
    setState(() {
                    _isDropdownHovered = false;
                    _hoveredProduct = null;
                  });
                  _checkAndClose();
                },
                child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black.withOpacity(0.08),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _products.asMap().entries.map((entry) {
                      final index = entry.key;
                      final product = entry.value;
                      return _buildDropdownItem(
                        product['name']!,
                        product['icon']!,
                        index,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showNestedOverlay(String productName, int itemIndex) {
    final subItems = _subMenus[productName];
    if (subItems == null || subItems.isEmpty) return;
    
    _removeNestedOverlay();
    
    _nestedOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(220, 44.0 + (itemIndex * 52.0)),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 150),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(10 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Material(
              color: Colors.transparent,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isNestedHovered = true;
                  _hoveredProduct = productName;
                }),
                onExit: (_) {
                  setState(() => _isNestedHovered = false);
                  _checkAndClose();
                },
                child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black.withOpacity(0.08),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: subItems.map((subItem) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            widget.onProductSelected(subItem);
                            _removeOverlay();
                            _removeNestedOverlay();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black.withOpacity(0.05),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              subItem,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1A1A1A),
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
    
    Overlay.of(context).insert(_nestedOverlay!);
  }

  void _removeNestedOverlay() {
    _nestedOverlay?.remove();
    _nestedOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _isHovered = true);
          _showOverlay();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _checkAndClose();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: widget.isActive 
                ? const Border(
                    bottom: BorderSide(
                      color: Color(0xFFD71920),
                      width: 2,
                    ),
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ürünler',
              style: TextStyle(
                fontSize: 15,
                fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w600,
                color: _isHovered 
                    ? const Color(0xFFD71920) 
                    : (widget.isActive ? const Color(0xFF111827) : const Color(0xFF1F2937)),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              _isHovered ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 18,
              color: _isHovered 
                  ? const Color(0xFFD71920) 
                  : (widget.isActive ? const Color(0xFF111827) : const Color(0xFF1F2937)),
            ),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(String name, String icon, int index) {
    final hasSubMenu = _subMenus.containsKey(name);
    final isHovered = _hoveredProduct == name;
    
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredProduct = name;
          _isDropdownHovered = true;
        });
        if (hasSubMenu) {
          _showNestedOverlay(name, index);
        } else {
          _removeNestedOverlay();
        }
      },
      onExit: (_) {
        // Item'den çıkınca state temizleme (dropdown hala hover'da olabilir)
        if (!hasSubMenu) {
          setState(() => _hoveredProduct = null);
        }
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!hasSubMenu) {
              widget.onProductSelected(name);
              _removeOverlay();
              _removeNestedOverlay();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      image: AssetImage('assets/images/$icon'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Icon(
                  hasSubMenu ? Icons.chevron_right : Icons.arrow_forward_ios,
                  size: hasSubMenu ? 14 : 10,
                  color: (hasSubMenu && isHovered) ? const Color(0xFFD71920) : const Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Markalar Dropdown Menü Widget'ı
class _BrandsDropdownNavItem extends StatefulWidget {
  final bool isActive;
  final Function(String) onBrandSelected;

  const _BrandsDropdownNavItem({
    required this.isActive,
    required this.onBrandSelected,
  });

  @override
  State<_BrandsDropdownNavItem> createState() => _BrandsDropdownNavItemState();
}

class _BrandsDropdownNavItemState extends State<_BrandsDropdownNavItem> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isDropdownHovered = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late AnimationController _closeController;
  
  final List<Map<String, String>> _brands = [
    {'name': 'Japan Oil', 'logo': 'japanoil.png'},
    {'name': 'Oilport', 'logo': 'oilport.png'},
    {'name': 'Borax', 'logo': 'borax.png'},
    {'name': 'Brava', 'logo': 'brava.png'},
    {'name': 'Xenol', 'logo': 'xenol.png'},
  ];

  @override
  void initState() {
    super.initState();
    _closeController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _closeController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _checkAndClose() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && !_isHovered && !_isDropdownHovered) {
        _removeOverlay();
      }
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 250,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(-20, 36),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 200),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.95 + (0.05 * value),
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Material(
              color: Colors.transparent,
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isDropdownHovered = true;
                }),
                onExit: (_) {
                  setState(() => _isDropdownHovered = false);
                  _checkAndClose();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.black.withOpacity(0.08),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _brands.map((brand) {
                        return _buildDropdownItem(
                          brand['name']!,
                          brand['logo']!,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _isHovered = true);
          _showOverlay();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _checkAndClose();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: widget.isActive
                ? const Border(
                    bottom: BorderSide(
                      color: Color(0xFFD71920),
                      width: 2,
                    ),
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Markalar',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w600,
                  color: _isHovered
                      ? const Color(0xFFD71920)
                      : (widget.isActive ? const Color(0xFF111827) : const Color(0xFF1F2937)),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _isHovered ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 18,
                color: _isHovered
                    ? const Color(0xFFD71920)
                    : (widget.isActive ? const Color(0xFF111827) : const Color(0xFF1F2937)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(String name, String logo) {
    return MouseRegion(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.onBrandSelected(name);
            _removeOverlay();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/images/logos/$logo',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension _HomePageWidgets on _HomePageState {
  Widget _buildHeroSection(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/banner.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.only(
                top: 140, // Header (80px) + ekstra boşluk
                bottom: 140, // Simetrik boşluk
                left: 40,
                right: 40,
              ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD71920),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD71920).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Text(
                      'PREMİUM KALİTE',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Main Title
                  const Text(
                    'MNR PETROL',
                    style: TextStyle(
                      fontSize: 68,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 4),
                          blurRadius: 20,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Subtitle
                  const Text(
                    'Yüksek Performanslı Motor Yağları ve Endüstriyel Ürünler',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 10,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 45),
                  // Buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD71920),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 36,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 8,
                          shadowColor: const Color(0xFFD71920).withOpacity(0.6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
            Text(
                              'Ürünlerimizi Keşfedin',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
                      OutlinedButton(
                        onPressed: _scrollToContact,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2.5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 36,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.phone, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'İletişime Geç',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 55),
                  // Stats
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatCard('15+', 'Yıllık Tecrübe'),
                        Container(
                          height: 50,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          color: Colors.white.withOpacity(0.3),
                        ),
                        _buildStatCard('1000+', 'Mutlu Müşteri'),
                        Container(
                          height: 50,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          color: Colors.white.withOpacity(0.3),
                        ),
                        _buildStatCard('5', 'Premium Marka'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD71920),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ürünlerimiz',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Geniş ürün yelpazemiz ile her türlü ihtiyacınıza çözüm sunuyoruz',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 60),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 1.1,
                children: [
                  _buildProductCardWithImage(
                    Icons.directions_car_outlined,
                    'Motor Yağları',
                    'Otomobil ve ticari araçlar için yüksek performanslı motor yağları',
                    'assets/images/motor-yaglari.png',
                  ),
                  _buildProductCardWithImage(
                    Icons.two_wheeler_outlined,
                    'Motorsiklet Yağları',
                    'Motorsikletler için özel olarak tasarlanmış motor yağları',
                    'assets/images/motorsiklet-yaglari.png',
                  ),
                  _buildProductCardWithImage(
                    Icons.build_circle_outlined,
                    'Motor Bakım Ürünleri',
                    'Motorunuzun uzun ömürlü olması için bakım ve koruma ürünleri',
                    'assets/images/motor-bakim.png',
                  ),
                  _buildProductCardWithImage(
                    Icons.ac_unit_outlined,
                    'Antifrizler',
                    'Motor soğutma sistemleri için yüksek kaliteli antifriz ürünleri',
                    'assets/images/antifiriz.png',
                  ),
                  _buildProductCardWithImage(
                    Icons.settings_outlined,
                    'Şanzıman ve Dişli Yağları',
                    'Şanzıman ve dişli sistemleri için özel formülasyonlu yağlar',
                    'assets/images/sanziman.png',
                  ),
                  _buildProductCardWithImage(
                    Icons.inventory_2_outlined,
                    'Sarf Malzemeler',
                    'Fren Hidrolik Sıvıları, Katkı Maddeleri',
                    'assets/images/sarf-malzemeler.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(IconData icon, String title, String description) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              const Color(0xFFF8F9FA),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1E3A8A),
                    const Color(0xFF2563EB),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 38,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCardWithImage(IconData icon, String title, String description, String imagePath) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              // Dark Overlay for readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 8,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF8F9FA),
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD71920),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Markalarımız',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Güvenilir ve kaliteli markalarla hizmetinizdeyiz',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 60),
              Wrap(
                spacing: 40,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: [
                  _buildBrandLogo('assets/images/logos/japanoil.png', 'Japan Oil'),
                  _buildBrandLogo('assets/images/logos/oilport.png', 'Oilport'),
                  _buildBrandLogo('assets/images/logos/borax.png', 'Borax'),
                  _buildBrandLogo('assets/images/logos/brava.png', 'Brava'),
                  _buildBrandLogo('assets/images/logos/xenol.png', 'Xenol'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandLogo(String imagePath, String brandName) {
    return Container(
      width: 200,
      height: 120,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      key: _contactKey,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/iletisim-arkaplan.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.7),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Başlık Bölümü
              Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD71920),
                      const Color(0xFFE53935),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD71920).withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Bize Ulaşın',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1,
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Sorularınız için her zaman yanınızdayız',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        _buildModernContactCard(
                          Icons.phone_in_talk_rounded,
                          'Telefon',
                          '+90 532 562 71 23',
                          'Hafta içi 09:00 - 18:00',
                        ),
                        const SizedBox(height: 24),
                        _buildModernContactCard(
                          Icons.location_on_rounded,
                          'Adres',
                          'Uncalı Mh. Şehit Teğmen Abdulkadir Güler Cad.',
                          'Bilgi Sitesi, Konyaaltı / Antalya',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 7,
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 40,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Mesaj Gönderin',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Formu doldurun, size en kısa sürede geri dönüş yapalım',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF6B7280),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Zorunlu alan';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Adınız Soyadınız',
                                      hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                                      filled: true,
                                      fillColor: const Color(0xFFF8F9FA),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Color(0xFFD71920), width: 2),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Colors.red, width: 1),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Colors.red, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Zorunlu alan';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Geçersiz e-posta';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'E-posta Adresiniz',
                                      hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                                      filled: true,
                                      fillColor: const Color(0xFFF8F9FA),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Color(0xFFD71920), width: 2),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Colors.red, width: 1),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Colors.red, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: 'Telefon (Opsiyonel)',
                                      hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                                      filled: true,
                                      fillColor: const Color(0xFFF8F9FA),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Color(0xFFD71920), width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _subjectController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Zorunlu alan';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Konu Başlığı',
                                      hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                                      filled: true,
                                      fillColor: const Color(0xFFF8F9FA),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Color(0xFFD71920), width: 2),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Colors.red, width: 1),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Colors.red, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _messageController,
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Lütfen mesajınızı yazınız';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Mesajınız',
                                hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                                filled: true,
                                fillColor: const Color(0xFFF8F9FA),
                                contentPadding: const EdgeInsets.all(20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFD71920), width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.red, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.red, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _sendEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD71920),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Mesaj Gönder',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward_rounded, size: 20),
                                ],
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
    );
  }

  Widget _buildModernContactCard(IconData icon, String title, String content, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFD71920).withOpacity(0.1),
                  const Color(0xFFE53935).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 32,
              color: const Color(0xFFD71920),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1F2937),
            const Color(0xFF111827),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/images/mnr-petrol.jpg',
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Kaliteli motor yağları ve endüstriyel ürünler',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF9CA3AF),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            '2008 yılından beri Akdeniz bölgesinde\nhizmet vermekteyiz',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HIZLI ERİŞİM',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildModernFooterLink('Ana Sayfa', Icons.home_outlined),
                          _buildModernFooterLink('Hakkımızda', Icons.info_outlined),
                          _buildModernFooterLink('Ürünler', Icons.inventory_2_outlined),
                          _buildModernFooterLink('Markalar', Icons.business_outlined),
                          _buildModernFooterLink('İletişim', Icons.mail_outlined),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'İLETİŞİM',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildContactInfo(Icons.phone_outlined, '+90 532 562 71 23'),
                          const SizedBox(height: 12),
                          _buildContactInfo(Icons.location_on_outlined, 'Uncalı Mh. Şehit Teğmen\nAbdulkadir Güler Cad.\nKonyaaltı / Antalya'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: const Text(
                  '© 2025 MNR Petrol. Tüm hakları saklıdır.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFooterLink(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (text == 'Hakkımızda') {
              context.go('/hakkimizda');
            } else if (text == 'Ana Sayfa') {
              context.go('/');
            } else if (text == 'İletişim') {
              // Önce ana sayfaya git, sonra scroll yap
              context.go('/');
              Future.delayed(const Duration(milliseconds: 400), () {
                _scrollToContact();
              });
            }
          },
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFFD71920),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

// Hakkımızda Sayfası
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Spacer for fixed top bar and header
              const SliverToBoxAdapter(
                child: SizedBox(height: 142), // 42px top bar + 100px header
              ),
              // About Content
              SliverToBoxAdapter(
                child: _buildAboutContent(context),
              ),
              // Footer
              SliverToBoxAdapter(
                child: _buildAboutPageFooter(context),
              ),
            ],
          ),
          // Fixed Top Info Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopInfoBar(),
          ),
          // Fixed Header
          Positioned(
            top: 42,
            left: 0,
            right: 0,
            child: _buildHeader(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.06),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo ve Şirket İsmi
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFF8F9FA),
                        Colors.white,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/mnr-petrol.jpg',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MNR Petrol Tarım İnş. San. Tic. Ltd. Şti.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        letterSpacing: 0.3,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Antalya Madeni Yağ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280),
                        letterSpacing: 0.2,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Navigation
            Row(
              children: [
                _buildNavItem(context, 'Ana Sayfa', false),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Ürünler', false),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Markalar', false),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Hakkımızda', true),
                const SizedBox(width: 32),
                _buildNavItem(context, 'İletişim', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, bool isActive) {
    // Ürünler için dropdown menü
    if (title == 'Ürünler') {
      return _ProductsDropdownNavItem(
        isActive: isActive,
        onProductSelected: (productName) {
          // Ana sayfaya git
          context.go('/');
        },
      );
    }
    
    // Markalar için dropdown menü
    if (title == 'Markalar') {
      return _BrandsDropdownNavItem(
        isActive: isActive,
        onBrandSelected: (brandName) {
          // Ana sayfaya git ve markalar bölümüne scroll yap
          context.go('/');
        },
      );
    }
    
    return _ModernNavItem(
      title: title,
      isActive: isActive,
      onTap: () {
        if (title == 'Ana Sayfa') {
          context.go('/');
        } else if (title == 'Hakkımızda') {
          context.go('/hakkimizda');
        } else if (title == 'İletişim') {
          // Ana sayfaya git ve iletişim alanına scroll yap
          context.go('/?scrollTo=contact');
        }
      },
    );
  }

  Widget _buildClickableYukunolsunText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 18,
          color: Color(0xFF4A4A4A),
          height: 1.8,
        ),
        children: [
          const TextSpan(
            text: 'Nakliye sektöründe büyük bir yenilik olarak hayata geçirdiğimiz ',
          ),
          TextSpan(
            text: 'yukunolsun.com',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFFD71920),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFFD71920),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                html.window.open('https://yukunolsun.com', '_blank');
              },
            mouseCursor: SystemMouseCursors.click,
          ),
          const TextSpan(
            text: ' platformumuz, araç sahipleri ile yük sahiplerini bir araya getiren inovatif bir dijital çözümdür. Modern teknoloji altyapımız ve güçlü yazılım sistemimiz sayesinde, nakliye süreçlerini hızlandırıyor, maliyetleri düşürüyor ve lojistik operasyonlarını optimize ediyoruz. Geniş araç filomuz ve deneyimli ekibimizle, sektörde dijital dönüşüme öncülük ederek müşterilerimize en verimli ve güvenilir hizmeti sunmaktayız.',
          ),
        ],
      ),
    );
  }

  Widget _buildAboutContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            const Color(0xFFF8F9FA),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
            children: [
              // Logo ve Başlık Bölümü
              Container(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    // Logo
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/mnr-petrol.jpg',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Başlık
                    Container(
                      width: 80,
                      height: 5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFD71920),
                            const Color(0xFFE53935),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'MNR Petrol',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              // Açıklama Metni
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  children: [
                    const Text(
                      '2008 yılında kurulan firmamız, Akdeniz bölgesinde otomotiv ve endüstriyel sektörlerin madeni yağ ihtiyacını karşılayan güvenilir çözüm ortağınızdır. Yılların deneyimiyle, kaliteli ürünler ve profesyonel hizmet anlayışımızla müşterilerimize değer katıyoruz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF4A4A4A),
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Partneri olduğumuz firmaların yurt dışı ve yurt içi Ar-Ge departmanları ile koordineli olarak çalışmakta, sektörün ihtiyacı olan özel ürünlerin oluşması ve sahaya sunulmasında öncülük etmekteyiz. Tamamı ile teknik ekiple hizmet veren firmamız, araç ve endüstriyel ekipmanlarınızın performansını maksimize etmek için en uygun yağlama çözümlerini sunmaktadır.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF4A4A4A),
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildClickableYukunolsunText(),
                    const SizedBox(height: 20),
                    const Text(
                      'Geniş ürün yelpazemiz ve uzman kadromuzla, madeni yağ konusunda her alanda siz saygıdeğer müşterilerimizin ihtiyacını karşılamak için çalışıyoruz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF4A4A4A),
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Feature Kartları - Grid Layout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 0.85,
                  children: [
                    _buildFeatureCard(
                      Icons.verified_outlined,
                      'Kalite Güvencesi',
                      'Tüm ürünlerimiz uluslararası standartlara uygun olarak tedarik edilir.',
                    ),
                    _buildFeatureCard(
                      Icons.support_agent_outlined,
                      'Uzman Destek',
                      'Deneyimli ekibimiz, size en uygun ürünü seçmenizde yardımcı olur.',
                    ),
                    _buildFeatureCard(
                      Icons.local_shipping_outlined,
                      'Hızlı Teslimat',
                      'Geniş stok ağımız ile siparişlerinizi zamanında teslim ediyoruz.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return _ModernFeatureCard(
      icon: icon,
      title: title,
      description: description,
    );
  }

  Widget _buildAboutPageFooter(BuildContext context) {
    // Ana sayfadaki modern footer'ı kullan
    return const ModernFooter();
  }
}

// Top Info Bar Widget (Tüm sayfalarda kullanılır)
Widget _buildTopInfoBar() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
    decoration: BoxDecoration(
      color: const Color(0xFF1F2937),
      border: Border(
        bottom: BorderSide(
          color: const Color(0xFFD71920).withOpacity(0.3),
          width: 1,
        ),
      ),
    ),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Telefon
            Icon(
              Icons.phone_outlined,
              size: 16,
              color: const Color(0xFFD71920),
            ),
            const SizedBox(width: 8),
            const Text(
              '+90 532 562 71 23',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFE5E7EB),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 30),
            Container(
              width: 1,
              height: 16,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(width: 30),
            // Adres
            Icon(
              Icons.location_on_outlined,
              size: 16,
              color: const Color(0xFFD71920),
            ),
            const SizedBox(width: 8),
            const Text(
              'Uncalı Mh., Konyaaltı / Antalya',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFE5E7EB),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Modern Footer Widget (Tüm sayfalarda kullanılır)
class ModernFooter extends StatelessWidget {
  const ModernFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1F2937),
            const Color(0xFF111827),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/mnr-petrol.jpg',
                              height: 45,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            'Kaliteli motor yağları ve\nendüstriyel ürünler',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF9CA3AF),
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HIZLI ERİŞİM',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                      const SizedBox(height: 20),
                      _buildFooterLink(context, 'Ana Sayfa', Icons.home_outlined),
                      _buildFooterLink(context, 'Ürünler', Icons.inventory_2_outlined),
                      _buildFooterLink(context, 'Markalar', Icons.business_outlined),
                      _buildFooterLink(context, 'Hakkımızda', Icons.info_outlined),
                      _buildFooterLink(context, 'İletişim', Icons.mail_outlined),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'İLETİŞİM',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildContactInfo(Icons.phone_outlined, '+90 532 562 71 23'),
                          const SizedBox(height: 12),
                          _buildContactInfo(Icons.location_on_outlined, 'Uncalı Mh. Şehit Teğmen\nAbdulkadir Güler Cad.\nKonyaaltı / Antalya'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: const Text(
                  '© 2025 MNR Petrol. Tüm hakları saklıdır.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (text == 'Hakkımızda') {
              context.go('/hakkimizda');
            } else if (text == 'Ana Sayfa') {
              context.go('/');
            } else if (text == 'İletişim') {
              context.go('/?scrollTo=contact');
            }
          },
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: const Color(0xFFD71920),
              ),
              const SizedBox(width: 12),
            Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFFD71920),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

// Modern Feature Card Widget with Hover Effect
class _ModernFeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ModernFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_ModernFeatureCard> createState() => _ModernFeatureCardState();
}

class _ModernFeatureCardState extends State<_ModernFeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered 
                ? const Color(0xFFD71920).withOpacity(0.3)
                : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFFD71920).withOpacity(0.15)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _isHovered ? 30 : 15,
              offset: Offset(0, _isHovered ? 12 : 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _isHovered
                    ? const Color(0xFFD71920)
                    : const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovered
                      ? const Color(0xFFD71920)
                      : const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: Icon(
                widget.icon,
                color: _isHovered 
                    ? Colors.white
                    : const Color(0xFFD71920),
                size: 28,
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _isHovered
                    ? const Color(0xFF111827)
                    : const Color(0xFF1F2937),
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.7,
                letterSpacing: 0.1,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
