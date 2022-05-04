class CardDetail {
  int id;
  String nameCard;
  String img;
  double heightImg;
  double widthImg;
  CardDetail(
      {required this.id,
      required this.nameCard,
      required this.img,
      required this.heightImg,
      required this.widthImg});

  static List<CardDetail> init() {
    List<CardDetail> data = [
      CardDetail(
          id: 1,
          nameCard: 'Viet - Eng Dictionary',
          img: 'assets/images/lookup.png',
          heightImg: 55,
          widthImg: 55),
      CardDetail(
          id: 2,
          nameCard: 'Favorite Words',
          img: 'assets/images/favorite.png',
          heightImg: 55,
          widthImg: 55),
      CardDetail(
          id: 3,
          nameCard: 'Short Story',
          img: 'assets/images/reading.jpg',
          heightImg: 55,
          widthImg: 55),
      CardDetail(
          id: 4,
          nameCard: 'Idioms',
          img: 'assets/images/bag-cat.png',
          heightImg: 55,
          widthImg: 55),
      CardDetail(
          id: 5,
          nameCard: 'Conversations',
          img: 'assets/images/convers.jpg',
          heightImg: 50,
          widthImg: 70),
      CardDetail(
          id: 6,
          nameCard: 'Grammar',
          img: 'assets/images/cat-book.png',
          heightImg: 55,
          widthImg: 55),
    ];
    return data;
  }
}
