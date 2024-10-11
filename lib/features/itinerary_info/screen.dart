import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart'
    as drp;
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradule/common/app_bar_blur.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/my_text_field.dart';
import 'package:tradule/common/my_text_style.dart';

import 'package:tradule/common/section.dart';
import 'package:tradule/common/single_child_scroll_fade_view.dart';
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
  final ScrollController _scrollController = ScrollController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  String _selectedIcon = '';
  Color _selectedColor = cAqua;

  var iconList = const [
    'assets/icon/기본.svg',
    'assets/icon/나침반.svg',
    'assets/icon/맛집.svg',
    'assets/icon/게임.svg',
    'assets/icon/비행기.svg',
    'assets/icon/휴식.svg',
  ];
  var iconColorList = const [
    Color(0xFFE20F0F),
    Color(0xFFFFA63D),
    Color(0xFFFEE500),
    Color(0xFF09AB19),
    Color(0xFF0ED2F7),
    Color(0xFFFB90CA),
  ];

  @override
  void initState() {
    super.initState();
    bool isEditing = widget.itineraryCubit != null;

    if (isEditing) {
      _selectedIcon = widget.itineraryCubit!.state.iconPath ?? '';
      _selectedColor = widget.itineraryCubit!.state.iconColor;
    } else {
      _selectedIcon = iconList[Random().nextInt(iconList.length)];
      _selectedColor = iconColorList[Random().nextInt(iconColorList.length)];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.itineraryCubit != null;

    if (isEditing) {
      setDateRange(DateRange(
        widget.itineraryCubit!.state.startDate,
        widget.itineraryCubit!.state.endDate,
      ));
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: isEditing ? const Text('기존 일정 수정하기') : const Text('새 일정 만들기'),
      // ),
      appBar: AppBarBlur(
        title: isEditing ? const Text('기존 일정 수정하기') : const Text('새 일정 만들기'),
        scrollController: _scrollController,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        clipBehavior: Clip.none,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 20,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Text('일정 이름',
                      style: myTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                  MyTextFormField(
                    controller: _titleController,
                    // decoration: InputDecoration(
                    // ),
                    labelText: isEditing
                        ? widget.itineraryCubit!.state.title
                        : '새 일정 이름을 입력하세요',
                    hintText:
                        isEditing ? widget.itineraryCubit!.state.title : null,
                    // decoration: InputDecoration(
                    //   labelText: isEditing
                    //       ? widget.itineraryCubit!.state!.title
                    //       : '새 일정 이름을 입력하세요',
                    //   hintText:
                    //       isEditing ? widget.itineraryCubit!.state!.title : null,
                    // ),
                    validator: (value) {
                      if (!isEditing && (value == null || value.isEmpty)) {
                        return '일정 이름은 비워둘 수 없어요!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Text('아이콘',
                      style: myTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: iconList.length,
                      itemBuilder: (context, index) {
                        // index -= 1;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Material(
                                  color: _selectedIcon == iconList[index]
                                      ? _selectedColor
                                      : Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedIcon = iconList[index];
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      iconList[index],
                                      colorFilter: ColorFilter.mode(
                                        _selectedIcon == iconList[index]
                                            ? Colors.white
                                            : cGray3,
                                        BlendMode.srcIn,
                                      ),
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Material(
                                  color: _selectedColor == iconColorList[index]
                                      ? _selectedColor
                                      : Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedColor = iconColorList[index];
                                      });
                                    },
                                    child: Center(
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _selectedColor ==
                                                  iconColorList[index]
                                              ? Colors.white
                                              : iconColorList[index], // 색상 설정
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Row(
                    spacing: 28,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '여행 기간',
                        style: myTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '총 ${(_endDate?.difference(_startDate!).inDays ?? -1) + 1}일간',
                        style: myTextStyle(
                          color: Theme.of(context).primaryColor,
                          height: 1,
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
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
                          initialDateRange:
                              _startDate != null && _endDate != null
                                  ? DateRange(_startDate!, _endDate!)
                                  : null,
                        );
                      },
                      barrierColor: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                spacing: 8,
                children: [
                  Flexible(
                    flex: 3,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '돌아기기',
                        style: TextStyle(color: cGray3),
                      ),
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                          const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isEditing) {
                          widget.itineraryCubit!.setItinerary(
                              widget.itineraryCubit!.state.copyWith(
                            title: _titleController.text.isEmpty
                                ? widget.itineraryCubit!.state.title
                                : _titleController.text,
                            startDate: _startDate!,
                            endDate: _endDate!,
                            iconColor: _selectedColor,
                            iconPath: _selectedIcon,
                          ));
                          ServerWrapper.putSchedule(widget.itineraryCubit!);
                        } else {
                          var itineraryCubit = ItineraryCubit(
                            ItineraryData(
                              id: Random().nextInt(1000),
                              users: [ServerWrapper.userCubit.state!.id],
                              title: isEditing && _titleController.text.isEmpty
                                  ? widget.itineraryCubit!.state.title
                                  : _titleController.text,
                              startDate: _startDate!,
                              endDate: _endDate!,
                              iconColor: _selectedColor,
                              iconPath: _selectedIcon,
                            ),
                          );
                          ServerWrapper.itineraryCubitMapCubit
                              .addItineraryCubit(itineraryCubit);
                          ServerWrapper.postSchedule(itineraryCubit);
                        }
                        Navigator.pop(context);
                      },
                      // child: isEditing ? const Text('수정 완료') : const Text('일정 만들기'),
                      child: Text(isEditing ? '저장하기' : '일정 만들기',
                          style: myTextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).primaryColor,
                        ),
                        minimumSize: WidgetStateProperty.all(
                          const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 일정 삭제
              if (isEditing)
                TextButton(
                  onPressed: () {
                    ServerWrapper.itineraryCubitMapCubit
                        .removeItineraryCubit(widget.itineraryCubit!);
                    ServerWrapper.deleteSchedule(widget.itineraryCubit!);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '일정 삭제하기',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                      const Size(double.infinity, 50),
                    ),
                    overlayColor: WidgetStateProperty.all(
                      Colors.red.withAlpha(10),
                    ),
                  ),
                ),
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
      setState(() {});
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
