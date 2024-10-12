import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tradule/common/app_bar_blur.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/my_text_field.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';
import 'package:tradule/common/tag_filter_button.dart';

class MyPlaceScreen extends StatefulWidget {
  const MyPlaceScreen({super.key});

  @override
  State<MyPlaceScreen> createState() => _MyPlaceScreenState();
}

class _MyPlaceScreenState extends State<MyPlaceScreen> {
  // final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _selectedProvidedPlace = false;
  bool _selectedMyPlace = false;
  bool _selectedAllPlace = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 장소'),
        // scrollController: _scrollController,
        // clipper: const InvertedCornerClipper(arcRadius: 10),
        // preferredSize: const Size.fromHeight(kToolbarHeight + 10),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: <Widget>[
              MyTextField(
                controller: _searchController,
                hintText: '장소 이름, 태그로 검색',
                onSubmitted: (value) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: <Widget>[
                  TagFilterButton(
                    text: '전체',
                    badgeText: '10',
                    isSelected: _selectedAllPlace,
                    onPressed: () {
                      setState(() {
                        _selectedAllPlace = true;
                        _selectedProvidedPlace = false;
                        _selectedMyPlace = false;
                      });
                    },
                  ),
                  TagFilterButton(
                    text: '관심 장소',
                    isSelected: _selectedProvidedPlace,
                    onPressed: () {
                      setState(() {
                        _selectedAllPlace = false;
                        _selectedProvidedPlace = !_selectedProvidedPlace;
                        if (!_selectedProvidedPlace && !_selectedMyPlace) {
                          _selectedAllPlace = true;
                        }
                      });
                    },
                  ),
                  TagFilterButton(
                    text: '내 장소',
                    isSelected: _selectedMyPlace,
                    onPressed: () {
                      setState(() {
                        _selectedAllPlace = false;
                        _selectedMyPlace = !_selectedMyPlace;
                        if (!_selectedProvidedPlace && !_selectedMyPlace) {
                          _selectedAllPlace = true;
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
