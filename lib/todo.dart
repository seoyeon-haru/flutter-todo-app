// 데이터를 담는 모델 클래스
// 사용하는 이유 : Map 을 사용하게 되면 키로 데이터를 가져와야되는데
// 키가 문자열일 때 오타가 나도 개발할 때는 에러가 안남
// 대신에 실행하게 되면 에러 발생 => 런타임 에러
// 런타임 에러를 사전에 방지하기 위해서
// 클래스는 객체 내 속성 참조하거나 생성자에 값 넣어줄 때
// 속성명이 오타가 나면 VsCode에서 에러가 나서 실행조차 안됨!!! => 컴파일 에러
class Todo {
  String title;
  bool isDone;
  String Id;

  Todo({
    required this.title,
    required this.isDone,
    required this.Id,
  });
}
