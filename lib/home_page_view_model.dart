import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/todo.dart';

// 1. 상태 클래스 만들기
class HomeState {
  List<Todo> todoList;
  HomeState(this.todoList);
}

// 2. 로직을 담는 뷰모델 만들기 => 상태 클래스 객체하해서 가지고 있음, 상태 업데이트 하는 로직
class HomeViewModel extends Notifier<HomeState> {
  // 이 뷰모델이 관리하는 최초 상태를 반환! => 여기서는 빈 리스트
  // 뷰 모델이 생성될 때 최초 한번만 실행 => initState 에서 사용하던 데이터 불러오는 함수 호출 여기서 해줘도 됨
  @override
  HomeState build() {
    loadTodoList();
    return HomeState([]);
  }

  // 로직 작성
  // 1) todo리스트 불러오기
  /// todos 컬렉션의 모든 투두 데이터 가지고 오는 함수
  void loadTodoList() async {
    // 1. Firestore 인스턴스 (객체)
    final firestore = FirebaseFirestore.instance;
    // 2. 1번에서 만든 객체로 컬렉션 참조 만들어주기
    final colRef = firestore.collection('todos');
    // 3. 2번에서 만든 컬렉션 참조로 모든 데이터 불러오기
    final result = await colRef.get();
    final documentList = result.docs;

    List<Todo> newTodoList = [];
    for (var i = 0; i < documentList.length; i++) {
      final document = documentList[i];
      print(document.id);

      /// QueryDocumentSnapshot 이라는 객체 내 data() 함수 호출해주면
      /// 우리가 원하는 진짜 데이터 반환해줌!
      final realData = document.data();
      Todo todo = Todo(
          Id: document.id,
          title: realData['title'],
          isDone: realData['isDone']);
      newTodoList.add(todo);
    }
    // 뷰 모델에서 setState의 역할을 함
    // state에 새로운 객체 생성
    state = HomeState(newTodoList);
    // 이거 안됨 : 반드시 새로운 객체를 할당해줘야 함
    // state.todoList = newTodoList;
    // setState(() {
    //   todoList = newTodoList;
    // });
  }

  // 2) todo 생성
  void createTodo(String text) async {
    // 1. Firestore 인스턴스 가져오기
    final firestore = FirebaseFirestore.instance;
    // 2. 어떤 컬렉션에 저장할지 설정하는 컬렉션 참조 만들기
    final colRef = firestore.collection('todos');
    // 3. 어떤 문서를 저장할지 설정하는 문서 참조
    final docRef = colRef.doc();
    await docRef.set({
      'title': text,
      'isDone': false,
    });
    loadTodoList();
  }

  // 3) todo 삭제
  void deleteTodo(String id) async {
    // 1. 파이어스토어 인스턴스 가져오기
    final firestore = FirebaseFirestore.instance;
    // 2. 컬렉션 참조 만들기
    final colRef = firestore.collection('todos');
    // 3. 문서 참조 만들기
    final docRef = colRef.doc(id);
    // 4. 삭제
    await docRef.delete();
    // 데이터 새로고침
    loadTodoList();
  }

  // 4) todo 수정
  void updateTodo(String id, bool nextIsDone) async {
    // 1. 파이어베이스 콘솔에서 파이어 스토어 클릭하기 => Firestore 인스턴스 가져오기
    final firestore = FirebaseFirestore.instance;
    // 2. 어떤 컬렉션 안의 문서 수정할지 선택하기 위해서 컬렉션 클릭하기 => 컬렉션 참조 만들기
    final colRef = firestore.collection('todos');
    // 3. 수정할 문서 클릭 => 문서 참조 만들기
    final docRef = colRef.doc(id);
    // 4. 수정 => 문서 참조 객체 이용해서 update 함수 호출
    await docRef.update({'isDone': nextIsDone});
    // 데이터 새로고침
    loadTodoList();
  }
}

// 3. 뷰모델을 공급해주는 관리자 만들어줘야함
// 리버팟에서 뷰모델들의 생성은 리버팟 내부적으로 해주게 구현되어있음!
final homeViewModelProvider = NotifierProvider<HomeViewModel,HomeState>(() {
  return HomeViewModel();
},);
