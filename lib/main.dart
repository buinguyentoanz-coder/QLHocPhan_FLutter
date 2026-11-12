import 'dart:convert';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDFiAUGFjSSDA98c0h7TqLrPUZuK6NdYcc',
      authDomain: 'qlhocphan-84c2d.firebaseapp.com',
      projectId: 'qlhocphan-84c2d',
      storageBucket: 'qlhocphan-84c2d.firebasestorage.app',
      messagingSenderId: '291434960065',
      appId: '1:291434960065:web:44389f324780e41438f040',
    ),
  );

  runApp(const QLHocPhanApp());
}

const Color ink = Color(0xFF17233D);
const Color primary = Color(0xFF3157D5);
const Color canvas = Color(0xFFF4F6FB);
const Color muted = Color(0xFF7B879D);

class QLHocPhanApp extends StatelessWidget {
  const QLHocPhanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      surface: Colors.white,
    );
    return MaterialApp(
      title: 'QLHocPhan - Quản lý giảng viên',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: canvas,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: ink,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F8FC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: primary, width: 1.4),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snapshot.hasData ? const DashboardPage() : const LoginPage();
      },
    );
  }
}

// -------------------- LOGIN --------------------

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool loading = false;
  bool obscure = true;
  String error = '';

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future login() async {
    if (emailCtrl.text.trim().isEmpty || passwordCtrl.text.isEmpty) {
      setState(() => error = 'Vui lòng nhập email và mật khẩu.');
      return;
    }
    setState(() {
      loading = true;
      error = '';
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? 'Không thể đăng nhập. Vui lòng thử lại.');
    } catch (_) {
      setState(() => error = 'Đã xảy ra lỗi kết nối. Vui lòng thử lại.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 760;
          return Row(
            children: [
              if (wide)
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(64),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF172B68), Color(0xFF3157D5), Color(0xFF6888F0)],
                        ),
                      ),
                      padding: const EdgeInsets.all(64),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school_rounded, color: Colors.white, size: 58),
                          SizedBox(height: 28),
                          Text('QLHocPhan', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w800)),
                          SizedBox(height: 14),
                          Text('Quản lý giảng viên\nđơn giản và hiệu quả.', style: TextStyle(color: Colors.white, fontSize: 27, height: 1.35, fontWeight: FontWeight.w600)),
                          SizedBox(height: 20),
                          Text('Không gian quản trị tập trung dành cho nhà trường.', style: TextStyle(color: Color(0xFFDCE5FF), fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!wide) ...[
                            const Icon(Icons.school_rounded, color: primary, size: 52),
                            const SizedBox(height: 14),
                            const Text('QLHocPhan', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: ink)),
                            const SizedBox(height: 28),
                          ],
                          const Text('Chào mừng trở lại!', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800, color: ink)),
                          const SizedBox(height: 8),
                          const Text('Đăng nhập tài khoản quản trị để tiếp tục.', style: TextStyle(color: muted, fontSize: 14)),
                          const SizedBox(height: 32),
                          const Text('ĐỊA CHỈ EMAIL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1, color: muted)),
                          const SizedBox(height: 9),
                          TextField(
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'admin@example.com',
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('MẬT KHẨU', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1, color: muted)),
                          const SizedBox(height: 9),
                          TextField(
                            controller: passwordCtrl,
                            obscureText: obscure,
                            onSubmitted: (_) => login(),
                            decoration: InputDecoration(
                              hintText: 'Nhập mật khẩu',
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => obscure = !obscure),
                                icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              ),
                            ),
                          ),
                          if (error.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: const Color(0xFFFFEEEE), borderRadius: BorderRadius.circular(12)),
                              child: Text(error, style: const TextStyle(color: Color(0xFFB42318), fontSize: 13)),
                            ),
                          ],
                          const SizedBox(height: 26),
                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              onPressed: loading ? null : login,
                              style: FilledButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                              ),
                              child: loading
                                  ? const SizedBox(height: 21, width: 21, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Text('ĐĂNG NHẬP', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: .5)),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text('QLHocPhan • Hệ thống quản lý giảng viên', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// -------------------- DASHBOARD --------------------

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final CollectionReference ref = FirebaseFirestore.instance.collection('GiangVien');
  final searchCtrl = TextEditingController();
  String query = '';

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  Future exportJson(List docs) async {
    final rows = docs.map((doc) {
      final d = (doc as QueryDocumentSnapshot).data() as Map;
      return {
        'IDGV': d['IDGV'] ?? '',
        'Fullname': d['Fullname'] ?? '',
        'Image': d['Image'] ?? '',
        'SumClass': d['SumClass'] ?? 0,
      };
    }).toList();

    final jsonString = const JsonEncoder.withIndent('  ').convert(rows);
    final bytes = utf8.encode(jsonString);
    final blob = html.Blob([bytes], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'GiangVien_QLHocPhan.json')
      ..click();
    html.Url.revokeObjectUrl(url);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã tải file GiangVien_QLHocPhan.json về máy!')),
    );
  }

  Future deleteLecturer(String docId, String name) async {
    final ok = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa giảng viên "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD92D20)),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa giảng viên'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.doc(docId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa giảng viên.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_person_rounded, size: 56, color: Color(0xFFD92D20)),
                      const SizedBox(height: 12),
                      Text(
                        'Không thể tải dữ liệu: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w700, color: ink),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final List all = (snapshot.data as QuerySnapshot).docs;
            final List filtered = all.where((doc) {
              final d = (doc as QueryDocumentSnapshot).data() as Map;
              final id = (d['IDGV'] ?? '').toString().toLowerCase();
              final name = (d['Fullname'] ?? '').toString().toLowerCase();
              return id.contains(query) || name.contains(query);
            }).toList();

            int totalClasses = 0;
            for (final doc in all) {
              final d = (doc as QueryDocumentSnapshot).data() as Map;
              final value = d['SumClass'];
              totalClasses += (value is num ? value.toInt() : int.tryParse('$value') ?? 0);
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 700;
                return Column(
                  children: [
                    _topBar(compact),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 34, vertical: 28),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1440),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Tổng quan', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800, color: ink)),
                                          SizedBox(height: 6),
                                          Text('Theo dõi và quản lý thông tin đội ngũ giảng viên.', style: TextStyle(color: muted)),
                                        ],
                                      ),
                                    ),
                                    if (!compact)
                                      FilledButton.icon(
                                        onPressed: () => showLecturerDialog(context, ref),
                                        icon: const Icon(Icons.add_rounded),
                                        label: const Text('Thêm giảng viên'),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: primary,
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: [
                                    _statCard('Tổng giảng viên', '${all.length}', Icons.groups_2_rounded, const Color(0xFFE9EFFF), primary),
                                    _statCard('Tổng số lớp', '$totalClasses', Icons.menu_book_rounded, const Color(0xFFE7F7F1), const Color(0xFF15966A)),
                                    _statCard('Kết quả tìm kiếm', '${filtered.length}', Icons.manage_search_rounded, const Color(0xFFFFF3E5), const Color(0xFFE58A21)),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFE9EDF5)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Danh sách giảng viên', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: ink)),
                                                SizedBox(height: 5),
                                                Text('Thông tin được đồng bộ trực tiếp từ Firestore.', style: TextStyle(fontSize: 12, color: muted)),
                                              ],
                                            ),
                                          ),
                                          if (compact)
                                            IconButton.filled(
                                              tooltip: 'Thêm giảng viên',
                                              onPressed: () => showLecturerDialog(context, ref),
                                              icon: const Icon(Icons.add),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: searchCtrl,
                                              onChanged: (v) => setState(() => query = v.trim().toLowerCase()),
                                              decoration: const InputDecoration(
                                                hintText: 'Tìm theo mã hoặc họ tên giảng viên...',
                                                prefixIcon: Icon(Icons.search_rounded),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          OutlinedButton.icon(
                                            onPressed: () => exportJson(all),
                                            icon: const Icon(Icons.download_rounded),
                                            label: const Text('Xuất JSON'),
                                            style: OutlinedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      if (filtered.isEmpty)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 50),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Icon(Icons.person_search_rounded, size: 48, color: Color(0xFFB8C1D1)),
                                                SizedBox(height: 12),
                                                Text('Không tìm thấy giảng viên phù hợp.', style: TextStyle(color: muted)),
                                              ],
                                            ),
                                          ),
                                        )
                                      else if (compact)
                                        Column(
                                          children: filtered.map((doc) => _lecturerTile(doc as QueryDocumentSnapshot)).toList(),
                                        )
                                      else
                                        _lecturerTable(filtered),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text('QLHocPhan  •  Hệ thống quản lý giảng viên', style: TextStyle(color: muted, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _topBar(bool compact) {
    return Container(
      height: 76,
      padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 34),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE9EDF5))),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(13)),
                child: const Icon(Icons.school_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('QLHocPhan', style: TextStyle(fontWeight: FontWeight.w900, color: ink, fontSize: 17)),
                  Text('ADMIN WORKSPACE', style: TextStyle(color: muted, fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
                ],
              ),
              const Spacer(),
              if (!compact) ...[
                const Icon(Icons.verified_user_outlined, size: 18, color: muted),
                const SizedBox(width: 8),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? 'Quản trị viên',
                  style: const TextStyle(color: ink, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(width: 18),
              ],
              IconButton(
                tooltip: 'Đăng xuất',
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: const Icon(Icons.logout_rounded, color: Color(0xFF65728A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color bg, Color fg) {
    return SizedBox(
      width: 245,
      child: Container(
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE9EDF5)),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: fg),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  Text(value, style: const TextStyle(color: ink, fontSize: 25, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ĐÃ SỬA: Bỏ SingleChildScrollView ngang gây lỗi Unbounded Width cho Expanded
  Widget _lecturerTable(List docs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(color: const Color(0xFFF6F8FC), borderRadius: BorderRadius.circular(10)),
          child: const Row(
            children: [
              Expanded(flex: 1, child: Text('MÃ GIẢNG VIÊN', style: _headerStyle)),
              Expanded(flex: 3, child: Text('GIẢNG VIÊN', style: _headerStyle)),
              Expanded(flex: 1, child: Text('SỐ LỚP', style: _headerStyle)),
              SizedBox(width: 100, child: Text('THAO TÁC', style: _headerStyle)),
            ],
          ),
        ),
        ...docs.map((item) {
          final doc = item as QueryDocumentSnapshot;
          final d = doc.data() as Map;
          final name = (d['Fullname'] ?? 'Chưa có tên').toString();
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF0F2F7)))),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text((d['IDGV'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.w700, color: primary)),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      _avatar((d['Image'] ?? '').toString(), 40),
                      const SizedBox(width: 12),
                      Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700, color: ink))),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text('${d['SumClass'] ?? 0} lớp', style: const TextStyle(color: muted, fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Chỉnh sửa',
                        onPressed: () => showLecturerDialog(context, ref, doc: doc),
                        icon: const Icon(Icons.edit_outlined, color: primary, size: 20),
                      ),
                      IconButton(
                        tooltip: 'Xóa',
                        onPressed: () => deleteLecturer(doc.id, name),
                        icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD92D20), size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _lecturerTile(QueryDocumentSnapshot doc) {
    final d = doc.data() as Map;
    final name = (d['Fullname'] ?? 'Chưa có tên').toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EDF5)),
      ),
      child: Row(
        children: [
          _avatar((d['Image'] ?? '').toString(), 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)),
                const SizedBox(height: 4),
                Text('${d['IDGV'] ?? ''}  •  ${d['SumClass'] ?? 0} lớp', style: const TextStyle(color: muted, fontSize: 12)),
              ],
            ),
          ),
          PopupMenuButton(
            onSelected: (v) {
              if (v == 'edit') showLecturerDialog(context, ref, doc: doc);
              if (v == 'delete') deleteLecturer(doc.id, name);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
              PopupMenuItem(value: 'delete', child: Text('Xóa')),
            ],
          ),
        ],
      ),
    );
  }
}

const TextStyle _headerStyle = TextStyle(fontSize: 10, letterSpacing: .8, color: muted, fontWeight: FontWeight.w800);

Widget _avatar(String image, double size) {
  ImageProvider? provider;
  try {
    if (image.startsWith('data:image')) {
      provider = MemoryImage(base64Decode(image.split(',').last));
    } else if (image.startsWith('http')) {
      provider = NetworkImage(image);
    }
  } catch (_) {}
  return CircleAvatar(
    radius: size / 2,
    backgroundColor: const Color(0xFFE9EFFF),
    backgroundImage: provider,
    child: provider == null ? const Icon(Icons.person_outline_rounded, color: primary) : null,
  );
}

// -------------------- ADD / EDIT --------------------

Future showLecturerDialog(
  BuildContext context,
  CollectionReference ref, {
  QueryDocumentSnapshot? doc,
}) async {
  final editing = doc != null;
  final Map data = doc != null ? (doc.data() as Map) : {};
  final idCtrl = TextEditingController(text: (data['IDGV'] ?? '').toString());
  final nameCtrl = TextEditingController(text: (data['Fullname'] ?? '').toString());
  final imageCtrl = TextEditingController(text: (data['Image'] ?? '').toString());
  final classCtrl = TextEditingController(text: (data['SumClass'] ?? '').toString());
  bool saving = false;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) {
        void chooseImage() {
          final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
          uploadInput.click();
          uploadInput.onChange.listen((event) {
            final files = uploadInput.files;
            if (files != null && files.isNotEmpty) {
              final reader = html.FileReader();
              reader.readAsDataUrl(files[0]);
              reader.onLoadEnd.listen((_) {
                if (reader.result != null) {
                  setDialogState(() {
                    imageCtrl.text = reader.result.toString();
                  });
                }
              });
            }
          });
        }

        Future save() async {
          final id = idCtrl.text.trim();
          final name = nameCtrl.text.trim();
          final sum = int.tryParse(classCtrl.text.trim());
          if (id.isEmpty || name.isEmpty || sum == null || sum < 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng nhập mã, họ tên và số lớp hợp lệ.')),
            );
            return;
          }
          setDialogState(() => saving = true);
          try {
            final Map<String, dynamic> payload = {
              'IDGV': id,
              'Fullname': name,
              'Image': imageCtrl.text.trim(),
              'SumClass': sum,
            };
            if (editing) {
              await ref.doc(doc.id).update(payload);
            } else {
              await ref.doc(id).set(payload);
            }
            if (dialogContext.mounted) Navigator.pop(dialogContext);
          } catch (e) {
            setDialogState(() => saving = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Không thể lưu dữ liệu: $e')),
            );
          }
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(color: const Color(0xFFE9EFFF), borderRadius: BorderRadius.circular(12)),
                child: Icon(editing ? Icons.edit_rounded : Icons.person_add_alt_1_rounded, color: primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  editing ? 'Cập nhật giảng viên' : 'Thêm giảng viên',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 470,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MÃ GIẢNG VIÊN', style: _headerStyle),
                  const SizedBox(height: 7),
                  TextField(
                    controller: idCtrl,
                    enabled: !editing,
                    decoration: const InputDecoration(
                      hintText: 'Ví dụ: GV01',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('HỌ VÀ TÊN', style: _headerStyle),
                  const SizedBox(height: 7),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Nhập họ và tên',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('ẢNH ĐẠI DIỆN', style: _headerStyle),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: imageCtrl,
                          onChanged: (_) => setDialogState(() {}),
                          decoration: const InputDecoration(hintText: 'Dán đường dẫn ảnh hoặc chọn từ máy'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: chooseImage,
                        tooltip: 'Chọn ảnh từ máy',
                        icon: const Icon(Icons.upload_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(child: _avatar(imageCtrl.text, 64)),
                  const SizedBox(height: 16),
                  const Text('TỔNG SỐ LỚP', style: _headerStyle),
                  const SizedBox(height: 7),
                  TextField(
                    controller: classCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Ví dụ: 5',
                      prefixIcon: Icon(Icons.menu_book_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: saving ? null : save,
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              ),
              child: saving
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(editing ? 'Lưu thay đổi' : 'Thêm giảng viên'),
            ),
          ],
        );
      },
    ),
  );

  idCtrl.dispose();
  nameCtrl.dispose();
  imageCtrl.dispose();
  classCtrl.dispose();
}