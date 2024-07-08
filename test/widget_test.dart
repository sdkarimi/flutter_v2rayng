
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Center(child: Text("vpn Boriya")),
//           actions: const [
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Icon(Icons.menu_rounded),
//             )
//           ],
//         ),
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//
//             gradient: LinearGradient(
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//               colors: [
//                Color(0xff37474F),
//                 Color(0xff455A64),
//                 Color(0xff546E7A),
//                 Color(0xff607D8B),
//               ],
//             ),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 width: 200,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                     colors: [
//                       Color(0xffFF6F00),
//                       Color(0xffFF8F00),
//                       Color(0xffFFA000),
//                     ],
//                   ),
//                 ),
//                 child: Container(
//                   margin: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: DarkTheme.backgroundColor,
//                     shape: BoxShape.circle,
//                   ),
//                   padding: const EdgeInsets.all(5),
//                   child: Icon(Icons.on_device_training),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
