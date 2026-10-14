import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const NijhumdwipApp());

const navy = Color(0xFF0B1736);
const teal = Color(0xFF12B8A6);
const gold = Color(0xFFFFC857);

class NijhumdwipApp extends StatelessWidget {
  const NijhumdwipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'নিঝুমদ্বীপ নির্বাচন',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: teal, brightness: Brightness.light),
        fontFamily: 'NotoSansBengali',
      ),
      home: const IntroJourney(),
    );
  }
}

class IntroJourney extends StatefulWidget {
  const IntroJourney({super.key});
  @override
  State<IntroJourney> createState() => _IntroJourneyState();
}

class _IntroJourneyState extends State<IntroJourney> with TickerProviderStateMixin {
  final places = const [
    ('বাংলাদেশ', 'আমাদের মাটি, আমাদের মানুষ, আমাদের ভবিষ্যৎ'),
    ('চট্টগ্রাম বিভাগ', 'বাংলাদেশের দক্ষিণ-পূর্বের পথে'),
    ('নোয়াখালী', 'উপকূলের দিকে যাত্রা'),
    ('হাতিয়া', 'দ্বীপের পথে আরও এক ধাপ'),
    ('নিঝুমদ্বীপ', 'নির্বাচনী পরিবেশের গল্পে স্বাগতম'),
  ];
  int index = 0;
  Timer? timer;
  late final AnimationController zoom = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..forward();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 2300), (_) {
      if (!mounted) return;
      if (index < places.length - 1) {
        setState(() => index++);
        zoom.forward(from: 0);
      } else {
        timer?.cancel();
      }
    });
  }

  @override
  void dispose() { timer?.cancel(); zoom.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isLast = index == places.length - 1;
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: Stack(children: [
          Positioned.fill(child: CustomPaint(painter: MapBackdropPainter(index: index))),
          Center(child: AnimatedBuilder(animation: zoom, builder: (context, child) {
            final scale = 0.72 + (zoom.value * 0.35);
            return Transform.scale(scale: scale, child: child);
          }, child: Container(
            width: 250, height: 250,
            decoration: BoxDecoration(shape: BoxShape.circle, color: teal.withOpacity(.10), border: Border.all(color: teal.withOpacity(.55), width: 1.5), boxShadow: [BoxShadow(color: teal.withOpacity(.15), blurRadius: 50, spreadRadius: 10)]),
            child: const Icon(Icons.public, size: 105, color: Colors.white),
          ))),
          Positioned(left: 24, right: 24, bottom: 44, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('বাংলাদেশ  ›  চট্টগ্রাম  ›  নোয়াখালী  ›  হাতিয়া  ›  নিঝুমদ্বীপ', style: TextStyle(color: Colors.white.withOpacity(.68), fontSize: 11),),
            const SizedBox(height: 14),
            AnimatedSwitcher(duration: const Duration(milliseconds: 350), child: Text(places[index].$1, key: ValueKey(index), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Text(places[index].$2, style: const TextStyle(color: gold, fontSize: 15)),
            const SizedBox(height: 22),
            Row(children: [
              Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: (index + 1) / places.length, minHeight: 5, backgroundColor: Colors.white24, color: teal))),
              const SizedBox(width: 12),
              Text('${index + 1}/${places.length}', style: const TextStyle(color: Colors.white70)),
            ]),
            if (isLast) ...[
              const SizedBox(height: 22),
              SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())), icon: const Icon(Icons.arrow_forward), label: const Text('গল্পটি দেখুন'))),
            ],
            if (!isLast) ...[
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () { timer?.cancel(); setState(() => index = places.length - 1); zoom.forward(from: 0); }, child: const Text('এড়িয়ে যান', style: TextStyle(color: Colors.white70)))),
            ],
          ])),
        ]),
      ),
    );
  }
}

class MapBackdropPainter extends CustomPainter {
  final int index;
  MapBackdropPainter({required this.index});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF14294D);
    canvas.drawRect(Offset.zero & size, p);
    final grid = Paint()..color = Colors.white.withOpacity(.045)..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 28) { canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid); }
    for (double y = 0; y < size.height; y += 28) { canvas.drawLine(Offset(0, y), Offset(size.width, y), grid); }
    final land = Paint()..color = const Color(0xFF245B65).withOpacity(.65);
    final path = Path()
      ..moveTo(size.width * .13, size.height * .18)
      ..quadraticBezierTo(size.width * .25, size.height * .08, size.width * .39, size.height * .19)
      ..lineTo(size.width * .48, size.height * .33)
      ..lineTo(size.width * .42, size.height * .45)
      ..lineTo(size.width * .50, size.height * .58)
      ..lineTo(size.width * .41, size.height * .70)
      ..lineTo(size.width * .33, size.height * .61)
      ..lineTo(size.width * .23, size.height * .48)
      ..lineTo(size.width * .15, size.height * .36)
      ..close();
    canvas.drawPath(path, land);
    final route = Paint()..color = gold..strokeWidth = 2.5..style = PaintingStyle.stroke;
    final routePath = Path()..moveTo(size.width*.29, size.height*.25)..quadraticBezierTo(size.width*.58, size.height*.31, size.width*.62, size.height*.52)..quadraticBezierTo(size.width*.67, size.height*.61, size.width*.74, size.height*.70);
    canvas.drawPath(routePath, route);
    final dot = Paint()..color = teal;
    final points = [Offset(size.width*.29,size.height*.25),Offset(size.width*.46,size.height*.35),Offset(size.width*.62,size.height*.52),Offset(size.width*.74,size.height*.70)];
    for (final point in points) { canvas.drawCircle(point, 5, dot); canvas.drawCircle(point, 10, Paint()..color = teal.withOpacity(.18)); }
  }
  @override
  bool shouldRepaint(covariant MapBackdropPainter oldDelegate) => oldDelegate.index != index;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(title: const Text('নিঝুমদ্বীপ নির্বাচন'), backgroundColor: navy, foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [navy, Color(0xFF21536A)]), borderRadius: BorderRadius.circular(24)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.waves, color: gold, size: 38), SizedBox(height: 16),
          Text('নিঝুমদ্বীপের ভবিষ্যৎ', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
          SizedBox(height: 8), Text('এলাকা, নাগরিক সমস্যা ও নির্বাচনী তথ্য জানুন।', style: TextStyle(color: Colors.white70, fontSize: 15)),
        ])),
        const SizedBox(height: 18),
        const SceneCard(icon: Icons.signpost_outlined, title: 'নিঝুমদ্বীপের নির্বাচনী পরিবেশ', subtitle: 'রাস্তাঘাট, বাজার ও নির্বাচনী পোস্টারের দৃশ্য', body: 'এই অংশে নিঝুমদ্বীপের নিজস্ব ছবি বা ভিডিও যোগ করা যাবে।'),
        const SceneCard(icon: Icons.how_to_vote_outlined, title: 'ভোটকেন্দ্র', subtitle: 'ভোটারদের আসা-যাওয়া ও ভোটের পরিবেশ', body: 'এটি একটি সিমুলেটেড দৃশ্য। বাস্তব ভোটারের পছন্দ বা গোপন ব্যালট দেখানো হবে না।'),
        const SceneCard(icon: Icons.compare_arrows, title: 'নির্বাচনের পর এলাকার চিত্র', subtitle: 'দায়িত্বশীলতা, নাগরিক সমস্যা ও উন্নয়ন', body: 'কাল্পনিক উদাহরণ বা যাচাইযোগ্য তথ্য দিয়ে এলাকার সমস্যা ও কাজের অগ্রগতি তুলে ধরা যাবে।'),
        Card(elevation: 0, clipBehavior: Clip.antiAlias, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.fromLTRB(18, 18, 18, 8), child: Row(children: [
            ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.asset('assets/images/candidate_photo.jpg', width: 76, height: 88, fit: BoxFit.cover)),
            const SizedBox(width: 14),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('মোঃ নাহিদ উদ্দিন', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: navy)),
              SizedBox(height: 5), Text('মেম্বার পদপ্রার্থী', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              SizedBox(height: 3), Text('৬ নং ওয়ার্ড • নিঝুমদ্বীপ ইউনিয়ন', style: TextStyle(fontSize: 12, color: Colors.black54)),
            ])),
          ])),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8), child: Text('প্রার্থীর দেওয়া নির্বাচনী পোস্টার', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          Image.asset('assets/images/candidate_poster.jpg', width: double.infinity, fit: BoxFit.fitWidth),
          const Padding(padding: EdgeInsets.all(14), child: Text('পোস্টারটি দেওয়া অবস্থায় রাখা হয়েছে। নির্বাচনী প্রতীক চূড়ান্ত না হওয়ায় আলাদা কোনো প্রতীক যোগ করা হয়নি।', style: TextStyle(color: Colors.black54, fontSize: 12))),
        ])),
        const SizedBox(height: 12),
        const Center(child: Text('আজকের সচেতন সিদ্ধান্ত, আগামীর সুন্দর নিঝুমদ্বীপ।', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: navy))),
        const SizedBox(height: 26),
      ]),
    );
  }
}

class SceneCard extends StatelessWidget {
  final IconData icon; final String title; final String subtitle; final String body;
  const SceneCard({super.key, required this.icon, required this.title, required this.subtitle, required this.body});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), child: Padding(padding: const EdgeInsets.all(16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: teal.withOpacity(.12), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: teal, size: 27)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: navy, fontSize: 13)), const SizedBox(height: 8), Text(body, style: const TextStyle(color: Colors.black54, fontSize: 13))]))])));
}
