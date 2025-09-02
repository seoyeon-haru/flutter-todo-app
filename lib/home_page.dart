import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/home_page_view_model.dart';
import 'package:flutter_todo_app/todo.dart';
import 'package:flutter_todo_app/todo_widget.dart';

// CRUD
// Create => 투두 작성
// Read => 저장된 투두리스트 불러오기
// Update => 투두 수정
// Delete =>  투두 삭제

class HomePage extends ConsumerWidget {
  // 필요한 것 : 투두 내용 (title), 완료 여부 (isDone)

  /// dynamic 은 모든 타입 다 받을 수 있을 때
  // Generic => 타입을 나중에 지정하고 싶을 때 사용
  // 여러가지 담고 싶은데 클래스는 하나만 구현하고 싶을 때

  // @override => 어노테이션
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WidgetRef ref => 리버팟 뷰모델 관리자한테 접근할 수 있게 해주는 객체!
    // 1. 상태 가지고 오기
    final homeState = ref.watch(homeViewModelProvider);
    // 2. 뷰 모델 객체 가지고오기
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text("투두앱"),
        // 안드로이드, 아이폰 모두 title이 가운데 옴!
        // 기본값 : 안드로이드 - 왼쪽, 아이폰 - 가운데
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemCount: homeState.todoList.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 20);
        },
        itemBuilder: (context, index) {
          Todo todoItem = homeState.todoList[index];
          return GestureDetector(
            onTap: () async {
              print('투두 위젯 터치됨');
              homeViewModel.updateTodo(todoItem.Id, !todoItem.isDone);
            },
            onLongPress: () async {
              print('길게 터치됨');
              final result = await showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('삭제하시겠습니까?'),
                    actions: [
                      CupertinoDialogAction(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          isDestructiveAction: true,
                          child: Text(
                            '삭제',
                          )),
                      CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            '취소',
                            style: TextStyle(color: Colors.blue),
                          )),
                    ],
                  );
                  // 정렬해주는 위젯 없으면 꽉참
                  return Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      color: Colors.amber,
                    ),
                  );
                },
              );
              print('팝업 닫힘');
              if (result == true) {
                homeViewModel.deleteTodo(todoItem.Id);
              }
            },
            child: TodoWidget(
              title: todoItem.title,
              isDone: todoItem.isDone,
            ),
          );
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

              // FIXME dispose 호출해줘야됨
              TextEditingController controller = TextEditingController();
              return GestureDetector(
                onTap: () {
                  print('컨테이너 터치됨');
                  // MaterialApp내에 아래 속성 있음
                  // context가 위치를 가지고 있고 이걸로 부모 위젯을 탐색할 수 있음
                  // 키보드 내릴 때!
                  FocusScope.of(context).unfocus();
                },
                child: Container(
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
                      TextField(
                        controller: controller,
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
                      // ElevatedButton 속성에는 크기를 정할 수 있는 속성이 없음
                      // 부모 위젯의 크기가 있다면 => 부모 위젯의 크기만큼 버튼 크기가 확장됨
                      // 부모 위젯의 크기가 없다면 => 자녀 위젯의 크기만큼 축소됨
                      SizedBox(
                        //double.infinity =>  소수 표현하는 타입 double
                        // => double(소수)이 가질 수 있는 값 중에서 가장 큰값(무한)
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          //ButtonStryle 클래스 사용하면
                          // WidgetStatePropertyAll(Colors.red)
                          // 이런 식으로 객체 하나 더 감싸줘야 해서
                          // 코드가 길어짐
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff5714E6),
                            // 버튼 내 아이콘, 텍스트 모두 적용됨
                            foregroundColor: Colors.white,
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            homeViewModel.createTodo(controller.text);
                            // 네비게이터가 관리하는 페이지를 담아놓는 컵(스택)에서 가장
                            // 위에 쌓인 페이지 꺼내기(pop)
                            Navigator.pop(context);
                          },
                          child: Text('저장'),
                        ),
                      ),
                    ],
                  ),
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
