import 'package:flutter/foundation.dart';
import 'quiz.dart';
import 'quiz_data.dart';

// Enums for various states
enum HIVStatus { positive, negative, unknown }
enum FrequencyOfUseOfCondomWithPartner { everytime, sometimes, never }
enum SectionOneResults { congrats, reduceIntake, setReductionGoal }

class QuizLogic extends ChangeNotifier {
  int _questionNumber = 0;
  List<int> question4Answers = [];
  List<int> question4ExtraAnswers = [];

  int _alcoholAndDrugsPoints = 0;
  int _sexualStatusAndRelationshipsPoints = 0;
  int _gbvRelated = 0;

  // Sexual status and relationships
  bool hasTestedInForHIVLastYear = false;
  HIVStatus hivStatus = HIVStatus.unknown;
  bool isOnTreatment = false;
  bool isTakingMedicationRegularly = false;
  bool hasEverBeenSexuallyActive = false;
  bool hasHadSexInLast3Months = false;
  bool hasHadMoreThanOnePartnerAtTheSameTime = false;
  bool hasParticipatedInSexParty = false;
  bool hasAnyPartnerBeenBlesserBaes = false;
  bool hasHadSexWithoutCondom = false;
  FrequencyOfUseOfCondomWithPartner condomUseWithPartner = FrequencyOfUseOfCondomWithPartner.never;
  bool isUsingContraceptives = false;
  bool knowsStatusOfPartners = false;
  bool hasBeenForcedIntoSex = false;
  bool isPartnerControlling = false;
  bool hasEverBeenAbusedByPartner = false;
  bool hasGottenHelpAfterAbuse = false;
  bool isCircumcised = false;
  bool finish = false;

  final List<QuizQuestion> quizData = QuizData.questions;

  String getQuestion() => quizData[_questionNumber].question;

  void addAnswerToQuestion4(int answer) {
    question4Answers.add(answer);
    notifyListeners();
  }

  void removeAnswerFromQuestion4(int answer) {
    question4Answers.remove(answer);
    notifyListeners();
  }

  bool isAnswerInQuestion4(int answer) => question4Answers.contains(answer);

  void clearQuestion4Answers() {
    question4Answers.clear();
    notifyListeners();
  }

  void clearQuestion4ExtraAnswers() {
    question4ExtraAnswers.clear();
    notifyListeners();
  }

  List<int> getQuestion4Answers() => question4Answers;

  List<String> getAnswers() => quizData[_questionNumber].answers;

  String getAnswer(int index) => quizData[_questionNumber].answers[index];

  bool isNotFirstQuestion() => _questionNumber != 0;

  void finishQuiz() {
    finish = true;
    notifyListeners();
  }

  bool isFinished() => _questionNumber == quizData.length;

  String getQuestionNumber() => (_questionNumber + 1).toString();

  int getQuestionNumberAsInt() => _questionNumber + 1;

  int getQuestionIndex() => _questionNumber;

  void isQuestion4Answered() {
    if (question4Answers.isNotEmpty || question4ExtraAnswers.isNotEmpty) {
      _alcoholAndDrugsPoints += question4Answers.length * 5;
      _questionNumber = 4;
      notifyListeners();
    }
  }

void nextQuestion(int? choiceNumber) {
    print('Current question number: $_questionNumber');
    print('Choice number: $choiceNumber');

    switch (_questionNumber) {
      case 0:
        _alcoholAndDrugsPoints += choiceNumber == 0 ? 5 : 0;
        _questionNumber = choiceNumber == 0 ? 1 : 4;
        break;
      case 1:
      case 2:
      case 4:
      case 7:
      case 8:
        _alcoholAndDrugsPoints += choiceNumber == 0 ? 10 : 0;
        _questionNumber += 1;
        break;
      case 5:
        hasTestedInForHIVLastYear = choiceNumber == 0;
        _sexualStatusAndRelationshipsPoints += choiceNumber == 1 ? 10 : 0;
        _questionNumber = 6;
        break;
      case 6:
        hivStatus = HIVStatus.values[choiceNumber!];
        _sexualStatusAndRelationshipsPoints += choiceNumber == 2 ? 10 : 0;
        _questionNumber = choiceNumber == 1 ? 7 : 9;
        break;
      case 9:
        hasEverBeenSexuallyActive = choiceNumber == 0;
        _sexualStatusAndRelationshipsPoints += _sexualStatusAndRelationshipsPoints >= 20 ? 10 : 0;
        _questionNumber = choiceNumber == 0 ? 10 : 22;
        if (choiceNumber == 1) {
          finishQuiz();  // Finish the quiz if the answer is "No"
        }
        break;
      case 10:
        hasHadSexInLast3Months = choiceNumber == 0;
        _sexualStatusAndRelationshipsPoints += _sexualStatusAndRelationshipsPoints >= 30 ? 10 : 0;
        _questionNumber = choiceNumber == 0 ? 11 : 18;
        break;
      case 11:
      case 12:
        _sexualStatusAndRelationshipsPoints += choiceNumber == 0 ? 10 : 0;
        _questionNumber += 1;
        break;
      case 13:
        hasAnyPartnerBeenBlesserBaes = choiceNumber == 0;
        _sexualStatusAndRelationshipsPoints += choiceNumber == 0 ? 10 : 0;
        _questionNumber = 14;
        break;
      case 14:
        hasHadSexWithoutCondom = choiceNumber == 0;
        _sexualStatusAndRelationshipsPoints += choiceNumber == 0 ? 10 : 0;
        _questionNumber = 15;
        break;
      case 15:
        condomUseWithPartner = FrequencyOfUseOfCondomWithPartner.values[choiceNumber!];
        _sexualStatusAndRelationshipsPoints += choiceNumber == 1 ? 10 : choiceNumber == 2 ? 30 : 0;
        _questionNumber = 16;
        break;
      case 16:
        isUsingContraceptives = choiceNumber == 0;
        _sexualStatusAndRelationshipsPoints += choiceNumber == 1 ? 10 : 0;
        _questionNumber = 17;
        break;
      case 17:
        knowsStatusOfPartners = choiceNumber == 0;
        _sexualStatusAndRelationshipsPoints += choiceNumber == 1 ? 20 : 0;
        _questionNumber = 18;
        break;
      case 18:
        hasBeenForcedIntoSex = choiceNumber == 0;
        _gbvRelated += choiceNumber == 0 ? 10 : 0;
        _questionNumber = 19;
        break;
      case 19:
        isPartnerControlling = choiceNumber == 0;
        _gbvRelated += choiceNumber == 0 ? 10 : 0;
        _questionNumber = 20;
        break;
      case 20:
        hasEverBeenAbusedByPartner = choiceNumber == 0;
        _gbvRelated += choiceNumber == 0 ? 20 : 0;
        _questionNumber = 21;
        break;
      case 21:
        hasGottenHelpAfterAbuse = choiceNumber == 0;
        _gbvRelated += choiceNumber == 0 ? 20 : 0;
        finishQuiz();
        _questionNumber = 22;
        break;
      case 22:
        isCircumcised = choiceNumber == 0;
        finishQuiz();
        break;
      default:
        _questionNumber += 1;
        if (_questionNumber >= quizData.length) {
          finishQuiz();
        }
        notifyListeners();
        return;
    }

    notifyListeners();
  }
  String sectionOneResults() {
    if (_alcoholAndDrugsPoints <= 10) {
      return "Congratulations! You are doing well. Keep it up!";
    }
    if (_alcoholAndDrugsPoints <= 30) return "Consider reducing your intake";
    return "Consider setting a goal to reduce intake";
  }

  SectionOneResults displayAnimation() {
    if (_alcoholAndDrugsPoints <= 10) return SectionOneResults.congrats;
    if (_alcoholAndDrugsPoints <= 30) return SectionOneResults.reduceIntake;
    return SectionOneResults.setReductionGoal;
  }

  bool getRequiresAction(int points, {int low = 10, int high = 30}) {
    return points > low;
  }

  String getRiskRating(int points, {int low = 10, int high = 30}) {
    if (points <= low) return "Low";
    if (points <= high) return "Moderate";
    return "High";
  }

  String getHeadline(int points, String lowMessage, String moderateMessage, String highMessage, {int low = 10, int high = 30}) {
    if (points <= low) return lowMessage;
    if (points <= high) return moderateMessage;
    return highMessage;
  }

  String getRiskMessage(int points, String lowMessage, String moderateMessage, String highMessage, {int low = 10, int high = 30}) {
    if (points <= low) return lowMessage;
    if (points <= high) return moderateMessage;
    return highMessage;
  }

  String getTrailingMessage(int points, String lowMessage, String moderateMessage, String highMessage, {int low = 10, int high = 30}) {
    if (points <= low) return lowMessage;
    if (points <= high) return moderateMessage;
    return highMessage;
  }

  // Alcohol and Drugs Section
  bool getAlcoholSectionRequiresAction() => getRequiresAction(_alcoholAndDrugsPoints);

  String getAlcoholSectionRiskRating() => getRiskRating(_alcoholAndDrugsPoints);

  String getAlcoholSectionHeadline() => getHeadline(
    _alcoholAndDrugsPoints,
    "Your relationship with alcohol is currently low-risk.",
    "Your answers suggest a moderate risk in your relationship with alcohol.",
    "Your responses indicate a high risk in your relationship with alcohol."
  );

  String getAlcoholSectionRiskMessage() => getRiskMessage(
    _alcoholAndDrugsPoints,
    "Continue to enjoy responsibly and stay mindful of your consumption. Remember, moderation is key to maintaining good health.",
    "It's important to be aware of your drinking habits and consider reducing your intake. Seeking advice from a healthcare professional can be beneficial.",
    "This could have serious implications for your health and well-being. Please seek help from a healthcare professional or a support group to address this issue as soon as possible."
  );

  String getAlcoholSectionTrailingMessage() => getTrailingMessage(
    _alcoholAndDrugsPoints,
    "You're doing great! Continue to monitor your habits to maintain a healthy lifestyle.",
    "Consider setting a goal to reduce your alcohol intake. Small steps can lead to big changes.",
    "Setting a goal to reduce your intake is crucial. Seek professional help to support your journey."
  );

  // Health Status and Relationships Section
  bool getHealthStatusRequiresAction() => getRequiresAction(_sexualStatusAndRelationshipsPoints);

  String getHealthStatusRiskRating() => getRiskRating(_sexualStatusAndRelationshipsPoints);

  String getHealthStatusHeadline() => getHeadline(
    _sexualStatusAndRelationshipsPoints,
    hivStatus == HIVStatus.unknown ? "It's important to know your HIV status." : "You are practicing safe behaviors and maintaining open communication with your partner.",
    "It's important to discuss health statuses with your partner and encourage regular testing.",
    "This could have serious implications for your health and well-being."
  );

  String getHealthStatusRiskMessage() => getRiskMessage(
    _sexualStatusAndRelationshipsPoints,
    hivStatus == HIVStatus.unknown ? "Knowing your HIV status is crucial for your health and the health of your partner. Please get tested to ensure you can take appropriate steps if necessary." : "Continue these practices to ensure ongoing health and safety.",
    "Adhering to prescribed treatments and staying informed can help reduce risks.",
    "Please seek help from a healthcare professional to discuss treatment options and ensure open communication with your partner for mutual protection and support."
  );

  String getHealthStatusTrailingMessage() => getTrailingMessage(
    _sexualStatusAndRelationshipsPoints,
    hivStatus == HIVStatus.unknown ? "Click the button below to view health recommendations." : "Great job! Have a look below for more on health",
    "Consider setting a goal to discuss health statuses regularly with your partner.",
    "Setting a goal to ensure open communication and regular testing is crucial. Seek professional help for support."
  );

  // GBV Section
  String getGBVStatusRiskRating() => getRiskRating(_gbvRelated);

  String getGBVStatusHeadline() => getHeadline(
    _gbvRelated,
    "You are at low risk of gender-based violence",
    "Your responses suggest a moderate risk of experiencing gender-based violence",
    "Your responses indicate a high risk of experiencing gender-based violence"
  );

  String getGBVStatusRiskMessage() => getRiskMessage(
    _gbvRelated,
    "You appear to be in a safe environment where respectful and equal interactions are the norm. It's important to continue fostering these positive relationships.",
    "There are some signs that you may be in situations or relationships that could become unsafe. It's crucial to be aware of your surroundings and the behavior of those around you.",
    "This is a serious concern and immediate action is necessary to ensure your safety. It's vital to seek support and take steps to protect yourself from potential harm."
  );

  String getGBVStatusTrailingMessage() => getTrailingMessage(
    _gbvRelated,
    "Stay vigilant and maintain open communication with trusted individuals.",
    "Consider reaching out to a trusted friend, family member, or professional to discuss your concerns and develop strategies to protect yourself.",
    "Contact a healthcare professional, support group, or local organization specializing in gender-based violence. Prioritize your safety and well-being and do not hesitate to seek help."
  );

  // Reproductive Health Section
  String getReproductiveHealthStatus() => isCircumcised ? "Circumcised" : "Uncircumcised";

  String getReproductiveHealthMessage() => isCircumcised
    ? "Being circumcised can reduce the risk of certain infections. Maintain good hygiene practices."
    : "Being uncircumcised requires diligent hygiene practices to reduce the risk of infections.";

  String getReproductiveHealthTrailingMessage() => isCircumcised
    ? "Continue to practice good hygiene to ensure ongoing health."
    : "Consider discussing with a healthcare professional about best hygiene practices.";

  bool getReproductiveHealthRequiresAction() => !isCircumcised;

  // Reset quiz to initial state for retaking
  void resetQuiz() {
    _questionNumber = 0;
    question4Answers.clear();
    question4ExtraAnswers.clear();
    
    _alcoholAndDrugsPoints = 0;
    _sexualStatusAndRelationshipsPoints = 0;
    _gbvRelated = 0;
    
    // Reset all boolean flags to their initial states
    hasTestedInForHIVLastYear = false;
    hivStatus = HIVStatus.unknown;
    isOnTreatment = false;
    isTakingMedicationRegularly = false;
    hasEverBeenSexuallyActive = false;
    hasHadSexInLast3Months = false;
    hasHadMoreThanOnePartnerAtTheSameTime = false;
    hasParticipatedInSexParty = false;
    hasAnyPartnerBeenBlesserBaes = false;
    hasHadSexWithoutCondom = false;
    condomUseWithPartner = FrequencyOfUseOfCondomWithPartner.never;
    isUsingContraceptives = false;
    knowsStatusOfPartners = false;
    hasBeenForcedIntoSex = false;
    isPartnerControlling = false;
    hasEverBeenAbusedByPartner = false;
    hasGottenHelpAfterAbuse = false;
    isCircumcised = false;
    finish = false;
    
    notifyListeners();
  }
}

