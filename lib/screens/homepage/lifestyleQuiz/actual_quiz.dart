import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../config/constants.dart';
import '../../../config/theme_manager.dart';
import '../../../global_widgets/custom_textfield.dart';
import '../../../global_widgets/pill_button.dart';
import '../../../global_widgets/primary_button.dart';
import '../../../global_widgets/primary_container.dart';
import '../../../global_widgets/primary_divider.dart';
import '../../../global_widgets/primary_padding.dart';
import '../../../global_widgets/primary_scaffold.dart';
import '../../../services/services_locator.dart';
import 'quiz_complete.dart';
import 'quiz_logic.dart';
import 'widgets/drinking_effects_pill.dart';
import 'widgets/question_pill.dart';

class ActualQuiz extends StatefulWidget {
  const ActualQuiz({super.key});

  @override
  State<ActualQuiz> createState() => _ActualQuizState();
}

class _ActualQuizState extends State<ActualQuiz> {
  int? selectedAnswer;
  bool addMoreSelected = false;
  bool isNoneSelected = false;

  final List<String> _drinkingEffects = [];

  final _moreController = TextEditingController();

  //add more drinking effects
  void _addDrinkingEffect() {
    if (_moreController.text.isNotEmpty && _drinkingEffects.length < 3) {
      setState(() {
        _drinkingEffects.add(_moreController.text);
        _moreController.clear();
        addMoreSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizLogic = Provider.of<QuizLogic>(context);
    final themeManager = getIt<ThemeManager>();

    return PrimaryScaffold(
      child: PrimaryPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                StepProgressIndicator(
                  totalSteps: 23,
                  currentStep: quizLogic.getQuestionIndex(),
                  size: 20,
                  padding: 0,
                  selectedColor: Colors.yellow,
                  unselectedColor: Colors.cyan,
                  roundedEdges: const Radius.circular(10),
                  selectedGradientColor: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.yellow, Colors.green],
                  ),
                  unselectedGradientColor: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.white],
                  ),
                ),
                const SizedBox(height: 20,),
                ValueListenableBuilder<Object>(
                    valueListenable: themeManager.themeMode,
                    builder: (context, theme, snapshot) {
                      return RichText(
                        text: TextSpan(
                          text: 'Question ${quizLogic.getQuestionNumber()}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: theme == ThemeMode.dark ? Colors.white : properBlack,
                          ),
                        ),
                      );
                    }),
                const Height10(),
                const PrimaryDivider(),
                const Height10(),
                Text(
                  quizLogic.getQuestion(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Height20(),
              ],
            ),
            Expanded(
              child: Center(child: _buildAnswerOptions(quizLogic)),
            ),
            const Height20(),
            Row(
              children: [
                Visibility(
                  visible: quizLogic.isNotFirstQuestion(),
                  child: Expanded(
                    child: PrimaryButton(
                      label: 'Back',
                      customBackgroundColor: Colors.grey,
                      onTap: () {
                        setState(() {
                          // quizLogic.previousQuestion();
                        });
                      },
                    ),
                  ),
                ),
                Visibility(
                    visible: quizLogic.isNotFirstQuestion(),
                    child: const Width20()),
                Expanded(
                  child: PrimaryButton(
                    label: 'Next',
                    customBackgroundColor: kSSIorange,
                    onTap: () {
                      if (!quizLogic.finish) {
                        if (quizLogic.getQuestionIndex() == 3) {
                          setState(() {
                            quizLogic.isQuestion4Answered();
                            return;
                          });
                        }
                        if (selectedAnswer != null) {
                          quizLogic.nextQuestion(selectedAnswer!);
                          setState(() {
                            selectedAnswer = null;
                          });
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizComplete(quizLogic: quizLogic,),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const Height20(),
            const Height20()
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(QuizLogic quizLogic) {
    if (quizLogic.getAnswers().length < 4) {
      return Wrap(
        spacing: 8.0,
        runSpacing: 20.0,
        children: List<Widget>.generate(
          quizLogic.getAnswers().length,
          (int index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedAnswer = index;
                });
              },
              child: PrimaryContainer(
                activeBorder: Border.all(
                  color: selectedAnswer == index ? kSSIorange : Colors.transparent,
                  width: 2.5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      quizLogic.getAnswer(index),
                    ),
                    Icon(
                      selectedAnswer == index ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: selectedAnswer == index ? kSSIorange : Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isNoneSelected = !isNoneSelected;
                      quizLogic.clearQuestion4Answers();
                      quizLogic.clearQuestion4ExtraAnswers();
                      _drinkingEffects.clear();
                      if (quizLogic.isAnswerInQuestion4(6)) {
                        quizLogic.removeAnswerFromQuestion4(6);
                      } else {
                        quizLogic.addAnswerToQuestion4(6);
                      }
                    });
                  },
                  child: QuestionPill2(
                    isNoneSelected: isNoneSelected,
                  ),
                ),
                const Width20(),
                InkWell(
                  onTap: () {
                    isNoneSelected
                        ? null
                        : setState(() {
                            if (quizLogic.isAnswerInQuestion4(0)) {
                              quizLogic.removeAnswerFromQuestion4(0);
                            } else {
                              quizLogic.addAnswerToQuestion4(0);
                            }
                          });
                  },
                  child: QuestionPill(
                    quizLogic: quizLogic,
                    index: 0,
                    selectedOptions: quizLogic.getQuestion4Answers(),
                    isNoneSelected: isNoneSelected,
                  ),
                ),
                const Width20(),
                InkWell(
                  onTap: () {
                    isNoneSelected
                        ? null
                        : setState(() {
                            if (quizLogic.isAnswerInQuestion4(1)) {
                              quizLogic.removeAnswerFromQuestion4(1);
                            } else {
                              quizLogic.addAnswerToQuestion4(1);
                            }
                          });
                  },
                  child: QuestionPill(
                    quizLogic: quizLogic,
                    index: 1,
                    selectedOptions: quizLogic.getQuestion4Answers(),
                    isNoneSelected: isNoneSelected,
                  ),
                ),
              ],
            ),
            const Height20(),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    isNoneSelected
                        ? null
                        : setState(() {
                            if (quizLogic.isAnswerInQuestion4(2)) {
                              quizLogic.removeAnswerFromQuestion4(2);
                            } else {
                              quizLogic.addAnswerToQuestion4(2);
                            }
                          });
                  },
                  child: QuestionPill(
                    quizLogic: quizLogic,
                    index: 2,
                    selectedOptions: quizLogic.getQuestion4Answers(),
                    isNoneSelected: isNoneSelected,
                  ),
                ),
                const Width20(),
                InkWell(
                  onTap: () {
                    isNoneSelected
                        ? null
                        : setState(() {
                            if (quizLogic.isAnswerInQuestion4(3)) {
                              quizLogic.removeAnswerFromQuestion4(3);
                            } else {
                              quizLogic.addAnswerToQuestion4(3);
                            }
                          });
                  },
                  child: QuestionPill(
                    quizLogic: quizLogic,
                    index: 3,
                    selectedOptions: quizLogic.getQuestion4Answers(),
                    isNoneSelected: isNoneSelected,
                  ),
                ),
              ],
            ),
            const Height20(),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    isNoneSelected
                        ? null
                        : setState(
                            () {
                              if (quizLogic.isAnswerInQuestion4(4)) {
                                quizLogic.removeAnswerFromQuestion4(4);
                              } else {
                                quizLogic.addAnswerToQuestion4(4);
                              }
                            },
                          );
                  },
                  child: QuestionPill(
                    quizLogic: quizLogic,
                    index: 4,
                    selectedOptions: quizLogic.getQuestion4Answers(),
                    isNoneSelected: isNoneSelected,
                  ),
                ),
                const Width20(),
                InkWell(
                  onTap: () {
                    isNoneSelected
                        ? null
                        : setState(() {
                            if (quizLogic.isAnswerInQuestion4(5)) {
                              quizLogic.removeAnswerFromQuestion4(5);
                            } else {
                              quizLogic.addAnswerToQuestion4(5);
                            }
                          });
                  },
                  child: QuestionPill(
                    quizLogic: quizLogic,
                    index: 5,
                    selectedOptions: quizLogic.getQuestion4Answers(),
                    isNoneSelected: isNoneSelected,
                  ),
                ),
              ],
            ),
            const Height20(),
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                runSpacing: 20,
                children: List<Widget>.generate(
                  _drinkingEffects.length,
                  (int index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: DrinkingEffectsPill(
                        index: index,
                        drinkingEffects: _drinkingEffects,
                        onTap: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 200,
                                child: PrimaryPadding(
                                  child: Column(
                                    children: [
                                      const Height20(),
                                      PrimaryButton(
                                          label: 'Edit',
                                          onTap: () async {
                                            Navigator.pop(context);
                                            editOption(index);
                                          }),
                                      const Height20(),
                                      PrimaryButton(
                                        label: 'Delete',
                                        customBackgroundColor: pinkClr,
                                        onTap: () {
                                          Navigator.pop(context);
                                          deleteOption(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: !isNoneSelected,
              child: addMoreSelected
                  ? Column(
                      children: [
                        const Height10(),
                        CustomTextField(
                          hintText: 'Enter Alcohol Effect   *only 3 maximum',
                          controller: _moreController,
                        ),
                        const Height10(),
                      ],
                    )
                  : const SizedBox(),
            ),
            const Height10(),
            Visibility(
              visible: _drinkingEffects.length < 3 && !isNoneSelected,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Add more',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Checkbox(
                        value: addMoreSelected,
                        onChanged: (value) {
                          setState(() {
                            addMoreSelected = value!;
                          });
                        },
                        activeColor: kSSIorange,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: addMoreSelected,
                    child: PillButton(
                      title: "Add Effect",
                      backgroundColor: kSSIorange,
                      onTap: () async {
                        _addDrinkingEffect();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<dynamic> editOption(int index) {
    final editController = TextEditingController(text: _drinkingEffects[index]);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C24),
          title: const Text('Edit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintText: '',
                controller: editController,
              ),
              const Height20(),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  PillButton(
                    title: "Update",
                    onTap: () {
                      setState(() {
                        _drinkingEffects[index] = editController.text;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const Width20(),
                  PillButton(
                    title: "Cancel",
                    backgroundColor: kSSIorange,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> deleteOption(int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C24),
          title: const Text('Delete Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete "${_drinkingEffects[index]}"?'),
              const Height20(),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  PillButton(
                    title: "Delete",
                    backgroundColor: pinkClr,
                    onTap: () {
                      setState(() {
                        _drinkingEffects.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const Width20(),
                  PillButton(
                    title: "Cancel",
                    backgroundColor: kSSIorange,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
