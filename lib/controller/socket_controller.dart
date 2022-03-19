import 'dart:io';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:liar_getx/controller/game_controller.dart';

// 소켓에 관련된 클래스
class SocketController extends GetxController {
  late ServerSocket serverSocket;
  List<Socket> clientSocket = [];
  int port = 8888; // 포트 수동 설정

  // Server Socket 열기
  Future<void> startServer() async
  {
    GameController gameController = Get.find<GameController>();
    Get.snackbar('System Msg', "방생성 완료", snackPosition: SnackPosition.BOTTOM);

    gameController.onChangeRoom();
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port, shared: true); // shared를 true 해줌으로써 iterative 서버가 생성
    serverSocket.listen(handleClient); // client가 connection 요청을 할 때, 콜백함수 실행
  }

  // 방 폭파 버튼 처리
  Future<void> stopServer() async
  {
    GameController gameController = Get.find<GameController>();

    gameController.resetInfo();
    disconnectAllClient();
    serverSocket.close();
    gameController.onChangeRoom();
    Get.snackbar('System Msg', "방폭파 완료", snackPosition: SnackPosition.BOTTOM);
  }

  // Client 모두 disconnect
  void disconnectAllClient()
  {
    if (clientSocket != null) {
      for (int i=0; i<clientSocket.length; i++) {
        clientSocket[i].close();
        clientSocket[i].destroy();
      }
    }
    clientSocket.clear();
  }

  // 예전에 만든 함수. 이 코드 역시 업데이트 해야함.
  // 원리는 msg를 서로 주고받으며 parsed 값으로 액션을 수행함.
  Future<void> handleClient(Socket client) async {
    GameController gameController = Get.find<GameController>();

    clientSocket.add(client); // 새로운 클라이언트를 넣음
    
    client.listen((List<int> data)
    {
      String result = utf8.decode(data);

      // connection 정보 업데이트
      if (result.length != result.split("connection:::")[0].length)
      {
        gameController.hosting(result);
        broadcast(makeHostingMsg());
      }

      // disconnection 정보 업데이트
      else if (result.length != result.split("disconnect:::")[0].length)
      {
        gameController.disconnectHosting(result.split("disconnect:::")[1].trim()); // 이걸 브로드캐스트
        broadcast(makeHostingMsg());
      }

      // 투표를 위한 함수 호출
      else if (result.length != result.split("vote:::")[0].length)
        gameController.calVote(result.split("vote:::")[0], clientSocket.length+1);
    });
  }

  // message 뿌림
  void broadcast(String message)
  {
    for (int i=0; i<clientSocket.length; i++)
    {
      clientSocket[i].encoding = utf8;
      clientSocket[i].write(message);
    }
  }

  // broadcastHosting의 msg를 만들어줌
  String makeHostingMsg()
  {
    GameController gameController = Get.find<GameController>();

    String result="";
    String temp;
    for (int i=0; i<6; i++)
    {
      (gameController.imageInfo[i] == true) ? temp="1" : temp="0";
      result+=temp+gameController.nickListInfo[i]+":";
    }
    result+="connection@";

    return result;
  }


}