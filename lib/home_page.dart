import 'package:flutter/material.dart';
import 'package:flutter_todo_app/todo_widget.dart';

class HomePage extends StatelessWidget {
  // @override => 어노테이션
  // 코드의 메타데이터!
  // 없어도 에러는 나지 않음
  // 협업할 때, 다른개발자한테 알려주기위해서!
  // 빌드할때 (apk파일 만들 때)
  @override
  Widget build(BuildContext context) {
    List<String> titles = ["물마시기", "프로그래밍", "아침에코딩", "Q&A", "스터디"];
    return Scaffold(
      appBar: AppBar(
        title: Text("투두앱"),
        // 안드로이드, 아이폰 모두 title이 가운데 옴!
        // 기본값 : 안드로이드 - 왼쪽, 아이폰 - 가운데
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemCount: titles.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 20);
        },
        itemBuilder: (context, index) {
          return TodoWidget(title: titles[index], isDone: index % 2 == 0);
        },
      ),
      // 익명함수 => 이름이 없는 함수
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('버튼 터치됨');
        },
        backgroundColor: Color(0xff5714E6),
        shape: RoundedRectangleBorder( // 둥글기
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}
