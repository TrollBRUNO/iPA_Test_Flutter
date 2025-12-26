import 'package:another_flushbar/flushbar.dart';
import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/class/cards.dart';
import 'package:first_app_flutter/class/statistics.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/background_worker.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/add_card_dialog_widget.dart';
import 'package:first_app_flutter/widgets/statistics_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardsDialogWidget extends StatefulWidget {
  final VoidCallback onClaim;

  const CardsDialogWidget({required this.onClaim});

  @override
  State<CardsDialogWidget> createState() => _CardsDialogState();
}

/* final List<Cards> cards = [
  Cards(cardId: "PB-123456", city: "Plovdiv", isActive: true),
  Cards(cardId: "SF-321232", city: "Sofia", isActive: false),
]; */
final List<Cards> cards = [];

Widget cardListWidget({
  required String cardId,
  required String city,
  required bool isActive,
  required VoidCallback onRemove,
}) {
  return Padding(
    padding: AdaptiveSizes.getCardsPadding(),
    child: Opacity(
      opacity: isActive ? 1.0 : 0.45,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.yellow.shade200,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow.shade600,
              spreadRadius: 1.5,
              blurRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            // 💳 Иконка
            Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.credit_card_rounded,
                color: isActive ? Colors.green[700] : Colors.grey,
                size: AdaptiveSizes.getCardSize(),
              ),
            ),

            const SizedBox(width: 8),

            // 🧾 Текст
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Card ID: $cardId',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.raleway(
                      fontSize: AdaptiveSizes.getFontInfoSize(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    city,
                    style: GoogleFonts.raleway(
                      fontSize: AdaptiveSizes.getFontInfoSize() - 1,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            if (isActive)
              GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class _CardsDialogState extends State<CardsDialogWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  List<Cards> cards = [];

  Future<void> _removeCard(BuildContext context, String cardId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove card'),
        content: const Text('Do you really want to deactivate this card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.removeCard(cardId);

      setState(() {
        cards = cards.map((c) {
          if (c.cardId == cardId) {
            /* return c.copyWith(
              isActive: false,
            ); // или просто c.isActive = false, если нет copyWith */
            return c.isActive
                ? Cards(cardId: c.cardId, city: c.city, isActive: false)
                : c;
          }
          return c;
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.ease);
    _controller.forward();

    _loadCards();
  }

  Future<void> _loadCards() async {
    final result = await AuthService.loadCards();
    setState(() {
      cards = result;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Основной контейнер с тенью
                      Container(
                        width: AdaptiveSizes.getStatisticsDialogMaxWidth(),
                        constraints: BoxConstraints(
                          maxHeight:
                              AdaptiveSizes.getStatisticsDialogMaxHeight(),
                          minHeight:
                              AdaptiveSizes.getStatisticsDialogMinHeight(),
                        ),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.lightGreen.shade100,
                              Colors.greenAccent.shade100,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.shade100,
                              blurRadius: 20,
                              spreadRadius: 4,
                              offset: const Offset(0, 0),
                            ),
                            BoxShadow(
                              color: Colors.yellow.shade200,
                              blurRadius: 1,
                              spreadRadius: 2,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ScaleTransition(
                                  scale: _scaleAnim,
                                  child: Icon(
                                    Icons.credit_card_rounded,
                                    color: Colors.green[400],
                                    size: AdaptiveSizes.getLogoSize(),
                                  ),
                                ),
                                SizedBox(height: AdaptiveSizes.h(0.00769)),
                                Text(
                                  "cards".tr(),
                                  style: TextStyle(
                                    fontSize:
                                        AdaptiveSizes.getFontUsernameSize(),
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(1, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: AdaptiveSizes.h(0.00769)),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    color: Colors.white.withOpacity(0.09),
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          AdaptiveSizes.getStatisticsDialogMaxWidth(),
                                    ),
                                    child: Scrollbar(
                                      thumbVisibility: false,
                                      radius: const Radius.circular(20),
                                      thickness: 4,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: cards
                                              .map(
                                                (card) => cardListWidget(
                                                  cardId: card.cardId,
                                                  city: card.city,
                                                  isActive: card.isActive,
                                                  onRemove: () => _removeCard(
                                                    context,
                                                    card.cardId,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AdaptiveSizes.h(0.02538)),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      /* BoxShadow(
                                        color: Colors.lightGreen.shade100,
                                        spreadRadius: 0.2,
                                        blurRadius: 20,
                                        offset: Offset(0, 0),
                                      ), */
                                      BoxShadow(
                                        color: Colors.yellow.shade600,
                                        spreadRadius: 1.5,
                                        blurRadius: 1,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: SizedBox(
                                    width: AdaptiveSizes.getButtonWidth() / 1.4,
                                    height:
                                        AdaptiveSizes.getButtonHeight() / 1.25,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.yellow.shade200,
                                        foregroundColor: Colors.black87,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              AdaptiveSizes.getAddCardSize(),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final cardData =
                                            await AddCardDialogWidget.show(
                                              context,
                                            );

                                        if (cardData == null) return;

                                        final cardId = cardData['card_id'];
                                        final city = cardData['city'];

                                        if (cardId == null || city == null) {
                                          Flushbar(
                                            message: 'Invalid card data',
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                          ).show(context);
                                          return;
                                        }

                                        final errorCode =
                                            await AuthService.bindCard(
                                              cardId: cardId,
                                              city: city,
                                            );

                                        if (errorCode != null) {
                                          if (errorCode ==
                                              'card_already_used') {
                                            Flushbar(
                                              message:
                                                  'This card is already linked to another account.',
                                              duration: const Duration(
                                                seconds: 3,
                                              ),
                                            ).show(context);
                                          }

                                          return;
                                        }
                                        await _loadCards();
                                      },
                                      child: Text(
                                        'Add new card',
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: -10,
                              right: -10,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: widget.onClaim,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
