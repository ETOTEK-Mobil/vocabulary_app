import 'package:erva_vocubulary/bloc.dart/Card/card_bloc.dart';
import 'package:erva_vocubulary/bloc.dart/Card/card_event.dart';
import 'package:erva_vocubulary/bloc.dart/Card/card_state.dart';
import 'package:erva_vocubulary/models/random_model.dart';
import 'package:erva_vocubulary/services/auth_service.dart';
import 'package:erva_vocubulary/ui/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class CardSwiperScreen extends StatelessWidget {
  const CardSwiperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardBloc()..add(LoadNextCard()), // İlk kartı yükle
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                final authService = AuthService();
                await authService.logout();
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<CardBloc, StateCard>(
          builder: (context, state) {
            if (state is CardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CardError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)),
              );
            } else if (state is CardFinished) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Tüm kelimeleri tamamladınız!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CardBloc>().add(LoadNextCard());
                      },
                      child: const Text("Kart Getir"),
                    ),
                  ],
                ),
              );
            } else if (state is CardLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: CardSwiper(
                      cardsCount: 1,
                      numberOfCardsDisplayed: 1,
                      onSwipe: (previousIndex, currentIndex, direction) {
                        context.read<CardBloc>().add(LoadNextCard());
                        return true;
                      },
                      cardBuilder: (context, index, percentX, percentY) {
                        return _buildCard(state.card, state.remainingSwipes);
                      },
                    ),
                  )
                ],
              );
            }

            return const Center(child: Text("Bilinmeyen bir hata oluştu."));
          },
        ),
      ),
    );
  }

  Widget _buildCard(RandomModel word, int remainingSwipes) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Word: ${word.word?.word}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text("Pronunciation: ${word.word?.pronunciation}",
                style:
                    const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Text("level: ${word.word?.level}",
                style:
                    const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Text("Meaning: ${word.word?.meaning}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text("Example: ${word.word?.example}",
                style:
                    const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
