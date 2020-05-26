import '../models/airplane.dart';
import '../models/offer.dart';
import '../models/user.dart';

final List<Airplane> listOfAirplanes = [
    Airplane(
      name: 'Airbus A330',
      price: 10300,
      distance: 1000,
      seats: 330,
      imageUrl:
          'https://airbus-h.assetsadobe2.com/is/image/content/dam/channel-specific/website-/products-and-services/aircraft/header/aircraft-families/A330-family-stage.jpg?wid=1920&fit=fit,1&qlt=85,0',
      onFlight: false,
    ),
    Airplane(
      name: 'Airbus A320',
      price: 800,
      distance: 900,
      seats: 200,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/d/d6/Airbus_A320-214%2C_CSA_-_Czech_Airlines_AN1841815.jpg',
      onFlight: false,
    ),
    Airplane(
      name: 'Airbus A320',
      price: 800,
      distance: 900,
      seats: 200,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/d/d6/Airbus_A320-214%2C_CSA_-_Czech_Airlines_AN1841815.jpg',
      onFlight: false,
    ),
  ];

final  List<Airplane> myAirplanes = [
    Airplane(
      name: 'Airbus A330',
      price: 1030,
      distance: 1000,
      seats: 330,
      imageUrl:
          'https://airbus-h.assetsadobe2.com/is/image/content/dam/channel-specific/website-/products-and-services/aircraft/header/aircraft-families/A330-family-stage.jpg?wid=1920&fit=fit,1&qlt=85,0',
      onFlight: false,
    ),
    Airplane(
      name: 'Airbus A320',
      price: 800,
      distance: 900,
      seats: 200,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/d/d6/Airbus_A320-214%2C_CSA_-_Czech_Airlines_AN1841815.jpg',
      onFlight: false,
    ),
  ];

final List<User> userList = [
    User(
      username: 'Matej',
      airlineName: 'Kiwi Airlines',
      coins: 0,
    ),
  ];


