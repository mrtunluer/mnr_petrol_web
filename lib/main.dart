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
    GoRoute(
      path: '/urunler',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: ProductsPage(
          brandFilter: state.uri.queryParameters['marka'],
          categoryFilter: state.uri.queryParameters['kategori'],
        ),
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
          // Kategori map
          String? kategori;
          if (productName == 'Motor Yağları') kategori = 'motor';
          else if (productName == 'Motorsiklet Yağları') kategori = 'motorsiklet';
          else if (productName == 'Şanzıman ve Dişli Yağları') kategori = 'sanziman';
          else if (productName == 'Hidrolik Sistem Yağları') kategori = 'hidrolik';
          else if (productName == 'Sarf Malzemeler') kategori = 'sarf';
          else if (productName == 'Antifrizler') kategori = 'antifriz';
          
          // Ürünler sayfasına kategori ile git
          if (kategori != null) {
            context.go('/urunler?kategori=$kategori');
          } else {
            context.go('/urunler');
          }
        },
      );
    }
    
    // Markalar için dropdown menü
    if (title == 'Markalar') {
      return _BrandsDropdownNavItem(
        isActive: isActive,
        onBrandSelected: (brandName) {
          // Ürünler sayfasına git ve marka filtrele
          context.go('/urunler?marka=${brandName.toLowerCase()}');
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
    {'name': 'Motor Yağları', 'icon': 'motor-yaglari.png', 'key': 'motor'},
    {'name': 'Motorsiklet Yağları', 'icon': 'motorsiklet-yaglari.png', 'key': 'motorsiklet'},
    {'name': 'Şanzıman ve Dişli Yağları', 'icon': 'sanziman.png', 'key': 'sanziman'},
    {'name': 'Hidrolik Sistem Yağları', 'icon': 'motor-bakim.png', 'key': 'hidrolik'},
    {'name': 'Sarf Malzemeler', 'icon': 'sarf-malzemeler.png', 'key': 'sarf'},
    {'name': 'Antifrizler', 'icon': 'antifiriz.png', 'key': 'antifriz'},
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
    {'name': 'Borax', 'logo': 'borax.png'},
    {'name': 'Japan Oil', 'logo': 'japanoil.png'},
    {'name': 'Xenol', 'logo': 'xenol.png'},
    {'name': 'Oilport', 'logo': 'oilport.png'},
    {'name': 'Brava', 'logo': 'brava.png'},
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
                    Icons.settings_outlined,
                    'Şanzıman ve Dişli Yağları',
                    'Şanzıman ve dişli sistemleri için özel formülasyonlu yağlar',
                    'assets/images/sanziman.png',
                  ),
                  _buildProductCardWithImage(
                    Icons.build_circle_outlined,
                    'Hidrolik Sistem Yağları',
                    'Hidrolik sistemleriniz için yüksek performanslı yağlar',
                    'assets/images/motor-bakim.png',
                  ),
                  _buildProductCardWithImage(
                    Icons.inventory_2_outlined,
                    'Sarf Malzemeler',
                    'Fren Hidrolik Sıvıları, Katkı Maddeleri',
                    'assets/images/sarf-malzemeler.png',
                  ),
                  _buildProductCardWithImage(
                    Icons.ac_unit_outlined,
                    'Antifrizler',
                    'Motor soğutma sistemleri için yüksek kaliteli antifriz ürünleri',
                    'assets/images/antifiriz.png',
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
                  _buildBrandLogo('assets/images/logos/borax.png', 'Borax'),
                  _buildBrandLogo('assets/images/logos/japanoil.png', 'Japan Oil'),
                  _buildBrandLogo('assets/images/logos/xenol.png', 'Xenol'),
                  _buildBrandLogo('assets/images/logos/oilport.png', 'Oilport'),
                  _buildBrandLogo('assets/images/logos/brava.png', 'Brava'),
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
          // Kategori map
          String? kategori;
          if (productName == 'Motor Yağları') kategori = 'motor';
          else if (productName == 'Motorsiklet Yağları') kategori = 'motorsiklet';
          else if (productName == 'Şanzıman ve Dişli Yağları') kategori = 'sanziman';
          else if (productName == 'Hidrolik Sistem Yağları') kategori = 'hidrolik';
          else if (productName == 'Sarf Malzemeler') kategori = 'sarf';
          else if (productName == 'Antifrizler') kategori = 'antifriz';
          
          // Ürünler sayfasına kategori ile git
          if (kategori != null) {
            context.go('/urunler?kategori=$kategori');
          } else {
            context.go('/urunler');
          }
        },
      );
    }
    
    // Markalar için dropdown menü
    if (title == 'Markalar') {
      return _BrandsDropdownNavItem(
        isActive: isActive,
        onBrandSelected: (brandName) {
          // Ürünler sayfasına git ve marka filtrele
          context.go('/urunler?marka=${brandName.toLowerCase()}');
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

// Ürünler Sayfası
class ProductsPage extends StatefulWidget {
  final String? brandFilter;
  final String? categoryFilter;

  const ProductsPage({
    super.key,
    this.brandFilter,
    this.categoryFilter,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String? _selectedBrand;
  String? _selectedCategory;

  final Map<String, List<Map<String, String>>> _products = {
    'borax-motor': [
      {'name': 'Borax Platinum Full Synthetic 10W40', 'image': 'assets/images/borax/motor/borax-10w40-bidon-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Ultimate DX 15W40', 'image': 'assets/images/borax/motor/borax-15w40-agır-dizel-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Ultimate DX 15W40', 'image': 'assets/images/borax/motor/borax-15w40-bidon-agır-dizel-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Ultimate DX 20W50', 'image': 'assets/images/borax/motor/borax-20w50-agır-dizel-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax 20W50', 'image': 'assets/images/borax/motor/borax-20w50-bidon-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Platinium Full Synthetic 5W40', 'image': 'assets/images/borax/motor/borax-5w40-bidon-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Platinium Full Synthetic DPF 5W30', 'image': 'assets/images/borax/motor/borax-dpf-5w30-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Full Synthetic Molygen Green 0W20', 'image': 'assets/images/borax/motor/borax-molygen-0w20-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Full Synthetic Molygen Green 0W30', 'image': 'assets/images/borax/motor/borax-molygen-0w30-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Full Synthetic Molygen Green 10W40', 'image': 'assets/images/borax/motor/borax-molygen-10w40-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Full Synthetic Molygen Green 5W30', 'image': 'assets/images/borax/motor/borax-molygen-5w30-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
    ],
    'borax-sanziman': [
      {'name': 'Borax Ultimate EP Series 30', 'image': 'assets/images/borax/sanziman/borax-30-sanzıman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax 75W80', 'image': 'assets/images/borax/sanziman/borax-75w80-sanzıman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax Ultimate EP Series 75W90', 'image': 'assets/images/borax/sanziman/borax-75w90-sanzıman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax Ultimate EP Series 80/90', 'image': 'assets/images/borax/sanziman/borax-80:90-sanzıman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax Ultimate EP Series 85W140', 'image': 'assets/images/borax/sanziman/borax-85w140-sanzıman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax EP 75W80', 'image': 'assets/images/borax/sanziman/borax-ep-75w80-sanzıman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax Ultimate EP Series', 'image': 'assets/images/borax/sanziman/borax-sanzıman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
    ],
    'borax-hidrolik': [
      {'name': 'Borax Hydro Plus 68 Hidrolik Sistem Yağı', 'image': 'assets/images/borax/hidrolik/borax-hidrolik.png', 'brand': 'Borax', 'category': 'Hidrolik Sistem Yağları'},
    ],
    'brava-motorsiklet': [
      {'name': 'Brava Extreme 9000 4T 10W40', 'image': 'assets/images/brava/motorsiklet/brava-10w40-4t-motorsiklet.png', 'brand': 'Brava', 'category': 'Motorsiklet Yağları'},
      {'name': 'Brava Extreme 6000 4T 10W40', 'image': 'assets/images/brava/motorsiklet/brava-10w40-4t-semi-motorsiklet.png', 'brand': 'Brava', 'category': 'Motorsiklet Yağları'},
      {'name': 'Brava Extreme 6000 4T 10W50', 'image': 'assets/images/brava/motorsiklet/brava-10w50-4t-semi-motorsiklet.png', 'brand': 'Brava', 'category': 'Motorsiklet Yağları'},
      {'name': 'Brava Extreme 9000 4T 10W50', 'image': 'assets/images/brava/motorsiklet/brava-10w50-motorsiklet.png', 'brand': 'Brava', 'category': 'Motorsiklet Yağları'},
      {'name': 'Brava Extreme 6000 4T 15W50', 'image': 'assets/images/brava/motorsiklet/brava-15w50-4t-motorsiklet.png', 'brand': 'Brava', 'category': 'Motorsiklet Yağları'},
      {'name': 'Brava Extreme 6000 4T 5W40', 'image': 'assets/images/brava/motorsiklet/brava-5w40-4t-semi-motorsiklet.png', 'brand': 'Brava', 'category': 'Motorsiklet Yağları'},
      {'name': 'Brava Extreme 9000 4T 5W50', 'image': 'assets/images/brava/motorsiklet/brava-5w50-4t-motorsiklet.png', 'brand': 'Brava', 'category': 'Motorsiklet Yağları'},
    ],
    'brava-katki': [
      {'name': 'Brava Zincir Temizleyici', 'image': 'assets/images/brava/katki/brava-chain cleaner.png', 'brand': 'Brava', 'category': 'Katkı Maddeleri'},
      {'name': 'Brava Katkı', 'image': 'assets/images/brava/katki/brava-katki.png', 'brand': 'Brava', 'category': 'Katkı Maddeleri'},
      {'name': 'Brava Nano Complex', 'image': 'assets/images/brava/katki/brava-nano-katki.png', 'brand': 'Brava', 'category': 'Katkı Maddeleri'},
    ],
    'japanoil-motor': [
      {'name': 'Japan Oil Molytech Sn+ Plus Tam Sentetik 5W30', 'image': 'assets/images/japanoil/motor/japanoil-bipower-molytech-5w30.png', 'brand': 'Japan Oil', 'category': 'Motor Yağları'}
    ],
    'japanoil-motorsiklet': [
      {'name': 'Japan Oil 4T 10W-40 SN MA2 Red', 'image': 'assets/images/japanoil/motorsiklet/japanoil-bipower-10w40-motorsiklet.png', 'brand': 'Japan Oil', 'category': 'Motorsiklet Yağları'},
      {'name': 'Japan Oıl 4T 15W-50 SM-MA 2 Purple', 'image': 'assets/images/japanoil/motorsiklet/japanoil-bipower-15w50-motorsiklet.png', 'brand': 'Japan Oil', 'category': 'Motorsiklet Yağları'},
      {'name': 'Japan Oil 4T 20W40 SE-MA 2 Grey', 'image': 'assets/images/japanoil/motorsiklet/japanoil-bipower-20w40-motorsiklet.png', 'brand': 'Japan Oil', 'category': 'Motorsiklet Yağları'},
    ],
    'japanoil-sanziman': [
      {'name': 'Japan Oil Otomatik Şanzıman Cvt Fluid-Ns-3', 'image': 'assets/images/japanoil/sanziman/japanoil-bipower-cvt-ns3-sanzıman.png', 'brand': 'Japan Oil', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Japan Oil Otomatik Şanzıman Atf-Cvt-Fe', 'image': 'assets/images/japanoil/sanziman/japanoil-bipower-cvt-sanzıman.png', 'brand': 'Japan Oil', 'category': 'Şanzıman ve Dişli Yağları'},
    ],
    'xenol-motor': [
      {'name': 'Xenol Ceramix Blue 10W40 SN/CF', 'image': 'assets/images/xenol/motor/xenol-10w40.png', 'brand': 'Xenol', 'category': 'Motor Yağları'},
      {'name': 'Xenol Ceramix Blue 5W30 SN/CF', 'image': 'assets/images/xenol/motor/xenol-5w30-motor.png', 'brand': 'Xenol', 'category': 'Motor Yağları'},
    ],
    'xenol-sanziman': [
      {'name': 'Xenol Atf Dexron VI', 'image': 'assets/images/xenol/sanziman/xenol-atf-dexron-sanzıman.png', 'brand': 'Xenol', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Xenol Cvt Fluid', 'image': 'assets/images/xenol/sanziman/xenol-cvt-sanzıman.png', 'brand': 'Xenol', 'category': 'Şanzıman ve Dişli Yağları'},
    ],
    'xenol-hidrolik': [
      {'name': 'Xenol Green Atf', 'image': 'assets/images/xenol/direksiyon/xenol-green-atf-direksiyon.png', 'brand': 'Xenol', 'category': 'Hidrolik Sistem Yağları'},
    ],
    'oilport-motor': [
      {'name': 'Oilport 10W40', 'image': 'assets/images/oilport/motor/oilport-10w40-motor.png', 'brand': 'Oilport', 'category': 'Motor Yağları'},
      {'name': 'Oilport 20W50', 'image': 'assets/images/oilport/motor/oilport-20w50-motor.png', 'brand': 'Oilport', 'category': 'Motor Yağları'},
      {'name': 'Oilport 5W30', 'image': 'assets/images/oilport/motor/oilport-5w30-motor.png', 'brand': 'Oilport', 'category': 'Motor Yağları'},
    ],
    'oilport-motorsiklet': [
      {'name': 'Oilport 4T 10W40', 'image': 'assets/images/oilport/motorsiklet/oilport-4t-10w40-motorsiklet.png', 'brand': 'Oilport', 'category': 'Motorsiklet Yağları'},
    ],
    'oilport-hidrolik': [
      {'name': 'Oilport ATF', 'image': 'assets/images/oilport/direksiyon/oilport-atf-direksiyon.png', 'brand': 'Oilport', 'category': 'Hidrolik Sistem Yağları'},
    ],
    'oilport-antifriz': [
      {'name': 'Oilport Bidon Antifreeze', 'image': 'assets/images/oilport/antifriz/oilport-bidon-antifreeze.png', 'brand': 'Oilport', 'category': 'Antifrizler'},
    ],
    'oilport-katki': [
      {'name': 'Oilport Bıçkı Zincir Yağı', 'image': 'assets/images/oilport/sarf/oilport-zincir.png', 'brand': 'Oilport', 'category': 'Katkı Maddeleri'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedBrand = widget.brandFilter;
    _selectedCategory = widget.categoryFilter;
  }

  String _getCategoryDisplayName(String? key) {
    if (key == null || key == 'Tümü') return 'Tümü';
    switch (key) {
      case 'motor':
        return 'Motor Yağları';
      case 'motorsiklet':
        return 'Motorsiklet Yağları';
      case 'sanziman':
        return 'Şanzıman ve Dişli Yağları';
      case 'hidrolik':
        return 'Hidrolik Sistem Yağları';
      case 'antifriz':
        return 'Antifrizler';
      case 'direksiyon':
        return 'Direksiyon';
      case 'fren':
        return 'Fren Hidrolik Sıvıları';
      case 'katki':
        return 'Katkı Maddeleri';
      case 'sarf':
        return 'Sarf Malzemeler';
      default:
        return key;
    }
  }

  List<Map<String, String>> _getFilteredProducts() {
    List<Map<String, String>> filtered = [];
    
    _products.forEach((key, products) {
      bool matchesBrand = _selectedBrand == null || _selectedBrand == 'Tümü';
      bool matchesCategory = _selectedCategory == null || _selectedCategory == 'Tümü';
      
      if (_selectedBrand != null && _selectedBrand != 'Tümü') {
        // "Japan Oil" -> "japanoil", "Borax" -> "borax"
        String normalizedBrand = _selectedBrand!.toLowerCase().replaceAll(' ', '');
        matchesBrand = key.toLowerCase().startsWith(normalizedBrand);
      }
      
      if (_selectedCategory != null && _selectedCategory != 'Tümü') {
        String normalizedCategory = _selectedCategory!.toLowerCase();
        String lowerKey = key.toLowerCase();
        
        // "sarf" seçilirse hem fren hem katkı ürünlerini göster
        if (normalizedCategory == 'sarf') {
          matchesCategory = lowerKey.contains('-katki') || lowerKey.contains('-fren');
        } 
        // "katki" seçilirse kategori badge'ine göre filtrele
        else if (normalizedCategory == 'katki') {
          // Ürünlerin category field'ına bak
          matchesCategory = products.any((product) => 
            product['category']?.toLowerCase().contains('katkı') ?? false
          );
        }
        // "fren" seçilirse kategori badge'ine göre filtrele
        else if (normalizedCategory == 'fren') {
          matchesCategory = products.any((product) => 
            product['category']?.toLowerCase().contains('fren') ?? false
          );
        }
        // Diğer kategoriler için key bazlı kontrol
        else {
          // Kesin eşleşme için: "-motor" ve "-motorsiklet" ayrı ayrı kontrol edilmeli
          if (normalizedCategory == 'motor') {
            // Sadece "-motor" ile biten, "-motorsiklet" olmayanlar
            matchesCategory = lowerKey.contains('-motor') && !lowerKey.contains('-motorsiklet');
          } else if (normalizedCategory == 'motorsiklet') {
            matchesCategory = lowerKey.contains('-motorsiklet');
          } else {
            matchesCategory = lowerKey.contains('-$normalizedCategory');
          }
        }
      }
      
      if (matchesBrand && matchesCategory) {
        filtered.addAll(products);
      }
    });
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();
    
    return SelectionArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Spacer for fixed elements
                const SliverToBoxAdapter(
                  child: SizedBox(height: 142), // 42px top bar + 100px header
                ),
                // Content
                SliverToBoxAdapter(
                  child: _buildContent(context, filteredProducts),
                ),
                // Footer
                SliverToBoxAdapter(
                  child: ModernFooter(),
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
            GestureDetector(
              onTap: () => context.go('/'),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
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
              ),
            ),
            // Navigation
            Row(
              children: [
                _buildNavItem(context, 'Ana Sayfa', false),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Ürünler', true),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Markalar', false),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Hakkımızda', false),
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
          // Kategori map
          String? kategori;
          if (productName == 'Motor Yağları') kategori = 'motor';
          else if (productName == 'Motorsiklet Yağları') kategori = 'motorsiklet';
          else if (productName == 'Şanzıman ve Dişli Yağları') kategori = 'sanziman';
          else if (productName == 'Hidrolik Sistem Yağları') kategori = 'hidrolik';
          else if (productName == 'Sarf Malzemeler') kategori = 'sarf';
          else if (productName == 'Antifrizler') kategori = 'antifriz';
          
          // Ürünler sayfasına kategori ile git
          if (kategori != null) {
            context.go('/urunler?kategori=$kategori');
          } else {
            context.go('/urunler');
          }
        },
      );
    }
    
    // Markalar için dropdown menü
    if (title == 'Markalar') {
      return _BrandsDropdownNavItem(
        isActive: isActive,
        onBrandSelected: (brandName) {
          context.go('/urunler?marka=${brandName.toLowerCase()}');
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
          context.go('/?scrollTo=contact');
        }
      },
    );
  }

  Widget _buildContent(BuildContext context, List<Map<String, String>> products) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'ÜRÜNLER',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              // Breadcrumb
              _buildBreadcrumb(),
              const SizedBox(height: 40),
              // Sidebar + Products Layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sol - Sidebar Filtreler (280px)
                  SizedBox(
                    width: 280,
                    child: _buildSidebar(),
                  ),
                  const SizedBox(width: 40),
                  // Sağ - Ürünler
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ürün sayısı
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFD71920).withOpacity(0.1),
                                    const Color(0xFFD71920).withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFD71920).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${products.length}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFD71920),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Ürün Bulundu',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        // Products Grid
                        if (products.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 100),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Bu filtreye uygun ürün bulunamadı',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // 3 kolon (sidebar varken)
                              mainAxisSpacing: 24,
                              crossAxisSpacing: 24,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return _buildProductCard(products[index]);
                            },
                          ),
                      ],
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

  Widget _buildFilters() {
    return Row(
      children: [
        // Brand Filter
        _buildFilterDropdown(
          'Marka',
          _selectedBrand ?? 'Tümü',
          ['Tümü', 'Borax', 'Brava', 'Japan Oil', 'Xenol', 'Oilport'],
          (value) {
            setState(() {
              _selectedBrand = value == 'Tümü' ? null : value;
            });
          },
        ),
        const SizedBox(width: 20),
        // Category Filter
        _buildFilterDropdown(
          'Kategori',
          _getCategoryDisplayName(_selectedCategory ?? 'Tümü'),
          [
            'Tümü',
            'Motor Yağları',
            'Motorsiklet Yağları',
            'Şanzıman ve Dişli Yağları',
            'Hidrolik Sistem Yağları',
            'Sarf Malzemeler',
            'Fren Hidrolik Sıvıları',  // Ok yok - DropdownButton'da eklenecek
            'Katkı Maddeleri',          // Ok yok - DropdownButton'da eklenecek
          ],
          (value) {
            setState(() {
              if (value == 'Tümü') {
                _selectedCategory = null;
              } else if (value == 'Motor Yağları') {
                _selectedCategory = 'motor';
              } else if (value == 'Motorsiklet Yağları') {
                _selectedCategory = 'motorsiklet';
              } else if (value == 'Şanzıman ve Dişli Yağları') {
                _selectedCategory = 'sanziman';
              } else if (value == 'Hidrolik Sistem Yağları') {
                _selectedCategory = 'hidrolik';
              } else if (value == 'Sarf Malzemeler') {
                _selectedCategory = 'sarf';
              } else if (value == 'Fren Hidrolik Sıvıları') {
                _selectedCategory = 'fren';
              } else if (value == 'Katkı Maddeleri') {
                _selectedCategory = 'katki';
              }
            });
          },
        ),
        const Spacer(),
        // Result count
        Text(
          '${_getFilteredProducts().length} Ürün',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items, Function(String) onChanged) {
    return _ModernFilterDropdown(
      label: label,
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildBreadcrumb() {
    List<String> breadcrumbs = ['Ürünler'];
    
    if (_selectedBrand != null && _selectedBrand != 'Tümü') {
      breadcrumbs.add(_selectedBrand!);
    }
    
    if (_selectedCategory != null) {
      breadcrumbs.add(_getCategoryDisplayName(_selectedCategory));
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.home_rounded,
            size: 16,
            color: Color(0xFF9CA3AF),
          ),
          const SizedBox(width: 8),
          for (int i = 0; i < breadcrumbs.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: Colors.grey[300],
                ),
              ),
            Text(
              breadcrumbs[i],
              style: TextStyle(
                fontSize: 13,
                fontWeight: i == breadcrumbs.length - 1 ? FontWeight.w700 : FontWeight.w500,
                color: i == breadcrumbs.length - 1
                    ? const Color(0xFFD71920)
                    : const Color(0xFF6B7280),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFFAFAFA),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filtreler başlığı
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD71920).withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD71920).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: Color(0xFFD71920),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Filtreler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          // Marka filtresi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildSidebarSection('Marka', _buildBrandFilters()),
                const SizedBox(height: 20),
                Divider(color: Colors.grey[200], thickness: 1),
                const SizedBox(height: 20),
                _buildSidebarSection('Kategori', _buildCategoryFilters()),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6B7280),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildBrandFilters() {
    final brands = ['Tümü', 'Borax', 'Brava', 'Japan Oil', 'Xenol', 'Oilport'];
    String selected = _selectedBrand ?? 'Tümü';
    
    return Column(
      children: brands.asMap().entries.map((entry) {
        int index = entry.key;
        String brand = entry.value;
        bool isSelected = brand == selected;
        return _buildCheckboxItem(
          brand,
          isSelected,
          () {
            setState(() {
              _selectedBrand = brand == 'Tümü' ? null : brand;
            });
          },
          key: 'brand_$index',
        );
      }).toList(),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = [
      {'name': 'Tümü', 'key': null, 'isSubCategory': false},
      {'name': 'Motor Yağları', 'key': 'motor', 'isSubCategory': false},
      {'name': 'Motorsiklet Yağları', 'key': 'motorsiklet', 'isSubCategory': false},
      {'name': 'Şanzıman ve Dişli Yağları', 'key': 'sanziman', 'isSubCategory': false},
      {'name': 'Hidrolik Sistem Yağları', 'key': 'hidrolik', 'isSubCategory': false},
      {'name': 'Sarf Malzemeler', 'key': 'sarf', 'isSubCategory': false},
      {'name': 'Fren Hidrolik Sıvıları', 'key': 'fren', 'isSubCategory': true},
      {'name': 'Katkı Maddeleri', 'key': 'katki', 'isSubCategory': true},
    ];
    
    return Column(
      children: categories.asMap().entries.map((entry) {
        int index = entry.key;
        var category = entry.value;
        bool isSelected = _selectedCategory == category['key'];
        bool isSubCategory = category['isSubCategory'] as bool;
        
        return _buildCheckboxItem(
          category['name'] as String,
          isSelected,
          () {
            setState(() {
              _selectedCategory = category['key'] as String?;
            });
          },
          indent: isSubCategory ? 20.0 : 0.0,
          key: 'category_$index',
        );
      }).toList(),
    );
  }

  Widget _buildCheckboxItem(String label, bool isSelected, VoidCallback onTap, {double indent = 0.0, String key = ''}) {
    return _AnimatedCheckboxItem(
      key: ValueKey(key),
      label: label,
      isSelected: isSelected,
      onTap: onTap,
      indent: indent,
    );
  }

  Widget _buildProductCard(Map<String, String> product) {
    return _ModernProductCard(product: product);
  }
}

// Animated Checkbox Item Widget for Sidebar
class _AnimatedCheckboxItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double indent;

  const _AnimatedCheckboxItem({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.indent = 0.0,
  }) : super(key: key);

  @override
  State<_AnimatedCheckboxItem> createState() => _AnimatedCheckboxItemState();
}

class _AnimatedCheckboxItemState extends State<_AnimatedCheckboxItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(
            left: widget.indent + 12,
            top: 10,
            bottom: 10,
            right: 12,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFFD71920).withOpacity(0.08)
                : _isHovered
                    ? const Color(0xFFF3F4F6)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected
                        ? const Color(0xFFD71920)
                        : _isHovered
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFFD1D5DB),
                    width: 2,
                  ),
                  color: widget.isSelected ? const Color(0xFFD71920) : Colors.transparent,
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFD71920).withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : [],
                ),
                child: widget.isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: widget.isSelected
                        ? const Color(0xFF111827)
                        : _isHovered
                            ? const Color(0xFF374151)
                            : const Color(0xFF6B7280),
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

// Modern Filter Dropdown Widget
class _ModernFilterDropdown extends StatefulWidget {
  final String label;
  final String value;
  final List<String> items;
  final Function(String) onChanged;

  const _ModernFilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<_ModernFilterDropdown> createState() => _ModernFilterDropdownState();
}

class _ModernFilterDropdownState extends State<_ModernFilterDropdown> {
  bool _isHovered = false;

  IconData _getIconForLabel() {
    if (widget.label == 'Marka') {
      return Icons.local_offer_outlined;
    } else if (widget.label == 'Kategori') {
      return Icons.category_outlined;
    }
    return Icons.filter_list;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minWidth: 280), // Minimum genişlik
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFF8F9FA),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.06),
              blurRadius: _isHovered ? 14 : 10,
              offset: Offset(0, _isHovered ? 5 : 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIconForLabel(),
                size: 18,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(width: 12),
            // Label ve Dropdown birlikte
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${widget.label}:',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 8),
                // Dropdown
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.white,
                  ),
                  child: DropdownButton<String>(
                    value: widget.value,
                    underline: const SizedBox(),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFFD71920),
                      size: 24,
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                      letterSpacing: -0.2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: Colors.white,
                    elevation: 8,
                    selectedItemBuilder: (BuildContext context) {
                      // Seçili item'da ok işareti gösterme
                      return widget.items.map((item) {
                        return Text(
                          item, // Ok işareti yok, sadece isim
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            letterSpacing: -0.2,
                          ),
                        );
                      }).toList();
                    },
                items: widget.items.map((item) {
                  bool isSelected = item == widget.value;
                  
                  // Alt kategorileri belirle (Sarf Malzemeler'in altındakiler)
                  bool isSubCategory = item == 'Fren Hidrolik Sıvıları' || item == 'Katkı Maddeleri';
                  
                  return DropdownMenuItem(
                    value: item, // Temiz value
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // Ok işareti için sabit genişlik
                          SizedBox(
                            width: 20,
                            child: Text(
                              isSubCategory ? '→' : '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xFFD71920)
                                    : const Color(0xFF111827),
                              ),
                            ),
                          ),
                          // Kategori adı
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xFFD71920)
                                    : const Color(0xFF111827),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        widget.onChanged(newValue);
                      }
                    },
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

// Modern Product Card Widget
class _ModernProductCard extends StatefulWidget {
  final Map<String, String> product;

  const _ModernProductCard({required this.product});

  @override
  State<_ModernProductCard> createState() => _ModernProductCardState();
}

class _ModernProductCardState extends State<_ModernProductCard> {
  bool _isHovered = false;

  String _getBrandLogoFileName(String brandName) {
    // "Japan Oil" -> "japanoil", "Borax" -> "borax", etc.
    return brandName.toLowerCase().replaceAll(' ', '');
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -12 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFFD71920).withOpacity(0.3)
                : const Color(0xFFE5E7EB),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFFD71920).withOpacity(0.2)
                  : Colors.black.withOpacity(0.06),
              blurRadius: _isHovered ? 30 : 15,
              offset: Offset(0, _isHovered ? 16 : 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Container with Gradient
            Expanded(
              child: Stack(
                children: [
                  // Background
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFF8F9FA),
                          const Color(0xFFFFFFFF),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Image.asset(
                      widget.product['image']!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Category Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD71920),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD71920).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.product['category']!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  // Brand Logo
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logos/${_getBrandLogoFileName(widget.product['brand']!)}.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product['name']!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _isHovered ? const Color(0xFFD71920) : const Color(0xFF111827),
                      height: 1.4,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Brand Name
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.product['brand']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
