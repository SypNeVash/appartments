import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardTask extends StatelessWidget {
  const CardTask({
    required this.data,
    required this.primary,
    required this.onPrimary,
    Key? key,
  }) : super(key: key);

  final ApartmentModel data;
  final Color primary;
  final Color onPrimary;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 800) {
        // Use Row layout if screen width is greater than 600 pixels
        return desktopCardTask();
      } else {
        // Use Column layout if screen width is less than or equal to 600 pixels
        return mobileCardTask();
      }
    });
  }

  ClipRRect mobileCardTask() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, primary.withOpacity(.7)],
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: NetworkImage(
                      data.photos!.first.toString(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildLabel(),
                      _buildAddress(),
                      const SizedBox(height: 20),
                      _buildStatus(),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      price(),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildDate(),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  IdButton(
                    id: data.id.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ClipRRect desktopCardTask() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, primary.withOpacity(.7)],
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: NetworkImage(
                      data.photos!.first.toString(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 115,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildLabel(),
                          _buildAddress(),
                          const SizedBox(height: 15),
                          _buildStatus(),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        price(),
                        const SizedBox(
                          height: 15,
                        ),
                        _buildDate(),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    IdButton(
                      id: data.id.toString(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card myCard() {
    return Card(
        elevation: 5.0,
        child: InkWell(
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Image.network(
                data.city ?? '',
                fit: BoxFit.contain,
                height: 150.0,
                width: 150.0,
              ),
            ),
          ),
        ));
  }

  Widget _buildLabel() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.region ?? '',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: onPrimary,
            letterSpacing: 1,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          ' - ${data.type}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: onPrimary,
            letterSpacing: 1,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatus() {
    return Container(
      decoration: data.status == 'Deleted'
          ? BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(25),
            )
          : BoxDecoration(
              color: onPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        data.status ?? '',
        style: data.status == 'Deleted'
            ? const TextStyle(
                color: Colors.white,
                fontSize: 15,
                letterSpacing: 1,
              )
            : const TextStyle(
                color: Colors.black,
                fontSize: 15,
                letterSpacing: 1,
              ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDate() {
    return _IconLabel(
      color: onPrimary,
      iconData: EvaIcons.calendarOutline,
      label: data.createdData.toString(),
    );
  }

   Widget _buildAddress() {
    return _IconLabel(
      color: onPrimary,
      iconData: EvaIcons.pin,
      label: data.address.toString(),
    );
  }

  Widget price() {
    return Row(
      children: [
        const FaIcon(
          FontAwesomeIcons.dollarSign,
          color: Colors.white,
          size: 18,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          data.price.toString(),
          style: const TextStyle(
              fontSize: 19, fontWeight: FontWeight.w700, color: Colors.white),
        )
      ],
    );
  }

  // Widget _buildHours() {
  //   return _IconLabel(
  //     color: onPrimary,
  //     iconData: EvaIcons.clockOutline,
  //     label: data.phone ?? '',
  //   );
  // }
}

class _IconLabel extends StatelessWidget {
  const _IconLabel({
    required this.color,
    required this.iconData,
    required this.label,
    Key? key,
  }) : super(key: key);

  final Color color;
  final IconData iconData;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(.8),
          ),
        )
      ],
    );
  }
}

class BackgroundDecoration extends StatelessWidget {
  const BackgroundDecoration({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Transform.translate(
            offset: const Offset(25, -25),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Transform.translate(
            offset: const Offset(-70, 70),
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class IdButton extends StatefulWidget {
  final String id;

  const IdButton({required this.id, super.key});

  @override
  State<IdButton> createState() => _IdButtonState();
}

class _IdButtonState extends State<IdButton> {
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
        foregroundColor: onPrimary,
        backgroundColor: Colors.orange,
      ),
      icon: const Icon(
        EvaIcons.copy,
        color: Colors.white,
        size: 15,
      ),
      label: Text("ID: ${widget.id}",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          )),
    );
  }
}
