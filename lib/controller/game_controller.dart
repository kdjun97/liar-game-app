import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:liar_refactoring/controller/myinfo_controller.dart';
import 'package:liar_refactoring/controller/socket_controller.dart';
import 'package:liar_refactoring/model/word_model.dart';
import 'package:liar_refactoring/widgets/message/message_list_widget.dart';

// 게임에 관련된 클래스
class GameController extends GetxController {
  late bool isServer;

  late TextEditingController submitController = TextEditingController(); // submit textForm
  MyInfoController myInfoController = Get.find<MyInfoController>();
  SocketController socketController = Get.find<SocketController>();
  List<MessageItem> msgList = [];

  int gameTime = 20; // 게임시간
  bool isGameStart = false; // 게임이 시작했는지 알려주는 bool 값
  var time = 0.obs; // 남은시간

  List<String> nickListInfo = ["", "", "", "", "", ""]; // Nickname 정보
  List<String> hostListInfo = ["", "", "", "", "", ""]; // 사용자 IP 정보
  List<int> voteResult = [0, 0, 0, 0, 0, 0];            // 투표 결과
  List<bool> imageInfo = [false, false, false, false, false, false]; // Image를 위한 boolean타입
  List<String> data = [];
  int userCount = 0; // 총 인원수
  int voteCount = 0; // 총 투표수
  int vote = 1; // 본인의 투표권
  late int maxIndex; //투표 최다 득표자의 index
  late int liar; // liar의 index
  late int wordNum; // random하게 정해진 word의 index

  bool isServerConnect = false; // 소켓 연결 되었는지 알려주는 bool 값(방생성)
  bool isClientConnect = false; // 클라이언트용 연결 여부 알려주는 bool 값
  late ServerSocket serverSocket; // 서버용
  late Socket clientSocket; // 클라이언트용

  void setServer(bool ck) => isServer=ck;

  void setUser(String nick, String host)
  {
    nickListInfo[userCount] = nick;
    hostListInfo[userCount] = host;
    imageInfo[userCount++] = true;
    update();
  }


  // 방생성 방폭파 버튼
  onChangeRoom() {
    isServerConnect = !isServerConnect;
    update();
  }

  // 게임시작 버튼 핸들링
  onChangeGame() {
    if (!isGameStart)
      showWord();
    isGameStart = !isGameStart;
    update();
  }



  // 정보들 reset, 서버는 지우지 않음.
  void resetInfo()
  {
    for (int i=1; i<6; i++) {
      hostListInfo[i] = "";
      nickListInfo[i] = "";
      imageInfo[i] = false;
    }
    update();
  }

  // 클라이언트 -> 서버에 연결
  void connectToServer() async
  {
    print("Destination Address: ${myInfoController.srvIp}");

    await Socket.connect(myInfoController.srvIp, socketController.port, timeout: Duration(seconds: 5))
        .then
      ((socket) {
        clientSocket = socket;
        isClientConnect = true;
        update();

        sendMessage("${clientSocket.remoteAddress.toString()}connection:::${myInfoController.myName}"); // 클라이언트와의 연결관계를 서버에게 넘김

        socket.listen((List<int> Data) {
          String result = utf8.decode(Data); // 한글을 위해 utf-8 decode
          if(result.length<7){  //서버에서 sendMessage()로 단어만 딸랑 보내는 거 수신
            if(result[0]=='l') { //투표결과 수신
              maxIndex = int.parse(result[1]);
              _showResult(1);
            }
            else if(result[0]=='n')
            {
              maxIndex = int.parse(result[1]);
              _showResult(0);
            }else if(result == ','){  //마지막 찬스 결과 수신
              _showResult(0);
            }else if(result == ',,'){
              _showResult(1);
            }
            else //제시어 수신
              showWordToClient(result); //팝업창 띄우고
          }

          if (result.length != result.split("connection@")[0].length)
            splitHostingMsg(result);
          else {
            List<String> temp = [];
            temp = splitData(result);

            msgList.insert(0, MessageItem(temp[0], temp[1], temp[2]));
            update();
          }
          },
          onDone: ()=>print("done"),
          onError: (e)=>print(e),
        );
      }
    ).catchError((e) {print(e);});
  }

  // 서버로부터 받아온 데이터 split (클라이언트 쪽에서)
  List<String> splitData(String m)
  {
    String temp1, temp3;
    List<String> result = [];
    temp1 = m.split("code1:::")[0]; // ip
    temp3 = m.split("code2:::")[1]; // message
    result.add(temp1);
    result.add(m.substring((temp1.length+8), (temp1.length+8)+(m.length - temp1.length - 16 - temp3.length))); // nickname
    result.add(temp3);

    return result;
  }


  void splitHostingMsg(String msg)
  {
    for (int i=0; i<6; i++)
    {
      if (msg.split(":")[i].substring(0,1).contains("1"))
      {
        nickListInfo[i] = msg.split(":")[i].substring(1,msg.split(":")[i].length);
        imageInfo[i] = true;
      }
      else
      {
        nickListInfo[i] = "";
        imageInfo[i] = false;
      }
    }
    update();
  }


  // client 연결 정보 셋팅해줌.
  void hosting(String m)
  {
    String temp1 = m.split("connection:::")[0]; // ip
    String temp2 = m.split("connection:::")[1]; // nick

    for (int i=1; i<6; i++) { // 0은 무조건 서버니까 1부터
      if (!imageInfo[i]) {
        hostListInfo[i] = temp1;
        nickListInfo[i] = temp2;
        imageInfo[i] = true;
        break;
      }
    }
    update();
  }

  // user disconnect시, 호출
  void disconnectHosting(String hostName)
  {
    for (int i=1; i<6; i++) { // 0은 무조건 서버니까 1부터
      if (nickListInfo[i].toString().contains(hostName.toString())) {
        hostListInfo[i] = "";
        nickListInfo[i] = "";
        imageInfo[i] = false;
      }
    }
    update();
  }

  // client disconncect
  void disconnectFromServer()
  {
    print("disconnectFromServer");

    for (int i =0; i<6 ;i++) {
      nickListInfo[i] = "";
      imageInfo[i] = false;
    }

    sendMessage("${clientSocket.remoteAddress.toString()}disconnect:::${myInfoController.myName}");

    clientSocket.close();
    isClientConnect = false;
    update();
  }

  void sendMessage(String message) {
    clientSocket.encoding = utf8;
    clientSocket.write("$message\n"); // send message
  }

  // 투표 계산
  void calVote(String msg, int len)
  {
    int cnt=0;

    for (int i=0; i<6; i++) {
      if (nickListInfo[i].toString().contains(msg.toString())) {
        cnt++;
        voteResult[i]++;
        voteCount++;
        break;
      }
    }
    if (cnt==0)
      voteCount++; // for safety

    if (voteCount == len)
      Who();
  }

  // 제일 많이 뽑힌 사람
  int Who()
  {
    int t = voteResult.reduce(max); // 중복이 있으면 앞에서부터그냥 적용 재투표없음
    for (int i=0; i<6; i++) {
      if (voteResult[i] == t) {
        Get.snackbar('투표끝', "${nickListInfo[i]}는 ${voteResult[i].toString()}표 뽑혔습니다.", snackPosition: SnackPosition.BOTTOM);
        return i;
      }
    }

    return 0; // for safety
  }

  // 메시지 보내기 (서버용)
  void submitMessage()
  {
    if (submitController.text.isEmpty) return;

    if(submitController.text.startsWith('정답:')) { //서버 라이어가 마지막 찬스 제시어 맞추는 경우
      if(submitController.text.contains(WordModel.wordModel[wordNum])) {
        result(0); //맞추면 승리
        socketController.broadcast(",");
      }else{
        result(1); //못 맞추면 패배
        socketController.broadcast(",,");
      }
    }

    submitMsg();
  }

  // 메시지 보내기 (서버, 클라이언트 둘 다)
  void submitMsg() {
    data = makeData(myInfoController.myIp, myInfoController.myName, submitController.text);
    handleMessageList();

    socketController.broadcast("${data[0]}code1:::"+"${data[1]}code2:::"+data[2]);
    submitController.clear();
    data.clear();
  }

  void handleMessageList() {
    print("${data[0]}/${data[1]}/${data[2]}");
    msgList.insert(0, MessageItem(data[0],data[1],data[2]));
    update();
  }

  // message 하나 만드는 함수
  List<String> makeData(String t_ip, String t_name, String t_msg)
  {
    List<String> msg = [];
    msg.add(t_ip);
    msg.add(t_name);
    msg.add(t_msg);

    return msg;
  }

  // 라이어 마지막 찬스 결과
  void result(int num)
  {
    Get.defaultDialog(
      title: '결과',
      middleText: (num==0) ? '라이어 승리!!' : '일반 시민 승리!!',
      textCancel: 'Ok'
    );
  }

  // 시작할 때 단어 선택 및 타이머 시작 (서버)
  void showWord()
  {
    liar = Random().nextInt(socketController.clientSocket.length+1); //라이어 뽑기 (0부터 clientSocket.length 숫자까지 반환)
    wordNum = Random().nextInt(WordModel.wordModel.length);        //단어 뽑기

    if(liar == socketController.clientSocket.length){ //서버가 라이어인 경우
      socketController.broadcast(WordModel.wordModel[wordNum]);
    }
    else { // 클라이언트 중 한명이 라이어인 경우
      for (int i=0; i<socketController.clientSocket.length; i++) {
        socketController.clientSocket[i].encoding = utf8;
        if (i==liar)
          socketController.clientSocket[i].write("라이어");
        else
          socketController.clientSocket[i].write(WordModel.wordModel[wordNum]);
      }
    }

    Get.defaultDialog(
        title: '당신은',
        middleText: (liar == socketController.clientSocket.length) ? '라이어 당첨!!' : '일반 시민 입니다.\n제시어는 [${WordModel.wordModel[wordNum]}]',
        textCancel: 'Ok'
    );

    vote=1;
    time.value = gameTime;
    for (int i=0;i<6;i++)
      voteResult[i] = 0;
    voteCount = 0;

    update();

    startTimer();
  }

  void showWordToClient(String msg) {
    Get.defaultDialog(
        title: '당신은',
        middleText: (msg == "라이어") ? '라이어 당첨!!' : '일반 시민 입니다.\n제시어는 [$msg]',
        textCancel: 'Ok'
    );

    vote=1;
    time.value = gameTime;
    for (int i=0;i<6;i++)
      voteResult[i] = 0;
  }

  // 메인 게임 타이머
  void startTimer()
  {
    print("메인 타이머 시작");
    time.value = gameTime;
    print(time.value);

    Timer _timer = Timer.periodic(const Duration(seconds: 1),
      (Timer timer) {
          if (time.value < 1) {
            timer.cancel();
            _showVote();   //투표 알림창
            subTimer(); //투표 시간 초 시작
          } else {
            time.value = time.value - 1;
          }
        },
    );
  }

  //투표 시간 타이머
  void subTimer()
  {
    print("투표 타이머");
    time.value = 10;

    Timer _timer2 = Timer.periodic(const Duration(seconds: 1),
      (Timer timer) {
          if (time.value < 1)
          {
            timer.cancel();
            maxIndex = Who(); //투표 최다 득표자의 인덱스
            if((maxIndex == 0 && liar == socketController.clientSocket.length) || (maxIndex !=0 && maxIndex == liar+1) ){
              _showResult(0); //라이어 맞춘 경우 : 라이어 보너스 찬스
              socketController.broadcast("n$maxIndex");
            }else {
              _showResult(1); //라이어 못맞춘 경우 : 라이어 승리
              socketController.broadcast("l$maxIndex");
            }

          } else {
            time.value = time.value - 1;
          }
        },
    );
    //}
  }

  //시간 끝나면 투표하라고 알림
  void _showVote()
  {
    Get.defaultDialog(
        title: '투표 시간 10초',
        middleText: '이미지를 클릭해서 라이어일 것 같은 사람에게 투표하세요',
        textCancel: 'Ok'
    );
  }

  //투표 결과 알려주는 팝업창. 1:라이어 못맞춤
  void _showResult(int num)
  {
    Get.defaultDialog(
        title: (num == 1) ? "라이어의 승리 !!" : "라이어 마지막 찬스",
        middleText: (num == 1) ? "축하 ^^" : "라이어 ${nickListInfo[maxIndex]}는 제시어를 맞춰주세요!",
        textCancel: 'Ok'
    );
  }


}