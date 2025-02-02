import 'package:flutter/material.dart';
import 'CategoryComponent.dart';

/*-----------------------分类影片------------------------*/
class AllCategoryListComponent extends StatefulWidget {
  final List<Map> categoryList;

  AllCategoryListComponent({super.key,required this.categoryList});

  @override
  _AllCategoryListComponentState createState() => _AllCategoryListComponentState();
}

class _AllCategoryListComponentState extends State<AllCategoryListComponent> {
  List<Map> get categoryList => categoryList;

  List<Widget> getAllCategoryList(List<Map> categoryList) {
    List<Widget> list = [];
    for (int i = 0; i < categoryList.length; i++) {
      list.add(CategoryComponent(
        category: categoryList[i]["category"],
        classify: categoryList[i]["classify"],
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: getAllCategoryList(this.categoryList)),
    );
  }
}
/*-----------------------分类影片------------------------*/