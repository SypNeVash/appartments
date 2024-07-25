import 'package:apartments/app/api/all_apartments_api.dart';
import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/features/dashboard/views/components/responsive_raw_to_column.dart';
import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../edit_appartment_screen.dart';

class ApartmentDetailsSubScreen extends StatefulWidget {
  const ApartmentDetailsSubScreen({super.key});

  @override
  State<ApartmentDetailsSubScreen> createState() =>
      _ApartmentDetailsSubScreenState();
}

class _ApartmentDetailsSubScreenState extends State<ApartmentDetailsSubScreen> {
  ApiClient apiClient = ApiClient();
  String? role;
  void _showAlertDialog() async {
    Get.defaultDialog(
      title: "Зачекай!",
      middleText: "Ти впевнений?",
      textConfirm: "Так",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        String apartmentId = await SPHelper.getIDAptSharedPreference() ?? '';
        final response =
            await RemoteApi().deleteApartDataFromAzure(apartmentId);

        if (response == true) {
          Get.back();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<ApartmentProvider>(context, listen: false)
                .fetchApartments(1);
          });

          Navigator.pop(context);

          Get.toNamed('/');
        } else {
          showSnackBarForError();
        }
      },
      textCancel: "Назад",
      onCancel: () {},
    );
  }

  void _refreshAppDialog() async {
    Get.defaultDialog(
      title: "Зачекай!",
      middleText: "Актуалізувати данні?",
      textConfirm: "Так",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        String apartmentId = await SPHelper.getIDAptSharedPreference() ?? '';
        final response =
            await RemoteApi().refreshApartDataFromAzure(apartmentId);

        if (response == true) {
          Get.back();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<ApartmentProvider>(context, listen: false)
                .fetchApartments(1);
          });

          Navigator.pop(context);
        } else {
          showSnackBarForError();
        }
      },
      textCancel: "Назад",
      onCancel: () {},
    );
  }

  showSnackBarForError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not delete apartment.Please try again'),
        duration: Duration(seconds: 4),
      ),
    );
  }

  getUserData() async {
    role = await SPHelper.getRolesSharedPreference() ?? '';
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  saveChatTextToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showSnackBarForConfirmation();
  }

  showSnackBarForConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Center(
          child: Text(
            'Copied',
            style: TextStyle(color: Colors.white),
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: apiClient.fetchApartmentDetails(),
        builder: (context, AsyncSnapshot<ApartmentModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.only(top: 28.0),
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Помилка: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            ApartmentModel apartment = snapshot.data!;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 248, 246, 246),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // const SizedBox(
                          //   child: FaIcon(
                          //     FontAwesomeIcons.arrowLeftLong,
                          //     color: Colors.black,
                          //     size: 18,
                          //   ),
                          // ),
                          const Expanded(
                            child: Text(
                              "Детальна інформація про квартиру",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (role == 'Admin' || role == 'Stuff') ...[
                            InkWell(
                              onTap: () => _refreshAppDialog(),
                              child: const FaIcon(
                                FontAwesomeIcons.arrowsRotate,
                                color: Colors.black,
                                size: 18,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () => _showAlertDialog(),
                              child: const FaIcon(
                                FontAwesomeIcons.trashCan,
                                color: Colors.black,
                                size: 18,
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.circleInfo,
                          color: Colors.blue,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Статус: ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          apartment.status.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CarouselSlider.builder(
                    itemCount: apartment.photos!.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return Container(
                        margin: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                FullScreenImagePage(
                                  images: apartment.photos!,
                                  initialIndex: index,
                                ),
                              );
                            },
                            child: Image.network(
                              apartment.photos![index],
                              fit: BoxFit.cover,
                              width: 1000.0,
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 400.0,
                      enlargeCenterPage: true,
                      scrollPhysics: const BouncingScrollPhysics(),
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              apartment.region.toString(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "- ${apartment.type}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '₴ ' + apartment.price.toString(),
                              style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.locationDot,
                              color: Colors.orange,
                              size: 13,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              apartment.city.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        IdButtonForAptDetails(
                          id: apartment.secondId.toString(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 250, 248, 248)),
                    child: ResponsiveRowColumn(
                        child1: Row(
                          children: [
                            const Text(
                              'Адреса: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              apartment.address.toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        child2: Row(
                          children: [
                            const Text(
                              'Площа: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              apartment.square.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Тел: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            InkWell(
                              onTap: () {
                                saveChatTextToClipboard(
                                    apartment.phone.toString());
                              },
                              child: Text(
                                apartment.phone.toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox()),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Про квартиру",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 800,
                            child: Text(
                              apartment.description.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 250, 248, 248)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Коментарій",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 800,
                              child: Text(
                                apartment.comment.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  if (role == 'Admin' || role == 'Stuff') ...[
                    SizedBox(
                        width: 240,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 188, 2),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ApartmentEditDetail()),
                              );

                              // Get.toNamed(
                              //   '/editingApartments',
                              // );
                            },
                            child: const Text(
                              'Редагувати',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ))),
                  ],
                  const SizedBox(
                    height: 55,
                  )
                ],
              ),
            );
          } else {
            return const Center(child: Text('Дані не доступні'));
          }
        });
  }
}

class IdButtonForAptDetails extends StatefulWidget {
  final String id;

  const IdButtonForAptDetails({required this.id, super.key});

  @override
  State<IdButtonForAptDetails> createState() => _IdButtonForAptDetailsState();
}

class _IdButtonForAptDetailsState extends State<IdButtonForAptDetails> {
  bool isCopied = false;

  get onPrimary => null;
  copyToClipboard(String? id) async {
    final text = widget.id;
    if (text.isNotEmpty) {
      // ClipboardData? data = await Clipboard.getData('text/plain');
      Clipboard.setData(ClipboardData(text: text));
      showSnackBarForConfirmation();
      // if (data!.text == id) {
      //   print('is the same');
      //   setState(() {});
      //   return false;
      // } else {
      //   setState(() {});
      //   return true;
      // }
    }
  }

  showSnackBarForConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Center(
          child: Text(
            'Copied',
            style: TextStyle(color: Colors.white),
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        copyToClipboard(widget.id);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        foregroundColor: onPrimary,
        backgroundColor: Colors.white,
      ),
      icon: const Icon(
        EvaIcons.copy,
        color: Colors.grey,
        size: 17,
      ),
      label: Text("ID: ${widget.id}",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          )),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final List images;
  final int initialIndex;

  const FullScreenImagePage(
      {Key? key, required this.images, required this.initialIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            EvaIcons.arrowBack,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        loadingBuilder: (context, event) {
          return Center(
            child: CircularProgressIndicator(
              value: event == null
                  ? null
                  : event.cumulativeBytesLoaded /
                      (event.expectedTotalBytes ?? 1),
            ),
          );
        },
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(images[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: initialIndex),
        onPageChanged: (index) {},
      ),
    );
  }
}
