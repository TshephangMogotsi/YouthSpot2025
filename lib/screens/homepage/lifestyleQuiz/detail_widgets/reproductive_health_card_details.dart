import 'package:flutter/material.dart';

import '../../../../global_widgets/primary_padding.dart';
import '../../../../global_widgets/primary_scaffold.dart';
import '../reproductive_health_widgets/benefits_of_smc.dart';
import '../reproductive_health_widgets/warning_card.dart';
import '../reproductive_health_widgets/where_to_get_smc.dart';

class ReproductiveHealthDetailsPage extends StatelessWidget {
  const ReproductiveHealthDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: const [
          PrimaryPadding(
            child: BenefitsofSMC(),
          ),
          SizedBox(
            height: 20,
          ),
          PrimaryPadding(
            child: WhereToGetSMC(),
          ),
          SizedBox(
            height: 20,
          ),
          PrimaryPadding(
            child: WarningCard(),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
