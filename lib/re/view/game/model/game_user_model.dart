class GameUserModel {
  String nickName;
  String ipAddress;
  int voteResult;
  bool isAvatarVisible;

  GameUserModel({
    this.nickName = '',
    this.ipAddress = '',
    this.voteResult = 0,
    this.isAvatarVisible = false,
  });
}