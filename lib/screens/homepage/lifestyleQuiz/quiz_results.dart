import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../db/models/medicine_model.dart';
import '../../../global_widgets/primary_button.dart';
import '../../../global_widgets/primary_divider.dart';
import '../../../global_widgets/primary_padding.dart';
import '../../../global_widgets/primary_scaffold.dart';
import 'quiz_logic.dart';
import 'widgets/alcohol_and_drugs_risk_assessment.dart';
import 'widgets/has_been_forced_into_intercourse.dart';
import 'widgets/has_reported_abuse.dart';
import 'widgets/is_circumcised.dart';
import 'widgets/is_not_arv_treatment.dart';
import 'widgets/is_not_circumcised.dart';
import 'widgets/is_not_sexually_active.dart';
import 'widgets/is_not_taking_medication_regularly.dart';
import 'widgets/knows_status_of_partners.dart';

class QuizResults extends StatefulWidget {
  const QuizResults({super.key, required this.quizLogic});

  final QuizLogic quizLogic;
  @override
  State<QuizResults> createState() => _QuizResultsState();
}

class _QuizResultsState extends State<QuizResults> {
  late List<Medicine> medication;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      child: PrimaryPadding(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const Height20(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quiz Results',
                    style: headingStyle,
                  ),
                 
                  
                ],
              ),
              const Height20(),
              const PrimaryDivider(),
              const Height20(),
              Text(
                'Alchohol and Drugs \nRisk Assessment',
                textAlign: TextAlign.center,
                style: subHeadingStyle.copyWith(fontSize: 20),
              ),
              // CURRENT SEXUAL STATUS AND RELATIONSHIPS
              const Height20(),
              AlcoholAndDrugsAssessment(widget: widget),
              const Height20(),
              Text(
                'Current Sexual Status, Relationships and Drugs',
                textAlign: TextAlign.center,
                style: subHeadingStyle.copyWith(fontSize: 20),
              ),
              widget.quizLogic.hivStatus == HIVStatus.positive &&
                      !widget.quizLogic.isOnTreatment
                  ? Column(
                      children: [
                        IsNotOnArvTreatment(widget: widget),
                        const Height20(),
                      ],
                    )
                  : Container(),
              widget.quizLogic.hivStatus == HIVStatus.positive &&
                      !widget.quizLogic.isOnTreatment
                  ? Column(
                      children: [
                        IsNotTakingMedicationRegularly(widget: widget),
                        const Height20(),
                      ],
                    )
                  : Container(),
              widget.quizLogic.hivStatus == HIVStatus.positive &&
                      !widget.quizLogic.isOnTreatment
                  ? Column(
                      children: [
                        KnowsStatusOfPartners(widget: widget),
                        const Height20(),
                      ],
                    )
                  : Container(),
              widget.quizLogic.hivStatus == HIVStatus.positive &&
                      !widget.quizLogic.isOnTreatment
                  ? Column(
                      children: [
                        IsNotSexuallyActive(widget: widget),
                        const Height20(),
                      ],
                    )
                  : Container(),
              widget.quizLogic.hasBeenForcedIntoSex ||
                      widget.quizLogic.hasGottenHelpAfterAbuse
                  ? Column(
                      children: [
                        Text(
                          'Gender Based Violence',
                          style: subHeadingStyle.copyWith(fontSize: 20),
                        ),
                        const Height20(),
                      ],
                    )
                  : Container(),
              widget.quizLogic.hasBeenForcedIntoSex
                  ? HasBeenForcedIntoIntercourse(widget: widget)
                  : Container(),
              const Height20(),
              !widget.quizLogic.hasGottenHelpAfterAbuse
                  ? HasReportedAbuse(widget: widget)
                  : Container(),
              const Height20(),
              widget.quizLogic.isCircumcised || !widget.quizLogic.isCircumcised
                  ? Text(
                      'Circumcision',
                      style: subHeadingStyle.copyWith(fontSize: 20),
                    )
                  : Container(),
              widget.quizLogic.isCircumcised
                  ? IsCircumcised(widget: widget)
                  : Container(),
              const Height20(),

              !widget.quizLogic.isCircumcised
                  ? IsCircumcised(widget: widget)
                  : IsNotCircumcised(widget: widget),
              const Height20(),
              const Height20(),
              PrimaryButton(
                label: 'Exit',
                customBackgroundColor: kSSIorange,
                onTap: () {
                  Navigator.popUntil(context, (route) {
                    return route
                        .isFirst; // Or you can check route.settings.name if you use route names
                  });
                },
              ),
              const Height20(),
            ],
          ),
        ),
      ),
    );
  }
}
