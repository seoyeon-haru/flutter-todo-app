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
          // 차지할 수 있는 영역이 정해져 있음
          showModalBottomSheet(
            context: context,
            // 그 영역을 늘려주는 속성 => 화면 전체 사용할 수 있게 해주는 속성!
            isScrollControlled: true,
            builder: (context) {
              // 키보드 높이
              //viewInsets = 키보드위치에 대한 정보
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              print('키보드의 높이는 : $keyboardHeight');
              return Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                padding:
                    //EdgeInsets = 왼쪽, 위, 오른쪽, 아래에 대한 위치 정보를 가지고 있음
                    EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 24),
                // 키보드 영역만큼 아래 공간 띄우기
                // 컨테이너 외부에 공간 줄 때는 margin
                margin: EdgeInsets.only(bottom: keyboardHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '할일',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 11),
                    // TODO 키보드 올라와있을 때 흰색 컨테이너 터치하면 키보드 없애는거 구현하기
                    // TODO 저장 버튼 꾸미기!
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xff1414E6),
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff1414E6),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('저장'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Color(0xff5714E6),
        shape: RoundedRectangleBorder(
          // 둥글기
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
