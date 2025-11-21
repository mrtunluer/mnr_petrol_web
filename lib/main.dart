import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
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
    GoRoute(
      path: '/urun/:id',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: ProductDetailPage(
          productId: state.pathParameters['id']!,
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
  final ScrollController _featuredScrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _contactKey = GlobalKey();
  final _brandsKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isScrolled = false;
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  String? _lastScrollTo;
  
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
    
    // Featured products scroll listener
    _featuredScrollController.addListener(() {
      _updateArrowVisibility();
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Her route değişiminde query parametresini kontrol et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = GoRouterState.of(context).uri;
      final scrollTo = uri.queryParameters['scrollTo'];
      
      // Sadece scrollTo değişmişse scroll yap (gereksiz scroll'ları önle)
      if (scrollTo != null && scrollTo != _lastScrollTo) {
        _lastScrollTo = scrollTo;
        
        // ÖNEMLİ: URL'i HEMEN temizle (scroll öncesi), 
        // böylece browser history'de temiz URL olacak
        _cleanScrollParameter();
        
        if (scrollTo == 'contact') {
          Future.delayed(const Duration(milliseconds: 400), () {
            _scrollToContact();
          });
        } else if (scrollTo == 'brands') {
          Future.delayed(const Duration(milliseconds: 400), () {
            _scrollToBrands();
          });
        }
      } else if (scrollTo == null && _lastScrollTo != null) {
        _lastScrollTo = null;
      }
      
      // İlk yüklemede ok görünürlüğünü kontrol et
      if (_featuredScrollController.hasClients) {
        _updateArrowVisibility();
      }
    });
  }
  
  void _cleanScrollParameter() {
    // URL'den scrollTo parametresini temizle (browser history'de)
    // Sayfa yenilenmeden URL'i güncelle
    // Hash routing (#/) veya normal routing'e göre düzelt
    final cleanUrl = html.window.location.hash.isNotEmpty ? '/#/' : '/';
    html.window.history.replaceState(null, '', cleanUrl);
    _lastScrollTo = null;
  }
  
  void _updateArrowVisibility() {
    if (!_featuredScrollController.hasClients) return;
    
    final position = _featuredScrollController.position;
    setState(() {
      _showLeftArrow = position.pixels > 0;
      _showRightArrow = position.pixels < position.maxScrollExtent;
    });
  }
  
  void _scrollFeaturedProducts(bool scrollRight) {
    if (!_featuredScrollController.hasClients) return;
    
    final screenWidth = MediaQuery.of(context).size.width;
    final scrollAmount = screenWidth < 768 ? 200.0 : 300.0;
    
    final targetOffset = scrollRight
        ? _featuredScrollController.offset + scrollAmount
        : _featuredScrollController.offset - scrollAmount;
    
    _featuredScrollController.animateTo(
      targetOffset.clamp(0.0, _featuredScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _featuredScrollController.dispose();
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

  void _scrollToBrands() {
    final context = _brandsKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.1, // Biraz yukarıdan göster (ekranın %10'undan başla)
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Spacer for fixed top bar and header
              SliverToBoxAdapter(
                child: SizedBox(height: isMobile ? 90 : 142), // Mobile: 32px top bar + 58px header, Desktop: 42px + 100px
              ),
              // Hero Section
              SliverToBoxAdapter(
                child: _buildHeroSection(context),
              ),
              // Featured Products Section (Öne Çıkan Ürünler)
              SliverToBoxAdapter(
                child: _buildFeaturedProductsSection(context),
              ),
              // Products Section
              SliverToBoxAdapter(
                child: _buildProductsSection(context),
              ),
              // Brands Section
              SliverToBoxAdapter(
                child: Container(
                  key: _brandsKey,
                child: _buildBrandsSection(context),
                ),
              ),
              // Contact Section
              SliverToBoxAdapter(
                child: _buildContactSection(context),
              ),
              // Footer
              SliverToBoxAdapter(
                child: ModernFooter(
                  onBrandsScroll: _scrollToBrands,
                  onContactScroll: _scrollToContact,
                ),
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
            top: isMobile ? 32 : 42,
            left: 0,
            right: 0,
            child: _buildFloatingHeader(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isMobile ? 58 : 100,
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
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 60,
          vertical: isMobile ? 8 : 10,
        ),
        child: isMobile
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo (Mobil - Küçük)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF8F9FA),
                          Colors.white,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/mnr-petrol.jpg',
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Hamburger Menu
                  IconButton(
                    icon: const Icon(Icons.menu),
                    iconSize: 28,
                    color: const Color(0xFF111827),
                    onPressed: () {
                      _showMobileMenu(context);
                    },
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo ve Şirket İsmi (Desktop)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFF8F9FA),
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
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MNR Petrol Tarım İnş. San. Tic. Ltd. Şti.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                              letterSpacing: 0.3,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Antalya Madeni Yağ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                              letterSpacing: 0.2,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Navigation (Desktop)
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

  void _showMobileMenu(BuildContext context) {
    showGlobalMobileMenu(
      context,
      currentPage: 'home',
      onContactTap: _scrollToContact,
      onBrandsTap: _scrollToBrands,
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
          else if (productName == 'Fren Hidrolik Sıvıları') kategori = 'fren';
          else if (productName == 'Katkı Maddeleri') kategori = 'katki';
          
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
          // Ürünler sayfasına git ve marka filtrele (boşlukları kaldır)
          context.go('/urunler?marka=${brandName.toLowerCase().replaceAll(' ', '')}');
        },
        onHeaderTap: () {
          // Ana sayfadaysak direkt scroll (daha smooth)
          _scrollToBrands();
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
          // Query parameter ile scroll yap (Ana sayfada olsak da olmasak da çalışır)
          _scrollToContact();
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
  final VoidCallback? onHeaderTap;

  const _BrandsDropdownNavItem({
    required this.isActive,
    required this.onBrandSelected,
    this.onHeaderTap,
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
    {'name': 'Skynell', 'logo': 'skynell.png'},
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
      child: GestureDetector(
        onTap: widget.onHeaderTap,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    return SizedBox(
      height: isMobile ? 600 : (isTablet ? 650 : 700),
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
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                padding: EdgeInsets.only(
                  top: isMobile ? 80 : (isTablet ? 110 : 140),
                  bottom: isMobile ? 80 : (isTablet ? 110 : 140),
                  left: isMobile ? 20 : (isTablet ? 30 : 40),
                  right: isMobile ? 20 : (isTablet ? 30 : 40),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  // Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 18 : 24,
                      vertical: isMobile ? 8 : 10,
                    ),
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
                    child: Text(
                      'PREMİUM KALİTE',
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: isMobile ? 2 : 3,
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 20 : 25),
                  // Main Title
                  Text(
                    'MNR PETROL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 36 : (isTablet ? 52 : 68),
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: isMobile ? 2 : 4,
                      height: 1.1,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 4),
                          blurRadius: 20,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 14 : 18),
                  // Subtitle
                  Text(
                    'Yüksek Performanslı Motor Yağları ve Endüstriyel Ürünler',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 15 : (isTablet ? 18 : 22),
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: 0.5,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 10,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 35 : 45),
                  // Buttons
                  Wrap(
                    spacing: isMobile ? 12 : 16,
                    runSpacing: isMobile ? 12 : 16,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go('/urunler'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD71920),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 24 : 36,
                            vertical: isMobile ? 16 : 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 8,
                          shadowColor: const Color(0xFFD71920).withOpacity(0.6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ürünlerimizi Keşfedin',
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: isMobile ? 8 : 10),
                            Icon(Icons.arrow_forward, size: isMobile ? 18 : 20),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _scrollToContact,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white, width: isMobile ? 2 : 2.5),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 24 : 36,
                            vertical: isMobile ? 16 : 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone, size: isMobile ? 18 : 20),
                            SizedBox(width: isMobile ? 8 : 10),
                            Text(
                              'İletişime Geç',
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 40 : 55),
                  // Stats
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : (isTablet ? 28 : 40),
                      vertical: isMobile ? 20 : (isTablet ? 25 : 30),
                    ),
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
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatCard('15+', 'Yıllık Tecrübe', isMobile),
                          Container(
                            height: isMobile ? 40 : 50,
                            width: 1,
                            margin: EdgeInsets.symmetric(horizontal: isMobile ? 12 : (isTablet ? 28 : 40)),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildStatCard('1000+', 'Mutlu Müşteri', isMobile),
                          Container(
                            height: isMobile ? 40 : 50,
                            width: 1,
                            margin: EdgeInsets.symmetric(horizontal: isMobile ? 12 : (isTablet ? 28 : 40)),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildStatCard('5', 'Premium Marka', isMobile),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label, bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: isMobile ? 28 : 38,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1,
          ),
        ),
        SizedBox(height: isMobile ? 6 : 8),
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 11 : 13,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : (isTablet ? 50 : 60),
        horizontal: isMobile ? 20 : (isTablet ? 30 : 40),
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Container(
                width: isMobile ? 50 : 60,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD71920),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: isMobile ? 16 : 20),
              Text(
                'Ürünlerimiz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 28 : (isTablet ? 36 : 42),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: isMobile ? 12 : 20),
              Text(
                'Geniş ürün yelpazemiz ile her türlü ihtiyacınıza çözüm sunuyoruz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 18,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
              SizedBox(height: isMobile ? 40 : (isTablet ? 50 : 60)),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                mainAxisSpacing: isMobile ? 16 : (isTablet ? 20 : 24),
                crossAxisSpacing: isMobile ? 16 : (isTablet ? 20 : 24),
                childAspectRatio: isMobile ? 1.4 : (isTablet ? 1.2 : 1.1),
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
    // Kategori mapping
    String? kategori;
    if (title == 'Motor Yağları') kategori = 'motor';
    else if (title == 'Motorsiklet Yağları') kategori = 'motorsiklet';
    else if (title == 'Şanzıman ve Dişli Yağları') kategori = 'sanziman';
    else if (title == 'Hidrolik Sistem Yağları') kategori = 'hidrolik';
    else if (title == 'Sarf Malzemeler') kategori = 'sarf';
    else if (title == 'Antifrizler') kategori = 'antifriz';
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (kategori != null) {
            context.go('/urunler?kategori=$kategori');
          } else {
            context.go('/urunler');
          }
        },
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
      ),
    );
  }

  // Featured Products Section (Öne Çıkan Ürünler)
  Widget _buildFeaturedProductsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    // Öne çıkan ürünler listesi
    final featuredProducts = [
      // Borax Molygen Serisi (EN ÖNE ALINMIŞTIR)
      {
        'name': 'Borax Full Synthetic Molygen Green 0W20',
        'image': 'assets/images/borax/motor/borax-molygen-0w20-motor.png',
        'brand': 'Borax',
        'category': 'Motor Yağları',
        'badge': 'Molygen',
      },
      {
        'name': 'Borax Full Synthetic Molygen Green 0W30',
        'image': 'assets/images/borax/motor/borax-molygen-0w30-motor.png',
        'brand': 'Borax',
        'category': 'Motor Yağları',
        'badge': 'Molygen',
      },
      {
        'name': 'Borax Full Synthetic Molygen Green 5W30',
        'image': 'assets/images/borax/motor/borax-molygen-5w30-motor.png',
        'brand': 'Borax',
        'category': 'Motor Yağları',
        'badge': 'Molygen',
      },
      {
        'name': 'Borax Full Synthetic Molygen Green 10W40',
        'image': 'assets/images/borax/motor/borax-molygen-10w40-motor.png',
        'brand': 'Borax',
        'category': 'Motor Yağları',
        'badge': 'Molygen',
      },
      // Japan Oil
      {
        'name': 'Japan Oil Molytech Sn+ Plus Tam Sentetik 5W30',
        'image': 'assets/images/japanoil/motor/japanoil-bipower-molytech-5w30.png',
        'brand': 'Japan Oil',
        'category': 'Motor Yağları',
        'badge': 'Japan Oil',
      },
      // Xenol Motor Yağları
      {
        'name': 'Xenol Ceramix Blue 10W40 SN/CF',
        'image': 'assets/images/xenol/motor/xenol-10w40.png',
        'brand': 'Xenol',
        'category': 'Motor Yağları',
        'badge': 'Ceramix',
      },
      {
        'name': 'Xenol Ceramix Blue 5W30 SN/CF',
        'image': 'assets/images/xenol/motor/xenol-5w30-motor.png',
        'brand': 'Xenol',
        'category': 'Motor Yağları',
        'badge': 'Ceramix',
      },
    ];

    return Container(
      padding: EdgeInsets.only(
        top: isMobile ? 40 : (isTablet ? 50 : 60),
        bottom: isMobile ? 40 : (isTablet ? 50 : 60),
        left: isMobile ? 0 : (isTablet ? 30 : 40),
        right: isMobile ? 0 : (isTablet ? 30 : 40),
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Kırmızı çizgi (diğer section'larla uyumlu)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 0),
                child: Container(
                  width: isMobile ? 50 : 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD71920),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 16 : 20),
              // Başlık
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 0),
                child: Text(
                  'Öne Çıkan Ürünler',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 28 : (isTablet ? 36 : 42),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 12 : 20),
              // Alt başlık
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 0),
                child: Text(
                  'Premium ve özel ürünlerimizi keşfedin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 18,
                    color: const Color(0xFF4A4A4A),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 40 : (isTablet ? 50 : 60)),
              
              // Ürünler (Horizontal scroll - Mobil ve Desktop)
              Stack(
                children: [
                  SizedBox(
                    height: isMobile ? 320 : (isTablet ? 380 : 400),
                    child: Listener(
                      onPointerSignal: (event) {
                        // Touchpad/Mouse wheel horizontal scroll'u yakala
                        if (event is PointerScrollEvent) {
                          // Scroll delta'yı al (trackpad horizontal scroll için)
                          final delta = event.scrollDelta;
                          
                          // Yatay scroll öncelikli (trackpad'de sola/sağa kaydırma)
                          if (delta.dx.abs() > delta.dy.abs()) {
                            // Yatay kaydırma daha baskın
                            if (_featuredScrollController.hasClients) {
                              final newOffset = _featuredScrollController.offset + delta.dx;
                              _featuredScrollController.jumpTo(
                                newOffset.clamp(
                                  0.0,
                                  _featuredScrollController.position.maxScrollExtent,
                                ),
                              );
                            }
                          } else if (delta.dy.abs() > 0) {
                            // Dikey kaydırma - izin ver (normal scroll için)
                            if (_featuredScrollController.hasClients) {
                              final newOffset = _featuredScrollController.offset + delta.dy;
                              _featuredScrollController.jumpTo(
                                newOffset.clamp(
                                  0.0,
                                  _featuredScrollController.position.maxScrollExtent,
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: ListView.builder(
                        controller: _featuredScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : (isTablet ? 30 : 40),
                        ),
                        itemCount: featuredProducts.length,
                        itemBuilder: (context, index) {
                          final product = featuredProducts[index];
                          return Container(
                            width: isMobile ? 180 : (isTablet ? 240 : 280),
                            margin: EdgeInsets.only(
                              right: index < featuredProducts.length - 1 
                                  ? (isMobile ? 16 : 24) 
                                  : 0,
                            ),
                            child: _FeaturedProductCard(
                              product: product,
                              isMobile: isMobile,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Sola scroll ok işareti (sadece sol tarafa scroll edilebiliyorsa)
                  if (_showLeftArrow)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _scrollFeaturedProducts(false),
                          child: Container(
                            width: isMobile ? 50 : 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.white.withOpacity(0),
                                  Colors.white.withOpacity(0.9),
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(isMobile ? 8 : 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD71920),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFD71920).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                  size: isMobile ? 20 : 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Sağa scroll ok işareti (sadece sağ tarafa scroll edilebiliyorsa)
                  if (_showRightArrow)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _scrollFeaturedProducts(true),
                          child: Container(
                            width: isMobile ? 50 : 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.white.withOpacity(0),
                                  Colors.white.withOpacity(0.9),
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(isMobile ? 8 : 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD71920),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFD71920).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: isMobile ? 20 : 24,
                                ),
                              ),
                            ),
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

  Widget _buildBrandsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : (isTablet ? 50 : 60),
        horizontal: isMobile ? 20 : (isTablet ? 30 : 40),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8F9FA),
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
                width: isMobile ? 50 : 60,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD71920),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: isMobile ? 16 : 20),
              Text(
                'Markalarımız',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 28 : (isTablet ? 36 : 42),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: isMobile ? 12 : 20),
              Text(
                'Güvenilir ve kaliteli markalarla hizmetinizdeyiz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 18,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
              SizedBox(height: isMobile ? 40 : (isTablet ? 50 : 60)),
              // Mobilde Wrap kullan (alt alta), Desktop/Tablet'te 3'er 3'er satırlar
              if (isMobile)
              Wrap(
                  spacing: 24,
                  runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  _buildBrandLogo('assets/images/logos/borax.png', 'Borax', isMobile, isTablet),
                  _buildBrandLogo('assets/images/logos/japanoil.png', 'Japan Oil', isMobile, isTablet),
                  _buildBrandLogo('assets/images/logos/xenol.png', 'Xenol', isMobile, isTablet),
                  _buildBrandLogo('assets/images/logos/oilport.png', 'Oilport', isMobile, isTablet),
                  _buildBrandLogo('assets/images/logos/brava.png', 'Brava', isMobile, isTablet),
                    _buildBrandLogo('assets/images/logos/skynell.png', 'Skynell', isMobile, isTablet),
                  ],
                )
              else
                Column(
                  children: [
                    // İlk satır - 3 marka
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBrandLogo('assets/images/logos/borax.png', 'Borax', isMobile, isTablet),
                        SizedBox(width: isTablet ? 32 : 40),
                        _buildBrandLogo('assets/images/logos/japanoil.png', 'Japan Oil', isMobile, isTablet),
                        SizedBox(width: isTablet ? 32 : 40),
                        _buildBrandLogo('assets/images/logos/xenol.png', 'Xenol', isMobile, isTablet),
                      ],
                    ),
                    SizedBox(height: isTablet ? 32 : 40),
                    // İkinci satır - 3 marka
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBrandLogo('assets/images/logos/oilport.png', 'Oilport', isMobile, isTablet),
                        SizedBox(width: isTablet ? 32 : 40),
                        _buildBrandLogo('assets/images/logos/brava.png', 'Brava', isMobile, isTablet),
                        SizedBox(width: isTablet ? 32 : 40),
                        _buildBrandLogo('assets/images/logos/skynell.png', 'Skynell', isMobile, isTablet),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandLogo(String imagePath, String brandName, bool isMobile, bool isTablet) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Marka ismini normalize et (Japan Oil -> japanoil)
          String markaParam = brandName.toLowerCase().replaceAll(' ', '');
          context.go('/urunler?marka=$markaParam');
        },
        child: Container(
          width: isMobile ? 140 : (isTablet ? 170 : 200),
          height: isMobile ? 90 : (isTablet ? 105 : 120),
          padding: EdgeInsets.all(isMobile ? 16 : (isTablet ? 18 : 20)),
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
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    return Container(
      key: _contactKey,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 50 : (isTablet ? 65 : 80),
        horizontal: isMobile ? 20 : (isTablet ? 30 : 40),
      ),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/iletisim-arkaplan.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black54,
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
                width: isMobile ? 60 : 80,
                height: isMobile ? 4 : 5,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFD71920),
                      Color(0xFFE53935),
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
              SizedBox(height: isMobile ? 20 : 25),
              Text(
                'Bize Ulaşın',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 32 : (isTablet ? 40 : 48),
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1,
                  shadows: const [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 12 : 15),
              Text(
                'Sorularınız için her zaman yanınızdayız',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 15 : 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  shadows: const [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 40 : (isTablet ? 50 : 60)),
              Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: isMobile ? 0 : 5,
                    fit: isMobile ? FlexFit.loose : FlexFit.tight,
                    child: Column(
                      children: [
                        _buildModernContactCard(
                          Icons.phone_in_talk_rounded,
                          'Telefon',
                          '+90 532 562 71 23',
                          'Hafta içi 09:00 - 18:00',
                          isMobile,
                          isTablet,
                        ),
                        SizedBox(height: isMobile ? 16 : 24),
                        _buildModernContactCard(
                          Icons.location_on_rounded,
                          'Adres',
                          'Uncalı Mh. Şehit Teğmen Abdulkadir Güler Cad.',
                          'Bilgi Sitesi, Konyaaltı / Antalya',
                          isMobile,
                          isTablet,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: isMobile ? 0 : 40, height: isMobile ? 24 : 0),
                  Flexible(
                    flex: isMobile ? 0 : 7,
                    fit: isMobile ? FlexFit.loose : FlexFit.tight,
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 24 : (isTablet ? 32 : 40)),
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
                            Text(
                              'Mesaj Gönderin',
                              style: TextStyle(
                                fontSize: isMobile ? 22 : (isTablet ? 25 : 28),
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1A1A1A),
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: isMobile ? 6 : 8),
                            Text(
                              'Formu doldurun, size en kısa sürede geri dönüş yapalım',
                              style: TextStyle(
                                fontSize: isMobile ? 13 : 15,
                                color: const Color(0xFF6B7280),
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: isMobile ? 24 : 32),
                            if (isMobile) ...[
                              TextFormField(
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
                              const SizedBox(height: 16),
                              TextFormField(
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
                            ] else
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
                            if (isMobile) ...[
                              TextFormField(
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
                              const SizedBox(height: 16),
                              TextFormField(
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
                            ] else
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

  Widget _buildModernContactCard(IconData icon, String title, String content, String subtitle, bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 24 : 28)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: isMobile ? 20 : 30,
            offset: Offset(0, isMobile ? 6 : 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFD71920).withOpacity(0.1),
                  const Color(0xFFE53935).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
            ),
            child: Icon(
              icon,
              size: isMobile ? 24 : 32,
              color: const Color(0xFFD71920),
            ),
          ),
          SizedBox(width: isMobile ? 14 : 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9CA3AF),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: isMobile ? 4 : 6),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                ),
                SizedBox(height: isMobile ? 3 : 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

// Hakkımızda Sayfası
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Spacer for fixed top bar and header
              SliverToBoxAdapter(
                child: SizedBox(height: isMobile ? 90 : 142), // Mobile: 32px + 58px, Desktop: 42px + 100px
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
            top: isMobile ? 32 : 42,
            left: 0,
            right: 0,
            child: _buildHeader(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Container(
      height: isMobile ? 58 : 100,
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
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 60,
          vertical: isMobile ? 8 : 10,
        ),
        child: isMobile
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo (Mobil - Küçük)
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF8F9FA),
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/mnr-petrol.jpg',
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Hamburger Menu
                  IconButton(
                    icon: const Icon(Icons.menu, size: 28),
                    color: const Color(0xFF111827),
                    onPressed: () {
                      showGlobalMobileMenu(context, currentPage: 'about');
                    },
                  ),
                ],
              )
            : Row(
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
                              gradient: const LinearGradient(
                      colors: [
                                  Color(0xFFF8F9FA),
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
                          const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                              Text(
                      'MNR Petrol Tarım İnş. San. Tic. Ltd. Şti.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        letterSpacing: 0.3,
                        height: 1.3,
                      ),
                    ),
                              SizedBox(height: 4),
                    Text(
                      'Antalya Madeni Yağ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B7280),
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

  Widget _buildMobileMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFD71920), size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827),
              ),
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
          else if (productName == 'Fren Hidrolik Sıvıları') kategori = 'fren';
          else if (productName == 'Katkı Maddeleri') kategori = 'katki';
          
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
          // Ürünler sayfasına git ve marka filtrele (boşlukları kaldır)
          context.go('/urunler?marka=${brandName.toLowerCase().replaceAll(' ', '')}');
        },
        onHeaderTap: () {
          // Ana sayfaya git ve markalar bölümüne scroll yap
          context.go('/?scrollTo=brands');
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

  Widget _buildClickableYukunolsunText(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: isMobile ? 15 : 18,
          color: const Color(0xFF4A4A4A),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFF8F9FA),
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
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 30 : 60,
                  horizontal: isMobile ? 20 : 0,
                ),
                child: Column(
                  children: [
                    // Logo
                    Container(
                      padding: EdgeInsets.all(isMobile ? 20 : 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(isMobile ? 15 : 20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: isMobile ? 20 : 30,
                            offset: Offset(0, isMobile ? 5 : 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/mnr-petrol.jpg',
                        height: isMobile ? 50 : 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: isMobile ? 24 : 40),
                    // Başlık
                    Container(
                      width: isMobile ? 60 : 80,
                      height: isMobile ? 4 : 5,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFD71920),
                            Color(0xFFE53935),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(height: isMobile ? 20 : 30),
                    Text(
                      'MNR Petrol',
                      style: TextStyle(
                        fontSize: isMobile ? 32 : 48,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1A1A1A),
                        letterSpacing: isMobile ? -0.5 : -1,
                      ),
                    ),
                  ],
                ),
              ),
              // Açıklama Metni
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 40,
                  vertical: isMobile ? 10 : 20,
                ),
                child: Column(
                  children: [
                    Text(
                      '2008 yılında kurulan firmamız, Akdeniz bölgesinde otomotiv ve endüstriyel sektörlerin madeni yağ ihtiyacını karşılayan güvenilir çözüm ortağınızdır. Yılların deneyimiyle, kaliteli ürünler ve profesyonel hizmet anlayışımızla müşterilerimize değer katıyoruz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 18,
                        color: const Color(0xFF4A4A4A),
                        height: 1.8,
                      ),
                    ),
                    SizedBox(height: isMobile ? 16 : 20),
                    Text(
                      'Partneri olduğumuz firmaların yurt dışı ve yurt içi Ar-Ge departmanları ile koordineli olarak çalışmakta, sektörün ihtiyacı olan özel ürünlerin oluşması ve sahaya sunulmasında öncülük etmekteyiz. Tamamı ile teknik ekiple hizmet veren firmamız, araç ve endüstriyel ekipmanlarınızın performansını maksimize etmek için en uygun yağlama çözümlerini sunmaktadır.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 18,
                        color: const Color(0xFF4A4A4A),
                        height: 1.8,
                      ),
                    ),
                    SizedBox(height: isMobile ? 16 : 20),
                    _buildClickableYukunolsunText(context),
                    SizedBox(height: isMobile ? 16 : 20),
                    Text(
                      'Geniş ürün yelpazemiz ve uzman kadromuzla, madeni yağ konusunda her alanda siz saygıdeğer müşterilerimizin ihtiyacını karşılamak için çalışıyoruz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 18,
                        color: const Color(0xFF4A4A4A),
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 24 : 40),
              // Feature Kartları - Grid Layout
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 40,
                  vertical: isMobile ? 20 : 40,
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                  mainAxisSpacing: isMobile ? 16 : 24,
                  crossAxisSpacing: isMobile ? 16 : 24,
                  childAspectRatio: isMobile ? 1.3 : (isTablet ? 0.9 : 0.85),
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
              SizedBox(height: isMobile ? 24 : 40),
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

// Global Mobile Menu Widget (Tüm sayfalarda tutarlı hamburger menü)
void showGlobalMobileMenu(BuildContext context, {String? currentPage, VoidCallback? onContactTap, VoidCallback? onBrandsTap}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          _buildGlobalMobileMenuItem(
            context,
            'Ana Sayfa',
            Icons.home_outlined,
            () {
              Navigator.pop(context);
              context.go('/');
            },
            isActive: currentPage == 'home',
          ),
          _buildGlobalMobileMenuItem(
            context,
            'Ürünler',
            Icons.inventory_2_outlined,
            () {
              Navigator.pop(context);
              context.go('/urunler');
            },
            isActive: currentPage == 'products',
          ),
          _buildGlobalMobileMenuItem(
            context,
            'Markalar',
            Icons.business_outlined,
            () {
              Navigator.pop(context);
              if (currentPage == 'home' && onBrandsTap != null) {
                // Ana sayfadayız, direkt scroll yap
                Future.delayed(const Duration(milliseconds: 300), () {
                  onBrandsTap();
                });
              } else {
                // Başka sayfadayız, ana sayfaya git ve scroll yap
                context.go('/?scrollTo=brands');
              }
            },
            isActive: false,
          ),
          _buildGlobalMobileMenuItem(
            context,
            'Hakkımızda',
            Icons.info_outlined,
            () {
              Navigator.pop(context);
              context.go('/hakkimizda');
            },
            isActive: currentPage == 'about',
          ),
          _buildGlobalMobileMenuItem(
            context,
            'İletişim',
            Icons.mail_outlined,
            () {
              Navigator.pop(context);
              if (currentPage == 'home' && onContactTap != null) {
                // Ana sayfadayız, direkt scroll yap
                Future.delayed(const Duration(milliseconds: 300), () {
                  onContactTap();
                });
              } else {
                // Başka sayfadayız, ana sayfaya git ve scroll yap
                context.go('/?scrollTo=contact');
              }
            },
            isActive: currentPage == 'contact',
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

Widget _buildGlobalMobileMenuItem(
  BuildContext context,
  String title,
  IconData icon,
  VoidCallback onTap, {
  bool isActive = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD71920).withOpacity(0.05) : null,
        border: Border(
          left: BorderSide(
            color: isActive ? const Color(0xFFD71920) : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFD71920) : const Color(0xFF6B7280),
            size: 24,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? const Color(0xFFD71920) : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    ),
  );
}

// Top Info Bar Widget (Tüm sayfalarda kullanılır)
Widget _buildTopInfoBar() {
  return Builder(
    builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isMobile = screenWidth < 768;
      
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 8 : 10,
          horizontal: isMobile ? 16 : 40,
        ),
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
                  size: isMobile ? 14 : 16,
                  color: const Color(0xFFD71920),
                ),
                SizedBox(width: isMobile ? 6 : 8),
                Text(
                  '+90 532 562 71 23',
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 13,
                    color: const Color(0xFFE5E7EB),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 30),
                  Container(
                    width: 1,
                    height: 16,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  const SizedBox(width: 30),
                  // Adres
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Color(0xFFD71920),
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
              ],
            ),
          ),
        ),
      );
    },
  );
}

// Featured Product Card Widget (Ana sayfa tasarımı ile uyumlu)
class _FeaturedProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isMobile;

  const _FeaturedProductCard({
    required this.product,
    required this.isMobile,
  });

  @override
  State<_FeaturedProductCard> createState() => _FeaturedProductCardState();
}

class _FeaturedProductCardState extends State<_FeaturedProductCard> {
  bool _isHovered = false;

  String _generateProductId() {
    // Ürün ID'si: brand-name formatında URL-safe
    String brand = (widget.product['brand'] ?? '').toLowerCase().replaceAll(' ', '-');
    String name = (widget.product['name'] ?? '').toLowerCase()
        .replaceAll(' ', '-')
        .replaceAll('/', '-')
        .replaceAll('ı', 'i')
        .replaceAll('ş', 's')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'[^\w-]'), '');
    
    return '$brand-$name';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          context.go('/urun/${_generateProductId()}');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered 
                  ? const Color(0xFFD71920)
                  : Colors.grey.withOpacity(0.2),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? const Color(0xFFD71920).withOpacity(0.15)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isHovered ? 12 : 8,
                offset: Offset(0, _isHovered ? 6 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ürün Görseli
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      padding: EdgeInsets.all(widget.isMobile ? 8 : 16),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            widget.product['image']!,
                            fit: BoxFit.contain,
                            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) return child;
                              return frame != null
                                  ? child
                                  : const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFD71920),
                                        strokeWidth: 2,
                                      ),
                                    );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Badge (Sağ üst)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.isMobile ? 8 : 10,
                          vertical: widget.isMobile ? 4 : 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD71920),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.product['badge'] ?? 'Premium',
                          style: TextStyle(
                            fontSize: widget.isMobile ? 9 : 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Ürün Bilgileri
              Padding(
                padding: EdgeInsets.all(widget.isMobile ? 10 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Marka
                    Text(
                      widget.product['brand']!,
                      style: TextStyle(
                        fontSize: widget.isMobile ? 11 : 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFD71920),
                      ),
                    ),
                    SizedBox(height: widget.isMobile ? 4 : 6),
                    // Ürün Adı
                    Text(
                      widget.product['name']!,
                      style: TextStyle(
                        fontSize: widget.isMobile ? 13 : 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: widget.isMobile ? 8 : 12),
                    // Detay butonu
                    Row(
                      children: [
                        Text(
                          'Detayları Gör',
                          style: TextStyle(
                            fontSize: widget.isMobile ? 12 : 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD71920),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: widget.isMobile ? 14 : 16,
                          color: const Color(0xFFD71920),
                        ),
                      ],
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
}

// Modern Footer Widget (Tüm sayfalarda kullanılır)
class ModernFooter extends StatelessWidget {
  final VoidCallback? onBrandsScroll;
  final VoidCallback? onContactScroll;
  
  const ModernFooter({
    super.key,
    this.onBrandsScroll,
    this.onContactScroll,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F172A), // Slate 900
            const Color(0xFF020617), // Slate 950
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD71920).withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 40 : 60,
              horizontal: isMobile ? 20 : 40,
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD71920).withOpacity(0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/mnr-petrol.jpg',
                            height: 42,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          'Kaliteli motor yağları ve endüstriyel ürünler',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Hızlı Erişim
                      const Text(
                        'HIZLI ERİŞİM',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildMobileFooterLink(context, 'Ana Sayfa', Icons.home_outlined),
                      _buildMobileFooterLink(context, 'Ürünler', Icons.inventory_2_outlined),
                      _buildMobileFooterLink(context, 'Markalar', Icons.business_outlined),
                      _buildMobileFooterLink(context, 'Hakkımızda', Icons.info_outlined),
                      _buildMobileFooterLink(context, 'İletişim', Icons.mail_outlined),
                      const SizedBox(height: 20),
                      // İletişim Bilgileri
                      const Text(
                        'İLETİŞİM',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.phone_outlined,
                            size: 14,
                            color: Color(0xFFD71920),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                            '+90 532 562 71 23',
                              style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Color(0xFFD71920),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Uncalı Mh. Şehit Teğmen\nAbdulkadir Güler Cad.\nKonyaaltı / Antalya',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
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
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFD71920).withOpacity(0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/images/mnr-petrol.jpg',
                                    height: 55,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                const Text(
                                  'Kaliteli motor yağları ve\nendüstriyel ürünler',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF94A3B8),
                                    height: 1.8,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.2,
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
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 20 : 28,
              horizontal: isMobile ? 20 : 40,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    Text(
                      '© ${DateTime.now().year} MNR Petrol Tarım İnş. San. Tic. Ltd. Şti.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: isMobile ? 6 : 8),
                    Text(
                      'Tüm hakları saklıdır.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 12,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFooterLink(BuildContext context, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          if (text == 'Hakkımızda') {
            context.go('/hakkimizda');
          } else if (text == 'Ana Sayfa') {
            context.go('/');
          } else if (text == 'İletişim') {
            if (onContactScroll != null) {
              // Ana sayfadaysak direkt scroll yap
              onContactScroll!();
            } else {
            context.go('/?scrollTo=contact');
            }
          } else if (text == 'Markalar') {
            if (onBrandsScroll != null) {
              // Ana sayfadaysak direkt scroll yap
              onBrandsScroll!();
            } else {
              context.go('/?scrollTo=brands');
            }
          } else if (text == 'Ürünler') {
            context.go('/urunler');
          }
        },
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: const Color(0xFFD71920),
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
            } else if (text == 'Ürünler') {
              context.go('/urunler');
            } else if (text == 'Markalar') {
              if (onBrandsScroll != null) {
                // Ana sayfadaysak direkt scroll yap
                onBrandsScroll!();
              } else {
                context.go('/?scrollTo=brands');
              }
            } else if (text == 'İletişim') {
              if (onContactScroll != null) {
                // Ana sayfadaysak direkt scroll yap
                onContactScroll!();
              } else {
              context.go('/?scrollTo=contact');
              }
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

  static final Map<String, List<Map<String, String>>> _products = {
    'borax-motor': [
      // Molygen Serisi (Premium)
      {'name': 'Borax Full Synthetic Molygen Green 0W20', 'image': 'assets/images/borax/motor/borax-molygen-0w20-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Full Synthetic Molygen Green 0W30', 'image': 'assets/images/borax/motor/borax-molygen-0w30-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Full Synthetic Molygen Green 5W30', 'image': 'assets/images/borax/motor/borax-molygen-5w30-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Full Synthetic Molygen Green 10W40', 'image': 'assets/images/borax/motor/borax-molygen-10w40-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      // Diğer Motor Yağları
      {'name': 'Borax Platinum Full Synthetic 10W40', 'image': 'assets/images/borax/motor/borax-10w40-bidon-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Platinium Full Synthetic DPF 5W30', 'image': 'assets/images/borax/motor/borax-dpf-5w30-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Platinium Full Synthetic 5W40', 'image': 'assets/images/borax/motor/borax-5w40-bidon-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Ultimate DX 15W40', 'image': 'assets/images/borax/motor/borax-15w40-agir-dizel-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Ultimate DX 15W40', 'image': 'assets/images/borax/motor/borax-15w40-bidon-agir-dizel-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax Ultimate DX 20W50', 'image': 'assets/images/borax/motor/borax-20w50-agir-dizel-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
      {'name': 'Borax 20W50', 'image': 'assets/images/borax/motor/borax-20w50-bidon-motor.png', 'brand': 'Borax', 'category': 'Motor Yağları'},
    ],
    'borax-sanziman': [
      {'name': 'Borax Ultimate EP Series 30', 'image': 'assets/images/borax/sanziman/borax-30-sanziman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax 75W80', 'image': 'assets/images/borax/sanziman/borax-75w80-sanziman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax Ultimate EP Series 75W90', 'image': 'assets/images/borax/sanziman/borax-75w90-sanziman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax Ultimate EP Series 80/90', 'image': 'assets/images/borax/sanziman/borax-80-90-sanziman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax Ultimate EP Series 85W140', 'image': 'assets/images/borax/sanziman/borax-85w140-sanziman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax EP 75W80', 'image': 'assets/images/borax/sanziman/borax-ep-75w80-sanziman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Borax Ultimate EP Series', 'image': 'assets/images/borax/sanziman/borax-sanziman.png', 'brand': 'Borax', 'category': 'Şanzıman ve Dişli Yağları'},
    ],
    'borax-hidrolik': [
      {'name': 'Borax Hydro Plus 68 Hidrolik Sistem Yağı', 'image': 'assets/images/borax/hidrolik/borax-hidrolik.png', 'brand': 'Borax', 'category': 'Hidrolik Sistem Yağları'},
      {'name': 'Borax Hydro Plus 46 Hidrolik Sistem Yağı', 'image': 'assets/images/borax/hidrolik/borax-hidrolik.png', 'brand': 'Borax', 'category': 'Hidrolik Sistem Yağları'},
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
      {'name': 'Brava Zincir Temizleyici', 'image': 'assets/images/brava/katki/brava-chain-cleaner.png', 'brand': 'Brava', 'category': 'Katkı Maddeleri'},
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
      {'name': 'Japan Oil Otomatik Şanzıman Cvt Fluid-Ns-3', 'image': 'assets/images/japanoil/sanziman/japanoil-bipower-cvt-ns3-sanziman.png', 'brand': 'Japan Oil', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Japan Oil Otomatik Şanzıman Atf-Cvt-Fe', 'image': 'assets/images/japanoil/sanziman/japanoil-bipower-cvt-sanziman.png', 'brand': 'Japan Oil', 'category': 'Şanzıman ve Dişli Yağları'},
    ],
    'xenol-motor': [
      {'name': 'Xenol Ceramix Blue 10W40 SN/CF', 'image': 'assets/images/xenol/motor/xenol-10w40.png', 'brand': 'Xenol', 'category': 'Motor Yağları'},
      {'name': 'Xenol Ceramix Blue 5W30 SN/CF', 'image': 'assets/images/xenol/motor/xenol-5w30-motor.png', 'brand': 'Xenol', 'category': 'Motor Yağları'},
    ],
    'xenol-sanziman': [
      {'name': 'Xenol Atf Dexron VI', 'image': 'assets/images/xenol/sanziman/xenol-atf-dexron-sanziman.png', 'brand': 'Xenol', 'category': 'Şanzıman ve Dişli Yağları'},
      {'name': 'Xenol Cvt Fluid', 'image': 'assets/images/xenol/sanziman/xenol-cvt-sanziman.png', 'brand': 'Xenol', 'category': 'Şanzıman ve Dişli Yağları'},
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
      {'name': 'Oilport Antifreeze', 'image': 'assets/images/oilport/antifriz/oilport-bidon-antifreeze.png', 'brand': 'Oilport', 'category': 'Antifrizler'},
    ],
    'oilport-katki': [
      {'name': 'Oilport Bıçkı Zincir Yağı', 'image': 'assets/images/oilport/sarf/oilport-zincir.png', 'brand': 'Oilport', 'category': 'Katkı Maddeleri'},
    ],
    'skynell-fren': [
      {'name': 'Skynell DOT3', 'image': 'assets/images/skynell/fren/skynell-dot3-fren.png', 'brand': 'Skynell', 'category': 'Fren Hidrolik Sıvıları'},
      {'name': 'Skynell DOT4', 'image': 'assets/images/skynell/fren/skynell-dot4-fren.png', 'brand': 'Skynell', 'category': 'Fren Hidrolik Sıvıları'},
      {'name': 'Skynell Balata Temizleyici', 'image': 'assets/images/skynell/fren/skynell-balata.png', 'brand': 'Skynell', 'category': 'Fren Hidrolik Sıvıları'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedBrand = widget.brandFilter;
    _selectedCategory = widget.categoryFilter;
  }

  void _updateUrl() {
    // URL query parametrelerini güncelle
    final Map<String, String> params = {};
    
    if (_selectedBrand != null && _selectedBrand != 'Tümü') {
      params['marka'] = _selectedBrand!;
    }
    
    if (_selectedCategory != null && _selectedCategory != 'Tümü') {
      params['kategori'] = _selectedCategory!;
    }
    
    // URL'yi güncelle (state korunur)
    final uri = Uri(path: '/urunler', queryParameters: params.isEmpty ? null : params);
    context.go(uri.toString());
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
        // "katki" seçilirse sadece katkı maddeleri
        else if (normalizedCategory == 'katki') {
          matchesCategory = lowerKey.contains('-katki');
        }
        // "fren" seçilirse sadece fren hidrolik sıvıları
        else if (normalizedCategory == 'fren') {
          matchesCategory = lowerKey.contains('-fren');
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return SelectionArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Spacer for fixed elements
                SliverToBoxAdapter(
                  child: SizedBox(height: isMobile ? 90 : 142), // Mobile: 32px top bar + 58px header, Desktop: 42px + 100px
                ),
                // Content
                SliverToBoxAdapter(
                  child: _buildContent(context, filteredProducts),
                ),
                // Footer
                const SliverToBoxAdapter(
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
              top: isMobile ? 32 : 42,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Container(
      height: isMobile ? 58 : 100,
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
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 60,
          vertical: isMobile ? 8 : 10,
        ),
        child: isMobile
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo (Mobil - Küçük)
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF8F9FA),
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/mnr-petrol.jpg',
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Hamburger Menu
                  IconButton(
                    icon: const Icon(Icons.menu, size: 28),
                    color: const Color(0xFF111827),
                    onPressed: () {
                      showGlobalMobileMenu(context, currentPage: 'products');
                    },
                  ),
                ],
              )
            : Row(
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
                              gradient: const LinearGradient(
                          colors: [
                                  Color(0xFFF8F9FA),
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
                          const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                              Text(
                          'MNR Petrol Tarım İnş. San. Tic. Ltd. Şti.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            letterSpacing: 0.3,
                            height: 1.3,
                          ),
                        ),
                              SizedBox(height: 4),
                        Text(
                          'Antalya Madeni Yağ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B7280),
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

  Widget _buildMobileMenu(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          _buildMobileMenuItem(context, 'Ana Sayfa', Icons.home_outlined, () {
            Navigator.pop(context);
            context.go('/');
          }),
          _buildMobileMenuItem(context, 'Ürünler', Icons.inventory_2_outlined, () {
            Navigator.pop(context);
            // Zaten ürünler sayfasındayız
          }),
          _buildMobileMenuItem(context, 'Hakkımızda', Icons.info_outlined, () {
            Navigator.pop(context);
            context.go('/hakkimizda');
          }),
          _buildMobileMenuItem(context, 'İletişim', Icons.mail_outlined, () {
            Navigator.pop(context);
            context.go('/?scrollTo=contact');
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMobileMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFD71920), size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827),
              ),
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
          else if (productName == 'Fren Hidrolik Sıvıları') kategori = 'fren';
          else if (productName == 'Katkı Maddeleri') kategori = 'katki';
          
          // State'i güncelle ve URL'yi değiştir
          setState(() {
            _selectedCategory = kategori;
            _selectedBrand = null; // Markayı temizle - sadece kategori filtresi
          });
          _updateUrl();
        },
      );
    }
    
    // Markalar için dropdown menü
    if (title == 'Markalar') {
      return _BrandsDropdownNavItem(
        isActive: isActive,
        onBrandSelected: (brandName) {
          // Marka ismini normalize et ve _updateUrl kullanarak state'i güncelle
          String markaParam = brandName.toLowerCase().replaceAll(' ', '');
          setState(() {
            _selectedBrand = markaParam;
            _selectedCategory = null; // Kategoriyi temizle - sadece marka filtresi
          });
          _updateUrl();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 30 : 60,
        horizontal: isMobile ? 16 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'ÜRÜNLER',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 36,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111827),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              // Breadcrumb
              _buildBreadcrumb(),
              SizedBox(height: isMobile ? 24 : 40),
              // Sidebar + Products Layout
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mobil Filtre Butonu + Ürün Sayısı
                    Row(
                      children: [
                        // Filtre Butonu
                        ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) => _buildFilterDrawer(context),
                            );
                          },
                          icon: const Icon(Icons.tune, size: 20),
                          label: const Text('Filtrele'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD71920),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                        const Spacer(),
                        // Ürün Sayısı (Modern Badge)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFD71920),
                                      Color(0xFFFF4757),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFD71920).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${products.length}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Ürün',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF9CA3AF),
                                      letterSpacing: 0.3,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Bulundu',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[800],
                                      letterSpacing: 0.2,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // Aktif Filtreler (Mobil)
                    if (_selectedBrand != null || _selectedCategory != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            // Marka Filtresi
                            if (_selectedBrand != null && _selectedBrand != 'Tümü')
                              _buildFilterChip(
                                label: _selectedBrand!,
                                icon: Icons.business_outlined,
                                onRemove: () {
                                  setState(() => _selectedBrand = null);
                                  _updateUrl();
                                },
                              ),
                            // Kategori Filtresi
                            if (_selectedCategory != null && _selectedCategory != 'Tümü')
                              _buildFilterChip(
                                label: _getCategoryDisplayName(_selectedCategory),
                                icon: Icons.category_outlined,
                                onRemove: () {
                                  setState(() => _selectedCategory = null);
                                  _updateUrl();
                                },
                              ),
                            // Tümünü Temizle
                            if ((_selectedBrand != null && _selectedBrand != 'Tümü') || 
                                (_selectedCategory != null && _selectedCategory != 'Tümü'))
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedBrand = null;
                                    _selectedCategory = null;
                                  });
                                  _updateUrl();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.clear_all_rounded,
                                        size: 16,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Tümünü Temizle',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    // Products Grid - Mobil (Modern E-ticaret Tasarımı)
                    if (products.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 80),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 56,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Ürün Bulunamadı',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Farklı filtreler deneyin',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _ModernMobileProductCard(product: products[index]),
                          );
                        },
                      ),
                  ],
                )
              else
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
                        // Ürün sayısı (Modern Badge - Desktop)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFD71920),
                                          Color(0xFFFF4757),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFD71920).withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                    '${products.length}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  const Text(
                                        'Ürün',
                                    style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF9CA3AF),
                                          letterSpacing: 0.3,
                                          height: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Bulundu',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[800],
                                          letterSpacing: 0.2,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                          // Products Grid - Desktop/Tablet
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
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isTablet ? 2 : 3,
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
          ['Tümü', 'Borax', 'Brava', 'Japan Oil', 'Xenol', 'Oilport', 'Skynell'],
          (value) {
            setState(() {
              _selectedBrand = value == 'Tümü' ? null : value;
            });
            _updateUrl();
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
            'Antifrizler',
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
              } else if (value == 'Antifrizler') {
                _selectedCategory = 'antifriz';
              } else if (value == 'Sarf Malzemeler') {
                _selectedCategory = 'sarf';
              } else if (value == 'Fren Hidrolik Sıvıları') {
                _selectedCategory = 'fren';
              } else if (value == 'Katkı Maddeleri') {
                _selectedCategory = 'katki';
              }
            });
            _updateUrl();
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

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD71920).withOpacity(0.1),
            const Color(0xFFD71920).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD71920).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFFD71920),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD71920),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFFD71920).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 14,
                color: Color(0xFFD71920),
              ),
            ),
          ),
        ],
      ),
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
    final brands = ['Tümü', 'Borax', 'Brava', 'Japan Oil', 'Xenol', 'Oilport', 'Skynell'];
    String selected = _selectedBrand ?? 'Tümü';
    
    return Column(
      children: brands.asMap().entries.map((entry) {
        int index = entry.key;
        String brand = entry.value;
        // Marka karşılaştırması: URL'deki "japanoil" ile "Japan Oil" eşleşmeli
        String brandNormalized = brand.toLowerCase().replaceAll(' ', '');
        String selectedNormalized = selected.toLowerCase().replaceAll(' ', '');
        bool isSelected = brandNormalized == selectedNormalized;
        return _buildCheckboxItem(
          brand,
          isSelected,
          () {
            setState(() {
              _selectedBrand = brand == 'Tümü' ? null : brand;
            });
            _updateUrl();
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
      {'name': 'Antifrizler', 'key': 'antifriz', 'isSubCategory': false},
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
            _updateUrl();
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

  Widget _buildFilterDrawer(BuildContext context) {
    String? tempSelectedBrand = _selectedBrand;
    String? tempSelectedCategory = _selectedCategory;
    
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle Bar
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD71920).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            size: 24,
                            color: Color(0xFFD71920),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Filtreler',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 32),
              
              // Filter Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Marka Filtresi
                      const Text(
                        'MARKA',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7280),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDrawerFilterItem(
                        'Tümü',
                        tempSelectedBrand == null || tempSelectedBrand == 'Tümü',
                        () {
                          setModalState(() {
                            tempSelectedBrand = null;
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Borax',
                        tempSelectedBrand == 'borax',
                        () {
                          setModalState(() {
                            tempSelectedBrand = 'borax';
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Brava',
                        tempSelectedBrand == 'brava',
                        () {
                          setModalState(() {
                            tempSelectedBrand = 'brava';
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Japan Oil',
                        tempSelectedBrand == 'japanoil',
                        () {
                          setModalState(() {
                            tempSelectedBrand = 'japanoil';
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Xenol',
                        tempSelectedBrand == 'xenol',
                        () {
                          setModalState(() {
                            tempSelectedBrand = 'xenol';
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Oilport',
                        tempSelectedBrand == 'oilport',
                        () {
                          setModalState(() {
                            tempSelectedBrand = 'oilport';
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Skynell',
                        tempSelectedBrand == 'skynell',
                        () {
                          setModalState(() {
                            tempSelectedBrand = 'skynell';
                          });
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      
                      // Kategori Filtresi
                      const Text(
                        'KATEGORİ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7280),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDrawerFilterItem(
                        'Tümü',
                        tempSelectedCategory == null || tempSelectedCategory == 'Tümü',
                        () {
                          setModalState(() {
                            tempSelectedCategory = null;
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Motor Yağları',
                        tempSelectedCategory == 'motor',
                        () {
                          setModalState(() {
                            tempSelectedCategory = 'motor';
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Motorsiklet Yağları',
                        tempSelectedCategory == 'motorsiklet',
                        () {
                          setModalState(() {
                            tempSelectedCategory = 'motorsiklet';
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Şanzıman ve Dişli Yağları',
                        tempSelectedCategory == 'sanziman',
                        () {
                          setModalState(() {
                            tempSelectedCategory = 'sanziman';
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Hidrolik Sistem Yağları',
                        tempSelectedCategory == 'hidrolik',
                        () {
                          setModalState(() {
                            tempSelectedCategory = 'hidrolik';
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Antifrizler',
                        tempSelectedCategory == 'antifriz',
                        () {
                          setModalState(() {
                            tempSelectedCategory = 'antifriz';
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Sarf Malzemeler',
                        tempSelectedCategory == 'sarf',
                        () {
                          setModalState(() {
                            tempSelectedCategory = 'sarf';
                          });
                        },
                      ),
                      _buildDrawerFilterItem(
                        'Katkı Maddeleri',
                        tempSelectedCategory == 'katki',
                        () {
                          setModalState(() {
                            tempSelectedCategory = 'katki';
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              
              // Action Buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Temizle Butonu
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            tempSelectedBrand = null;
                            tempSelectedCategory = null;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Temizle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Uygula Butonu
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedBrand = tempSelectedBrand;
                            _selectedCategory = tempSelectedCategory;
                          });
                          _updateUrl();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD71920),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Uygula',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerFilterItem(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD71920).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD71920)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD71920)
                      : const Color(0xFFD1D5DB),
                  width: 2,
                ),
                color: isSelected
                    ? const Color(0xFFD71920)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF111827)
                      : const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  String _generateProductId() {
    // Ürün ID'si: brand-category-name formatında URL-safe
    String brand = (widget.product['brand'] ?? '').toLowerCase().replaceAll(' ', '-');
    String name = (widget.product['name'] ?? '').toLowerCase()
        .replaceAll(' ', '-')
        .replaceAll('/', '-')
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
    return '$brand-$name';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    // Güvenlik kontrolü - gerekli alanlar yoksa render etme
    if (widget.product['name'] == null || 
        widget.product['brand'] == null || 
        widget.product['image'] == null) {
      return const SizedBox.shrink();
    }
    
    return GestureDetector(
      onTap: () {
        context.go('/urun/${_generateProductId()}');
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered && !isMobile ? -12 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFFD71920).withOpacity(0.3)
                : const Color(0xFFE5E7EB),
            width: isMobile ? 1.5 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFFD71920).withOpacity(0.15)
                  : Colors.black.withOpacity(isMobile ? 0.04 : 0.06),
              blurRadius: _isHovered ? (isMobile ? 20 : 30) : (isMobile ? 10 : 15),
              offset: Offset(0, _isHovered ? (isMobile ? 8 : 16) : (isMobile ? 4 : 8)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Container with Gradient
            Expanded(
              flex: isMobile ? 3 : 2, // Mobilde görsel daha büyük
              child: Stack(
                children: [
                  // Background
                  Container(
                    padding: EdgeInsets.all(isMobile ? 32 : 24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF8F9FA),
                          Color(0xFFFFFFFF),
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(isMobile ? 16 : 20),
                      ),
                    ),
                    child: Image.asset(
                      widget.product['image'] ?? '',
                      fit: BoxFit.contain,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) return child;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: frame != null
                              ? child
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: isMobile ? 32 : 40,
                                        height: isMobile ? 32 : 40,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            const Color(0xFFD71920).withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: isMobile ? 12 : 16),
                                      Text(
                                        'Yükleniyor...',
                                        style: TextStyle(
                                          fontSize: isMobile ? 11 : 12,
                                          color: const Color(0xFF9CA3AF),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_outlined,
                                size: isMobile ? 40 : 48,
                                color: const Color(0xFFE5E7EB),
                              ),
                              SizedBox(height: isMobile ? 8 : 12),
                              Text(
                                'Görsel yüklenemedi',
                                style: TextStyle(
                                  fontSize: isMobile ? 10 : 11,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Category Badge
                  Positioned(
                    top: isMobile ? 10 : 12,
                    right: isMobile ? 10 : 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 10 : 12,
                        vertical: isMobile ? 5 : 6,
                      ),
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
                        style: TextStyle(
                          fontSize: isMobile ? 9 : 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  // Brand Logo
                  Positioned(
                    top: isMobile ? 10 : 12,
                    left: isMobile ? 10 : 12,
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 6 : 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logos/${_getBrandLogoFileName(widget.product['brand'] ?? '')}.png',
                        width: isMobile ? 28 : 32,
                        height: isMobile ? 28 : 32,
                        fit: BoxFit.contain,
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) return child;
                          return frame != null
                              ? child
                              : SizedBox(
                                  width: isMobile ? 28 : 32,
                                  height: isMobile ? 28 : 32,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      const Color(0xFFD71920).withOpacity(0.5),
                                    ),
                                  ),
                                );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported_outlined,
                            size: isMobile ? 24 : 28,
                            color: const Color(0xFFE5E7EB),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info
            Container(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(isMobile ? 16 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Name
                  Text(
                    widget.product['name'] ?? '',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 15,
                      fontWeight: FontWeight.w700,
                      color: _isHovered ? const Color(0xFFD71920) : const Color(0xFF111827),
                      height: 1.4,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isMobile ? 6 : 8),
                  // Brand Name
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        size: isMobile ? 13 : 14,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                        widget.product['brand'] ?? '',
                        style: TextStyle(
                            fontSize: isMobile ? 11 : 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                          letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}

// Modern Mobile Product Card (E-ticaret Tasarımı)
class _ModernMobileProductCard extends StatelessWidget {
  final Map<String, String> product;

  const _ModernMobileProductCard({required this.product});

  String _generateProductId() {
    String brand = (product['brand'] ?? '').toLowerCase().replaceAll(' ', '-');
    String name = (product['name'] ?? '').toLowerCase()
        .replaceAll(' ', '-')
        .replaceAll('/', '-')
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
    return '$brand-$name';
  }

  String _getBrandLogoFileName(String brandName) {
    return brandName.toLowerCase().replaceAll(' ', '');
  }

  @override
  Widget build(BuildContext context) {
    // Güvenlik kontrolü
    if (product['name'] == null || product['brand'] == null || product['image'] == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => context.go('/urun/${_generateProductId()}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sol: Görsel (120x120)
            Container(
              width: 120,
              height: 120,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8F9FA),
                    Color(0xFFFFFFFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    product['image'] ?? '',
                    fit: BoxFit.contain,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: frame != null
                            ? child
                            : Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      const Color(0xFFD71920).withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 32,
                          color: Colors.grey[300],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Sağ: Bilgiler
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Üst: Kategori Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD71920).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product['category'] ?? '',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD71920),
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Orta: Ürün Adı
                    Text(
                      product['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        height: 1.3,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Alt: Marka Logosu + İsmi
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/logos/${_getBrandLogoFileName(product['brand'] ?? '')}.png',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(width: 20, height: 20);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            product['brand'] ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Ok ikonu (detaya git)
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
      ),
      ),
    );
  }
}

// Product Detail Page
class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    // Tüm ürünleri ProductsPage'den al
    final allProducts = _ProductsPageState._products;
    
    // ID'ye göre ürünü bul
    Map<String, String>? product;
    for (var productList in allProducts.values) {
      for (var p in productList) {
        String pid = _generateProductId(p['brand']!, p['name']!);
        if (pid == widget.productId) {
          product = p;
          break;
        }
      }
      if (product != null) break;
    }

    if (product == null) {
      return Scaffold(
        body: Center(child: Text('Ürün bulunamadı')),
      );
    }

    return SelectionArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Spacer for fixed elements
                SliverToBoxAdapter(
                  child: SizedBox(height: isMobile ? 90 : 142), // Mobile: 32px + 58px, Desktop: 42px + 100px
                ),
                // Content
                SliverToBoxAdapter(
                  child: _buildDetailContent(context, product),
                ),
                // Footer
                const SliverToBoxAdapter(
                  child: ModernFooter(),
                ),
              ],
            ),
            // Fixed Top Info Bar (global)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopInfoBar(),
            ),
            // Fixed Header (shared component)
            Positioned(
              top: isMobile ? 32 : 42,
              left: 0,
              right: 0,
              child: _ProductDetailHeader(productId: widget.productId, isMobile: isMobile),
            ),
          ],
        ),
      ),
    );
  }

  static String _generateProductId(String brand, String name) {
    String brandNorm = brand.toLowerCase().replaceAll(' ', '-');
    String nameNorm = name.toLowerCase()
        .replaceAll(' ', '-')
        .replaceAll('/', '-')
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
    return '$brandNorm-$nameNorm';
  }

  // Hacim seçeneği gösterilmeli mi ve hangi hacimler kontrol et
  List<String>? _getAvailableVolumes(Map<String, String> product) {
    // Motor Yağları kontrolü
    if (product['category'] == 'Motor Yağları') {
      // Oilport motor yağlarını hariç tut
      if (product['brand'] == 'Oilport') return null;
      
      // Borax Ultimate DX tenekeleri hariç tut
      String productName = product['name']!.toLowerCase();
      if (product['brand'] == 'Borax' && 
          (productName.contains('ultimate dx') && !productName.contains('bidon'))) {
        return null;
      }
      
      return ['1 Litre', '4 Litre', '5 Litre'];
    }
    
    // Oilport Antifriz kontrolü
    if (product['category'] == 'Antifrizler' && product['brand'] == 'Oilport') {
      return ['1 Litre', '1.5 Litre', '3 Litre', '14 Litre'];
    }
    
    return null;
  }

  // Hacim bilgisi widget'i (sadece gösterim için)
  Widget _buildVolumeSelector(bool isMobile, List<String> volumes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mevcut Hacimler',
          style: TextStyle(
            fontSize: isMobile ? 13 : 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6B7280),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: isMobile ? 10 : 12),
        Wrap(
          spacing: isMobile ? 8 : 10,
          runSpacing: isMobile ? 8 : 10,
          children: volumes.map((volume) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 16,
                vertical: isMobile ? 8 : 10,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF059669).withOpacity(0.1),
                    const Color(0xFF059669).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                border: Border.all(
                  color: const Color(0xFF059669).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: isMobile ? 14 : 16,
                    color: const Color(0xFF059669),
                  ),
                  SizedBox(width: isMobile ? 6 : 8),
                  Text(
                    volume,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF059669),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDetailContent(BuildContext context, Map<String, String> product) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 20 : 80,
        horizontal: isMobile ? 16 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Geri Butonu + Breadcrumb
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Geri Butonu
                    InkWell(
                      onTap: () {
                        html.window.history.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back_rounded,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Geri',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Breadcrumb (mobilde tam genişlik)
                    _buildBreadcrumb(context, product),
                  ],
                )
              else
              Row(
                children: [
                  // Geri Butonu
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: InkWell(
                      onTap: () {
                        html.window.history.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                          child: const Row(
                          mainAxisSize: MainAxisSize.min,
                            children: [
                            Icon(
                              Icons.arrow_back_rounded,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Geri',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Breadcrumb
                  _buildBreadcrumb(context, product),
                ],
              ),
              SizedBox(height: isMobile ? 20 : 40),
              // Product Detail Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: isMobile ? 15 : 30,
                      offset: Offset(0, isMobile ? 5 : 10),
                    ),
                  ],
                ),
                child: isMobile
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        // Görsel (Mobil - Üstte) - Modern & Büyük
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierColor: Colors.black.withOpacity(0.9),
                              builder: (context) => _FullImageDialog(imagePath: product['image']!),
                            );
                          },
                          child: Container(
                            height: 420, // 300 → 420 (daha büyük)
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFFF8F9FA),
                                  Colors.white,
                                  const Color(0xFFF8F9FA).withOpacity(0.3),
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              // Modern shadow ekle
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD71920).withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Dekoratif pattern (background)
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: _ProductBackgroundPainter(),
                                  ),
                                ),
                                // Görsel
                                Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 40,
                              ),
                                child: Image.asset(
                                  product['image']!,
                                  fit: BoxFit.contain,
                                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                    if (wasSynchronouslyLoaded) return child;
                                    return AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: frame != null
                                          ? child
                                          : Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    height: 40,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 3,
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                        const Color(0xFFD71920).withOpacity(0.7),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  const Text(
                                                    'Yükleniyor...',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF9CA3AF),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.broken_image_outlined,
                                            size: 48,
                                            color: const Color(0xFFE5E7EB),
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            'Görsel yüklenemedi',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF9CA3AF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ), // Center kapanışı
                          // Modern Zoom İkonu (Sağ alt köşe) - Yeni tasarım
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFD71920),
                                    const Color(0xFFB01518),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD71920).withOpacity(0.4),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.zoom_in_rounded,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ], // Stack children kapanışı
                        ), // Stack kapanışı
                      ), // Container kapanışı
                    ), // GestureDetector kapanışı
                          // Bilgiler (Mobil - Altta)
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Marka Logosu
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                                  ),
child: Image.asset(
                                  'assets/images/logos/${product['brand']!.toLowerCase().replaceAll(' ', '')}.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                      if (wasSynchronouslyLoaded) return child;
                                      return frame != null
                                          ? child
                                          : SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  const Color(0xFFD71920).withOpacity(0.5),
                                                ),
                                              ),
                                            );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 40,
                                        color: const Color(0xFFE5E7EB),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Ürün Adı
                                Text(
                                  product['name']!,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF111827),
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Kategori
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFFD71920).withOpacity(0.1),
                                        const Color(0xFFD71920).withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFFD71920).withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    product['category']!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFD71920),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Hacim Seçenekleri
                                if (_getAvailableVolumes(product) != null) ...[
                                  _buildVolumeSelector(isMobile, _getAvailableVolumes(product)!),
                                  const SizedBox(height: 24),
                                ],
                                // Ürün Özellikleri
                                _buildFeature(Icons.verified_rounded, 'Orijinal Ürün', 'Yetkili distribütör garantisi'),
                                const SizedBox(height: 12),
                                _buildFeature(Icons.inventory_2_rounded, 'Stokta Mevcut', 'Hızlı teslimat imkanı'),
                                const SizedBox(height: 12),
                                _buildFeature(Icons.workspace_premium_rounded, 'Kalite Belgeli', 'Uluslararası standartlarda'),
                                const SizedBox(height: 24),
                                // Telefon Numarası
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD71920),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone_rounded, color: Colors.white, size: 20),
                                      SizedBox(width: 10),
                                      Text(
                                        '+90 532 562 71 23',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sol - Görsel (Desktop)
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 600,
                              decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                                    Color(0xFFF9FAFB),
                                    Color(0xFFFFFFFF),
                            ],
                          ),
                                borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(60),
                            child: _ZoomableImage(imagePath: product['image']!),
                          ),
                        ),
                      ),
                    ),
                          // Sağ - Bilgiler (Desktop)
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Marka Logosu
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
child: Image.asset(
                                  'assets/images/logos/${product['brand']!.toLowerCase().replaceAll(' ', '')}.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.contain,
                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                  if (wasSynchronouslyLoaded) return child;
                                  return frame != null
                                      ? child
                                      : SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              const Color(0xFFD71920).withOpacity(0.5),
                                            ),
                                          ),
                                        );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 50,
                                    color: const Color(0xFFE5E7EB),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Ürün Adı
                            Text(
                              product['name']!,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF111827),
                                height: 1.3,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Kategori
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                              child: Text(
                                product['category']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFD71920),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Hacim Seçenekleri
                            if (_getAvailableVolumes(product) != null) ...[
                              _buildVolumeSelector(isMobile, _getAvailableVolumes(product)!),
                              const SizedBox(height: 32),
                            ],
                            // Ürün Özellikleri
                            _buildFeature(Icons.verified_rounded, 'Orijinal Ürün', 'Yetkili distribütör garantisi'),
                            const SizedBox(height: 16),
                            _buildFeature(Icons.inventory_2_rounded, 'Stokta Mevcut', 'Hızlı teslimat imkanı'),
                            const SizedBox(height: 16),
                            _buildFeature(Icons.workspace_premium_rounded, 'Kalite Belgeli', 'Uluslararası standartlarda'),
                            const SizedBox(height: 40),
                                  // Telefon Numarası
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD71920),
                                borderRadius: BorderRadius.circular(14),
                              ),
                                    child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                        Icon(Icons.phone_rounded, color: Colors.white, size: 22),
                                        SizedBox(width: 12),
                                        Text(
                                    '+90 532 562 71 23',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildBreadcrumb(BuildContext context, Map<String, String> product) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => context.go('/'),
            child: Icon(Icons.home_rounded, size: 16, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, size: 16, color: Colors.grey[300]),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => context.go('/urunler'),
            child: Text(
              'Ürünler',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, size: 16, color: Colors.grey[300]),
          const SizedBox(width: 8),
          Text(
            product['brand']!,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, size: 16, color: Colors.grey[300]),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              product['name']!,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFD71920)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFD71920).withOpacity(0.1),
                const Color(0xFFD71920).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 24, color: const Color(0xFFD71920)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Paylaşılan Header Widget (Tüm sayfalarda kullanılır - Dropdown'larla birlikte)
class _SharedHeader extends StatelessWidget {
  final String currentPath;
  
  const _SharedHeader({required this.currentPath});
  
  @override
  Widget build(BuildContext context) {
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
                _buildNavItem(context, 'Ana Sayfa', currentPath == '/'),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Ürünler', currentPath.startsWith('/urunler') || currentPath.startsWith('/urun/')),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Markalar', false),
                const SizedBox(width: 32),
                _buildNavItem(context, 'Hakkımızda', currentPath == '/hakkimizda'),
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
          else if (productName == 'Fren Hidrolik Sıvıları') kategori = 'fren';
          else if (productName == 'Katkı Maddeleri') kategori = 'katki';
          
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
          context.go('/urunler?marka=${brandName.toLowerCase().replaceAll(' ', '')}');
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
}

// Tıklanabilir Görsel Widget'ı (Modal açar)
class _ZoomableImage extends StatefulWidget {
  final String imagePath;
  
  const _ZoomableImage({required this.imagePath});
  
  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage> {
  bool _isHovered = false;
  
  void _showFullImage() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) => _FullImageDialog(imagePath: widget.imagePath),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _showFullImage,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.02 : 1.0), // Hafif büyüme (tıklanabilir olduğunu göster)
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: frame != null
                          ? child
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        const Color(0xFFD71920).withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Yükleniyor...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF9CA3AF),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: 64,
                            color: const Color(0xFFE5E7EB),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Görsel yüklenemedi',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Tam ekran ikonu (hover durumunda)
              if (_isHovered)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.fullscreen_rounded,
                      color: Colors.white,
                      size: 24,
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

// Tam Ekran Görsel Dialog'u
class _FullImageDialog extends StatefulWidget {
  final String imagePath;
  
  const _FullImageDialog({required this.imagePath});
  
  @override
  State<_FullImageDialog> createState() => _FullImageDialogState();
}

class _FullImageDialogState extends State<_FullImageDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _close() {
    _controller.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return GestureDetector(
      onTap: _close,
      child: Material(
        color: Colors.black.withOpacity(0.95),
        child: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Stack(
            children: [
                // Ana görsel alanı - Tam ekran, zoom yok
              Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 40,
                      vertical: isMobile ? 60 : 80,
                    ),
                      child: Container(
                        constraints: BoxConstraints(
                        maxWidth: isMobile ? screenWidth * 0.95 : 1200,
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        borderRadius: BorderRadius.circular(isMobile ? 12 : 24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                            blurRadius: 40,
                            spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                        borderRadius: BorderRadius.circular(isMobile ? 12 : 24),
                            child: Image.asset(
                              widget.imagePath,
                              fit: BoxFit.contain,
                          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) return child;
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: frame != null
                                  ? child
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                const Color(0xFFD71920).withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Yükleniyor...',
                                            style: TextStyle(
                                              fontSize: isMobile ? 12 : 14,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                        ),
                      ),
                    );
                  },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Kapat butonu (Sağ üst)
            Positioned(
                  top: isMobile ? 12 : 20,
                  right: isMobile ? 12 : 20,
                child: GestureDetector(
                  onTap: _close,
                  child: Container(
                      padding: EdgeInsets.all(isMobile ? 10 : 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                      child: Icon(
                        Icons.close_rounded,
                      color: Colors.black87,
                        size: isMobile ? 20 : 24,
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Product Detail Header Component (Responsive)
class _ProductDetailHeader extends StatelessWidget {
  final String productId;
  final bool isMobile;

  const _ProductDetailHeader({
    required this.productId,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMobile ? 58 : 100,
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
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 60,
          vertical: isMobile ? 8 : 10,
        ),
        child: isMobile
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo (Mobil - Küçük)
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF8F9FA),
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/mnr-petrol.jpg',
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Hamburger Menu
                  IconButton(
                    icon: const Icon(Icons.menu, size: 28),
                    color: const Color(0xFF111827),
                    onPressed: () {
                      showGlobalMobileMenu(context, currentPage: 'products');
                    },
                  ),
                ],
              )
            : Row(
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
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFF8F9FA),
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
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                      Text(
                                'MNR Petrol Tarım İnş. San. Tic. Ltd. Şti.',
                        style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827),
                                  letterSpacing: 0.3,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Antalya Madeni Yağ',
                                style: TextStyle(
                                  fontSize: 12,
                          fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B7280),
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
    return _ModernNavItem(
      title: title,
      isActive: isActive,
      onTap: () {
        if (title == 'Ana Sayfa') {
          context.go('/');
        } else if (title == 'Ürünler') {
          context.go('/urunler');
        } else if (title == 'Hakkımızda') {
          context.go('/hakkimizda');
        } else if (title == 'İletişim') {
          context.go('/?scrollTo=contact');
        }
      },
    );
  }
}

// Modern Product Background Painter (Dekoratif pattern mobil ürün detayı için)
class _ProductBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD71920).withOpacity(0.02)
      ..style = PaintingStyle.fill;

    // Subtle circles for decoration
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.2),
      80,
      paint,
    );
    
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.7),
      60,
      paint,
    );
    
    // Subtle lines
    final linePaint = Paint()
      ..color = const Color(0xFFD71920).withOpacity(0.03)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.2,
        size.width,
        size.height * 0.4,
      );
    
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
