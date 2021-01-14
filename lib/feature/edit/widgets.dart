import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:provider/provider.dart';
import 'package:ontime/feature/edit/bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class BasicDateField extends StatelessWidget {
  final format = DateFormat("MM-dd");
  final DateTime _today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      child: DateTimeField(
        format: format,
        initialValue: _today,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.bodyText1,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    );
  }
}

class TimeShow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final select = Provider.of<TimeStore>(context);
    return Container(
      child: InkWell(
        onTap: () => select.showTimePicker(),
        child: Text(
          select.date.hour.toString().padLeft(2, '0') +
              ':' +
              select.date.minute.toString().padLeft(2, '0'),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class TimeField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final select = Provider.of<TimeStore>(context);
    return Visibility(
      visible: select.isShowTimePicker,
      child: TimePickerSpinner(
        spacing: 20,
        minutesInterval: 15,
        itemHeight: 40,
        onTimeChange: (time) {
          select.setDate(time);
        },
      ),
    );
  }
}