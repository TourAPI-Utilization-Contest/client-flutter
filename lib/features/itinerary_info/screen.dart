import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart'
    as drp;
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tradule/common/section.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';
import 'package:tradule/server_wrapper/data/itinerary_data.dart';

class ItineraryInfoScreen extends StatefulWidget {
  // final bool isEditing;
  // final ItineraryData? itineraryData;
  final ItineraryCubit? itineraryCubit;
  const ItineraryInfoScreen({
    super.key,
    this.itineraryCubit,
  });

  @override
  State<ItineraryInfoScreen> createState() => _ItineraryInfoScreenState();
}

class _ItineraryInfoScreenState extends State<ItineraryInfoScreen> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.itineraryCubit != null;

    if (isEditing) {
      setDateRange(DateRange(
        widget.itineraryCubit!.state!.startDate,
        widget.itineraryCubit!.state!.endDate,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: isEditing ? const Text('기존 일정 수정하기') : const Text('새 일정 만들기'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SectionLegacy(
                title: '일정 이름',
                content: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: isEditing
                        ? widget.itineraryCubit!.state!.title
                        : '새 일정 이름을 입력하세요',
                    hintText:
                        isEditing ? widget.itineraryCubit!.state!.title : null,
                  ),
                  validator: (value) {
                    if (!isEditing && (value == null || value.isEmpty)) {
                      return '일정 이름은 비워둘 수 없어요!';
                    }
                    return null;
                  },
                ),
              ),
              SectionLegacy(
                title: '여행 기간',
                content: TextFormField(
                  decoration: const InputDecoration(
                    hintText: '여기를 눌러 여행 기간을 선택하세요',
                  ),
                  readOnly: true,
                  controller: _dateController,
                  onTap: () => showDateRangePickerDialog2(
                    context: context,
                    builder: (context, onDateRangeChanged) {
                      return datePickerBuilder(
                        context,
                        setDateRange,
                        initialDateRange: _startDate != null && _endDate != null
                            ? DateRange(_startDate!, _endDate!)
                            : null,
                      );
                    },
                    barrierColor: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
              SectionLegacy(
                title: '아이콘 및 색상',
                content: IconAndColorPicker(),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (isEditing) {
                    widget.itineraryCubit!
                        .setItinerary(widget.itineraryCubit!.state!.copyWith(
                      title: _titleController.text,
                      startDate: _startDate!,
                      endDate: _endDate!,
                    ));
                  } else {
                    ServerWrapper.itineraryCubitMapCubit.addItineraryCubit(
                      ItineraryCubit(
                        ItineraryData(
                          id: 'new_id',
                          users: ['user_id'],
                          title: isEditing && _titleController.text.isEmpty
                              ? widget.itineraryCubit!.state!.title
                              : _titleController.text,
                          startDate: _startDate!,
                          endDate: _endDate!,
                          iconColor: Colors.blue,
                        ),
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                child: isEditing ? const Text('수정 완료') : const Text('일정 만들기'),
              ),
              const SizedBox(height: 8),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '돌아기기',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void setDateRange(DateRange? dateRange) {
    if (dateRange != null) {
      _dateController.text =
          '${_dateFormat.format(dateRange.start)} ~ ${_dateFormat.format(dateRange.end)}';
      _startDate = dateRange.start;
      _endDate = dateRange.end;
    }
  }

  Widget datePickerBuilder(
      BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
      {bool doubleMonth = false, DateRange? initialDateRange}) {
    return DateRangePickerWidget(
      doubleMonth: doubleMonth,
      onDateRangeChanged: onDateRangeChanged,
      initialDateRange: initialDateRange,
    );
  }
}

Future<DateRange?> showDateRangePickerDialog2({
  required BuildContext context,
  required Widget Function(BuildContext, dynamic Function(DateRange?)) builder,
  Color barrierColor = Colors.transparent,
}) {
  return showGeneralDialog(
    context: context,
    barrierLabel: 'DateRangePickerDialogBarrier',
    barrierColor: barrierColor,
    barrierDismissible: true,
    pageBuilder: (_, __, ___) {
      return Center(
        child: drp.DateRangePickerDialog(
          builder: builder,
          footerBuilder: ({selectedDateRange}) =>
              drp.DateRangePickerDialogFooter(
            selectedDateRange: selectedDateRange,
            cancelText: "취소",
            confirmText: "확인",
          ),
        ),
      );
    },
  );
}

class IconAndColorPicker extends StatefulWidget {
  @override
  _IconAndColorPickerState createState() => _IconAndColorPickerState();
}

class _IconAndColorPickerState extends State<IconAndColorPicker> {
  String selectedIcon =
      'assets/icon/travel_24dp_5F6368_FILL0_wght400_GRAD0_opsz24.svg'; // 초기 아이콘
  Color selectedColor = Colors.blue; // 초기 색상

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '아이콘을 선택하세요',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  selectedIcon =
                      'assets/icon/travel_24dp_5F6368_FILL0_wght400_GRAD0_opsz24.svg'; // 아이콘 1 선택
                });
              },
              icon: SvgPicture.asset(
                'assets/icon/travel_24dp_5F6368_FILL0_wght400_GRAD0_opsz24.svg',
                color: selectedColor,
                width: 40,
                height: 40,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  selectedIcon =
                      'assets/icon/travel_24dp_5F6368_FILL0_wght400_GRAD0_opsz24.svg'; // 아이콘 2 선택
                });
              },
              icon: SvgPicture.asset(
                'assets/icon/travel_24dp_5F6368_FILL0_wght400_GRAD0_opsz24.svg',
                // color: selectedColor,
                width: 40,
                height: 40,
              ),
            ),
            // 아이콘 추가 가능
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          '아이콘 색상을 선택하세요',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            buildColorPicker(Colors.red),
            buildColorPicker(Colors.green),
            buildColorPicker(Colors.blue),
            buildColorPicker(Colors.orange),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          '선택한 아이콘 미리보기',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SvgPicture.asset(
          selectedIcon,
          color: selectedColor,
          width: 100,
          height: 100,
        ),
      ],
    );
  }

  Widget buildColorPicker(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color; // 색상 변경
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
