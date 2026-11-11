import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';

class FocoScreen extends StatefulWidget {
  const FocoScreen({super.key});

  @override
  State<FocoScreen> createState() => _FocoScreenState();
}

class _FocoScreenState extends State<FocoScreen> {
  int _sessionMins = 25;
  bool _running = false;
  int _elapsed = 0;
  Timer? _timer;

  int get _totalSeconds => _sessionMins * 60;
  int get _secondsLeft => _totalSeconds - _elapsed;
  double get _progress => _totalSeconds > 0 ? _elapsed / _totalSeconds : 0;

  void _start() {
    setState(() {
      _running = true;
      _elapsed = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_elapsed + 1 >= _totalSeconds) {
          _elapsed = _totalSeconds;
          _running = false;
          _timer?.cancel();
        } else {
          _elapsed++;
        }
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _changeSession(int mins) {
    if (!_running) {
      setState(() {
        _sessionMins = mins;
        _elapsed = 0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timeDisplay {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              AppHeader(
                streak: '3 dias',
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined,
                        color: AppColors.textMuted, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              _buildScreenTimeCard(),
              _buildRobotSection(),
              if (!_running) _buildSessionPicker(),
              if (_running) _buildProgressBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _running ? _buildStopButton() : _buildStartButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreenTimeCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TEMPO DE ECRÃ HOJE',
                  style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: AppColors.green.withOpacity(0.2)),
                      ),
                      child: const Text('+15m',
                          style: TextStyle(
                              color: AppColors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.wb_sunny_outlined,
                        color: AppColors.textMuted, size: 16),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _running
                  ? '${(_elapsed ~/ 60).toString().padLeft(2, '0')}m ${(_elapsed % 60).toString().padLeft(2, '0')}s'
                  : '2h 00m',
              style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 40,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Meta diária de 3h  ·  60 min restantes',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 120 / 180,
                minHeight: 6,
                backgroundColor: AppColors.border.withOpacity(0.4),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRobotSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          RobotMascot(running: _running),
          const SizedBox(height: 10),
          Text(
            _running
                ? 'Sessão em andamento · $_timeDisplay'
                : 'Status de foco estável e em equilíbrio',
            style: const TextStyle(
                color: Color(0xFFBCC9CD), fontSize: 12, letterSpacing: 0.3),
          ),
          const SizedBox(height: 2),
          const Text(
            'MODO VIGILANTE',
            style: TextStyle(
              color: Color(0xB3A855F7),
              fontSize: 11,
              letterSpacing: 0.55,
              fontFamily: 'Courier',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionPicker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt,
                      color: AppColors.purpleLight, size: 14),
                  const SizedBox(width: 4),
                  const Text('Tempo da Sessão',
                      style:
                          TextStyle(color: AppColors.textMuted, fontSize: 13)),
                ],
              ),
              Text(
                '$_sessionMins minutos',
                style: const TextStyle(
                    color: AppColors.purpleLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [25, 45, 60].map((m) {
              final active = _sessionMins == m;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _changeSession(m),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.purple.withOpacity(0.15)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: active
                            ? AppColors.purpleLight.withOpacity(0.5)
                            : AppColors.border.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.timer_outlined,
                            color: AppColors.textMuted, size: 16),
                        const SizedBox(height: 4),
                        Text(
                          '$m min',
                          style: TextStyle(
                            color: active
                                ? AppColors.purpleDim
                                : AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final mins = _secondsLeft ~/ 60;
    final secs = _secondsLeft % 60;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: AppColors.border.withOpacity(0.4),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.purple),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('0 min',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              Text(
                '${(_progress * 100).round()}%  ·  ${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')} restantes',
                style: const TextStyle(
                    color: AppColors.purpleLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              Text('$_sessionMins min',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _start,
        icon: const Icon(Icons.bolt, size: 18),
        label: const Text('Iniciar Modo Foco',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: AppColors.purple.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildStopButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _stop,
        icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.red),
        label: const Text('Parar Sessão',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.red)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: const BorderSide(color: AppColors.red, width: 1),
          backgroundColor: AppColors.red.withOpacity(0.08),
        ),
      ),
    );
  }
}
