import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:liar_refactoring/re/core/manager/user_manager.dart';
import 'package:liar_refactoring/re/view/game/game_view.dart';
import 'package:liar_refactoring/re/view/game/model/game_user_model.dart';
import 'package:liar_refactoring/re/view/game/model/message_model.dart';
import 'package:liar_refactoring/re/view/game/model/word_model.dart';
import 'package:liar_refactoring/re/view/game/utils/constants.dart';

class GameViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameViewController>(() =>GameViewController());
  }
}

// 게임에 관련된 클래스
class GameViewController extends GetxController {
  final userManager = Get.find<UserManager>();
  var gameStatus = GameStatus.stop.obs;
  ResultPopupStatus? resultPopupStatus;

  TextEditingController submitController = TextEditingController(); // submit textForm
  List<MessageModel> messageList = [];

  var timeLimit = 0.obs; // 남은시간

  List<String> data = [];
  int totalNumberOfUser = 0; // 총 인원수
  int totalVoteCount = 0; // 총 투표수
  int vote = 1; // 본인의 투표권
  late int maxIndex; //투표 최다 득표자의 index
  late int liarIndex; // liar의 index
  late int selectedIndexFromWordList; // random하게 정해진 word의 index

  bool isConnectedServer = false; // 소켓 연결 되었는지 알려주는 bool 값(방생성)
  bool isConnectedClient = false; // 클라이언트용 연결 여부 알려주는 bool 값
  ServerSocket? serverSocket; // 서버용
  late Socket clientSocket; // 클라이언트용
  List<GameUserModel> gameUserList = [];
  List<Socket> clientSocketList = [];

  @override
  void onInit() {
    super.onInit();

    gameUserList = List.filled(GameViewConstants.maxGamePlayer, GameUserModel()); // 6명 default 값으로 초기화
  }

  // 방생성 방폭파 버튼
  void onChangeRoom() {
    isConnectedServer = !isConnectedServer;
    update();
  }

  void setUserInformation(String nickName, String ipAddress) {
    try {
      gameUserList[totalNumberOfUser].nickName = nickName;
      gameUserList[totalNumberOfUser].ipAddress = ipAddress;
      gameUserList[totalNumberOfUser++].isAvatarVisible = true;
      update();
    } catch (e) {
    }
  }

  // 정보들 reset, 서버는 지우지 않음.
  void resetOnlyClientUsersInformation() {
    try {
      for (int i=1; i<GameViewConstants.maxGamePlayer; i++) {
        gameUserList[i].nickName = '';
        gameUserList[i].ipAddress = '';
        gameUserList[i].isAvatarVisible = false;
      }
      update();
    } catch (e) {
    }
  }

  // 클라이언트 -> 서버에 연결
  Future<void> clientConnectToServer() async
  {
    try {
      await Socket.connect(
        userManager.serverIpAddress.value,
        GameViewConstants.portNumber,
        timeout: const Duration(seconds: 5)).then((socket) {
          setClientSocketInfo(socket);
          setClientListener(socket);
      }).catchError((e) {
        // TODO : Exception Handling
      });
    } catch(e) {
      // TODO : Exception Handling
    }
  }

  // 클라이언트 소켓 연결 정보 셋팅
  void setClientSocketInfo(Socket socket) {
    clientSocket = socket;
    isConnectedClient = true;
    update();

    sendMessage("${clientSocket.remoteAddress.toString()}connection:::${userManager.myName.value}"); // 클라이언트와의 연결관계를 서버에게 넘김
  }

  void setClientListener(Socket socket) {
    socket.listen((List<int> data) {
      String result = utf8.decode(data); // 한글을 위해 utf-8 decode
      if(result.length<7){  //서버에서 sendMessage()로 단어만 딸랑 보내는 거 수신
        setPopupStatus(result);
        showResultPopup(result);
      }

      if (result.length != result.split("connection@")[0].length)
        splitMessageFromClient(result);
      else {
        List<String> temp = [];
        temp = splitMessageFromServer(result);

        messageList.insert(0, MessageModel(temp[0], temp[1], temp[2]));
        update();
      }
    },
      onDone: ()=>print("done"),
      onError: (e)=>print(e),
    );
  }

  void setPopupStatus(String result) {
    try {
      switch(result[0]) {
        case 'l':
          maxIndex = int.parse(result[1]);
          resultPopupStatus = ResultPopupStatus.correctAnswer;
          showResult(1);
          break;
        case 'n':
          maxIndex = int.parse(result[1]);
          resultPopupStatus = ResultPopupStatus.wrongAnswer;
          showResult(0);
          break;
        case ',':
          resultPopupStatus = ResultPopupStatus.wrongAnswer;
          break;
        case '[':
          resultPopupStatus = ResultPopupStatus.correctAnswer;
          break;
        default:
          resultPopupStatus = ResultPopupStatus.whoIsLiarPopup;
          break;
      }
    } catch(e) {
      // TODO : Range Error 가능성, 0번째, 1번째 접근은 좋지않음
    }
  }

  void showResultPopup(String message) {
    switch(resultPopupStatus) {
      case ResultPopupStatus.correctAnswer:
        showResult(1);
        break;
      case ResultPopupStatus.wrongAnswer:
        showResult(0);
        break;
      case ResultPopupStatus.whoIsLiarPopup:
        showWhoIsLiarPopup(message);
        break;
    }
  }

  //투표 결과 알려주는 팝업창.
  void showResult(int num) {
    Get.defaultDialog(
      title: (num == 1)
        ? GameViewConstants.liarWinTitle
        : GameViewConstants.liarLastChanceTitle,
      middleText: (num == 1)
        ? GameViewConstants.liarWinContents
        : "라이어 ${gameUserList[maxIndex].nickName}는 제시어를 맞춰주세요!",
      textCancel: GameViewConstants.okMessage
    );
  }

  void showWhoIsLiarPopup(String msg) {
    Get.defaultDialog(
      title: GameViewConstants.you,
      middleText: (msg == GameViewConstants.liar)
        ? GameViewConstants.youAreLiar
        : '일반 시민 입니다.\n제시어는 [$msg]',
      textCancel: GameViewConstants.okMessage
    );

    vote=1;
    timeLimit.value = GameViewConstants.gamePlayTime;
    gameUserList.forEach((element) => element.voteResult=0);
  }

  // 서버로부터 받아온 데이터 split (클라이언트 쪽에서)
  List<String> splitMessageFromServer(String message)
  {
    List<String> result = [];

    try {
      String ipAddress, resultMessage;
      ipAddress = message.split("code1:::")[0]; // ip
      resultMessage = message.split("code2:::")[1]; // message
      result.add(ipAddress);
      result.add(message.substring((ipAddress.length+8), (ipAddress.length+8)+(message.length - ipAddress.length - 16 - resultMessage.length))); // nickname
      result.add(resultMessage);
    } catch(e) {
      // TODO : error 가능성 (배열 index참조)
    }
    return result;
  }


  void splitMessageFromClient(String message) {
    try {
      for (int i=0; i<GameViewConstants.maxGamePlayer; i++)
      {
        if (message.split(":")[i].substring(0,1).contains("1")) {
          gameUserList[i].nickName = message.split(":")[i].substring(1,message.split(":")[i].length);
          gameUserList[i].isAvatarVisible = true;
        }
        else {
          gameUserList[i].nickName = "";
          gameUserList[i].isAvatarVisible = false;
        }
      }
      update();
    } catch (e) {
      // TODO : error 가능성
    }
  }

  // client 연결 정보 셋팅해줌.
  void setClientUserInformation(String message) {
    try {
      String ipAddress = message.split("connection:::")[0]; // ip
      String nickName = message.split("connection:::")[1]; // nick

      for (int i=1; i<GameViewConstants.maxGamePlayer; i++) { // 0은 무조건 서버니까 1부터
        if (!gameUserList[i].isAvatarVisible) {
          gameUserList[i].ipAddress = ipAddress;
          gameUserList[i].nickName = nickName;
          gameUserList[i].isAvatarVisible = true;
          break;
        }
      }
      update();
    } catch (e) {
    }
  }

  // user disconnect시, 호출
  void findDisconnectedUserAndSetDefaultValue(String userName) {
    try {
      for (int i=1; i<GameViewConstants.maxGamePlayer; i++) { // 0은 무조건 서버니까 1부터
        if (gameUserList[i].nickName.contains(userName)) {
          gameUserList[i].ipAddress = "";
          gameUserList[i].nickName = "";
          gameUserList[i].isAvatarVisible = false;
        }
      }
      update();
    } catch (e) {
    }
  }

  // client disconnect from server
  void disconnectFromServer() {
    try {
      for (int i =0; i<GameViewConstants.maxGamePlayer ;i++) {
        gameUserList[i].nickName = "";
        gameUserList[i].isAvatarVisible = false;
      }

      sendMessage("${clientSocket.remoteAddress.toString()}disconnect:::${userManager.myName.value}");

      clientSocket.close();
      isConnectedClient = false;
      update();
    } catch (e) {

    }
  }

  void sendMessage(String message) {
    clientSocket.encoding = utf8;
    clientSocket.write("$message\n"); // send message
  }

  // 투표 계산
  void calculateVote(String message, int len) {
    int cnt=0;
    try {
      for (int i=0; i<GameViewConstants.maxGamePlayer; i++) {
        if (gameUserList[i].nickName.contains(message)) {
          cnt++;
          gameUserList[i].voteResult++;
          totalVoteCount++;
          break;
        }
      }
      if (cnt==0)
        totalVoteCount++; // for safety

      if (totalVoteCount == len)
        whoIsTheMostPick();
    } catch (e) {

    }
  }

  // 제일 많이 뽑힌 사람
  int whoIsTheMostPick()
  {
    try {
      int maxValue = gameUserList.map((eachUser) => eachUser.voteResult).reduce((currentMax, voteCount) => currentMax > voteCount ? currentMax : voteCount);

      for (int i=0; i<GameViewConstants.maxGamePlayer; i++) {
        if (gameUserList[i].voteResult == maxValue) {
          Get.snackbar('투표끝', "${gameUserList[i].nickName}는(은) ${gameUserList[i].voteResult}표 뽑혔습니다.", snackPosition: SnackPosition.BOTTOM);
          return i;
        }
      }
    } catch (e) {}
    return 0; // for safety
  }

  // 메시지 보내기 (서버용)
  void submitMessageToServer()
  {
    if (submitController.text.isEmpty) return;

    if(submitController.text.startsWith('정답:')) { //서버 라이어가 마지막 찬스 제시어 맞추는 경우
      if(submitController.text.contains(WordModel.wordModel[selectedIndexFromWordList])) {
        showResultDialog(0); //맞추면 승리
        broadcast(",");
      }else{
        showResultDialog(1); //못 맞추면 패배
        broadcast("[");
      }
    }

    submitMessage();
  }

  // 라이어 마지막 찬스 결과
  void showResultDialog(int num) {
    Get.defaultDialog(
        title: '결과',
        middleText: (num==0) ? '라이어 승리!!' : '일반 시민 승리!!',
        textCancel: 'Ok'
    );
  }

  // 메시지 보내기 (서버, 클라이언트 둘 다)
  void submitMessage() {
    data = makeMessage(userManager.myIpAddress.value, userManager.myName.value, submitController.text);
    handleMessageList();

    broadcast("${data[0]}code1:::"+"${data[1]}code2:::"+data[2]);
    submitController.clear();
    data.clear();
  }

  void handleMessageList() {
    messageList.insert(0, MessageModel(data[0],data[1],data[2]));
    update();
  }

  // message 하나 만드는 함수
  List<String> makeMessage(String ipAddress, String nickName, String message) {
    List<String> msg = [];
    msg.add(ipAddress);
    msg.add(nickName);
    msg.add(message);

    return msg;
  }

  // 시작할 때 단어 선택 및 타이머 시작 (서버)
  void showWord() {
    try {
      liarIndex = Random().nextInt(clientSocketList.length+1); //라이어 뽑기 (0부터 clientSocket.length 숫자까지 반환)
      selectedIndexFromWordList = Random().nextInt(WordModel.wordModel.length);        //단어 뽑기

      if(liarIndex == clientSocketList.length){ //서버가 라이어인 경우
        broadcast(WordModel.wordModel[selectedIndexFromWordList]);
      }
      else { // 클라이언트 중 한명이 라이어인 경우
        for (int i=0; i<clientSocketList.length; i++) {
          clientSocketList[i].encoding = utf8;
          if (i==liarIndex)
            clientSocketList[i].write("라이어");
          else
            clientSocketList[i].write(WordModel.wordModel[selectedIndexFromWordList]);
        }
      }

      Get.defaultDialog(
          title: GameViewConstants.you,
          middleText: (liarIndex == clientSocketList.length)
            ? GameViewConstants.youAreLiar
            : '일반 시민 입니다.\n제시어는 [${WordModel.wordModel[selectedIndexFromWordList]}]',
          textCancel: GameViewConstants.okMessage
      );

      vote=1;
      timeLimit.value = GameViewConstants.gamePlayTime;
      for (int i=0;i<GameViewConstants.maxGamePlayer;i++)
        gameUserList[i].voteResult = 0;
      totalVoteCount = 0;

      update();

      startTimer();
    } catch (e) {
      // TODO : 예기치못한 에러같은 경우의 handling 필요할듯 ex) 없는 소켓에 write를 한다던
    }

  }

  // 메인 게임 타이머
  void startTimer()
  {
    print("메인 타이머 시작");
    timeLimit.value = GameViewConstants.gamePlayTime;
    print(timeLimit.value);

    Timer _timer = Timer.periodic(const Duration(seconds: 1),
      (Timer timer) {
          if (timeLimit.value < 1) {
            timer.cancel();
            showVoteDialog();   //투표 알림창
            subTimer(); //투표 시간 초 시작
          } else {
            timeLimit.value = timeLimit.value - 1;
          }
        },
    );
  }

  //투표 시간 타이머
  void subTimer() {
    timeLimit.value = 10;

    Timer _timer2 = Timer.periodic(const Duration(seconds: 1),
      (Timer timer) {
          if (timeLimit.value < 1)
          {
            timer.cancel();
            maxIndex = whoIsTheMostPick(); //투표 최다 득표자의 인덱스
            if((maxIndex == 0 && liarIndex == clientSocketList.length) || (maxIndex !=0 && maxIndex == liarIndex+1) ){
              showResult(0); //라이어 맞춘 경우 : 라이어 보너스 찬스
              broadcast("n$maxIndex");
            }else {
              showResult(1); //라이어 못맞춘 경우 : 라이어 승리
              broadcast("l$maxIndex");
            }

          } else {
            timeLimit.value = timeLimit.value - 1;
          }
        },
    );
    //}
  }

  //시간 끝나면 투표하라고 알림
  void showVoteDialog() {
    Get.defaultDialog(
        title: '투표 시간 10초',
        middleText: '이미지를 클릭해서 라이어일 것 같은 사람에게 투표하세요',
        textCancel: 'Ok'
    );
  }

  // Server Socket 열기
  Future<void> startServer() async
  {
    Get.snackbar(
      GameViewConstants.systemTitle,
      GameViewConstants.completeMakeRoom,
      snackPosition: SnackPosition.BOTTOM,
    );

    onChangeRoom();

    try {
      serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, GameViewConstants.portNumber, shared: true); // shared를 true 해줌으로써 iterative 서버가 생성
      serverSocket?.listen(handleClient); // client가 connection 요청을 할 때, 콜백함수 실행
    } catch (e) {
      // TODO : socket error handling
    }
  }

  // 예전에 만든 함수. 이 코드 역시 업데이트 해야함.
  // 원리는 msg를 서로 주고받으며 parsed 값으로 액션을 수행함.
  Future<void> handleClient(Socket client) async {
    try {
      clientSocketList.add(client); // 새로운 클라이언트를 넣음

      client.listen((List<int> data) {
        String result = utf8.decode(data);

        // connection 정보 업데이트
        if (result.length != result.split("connection:::")[0].length) {
          setClientUserInformation(result);
          broadcast(makeBroadcastMessage());
        }

        // disconnection 정보 업데이트
        else if (result.length != result.split("disconnect:::")[0].length) {
          findDisconnectedUserAndSetDefaultValue(result.split("disconnect:::")[1].trim()); // 이걸 브로드캐스트
          broadcast(makeBroadcastMessage());
        }

        // 투표를 위한 함수 호출
        else if (result.length != result.split("vote:::")[0].length)
          calculateVote(result.split("vote:::")[0], clientSocketList.length+1);
      });
    } catch (e) {
      // TODO : socket error handling, index 참조 에러 등
    }
  }

  // message 뿌림
  void broadcast(String message) {
    for (int i=0; i<clientSocketList.length; i++)
    {
      clientSocketList[i].encoding = utf8;
      clientSocketList[i].write(message);
    }
  }

  // broadcastHosting의 msg를 만들어줌
  String makeBroadcastMessage() {
    String result="";
    String temp;
    try {
      for (int i=0; i<GameViewConstants.maxGamePlayer; i++) {
        (gameUserList[i].isAvatarVisible == true) ? temp="1" : temp="0";
        result+='$temp${gameUserList[i].nickName}:';
      }
      result+="connection@";
    } catch (e) {
    }
    return result;
  }

  // 방 폭파 버튼 처리
  Future<void> stopServer() async {
    try {
      resetOnlyClientUsersInformation();
      await disconnectAllClient();
      await serverSocket?.close();
      onChangeRoom();
      Get.snackbar(
        GameViewConstants.systemTitle,
        GameViewConstants.completeDestroyRoom,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // TODO : serversocket close할때 socket error handling 필요할듯
    }
  }

  // Client 모두 disconnect
  Future<void> disconnectAllClient() async {
    try {
      for (int i=0; i<clientSocketList.length; i++) {
        await clientSocketList[i].close();
        clientSocketList[i].destroy();
      }
      clientSocketList.clear();
    } catch (e) {
      // TODO : socket error handling
    }
  }
}