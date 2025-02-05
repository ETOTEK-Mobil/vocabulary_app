import 'package:erva_vocubulary/models/random_model.dart';

abstract class StateCard {}

class CardInitial extends StateCard {}

class CardLoading extends StateCard {}

class CardLoaded extends StateCard {
  final RandomModel card;
  final int remainingSwipes;

  CardLoaded({required this.card, required this.remainingSwipes});
}

class CardFinished extends StateCard {}

class CardError extends StateCard {
  final String message;
  CardError({required this.message});
}
