import 'package:flutter/material.dart';
import 'package:quizgame/pages/mode.dart';
import 'package:quizgame/pages/mode/collaboration/CollaborationGameScreen.dart';
import 'panduan_colaboration_new.dart';
import 'CollaborationGameManager.dart';

class TeamPlayer extends StatefulWidget {
  final String? teamName;

  const TeamPlayer({super.key, this.teamName});

  @override
  State<TeamPlayer> createState() => TeamPlayerState();
}

class TeamPlayerState extends State<TeamPlayer> {
  final TextEditingController namaGrupController = TextEditingController();
  final TextEditingController anggotaController = TextEditingController();
  List<String> daftarAnggota = [];
  String modeSoal = 'sesuai_siswa'; // 'sesuai_siswa' atau 'tetap_30'
  final int maxAnggota = 30;

  @override
  void initState() {
    super.initState();
    // Set nama tim dari parameter yang diterima
    if (widget.teamName != null) {
      namaGrupController.text = widget.teamName!;
    }
  }

  void _tambahAnggota() {
    final nama = anggotaController.text.trim();
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama anggota tidak boleh kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (daftarAnggota.length >= maxAnggota) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maksimal $maxAnggota anggota!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (daftarAnggota.contains(nama)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama anggota sudah ada!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      daftarAnggota.add(nama);
      anggotaController.clear();
    });
  }

  void _hapusAnggota(int index) {
    setState(() {
      daftarAnggota.removeAt(index);
    });
  }

  void _startColaborationGame() {
    if (daftarAnggota.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tambahkan minimal 1 anggota tim!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final totalQuestions =
        modeSoal == 'sesuai_siswa' ? daftarAnggota.length : 30;
    final removeNamesAfterSpin = modeSoal == 'sesuai_siswa';
    final groupName = namaGrupController.text.trim().isEmpty
        ? 'Tim Kolaborasi'
        : namaGrupController.text.trim();

    final gameManager = CollaborationGameManager(
      studentNames: List.from(daftarAnggota),
      totalQuestions: totalQuestions,
      removeNamesAfterSpin: removeNamesAfterSpin,
      groupName: groupName,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollaborationGameScreen(gameManager: gameManager),
      ),
    );
  }

  @override
  void dispose() {
    namaGrupController.dispose();
    anggotaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xffFEFFE8),
          image: DecorationImage(
            image: AssetImage('assets/images/bg_line.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SafeArea(child: _buildAppBar(context)),
                Expanded(child: Center(child: _buildInputTeamForm())),
                const SizedBox(height: 80),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'assets/images/colaborationmode.png',
                width: 400,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/images/colaborationmode.png',
                width: 400,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
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
              icon: Image.asset(
                'assets/images/icon_back.png',
                height: 54.0,
                width: 54.0,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ModePermainan(),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Image.asset(
              'assets/icons/icon_info.png',
              height: 54.0,
              width: 54.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PanduanColaboration(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputTeamForm() {
    return Container(
      height: 470,
      width: 1170,
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xff3689EF),
        borderRadius: BorderRadius.circular(41),
        border: Border.all(color: Colors.black, width: 2.5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/ColaborationModeText.png',
                    width: 290,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(height: 18.26),
                Text(
                  'Silahkan masukkan anggota tim sebelum memulai permainan\n(${daftarAnggota.length}/$maxAnggota anggota)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Satoshi',
                    fontStyle: FontStyle.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 14),

                // Team Name Display (readonly - sudah diset dari halaman sebelumnya)
                Center(
                  child: Container(
                    height: 46,
                    width: 298,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(38),
                      border: Border.all(color: Colors.black87, width: 1),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/icons/icon_soal.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Text(
                              namaGrupController.text.isNotEmpty
                                  ? namaGrupController.text
                                  : 'Tim Kolaborasi',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 14),

                // Add Member Input (dengan icon_nama) - Center dan sejajar dengan field nama tim
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 46,
                        width: 248,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(38),
                          border: Border.all(color: Colors.black87, width: 1),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/icons/icon_nama.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: anggotaController,
                                decoration: InputDecoration(
                                  hintText: 'Tambah orang',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'Poppins',
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Satoshi',
                                ),
                                onFieldSubmitted: (value) => _tambahAnggota(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: _tambahAnggota,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFAA0D),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 39,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFAA0D),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Kembali',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 26),
                    Expanded(
                      child: Container(
                        height: 39,
                        width: 140,
                        decoration: BoxDecoration(
                          color: daftarAnggota.isNotEmpty
                              ? Color(0xFFFFAA0D)
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextButton(
                          onPressed: daftarAnggota.isNotEmpty
                              ? _startColaborationGame
                              : null,
                          child: Text(
                            'Selanjutnya',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
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

          SizedBox(width: 75),

          Expanded(
            child: Container(
              width: 570,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/listAnggotaTim.png',
                      height: 40,
                      // fit: BoxFit.fitWidth,
                    ),
                  ),

                  // Content area dengan background putih
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Grid untuk menampilkan anggota (3 baris x 10 kolom)
                          Expanded(
                            flex: 3,
                            child: daftarAnggota.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/colaborationmode.png',
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Tambahkan anggota tim terlebih dahulu\nagar bisa memulai kuis',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, // 3 kolom
                                      childAspectRatio:
                                          2.0, // Rasio lebar:tinggi
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                    itemCount: 30, // Maksimal 30 slot
                                    itemBuilder: (context, index) {
                                      final bool hasData =
                                          index < daftarAnggota.length;
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: hasData
                                              ? Colors.blue[50]
                                              : Colors.grey[100],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: hasData
                                                ? Colors.blue[300]!
                                                : Colors.grey[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: hasData
                                            ? Stack(
                                                children: [
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                      ),
                                                      child: Text(
                                                        daftarAnggota[index],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins',
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 2,
                                                    right: 2,
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _hapusAnggota(index),
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Center(
                                                child: Text(
                                                  '${index + 1}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[500],
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Container terpisah untuk Mode Soal Selection
          if (daftarAnggota.isNotEmpty) ...[
            SizedBox(width: 20),
            Container(
              width: 250,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings, color: Color(0xFF3689EF), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Mode Soal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Opsi Sesuai Siswa
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        modeSoal = 'sesuai_siswa';
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: modeSoal == 'sesuai_siswa'
                            ? Color(0xFF3689EF)
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: modeSoal == 'sesuai_siswa'
                              ? Color(0xFF3689EF)
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sesuai Siswa',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: modeSoal == 'sesuai_siswa'
                                  ? Colors.white
                                  : Colors.black87,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${daftarAnggota.length} soal total',
                            style: TextStyle(
                              fontSize: 12,
                              color: modeSoal == 'sesuai_siswa'
                                  ? Colors.white70
                                  : Colors.grey[600],
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Setiap siswa menjawab 1 soal',
                            style: TextStyle(
                              fontSize: 10,
                              color: modeSoal == 'sesuai_siswa'
                                  ? Colors.white60
                                  : Colors.grey[500],
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Opsi Standar 30
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        modeSoal = 'tetap_30';
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: modeSoal == 'tetap_30'
                            ? Color(0xFF3689EF)
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: modeSoal == 'tetap_30'
                              ? Color(0xFF3689EF)
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Standar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: modeSoal == 'tetap_30'
                                  ? Colors.white
                                  : Colors.black87,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '30 soal total',
                            style: TextStyle(
                              fontSize: 12,
                              color: modeSoal == 'tetap_30'
                                  ? Colors.white70
                                  : Colors.grey[600],
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Siswa bisa menjawab berulang',
                            style: TextStyle(
                              fontSize: 10,
                              color: modeSoal == 'tetap_30'
                                  ? Colors.white60
                                  : Colors.grey[500],
                              fontFamily: 'Poppins',
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
        ],
      ),
    );
  }
}
