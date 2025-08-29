import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizgame/pages/mode.dart';
import 'battle_game_manager.dart';
import 'battle_game_screen.dart';
import 'panduan_battle.dart';

class HomeBattle extends StatefulWidget {
  const HomeBattle({super.key});

  @override
  State<HomeBattle> createState() => _HomeBattleState();
}

class _HomeBattleState extends State<HomeBattle> {
  int selectedTeams = 2;
  List<TextEditingController> teamControllers = [];
  List<String> allStudents = [];
  List<String> manualStudents = [];
  Map<int, List<String>> teamMembers = {};
  String assignmentMode = 'custom';
  String questionMode = 'based_on_students';
  String studentSource = 'class';
  TextEditingController studentInputController = TextEditingController();
  TextEditingController classSizeController = TextEditingController(text: '20');
  int classSize = 20;

  @override
  void initState() {
    super.initState();
    _initializeTeamControllers();
    _loadStudents();
  }

  void _initializeTeamControllers() {
    teamControllers.clear();
    teamMembers.clear();
    for (int i = 0; i < selectedTeams; i++) {
      teamControllers.add(TextEditingController(text: 'Tim ${i + 1}'));
      teamMembers[i] = [];
    }
  }

  Future<void> _loadStudents() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/nama_siswa.json');

      if (await file.exists()) {
        final contents = await file.readAsString();
        final data = json.decode(contents) as List;
        setState(() {
          allStudents = data.cast<String>();
        });
      }
    } catch (e) {
      print('Error loading students: $e');
    }
  }

  void _randomAssignment() {
    List<String> currentStudents;

    if (studentSource == 'class') {
      // Generate students based on class size
      currentStudents = List.generate(
        classSize,
        (index) => 'Siswa ${index + 1}',
      );
    } else {
      currentStudents = manualStudents;
    }

    if (currentStudents.isEmpty) return;

    setState(() {
      // Clear existing assignments
      for (int i = 0; i < selectedTeams; i++) {
        teamMembers[i] = [];
      }

      // Shuffle students and distribute
      List<String> shuffledStudents = List.from(currentStudents)..shuffle();
      for (int i = 0; i < shuffledStudents.length; i++) {
        int teamIndex = i % selectedTeams;
        teamMembers[teamIndex]!.add(shuffledStudents[i]);
      }
    });
  }

  void _addManualStudent() {
    String studentName = studentInputController.text.trim();
    if (studentName.isNotEmpty && !manualStudents.contains(studentName)) {
      setState(() {
        manualStudents.add(studentName);
        studentInputController.clear();
      });
    }
  }

  void _removeManualStudent(String studentName) {
    setState(() {
      manualStudents.remove(studentName);
      // Remove from team assignments if exists
      for (int i = 0; i < selectedTeams; i++) {
        teamMembers[i]?.remove(studentName);
      }
    });
  }

  List<String> _getCurrentStudents() {
    if (studentSource == 'class') {
      return List.generate(classSize, (index) => 'Siswa ${index + 1}');
    } else {
      return manualStudents;
    }
  }

  int _getStudentsPerTeam() {
    if (studentSource == 'class') {
      return (classSize / selectedTeams).ceil();
    } else {
      return manualStudents.isNotEmpty
          ? (manualStudents.length / selectedTeams).ceil()
          : 0;
    }
  }

  String _getStartButtonStatusMessage() {
    if (selectedTeams < 2) {
      return 'Minimal 2 tim diperlukan untuk memulai battle';
    }

    if (teamControllers.any((controller) => controller.text.trim().isEmpty)) {
      return 'Semua nama tim harus diisi';
    }

    if (studentSource == 'manual') {
      if (manualStudents.isEmpty) {
        return 'Silakan tambahkan siswa terlebih dahulu';
      }
      if (manualStudents.length < selectedTeams) {
        return 'Jumlah siswa minimal: $selectedTeams (saat ini: ${manualStudents.length})';
      }
    }

    return 'Semua persyaratan telah terpenuhi';
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ModePermainan(),
                  ),
                );
              },
              tooltip: 'Kembali ke Mode',
            ),
          ),
          const Expanded(
            child: Text(
              'Atur Mode Battle',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PanduanBattle(),
                  ),
                );
              },
              tooltip: 'Panduan Battle',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events,
            size: 64,
            color: Colors.white.withOpacity(0.9),
          ),
          const SizedBox(height: 16),
          const Text(
            'Mode Battle',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Buat tim, pilih anggota, dan lombakan tim-tim untuk menjawab soal dengan benar dan mendapatkan poin tertinggi!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9F7FFF), Color(0xFF8055FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(),
                      const SizedBox(height: 24),
                      _buildTeamNumberSelection(),
                      const SizedBox(height: 20),
                      _buildTeamNamesSection(),
                      const SizedBox(height: 20),
                      _buildStudentSourceSection(),
                      const SizedBox(height: 20),
                      _buildMemberAssignmentSection(),
                      const SizedBox(height: 20),
                      _buildQuestionModeSelection(),
                      const SizedBox(height: 30),
                      _buildStartBattleButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamNumberSelection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(Icons.groups, size: 30, color: Colors.red[600]),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Pilih Jumlah Tim',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [2, 3, 5, 10].map((number) {
                return ChoiceChip(
                  label: Text('$number Tim'),
                  selected: selectedTeams == number,
                  selectedColor: Colors.red[100],
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedTeams = number;
                        _initializeTeamControllers();
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentSourceSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.source,
                    size: 30,
                    color: Colors.orange[600],
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Sumber Siswa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Dari Kelas'),
                  subtitle: Text('$classSize siswa total'),
                  value: 'class',
                  groupValue: studentSource,
                  onChanged: (value) {
                    setState(() {
                      studentSource = value!;
                      // Clear team assignments when switching source
                      for (int i = 0; i < selectedTeams; i++) {
                        teamMembers[i] = [];
                      }
                    });
                  },
                ),
                if (studentSource == 'class') _buildClassSizeInput(),
                RadioListTile<String>(
                  title: const Text('Input Manual'),
                  subtitle: Text('${manualStudents.length} siswa'),
                  value: 'manual',
                  groupValue: studentSource,
                  onChanged: (value) {
                    setState(() {
                      studentSource = value!;
                      // Clear team assignments when switching source
                      for (int i = 0; i < selectedTeams; i++) {
                        teamMembers[i] = [];
                      }
                    });
                  },
                ),
              ],
            ),
            if (studentSource == 'manual') _buildManualStudentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildClassSizeInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Icon(Icons.group, color: Colors.orange),
          const SizedBox(width: 8),
          const Text('Ukuran Kelas: '),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: TextField(
              controller: classSizeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
              onChanged: (value) {
                int? newSize = int.tryParse(value);
                if (newSize != null && newSize > 0 && newSize <= 100) {
                  setState(() {
                    classSize = newSize;
                    // Clear team assignments when changing class size
                    for (int i = 0; i < selectedTeams; i++) {
                      teamMembers[i] = [];
                    }
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '(${(classSize / selectedTeams).ceil()} per tim)',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildManualStudentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: studentInputController,
                decoration: const InputDecoration(
                  labelText: 'Masukkan nama siswa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_add),
                ),
                onSubmitted: (_) => _addManualStudent(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addManualStudent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        if (manualStudents.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Siswa yang Ditambahkan:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: manualStudents.map((student) {
                  return Chip(
                    label: Text(student),
                    backgroundColor: Colors.blue[100],
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => _removeManualStudent(student),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTeamNamesSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(Icons.edit, size: 30, color: Colors.blue[600]),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Masukkan Nama Tim',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(selectedTeams, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: teamControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Nama Tim ${index + 1}',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag, color: Colors.red[300]),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberAssignmentSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(Icons.people, size: 30, color: Colors.green[600]),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Atur Anggota',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        assignmentMode = 'custom';
                      });
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Kustom'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: assignmentMode == 'custom'
                          ? Colors.blue[100]
                          : Colors.grey[200],
                      foregroundColor: assignmentMode == 'custom'
                          ? Colors.blue[800]
                          : Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _getCurrentStudents().isNotEmpty
                        ? () {
                            setState(() {
                              assignmentMode = 'random';
                            });
                            _randomAssignment();
                          }
                        : null,
                    icon: const Icon(Icons.shuffle),
                    label: const Text('Acak'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: assignmentMode == 'random'
                          ? Colors.green[100]
                          : Colors.grey[200],
                      foregroundColor: assignmentMode == 'random'
                          ? Colors.green[800]
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_getCurrentStudents().isEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        studentSource == 'class'
                            ? 'Silakan atur ukuran kelas di atas.'
                            : 'Belum ada siswa yang ditambahkan. Silakan tambahkan siswa secara manual di atas.',
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              )
            else if (assignmentMode == 'random')
              _buildRandomAssignmentDisplay()
            else
              _buildCustomAssignmentInputs(),
          ],
        ),
      ),
    );
  }

  Widget _buildRandomAssignmentDisplay() {
    List<String> currentStudents = _getCurrentStudents();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Siswa didistribusikan secara otomatis (${currentStudents.length} total):',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(selectedTeams, (teamIndex) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${teamControllers[teamIndex].text} (${teamMembers[teamIndex]?.length ?? 0} anggota)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  if (teamMembers[teamIndex]?.isNotEmpty == true)
                    Wrap(
                      spacing: 4,
                      children: teamMembers[teamIndex]!.map((student) {
                        return Chip(
                          label: Text(
                            student,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.green[100],
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCustomAssignmentInputs() {
    List<String> unassignedStudents = [];
    List<String> allCurrentStudents = _getCurrentStudents();

    // Identify unassigned students
    for (String student in allCurrentStudents) {
      bool isAssigned = false;
      for (int i = 0; i < selectedTeams; i++) {
        if (teamMembers[i]?.contains(student) ?? false) {
          isAssigned = true;
          break;
        }
      }
      if (!isAssigned) {
        unassignedStudents.add(student);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Drag & drop siswa ke tim yang tersedia:',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),

        // Unassigned students section
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Siswa yang belum masuk tim (${unassignedStudents.length}):',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: unassignedStudents.map((student) {
                  return Draggable<String>(
                    data: student,
                    feedback: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          student,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          student,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        student,
                        style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Team assignment sections
        ...List.generate(selectedTeams, (teamIndex) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.blue[50],
            child: DragTarget<String>(
              onAccept: (student) {
                setState(() {
                  // Remove from any existing team
                  for (int i = 0; i < selectedTeams; i++) {
                    teamMembers[i]?.remove(student);
                  }
                  // Add to this team
                  teamMembers[teamIndex]?.add(student);
                });
              },
              onWillAccept: (data) => data != null,
              builder: (context, candidateData, rejectedData) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty ? Colors.blue[100] : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${teamControllers[teamIndex].text} (${teamMembers[teamIndex]?.length ?? 0} anggota)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (teamMembers[teamIndex]?.isNotEmpty ?? false)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: teamMembers[teamIndex]!.map((student) {
                            return GestureDetector(
                              onTap: () {
                                // Remove from team on tap
                                setState(() {
                                  teamMembers[teamIndex]?.remove(student);
                                });
                              },
                              child: Chip(
                                label: Text(
                                  student,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () {
                                  setState(() {
                                    teamMembers[teamIndex]?.remove(student);
                                  });
                                },
                                backgroundColor: Colors.blue[100],
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            );
                          }).toList(),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue[200]!,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Letakkan siswa di sini',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.blue[300],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        }),

        const SizedBox(height: 16),
        // Warning message if not all students are assigned
        if (unassignedStudents.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tidak semua siswa telah dimasukkan ke tim. Jika dibiarkan, siswa yang belum masuk tim akan diacak secara otomatis.',
                    style: TextStyle(color: Colors.orange[800]),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionModeSelection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(Icons.quiz, size: 30, color: Colors.purple[600]),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Jumlah Pertanyaan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RadioListTile<String>(
              title: const Text('Berdasarkan jumlah siswa per tim'),
              subtitle: Text('${_getStudentsPerTeam()} pertanyaan per tim'),
              value: 'based_on_students',
              groupValue: questionMode,
              onChanged: (value) {
                setState(() {
                  questionMode = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Standar: 30 pertanyaan'),
              subtitle: const Text('Jumlah pertanyaan tetap'),
              value: 'standard_30',
              groupValue: questionMode,
              onChanged: (value) {
                setState(() {
                  questionMode = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartBattleButton() {
    bool canStart = selectedTeams >= 2 &&
        teamControllers.every(
          (controller) => controller.text.trim().isNotEmpty,
        );

    // Additional validation for manual student mode
    if (studentSource == 'manual') {
      canStart = canStart && manualStudents.length >= selectedTeams;
    }

    return Column(
      children: [
        // Status information
        if (!canStart) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getStartButtonStatusMessage(),
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        // Start button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8055FE).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: canStart ? _startBattle : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.rocket_launch, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Mulai Spin Battle ($selectedTeams Tim)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _startBattle() {
    // Validate before starting
    if (studentSource == 'manual' && manualStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan tambahkan siswa terlebih dahulu!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (studentSource == 'manual' && manualStudents.length < selectedTeams) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Jumlah siswa minimal harus $selectedTeams untuk $selectedTeams tim!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    List<String> teamNames =
        teamControllers.map((controller) => controller.text.trim()).toList();

    // Validate team names
    if (teamNames.any((name) => name.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua nama tim harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Prepare team members
      Map<String, List<String>> finalTeamMembers = {};

      if (assignmentMode == 'random') {
        // Use the existing random assignment
        for (int i = 0; i < selectedTeams; i++) {
          finalTeamMembers[teamNames[i]] = teamMembers[i] ?? [];
        }
      } else {
        // Custom assignment mode
        List<String> allStudents = _getCurrentStudents();

        if (allStudents.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tidak ada siswa yang tersedia!'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Initialize team members from existing assignments
        for (int i = 0; i < selectedTeams; i++) {
          finalTeamMembers[teamNames[i]] = teamMembers[i] ?? [];
        }

        // Find unassigned students
        List<String> unassignedStudents = [];
        for (String student in allStudents) {
          bool isAssigned = false;
          for (int i = 0; i < selectedTeams; i++) {
            if (teamMembers[i]?.contains(student) ?? false) {
              isAssigned = true;
              break;
            }
          }
          if (!isAssigned) {
            unassignedStudents.add(student);
          }
        }

        // If there are unassigned students, distribute them randomly
        if (unassignedStudents.isNotEmpty) {
          // Show a notification that unassigned students will be randomly assigned
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${unassignedStudents.length} siswa belum dimasukkan tim, mereka akan diacak otomatis.',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );

          // Shuffle unassigned students
          unassignedStudents.shuffle();

          // Distribute evenly, starting with teams that have fewer members
          while (unassignedStudents.isNotEmpty) {
            // Find team with the fewest members
            int teamWithFewestMembers = 0;
            for (int i = 1; i < selectedTeams; i++) {
              if ((finalTeamMembers[teamNames[i]]?.length ?? 0) <
                  (finalTeamMembers[teamNames[teamWithFewestMembers]]?.length ??
                      0)) {
                teamWithFewestMembers = i;
              }
            }

            // Add student to the team with fewest members
            finalTeamMembers[teamNames[teamWithFewestMembers]]?.add(
              unassignedStudents.removeAt(0),
            );
          }
        }
      }

      final questionsPerTeam =
          questionMode == 'based_on_students' ? _getStudentsPerTeam() : 30;

      final removeNamesAfterSpin = questionMode == 'based_on_students';

      final gameManager = BattleGameManager(
        teamNames: teamNames,
        teamMembers: finalTeamMembers,
        questionsPerTeam: questionsPerTeam,
        removeNamesAfterSpin: removeNamesAfterSpin,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BattleGameScreen(gameManager: gameManager),
        ),
      );
    } catch (e) {
      print('Error starting battle: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in teamControllers) {
      controller.dispose();
    }
    studentInputController.dispose();
    classSizeController.dispose();
    super.dispose();
  }
}
