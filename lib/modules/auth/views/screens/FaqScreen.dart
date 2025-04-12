import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ---------------------------
// Model
class FaqModel {
  final String question;
  final String answer;
  bool isExpanded;

  FaqModel({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

// ---------------------------
// Cubit (BLoC)
class FaqCubit extends Cubit<List<FaqModel>> {
  FaqCubit() : super(_faqData);

  static final List<FaqModel> _faqData = [
    FaqModel(
      question: "Who can use this app?",
      answer:
          "Parents or any family members can use this app, sit with their child and make the child improve their speaking ability step by step. If the child is not talking age appropriately due to reasons such as Autism, Deafness, ADHD, ADD, hearing impairment, behavioural issues, down syndrome etc, this app will be helpful.",
    ),
    FaqModel(
      question: "What are the prerequisites for the parent to use the app?",
      answer: "JA parent with basic knowledge of mobile can use this app. The most important quality needed for the parent is patience. The process is a long journey, and parents need to be disciplined and patient. The rewards",
    ),
    FaqModel(
      question: "Are you replacing traditional methods of speech therapy?",
      answer: "No, traditional methods are the best ways to give therapy. This will augment and complement the traditional method and improve the speech development faster",
    ),
    FaqModel(
      question: "My child is normal, still should I use this app?",
      answer: "Yes, the app can help improve general communication and language development in all children.",
    ),
    FaqModel(
      question: "Can I take the Online Speech therapy from The Dhwani?",
      answer: "Yes, we provide Online Speech Therapy. We recommend that a combination of Online Speech Therapy and the activity module of the app will provide the best outcome for the child.",
    ),
    FaqModel(
      question: "Don’t you think using a mobile to teach a child is harmful?",
      answer: "Using a mobile for a small period of time for intensive interaction (both ways of communication) along with the involvement of parents will be helpful. It is recommended to use a tablet for the same.",
    ),
    FaqModel(
      question: "My child is having a stuttering or voice disorder or misarticulation, can I use the app?",
      answer: "No, currently the app is only for Delayed Speech and Language.",
    ),
    FaqModel(
      question: "Where is your offline center?",
      answer: "We only have 1 offline center in Bhubaneswar, Odisha.",
    ),
  ];

  void toggle(int index) {
    final newList = [...state];
    for (int i = 0; i < newList.length; i++) {
      newList[i].isExpanded = i == index ? !newList[i].isExpanded : false;
    }
    emit(newList);
  }
}



class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FaqCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F7),
        appBar: AppBar(
          title: const Text(
            "FAQs",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          foregroundColor: Colors.black,
        ),
        body: BlocBuilder<FaqCubit, List<FaqModel>>(
          builder: (context, faqs) {
            return ListView.separated(
              itemCount: faqs.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = faqs[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.read<FaqCubit>().toggle(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.question,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E1E1E),
                                  ),
                                ),
                              ),
                              AnimatedRotation(
                                duration: const Duration(milliseconds: 300),
                                turns: item.isExpanded ? 0.5 : 0,
                                child: const Icon(
                                  Icons.expand_more,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                item.answer,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4A4A4A),
                                  height: 1.6,
                                ),
                              ),
                            ),
                            crossFadeState: item.isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
