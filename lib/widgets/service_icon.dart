import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiceIcon extends StatelessWidget {
  final String serviceName;
  final Color? color;
  final double size;

  const ServiceIcon(
      {Key? key, required this.serviceName, this.color, this.size = 15})
      : super(key: key);

  static const _serviceTypes = {
    "plumber": FontAwesomeIcons.sink,
    "electrician": FontAwesomeIcons.plugCircleExclamation,
    "cleaner": FontAwesomeIcons.broom,
    "doctor": FontAwesomeIcons.userDoctor,
    "painter": FontAwesomeIcons.paintRoller,
    "builder": FontAwesomeIcons.trowelBricks,
    "mover": FontAwesomeIcons.truckRampBox,
    "repairman": FontAwesomeIcons.screwdriverWrench,
  };

  @override
  Widget build(BuildContext context) {
    if (!_serviceTypes.containsKey(serviceName.toLowerCase())) {
      return Text(
        serviceName.characters.first.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: size,
        ),
      );
    }

    return FaIcon(
      _serviceTypes[serviceName.toLowerCase()],
      color: color,
      semanticLabel: serviceName.toLowerCase(),
      size: size,
    );
  }
}
