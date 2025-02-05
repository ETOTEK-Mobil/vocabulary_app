import 'package:erva_vocubulary/services/random_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'card_event.dart';
import 'card_state.dart';

class CardBloc extends Bloc<EventCard, StateCard> {
  int _swipeCount = 0;
  final int maxSwipeCount = 10;

  CardBloc() : super(CardInitial()) {
    on<LoadNextCard>((event, emit) async {
      // Eğer kartlar bittiyse ve tekrar başlatmak için butona basıldıysa
      if (state is CardFinished) {
        _swipeCount = 0; // Sayaç sıfırla
        emit(CardInitial()); // Başlangıç durumuna geç
      }

      if (_swipeCount >= maxSwipeCount) {
        emit(
            CardFinished()); // Kartlar bittiyse "Tüm kelimeleri tamamladınız!" mesajını göster
        return;
      }

      emit(CardLoading());
      try {
        final newWord = await RandomService.fetchCardInfo();

        if (newWord == null) {
          emit(CardError(message: "Yeni kelime bulunamadı."));
          return;
        }

        _swipeCount++;
        emit(CardLoaded(
            card: newWord, remainingSwipes: maxSwipeCount - _swipeCount));
      } catch (e) {
        emit(CardError(message: "Kart yüklenirken hata oluştu: $e"));
      }
    });
  }
}
