import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  // @override => 어노테이션
  // 코드의 메타데이터!
  // 없어도 에러는 나지 않음
  // 협업할 때 다른 개발자에게 알려주기 위해서!
  // 빌드할 때 (apk파일 만들 때)

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('투두앱'),
        // 안드로이드, 아이폰 모드 title이 가운데 옴
        // 기본값: 안드로이드 - 왼쪽, 아이폰 - 가운데
        // centerTitle: true,
      ),
    );
  }
}
