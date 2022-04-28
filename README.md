# Code Refactoring

### Image

<details>
<summary>접기/펼치기</summary><br>  

![init-page](assets/init-page.JPG)  
![make-room](assets/make-room-page.JPG)  

</details>

### Blog
[Tech Blog](https://kdjun97.github.io/blog/Project_Liar/)   

### History

<details>
<summary>접기/펼치기</summary><br>

2022.03.11  
- init Page 구현 완료. (방 고르는 페이지)  
- getX 적용(기존 코드 개선)  
- Server용 방만들기 페이지 구현.  
- getIp 기능 구현.  

2022.03.12
- Custom textFormField 추가  
- Validation Check 기능 추가
- Custom Elevated Button 추가  
- Server Room Page에 Custom Elevated Button 적용  
- Server 방만들기 페이지 overflow 감지. ListView로 바꿀 예정.(완료)  

2022.03.13
- Rename directory: utils->widgets  
- Remove directory: utils
- ADD func
- Custom App Bar 구현
- Server Home Page 구현
- User Connection시, face info UI 구현

2022.03.15  
- Client Join page와 Server Room Page 합치기 (두개 다 필요없음)
- Custom AppBar에 뒤로가기 기능 추가
- 필요없는 페이지 삭제

2022.03.16
- startServer 가능
- Server측 Timer 기능 구현
- Socket Controller추가
- 서버에서 처리할 각종 socket 기능들 구현 완료
- Message List UI 표현 완료

2022.03.19
- 두개의 서버가 생기는 오류 해결
- Server, Client페이지 GamePage로 합침
- Message 오류 해결(자신이 보낸 메시지가 왼쪽에 가는 현상 해결)

2022.03.22
- ServerHome 페이지 삭제
- Client 기능 구현

2022.04.17
- code refactoring

</details>

### TODO:  
- faceInfo 클릭시 투표기능 추가
- 클라이언트 data 송수신 확인 (핸드폰 3대 이상으로 확인)
- 현재 테스트할 핸드폰이 없어 잠시 중단.
- assets 이미지 다 바꿔야함.  
- controller code refactoring

### 개선할 점:  
1. db를 통해 채팅을 포함한 다른 데이터를 관리하면 좋을 것 같음.  
2. UI의 개선과 exception handling이 필요함(기능 검증이 끝났기 때문에, 게임 진행의 안정성을 고려해야 함)
3. word select에 대한 새로운 알고리즘 도입(혹은 분야별 word 추가)
4. 6명 초과의 인원에 대한 exception handling
5. 서로 주고받는 데이터에 대한 로직 변경(string으로 보내는 현재의 로직 변경)