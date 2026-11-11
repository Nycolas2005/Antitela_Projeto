import 'package:flutter/material.dart';
import '../main.dart';

class MissoesScreen extends StatefulWidget {
  const MissoesScreen({super.key});

  @override
  State<MissoesScreen> createState() => _MissoesScreenState();
}

class _MissoesScreenState extends State<MissoesScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_Mission> _missions = [
    _Mission(id: 1, text: 'Arrumar a cama ao acordar'),
    _Mission(id: 2, text: 'Ler 1 capítulo de um livro'),
    _Mission(id: 3, text: 'Caminhar com o cão ao ar livre'),
    _Mission(id: 4, text: 'Jantar sem telemóvel na mesa', done: true),
    _Mission(id: 5, text: 'Organizar o quarto / secretária'),
    _Mission(id: 6, text: 'Conversar 15min com alguém da família'),
  ];

  int get _done => _missions.where((m) => m.done).length;
  double get _progress => _missions.isEmpty ? 0 : _done / _missions.length;

  void _addMission() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _missions
          .add(_Mission(id: DateTime.now().millisecondsSinceEpoch, text: text));
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              streak: '$_done/${_missions.length}',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    _buildAddMission(),
                    _buildMissionsList(),
                    _buildProgressSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AUTONOMIA CIRCADIANA · $_done de ${_missions.length}',
            style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text('Missões Offline',
              style: TextStyle(
                  color: AppColors.text,
                  fontSize: 26,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text(
            'Substitua tempo de ecrã por hábitos com propósito no mundo real.',
            style: TextStyle(
                color: AppColors.textMuted, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAddMission() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _addMission(),
              style: const TextStyle(color: AppColors.text, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Nova missão...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.card,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColors.border.withOpacity(0.4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColors.border.withOpacity(0.4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppColors.purpleLight, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _addMission,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.purple, Color(0xFF6D28D9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('METAS DE HOJE',
                  style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border.withOpacity(0.3)),
                ),
                child: const Text('Offline',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(
              _missions.length,
              (i) => _MissionTile(
                    mission: _missions[i],
                    onToggle: () =>
                        setState(() => _missions[i].done = !_missions[i].done),
                    onDelete: () => setState(() => _missions.removeAt(i)),
                  )),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progresso das missões',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
              Text('$_done / ${_missions.length} concluídas',
                  style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _progress),
              duration: const Duration(milliseconds: 500),
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: AppColors.border.withOpacity(0.4),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.purple),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Mission {
  final int id;
  final String text;
  bool done;
  _Mission({required this.id, required this.text, this.done = false});
}

class _MissionTile extends StatelessWidget {
  final _Mission mission;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _MissionTile(
      {required this.mission, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: mission.done ? AppColors.purple : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: mission.done
                      ? AppColors.purple
                      : AppColors.textMuted.withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: mission.done
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mission.text,
              style: TextStyle(
                color: mission.done ? const Color(0xFF4B5563) : AppColors.text,
                fontSize: 14,
                decoration: mission.done ? TextDecoration.lineThrough : null,
                decorationColor: const Color(0xFF4B5563),
              ),
            ),
          ),
          if (mission.done)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text('Concluído',
                  style: TextStyle(
                      color: AppColors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            )
          else
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text('+1',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            ),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete_outline_rounded,
                color: Color(0xFF4B5563), size: 18),
          ),
        ],
      ),
    );
  }
}
