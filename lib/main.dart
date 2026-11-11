import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/ancora_screen.dart';
import 'screens/foco_screen.dart';
import 'screens/missoes_screen.dart';
import 'screens/diario_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const AntiTelaApp());
}

class AntiTelaApp extends StatelessWidget {
  const AntiTelaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AntiTela',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: AppColors.purple,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Roboto',
      ),
      home: const HomeShell(),
    );
  }
}

// ─── App Colors ──────────────────────────────────────────────────────────────
class AppColors {
  static const Color bg = Color(0xFF0A0E16);
  static const Color surface = Color(0xFF111827);
  static const Color card = Color(0xFF1A1F2E);
  static const Color border = Color(0xFF3D494C);
  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleLight = Color(0xFFA855F7);
  static const Color purpleDim = Color(0xFFC4B5FD);
  static const Color text = Color(0xFFF1F5F9);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color green = Color(0xFF4ADE80);
  static const Color red = Color(0xFFF87171);
}

// ─── Home Shell with Bottom Nav ──────────────────────────────────────────────
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    FocoScreen(),
    MissoesScreen(),
    DiarioScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          AncoraScreen(onNavigate: (index) {
            setState(() => _currentIndex = index);
          }),
          ..._screens,
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      _NavItem(icon: Icons.anchor, label: 'Âncora'),
      _NavItem(icon: Icons.timer_outlined, label: 'Foco'),
      _NavItem(icon: Icons.checklist_rounded, label: 'Missões'),
      _NavItem(icon: Icons.menu_book_rounded, label: 'Diário'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: Color(0x4D3D494C), width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (i) {
              final active = _currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        items[i].icon,
                        color: active
                            ? AppColors.purpleLight
                            : AppColors.textMuted,
                        size: 22,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[i].label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              active ? FontWeight.w600 : FontWeight.w400,
                          color: active
                              ? AppColors.purpleLight
                              : AppColors.textMuted,
                        ),
                      ),
                      if (active) ...[
                        const SizedBox(height: 2),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppColors.purpleLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}

// ─── Robot Mascot Widget ──────────────────────────────────────────────────────
class RobotMascot extends StatefulWidget {
  final bool running;
  final double size;

  const RobotMascot({super.key, this.running = false, this.size = 192});

  @override
  State<RobotMascot> createState() => _RobotMascotState();
}

class _RobotMascotState extends State<RobotMascot>
    with TickerProviderStateMixin {
  late AnimationController _auraController;
  late AnimationController _blinkController;
  late Animation<double> _auraAnimation;

  @override
  void initState() {
    super.initState();
    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _auraAnimation = Tween<double>(begin: 0.25, end: 0.7).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _auraController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer aura ring
          AnimatedBuilder(
            animation: _auraAnimation,
            builder: (_, __) => Container(
              width: s - 16,
              height: s - 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.purpleLight.withOpacity(
                    widget.running ? _auraAnimation.value : 0.25,
                  ),
                  width: 1,
                ),
              ),
            ),
          ),
          // Main circle chassis
          Container(
            width: s * 0.75,
            height: s * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF111827),
              border: Border.all(
                  color: AppColors.border.withOpacity(0.3), width: 1),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 15,
                    offset: Offset(0, 10)),
                BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Head chassis
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.border.withOpacity(0.4), width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Visor
                      Container(
                        width: 64,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0E16),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.border.withOpacity(0.3),
                              width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _Eye(blinkController: _blinkController),
                            const SizedBox(width: 10),
                            _Eye(
                                blinkController: _blinkController, delay: 0.05),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Mouth dot
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.purpleLight.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Ground glow
                Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.purpleLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(9999),
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

class _Eye extends StatelessWidget {
  final AnimationController blinkController;
  final double delay;

  const _Eye({required this.blinkController, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: blinkController,
      builder: (_, __) {
        final t = (blinkController.value + delay) % 1.0;
        final scaleY = (t > 0.9 && t < 0.95) ? 0.1 : 1.0;
        return Transform.scale(
          scaleY: scaleY,
          child: Container(
            width: 10,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.purpleLight,
              borderRadius: BorderRadius.circular(9999),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purpleLight.withOpacity(0.8),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────
class AppHeader extends StatelessWidget {
  final String? streak;
  final List<Widget> actions;

  const AppHeader({super.key, this.streak, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x4D3D494C), width: 1)),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.purpleLight.withOpacity(0.3), width: 1),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: AppColors.purpleLight,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Anti',
                  style: TextStyle(
                    color: AppColors.purpleLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                TextSpan(
                  text: 'Tela',
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (streak != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.purpleLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.purpleLight.withOpacity(0.3), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppColors.purpleLight,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    streak!,
                    style: const TextStyle(
                      color: AppColors.purpleDim,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ...actions.map((w) =>
              Padding(padding: const EdgeInsets.only(left: 8), child: w)),
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  const AppCard({super.key, required this.child, this.padding, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3), width: 1),
      ),
      child: child,
    );
  }
}

class PurpleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;

  const PurpleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.purple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          shadowColor: AppColors.purple.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8)
            ],
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
