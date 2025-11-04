import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WheelScreen extends StatelessWidget {
  const WheelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WheelPage(title: 'Wheel');
  }
}

class WheelPage extends StatefulWidget {
  const WheelPage({super.key, required this.title});

  final String title;

  @override
  State<WheelPage> createState() => _WheelState();
}

class _WheelState extends State<WheelPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'daily_bonus'.tr(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.daysOne(
                              fontSize: context.locale.languageCode == 'bg'
                                  ? AdaptiveSizes.getWheelTitleSize() -
                                        AdaptiveSizes.getLanguageMinusTitle()
                                  : context.locale.languageCode == 'ru'
                                  ? AdaptiveSizes.getWheelTitleSize() -
                                        AdaptiveSizes.getLanguageMinusTitle()
                                  : AdaptiveSizes.getWheelTitleSize(),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              color: Colors.orangeAccent[200],
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 244, 105, 179),
                                  offset: Offset(3.5, 4.5),
                                  blurRadius: 3,
                                ),
                                Shadow(
                                  color: Color.fromARGB(255, 224, 67, 146),
                                  offset: Offset(5.5, 6.5),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: context.locale.languageCode == 'bg'
                              ? AdaptiveSizes.h(0.09) - 45
                              : context.locale.languageCode == 'ru'
                              ? AdaptiveSizes.h(0.09) - 45
                              : AdaptiveSizes.h(0.09),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.95,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: const WheelWidget(),
                        ),

                        SizedBox(
                          height: context.locale.languageCode == 'bg'
                              ? AdaptiveSizes.h(0.08) +
                                    AdaptiveSizes.getWheelSizedBoxlanguageCode()
                              : context.locale.languageCode == 'ru'
                              ? AdaptiveSizes.h(0.08) +
                                    AdaptiveSizes.getWheelSizedBoxlanguageCode()
                              : AdaptiveSizes.h(0.08) +
                                    AdaptiveSizes.getWheelSizedBoxlanguageCode(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
