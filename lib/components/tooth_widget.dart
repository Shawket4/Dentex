import 'package:dentex/models/appointment.dart';
import 'package:dentex/models/patient.dart';
import 'package:flutter/material.dart';

GestureDetector toothWidget(Function() onTap, Tooth tooth,
        Appointment appointment, double? scale) =>
    GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70,
        height: 70,
        child: ColorFiltered(
          colorFilter:
              ColorFilter.mode(appointment.condition.color!, BlendMode.hue),
          child: Container(
            color: Colors.white,
            child: Image.asset(
              "assets/images/teeth/${tooth.toothCode[1] + tooth.toothCode[2]}${appointment.condition.name != "None" ? "_Colored" : ""}.png",
              scale: scale,
            ),
          ),
        ),
      ),
    );
