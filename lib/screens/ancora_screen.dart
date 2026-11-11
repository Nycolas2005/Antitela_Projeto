import 'package:flutter/material.dart';
import '../main.dart';

class AncoraScreen extends StatefulWidget {
  final ValueChanged<int> onNavigate;

  const AncoraScreen({super.key, required this.onNavigate});

  @override
  State<AncoraScreen> createState() => _AncoraScreenState();
}

class _AncoraScreenState extends State<AncoraScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCycle = 0;
  late AnimationController _ringController;

  final List<_Cycle> cycles = [
    _Cycle(
        label: '25 min',
        sublabel: 'Pomodoro clássico',
        tag: 'Ativo',
        badge: 'Padrão',
        mins: 25,
        icon: Icons.center_focus_strong),
    _Cycle(
        label: '45 min',
        sublabel: 'Foco profundo',
        badge: '+45 min',
        mins: 45,
        icon: Icons.bolt),
    _Cycle(
        label: '60 min',
        sublabel: 'Sem telas / Noturno',
        badge: '+60 min',
        mins: 60,
        icon: Icons.dark_mode_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cycle = cycles[_selectedCycle];
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildUserCard(),
              _buildTimerCircle(cycle),
              _buildActionButtons(),
              _buildTimeAdjust(),
              _buildCyclesList(),
              _buildNeuralTip(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.arrow_back_ios,
                color: AppColors.textMuted, size: 20),
          ),
          const Spacer(),
          const Icon(Icons.timer_outlined, color: AppColors.text, size: 18),
          const SizedBox(width: 6),
          const Text(
            'Modo Foco',
            style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w700,
                fontSize: 17),
          ),
          const Spacer(),
          _StreakBadge(label: '5 dias'),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border:
                    Border.all(color: AppColors.purpleLight.withOpacity(0.3)),
              ),
              child: const Icon(Icons.pets,
                  color: AppColors.purpleLight, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Neo Lynx',
                style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.green.withOpacity(0.3)),
              ),
              child: const Text(
                '● Pronto para Iniciar',
                style: TextStyle(
                    color: AppColors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerCircle(_Cycle cycle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background ring
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 8,
                  backgroundColor: AppColors.border.withOpacity(0.4),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.transparent),
                ),
              ),
              // Purple progress ring
              AnimatedBuilder(
                animation: _ringController,
                builder: (_, __) {
                  return SizedBox(
                    width: 220,
                    height: 220,
                    child: CustomPaint(
                      painter: _RingPainter(
                        progress: 1.0,
                        color: AppColors.purple,
                        strokeWidth: 8,
                        glowOpacity: 0.3 + _ringController.value * 0.3,
                      ),
                    ),
                  );
                },
              ),
              // Center text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'RESTANTE',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cycle.mins.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 44,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cycle.sublabel,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to Foco tab
                widget.onNavigate(1);
              },
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: const Text('Iniciar Foco',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 4,
                shadowColor: AppColors.purple.withOpacity(0.4),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border.withOpacity(0.4)),
            ),
            child: IconButton(
              onPressed: () {},
              icon:
                  const Icon(Icons.refresh_rounded, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAdjust() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _ChipButton(label: '+5 min', onTap: () {}),
          const SizedBox(width: 10),
          _ChipButton(label: '+15 min', onTap: () {}),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: const Row(
              children: [
                Icon(Icons.cancel_outlined, color: AppColors.red, size: 16),
                SizedBox(width: 4),
                Text('Desistir',
                    style: TextStyle(color: AppColors.red, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCyclesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ciclos Rápidos',
                  style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
              const Text('Toque para selecionar',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(cycles.length, (i) {
            final c = cycles[i];
            final active = i == _selectedCycle;
            return GestureDetector(
              onTap: () => setState(() => _selectedCycle = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.purple.withOpacity(0.12)
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: active
                        ? AppColors.purpleLight.withOpacity(0.5)
                        : AppColors.border.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.purple.withOpacity(0.2)
                            : AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        c.icon,
                        color: active
                            ? AppColors.purpleLight
                            : AppColors.textMuted,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(c.label,
                                  style: const TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              if (c.tag != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.purple,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(c.tag!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ],
                          ),
                          Text(c.sublabel,
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.border.withOpacity(0.3)),
                      ),
                      child: Text(c.badge,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNeuralTip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: AppCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                color: AppColors.purpleLight,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dica de Higiene Neural',
                      style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  SizedBox(height: 4),
                  Text(
                    'O anseio por checar notificações atinge o ápice aos 8-12 minutos. Respire fundo 3 vezes e retome o foco; sua dopamina estabilizará naturalmente.',
                    style: TextStyle(
                        color: AppColors.textMuted, fontSize: 12, height: 1.5),
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

class _Cycle {
  final String label, sublabel, badge;
  final IconData icon;
  final String? tag;
  final int mins;
  _Cycle(
      {required this.label,
      required this.sublabel,
      required this.badge,
      required this.mins,
      required this.icon,
      this.tag});
}

class _StreakBadge extends StatelessWidget {
  final String label;
  const _StreakBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.purpleLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.purpleLight.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: AppColors.purpleLight,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: AppColors.purpleDim,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ChipButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withOpacity(0.4)),
        ),
        child: Text(label,
            style: const TextStyle(color: AppColors.text, fontSize: 13)),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final double glowOpacity;

  _RingPainter(
      {required this.progress,
      required this.color,
      required this.strokeWidth,
      required this.glowOpacity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Glow paint
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 8
      ..strokeCap = StrokeCap.round
      ..color = color.withOpacity(glowOpacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    // Main paint
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    const startAngle = -3.14159 / 2;
    final sweepAngle = 2 * 3.14159 * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.glowOpacity != glowOpacity;
}
