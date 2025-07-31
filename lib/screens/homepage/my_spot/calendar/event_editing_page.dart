import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../db/models/event_model.dart';
import '../../../../global_widgets/custom_app_bar.dart';
import '../../../../global_widgets/pill_button.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../../../../providers/event_provider.dart';
import '../../../../services/notifications_helper.dart';
import '../../../../services/services_locator.dart';
import '../config/utils.dart';
import 'text_field_time_picker.dart';

class EventEditingPage extends StatefulWidget {
  const EventEditingPage({super.key, this.event});
  final Event? event;

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isAllDayEvent = false;

  @override
  void initState() {
    super.initState();

    final event = widget.event;
    if (event == null) {
      fromDate = DateTime.now();
      toDate = fromDate.add(const Duration(hours: 2));
    } else {
      _titleController.text = event.title;
      _descriptionController.text = event.description;
      isAllDayEvent = event.isAllDay;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    final backgroundColor = themeManager.themeMode.value == ThemeMode.dark
        ? darkmodeLight
        : backgroundColorLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          context: context,
          isHomePage: false,
        ),
      ),
      body: SingleChildScrollView(
        child: PrimaryPadding(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title*', style: formFieldTitle),
                const Height10(),
                buildTextField(
                  controller: _titleController,
                  hintText: 'Add Title',
                  validator: (title) =>
                      title?.isEmpty ?? true ? 'Title cannot be empty' : null,
                ),
                const Height20(),
                buildDateTimePickerRow(
                  label: 'From',
                  date: fromDate,
                  onDateTap: () => pickFromDateTime(pickDate: true),
                  onTimeTap: () => pickFromDateTime(pickDate: false),
                ),
                const Height20(),
                buildDateTimePickerRow(
                  label: 'To',
                  date: toDate,
                  onDateTap: () => pickToDateTime(pickDate: true),
                  onTimeTap: () => pickToDateTime(pickDate: false),
                ),
                const Height10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isAllDayEvent,
                      onChanged: (value) {
                        setState(() => isAllDayEvent = value ?? false);
                      },
                      activeColor: kSSIorange,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                    const Width10(),
                    Text('Is All Day Event', style: subTitleStyle),
                  ],
                ),
                const Height10(),
                   Text('Description*', style: formFieldTitle),
                const Height10(),
                buildTextField(
                  controller: _descriptionController,
                  hintText: 'Add description',
                  maxLines: 3,
                  validator: (description) => description?.isEmpty ?? true
                      ? 'Description cannot be empty'
                      : null,
                ),
                const Height20(),
                PillButton(
                  icon: Icons.add,
                  title: "Save",
                  backgroundColor: kSSIorange,
                  onTap: saveForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<EventProvider>(context, listen: false);
    final isEditing = widget.event != null;

    final notificationId = widget.event?.notificationId ??
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    final event = Event(
      title: _titleController.text,
      description: _descriptionController.text,
      from: fromDate,
      to: toDate,
      isAllDay: isAllDayEvent,
      notificationId: notificationId,
    );

    final notificationDescription =
        NotificationUtils.formatEventTime(fromDate, toDate);

    // Schedule notification with error handling
    try {
      await NotificationService.scheduleNotification(
        notificationId: notificationId,
        title: event.title,
        body: notificationDescription,
        scheduledDate: event.from,
      );
    } catch (e) {
      // Log the error but don't prevent event creation
      debugPrint('Failed to schedule notification: $e');
    }

    if (isEditing) {
      try {
        await AwesomeNotifications().cancel(widget.event!.notificationId!);
      } catch (e) {
        debugPrint('Failed to cancel previous notification: $e');
      }
      await provider.editEvent(event, widget.event!);
    } else {
      await provider.addEvent(event);
    }

    Navigator.of(context).pop();
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate = date.copyWith(hour: toDate.hour, minute: toDate.minute);
    }

    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date =
        await pickDateTime(toDate, pickDate: pickDate, firstDate: fromDate);
    if (date == null) return;

    if (date.isBefore(fromDate)) return;

    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
      if (date == null) return null;
      return date.copyWith(hour: initialDate.hour, minute: initialDate.minute);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;
      return initialDate.copyWith(
          hour: timeOfDay.hour, minute: timeOfDay.minute);
    }
  }
}
