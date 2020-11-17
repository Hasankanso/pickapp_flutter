import 'package:google_maps_webservice/directions.dart';
import 'package:pickapp/DataObjects/Car.dart';
import 'package:pickapp/DataObjects/User.dart';

class Ride {
  String _id, _comment, _mapUrl, _mapBase64;
  Location _from, _to;
  DateTime _leavingDate;
  bool _musicAllowed,
      _acAllowed,
      _smokingAllowed,
      _petsAllowed,
      _kidSeat,
      _reserved;
  int _availableSeats,
      _maxSeats,
      _maxLuggages,
      _reservedSeats,
      _availableLuggages,
      _reservedLuggages,
      _stopTime;

  //Texture2D map;
  double _price;
  User _user;
  //List<Passenger> passengers;
  Car _car;
  DateTime _updated;

  Ride(
      {id,
      comment,
      mapUrl,
      mapBase64,
      from,
      to,
      leavingDate,
      musicAllowed,
      acAllowed,
      smokingAllowed,
      petsAllowed,
      kidSeat,
      reserved,
      availableSeats,
      maxSeats,
      maxLuggages,
      reservedSeats,
      availableLuggages,
      reservedLuggages,
      stopTime,
      price,
      user,
      car,
      updated}) {
    this.id = id;
    this.comment = comment;
    this.mapUrl = mapUrl;
    this.mapBase64 = mapBase64;
    this.from = from;
    this.leavingDate = leavingDate;
    this.musicAllowed = musicAllowed;
    this.acAllowed = acAllowed;
    this.smokingAllowed = smokingAllowed;
    this.petsAllowed = petsAllowed;
    this.kidSeat = kidSeat;
    this.reserved = reserved;
    this.availableSeats = availableSeats;
    this.maxSeats = maxSeats;
    this.maxLuggages = maxLuggages;
    this.reservedSeats = reservedSeats;
    this.availableLuggages = availableLuggages;
    this.reservedLuggages = reservedLuggages;
    this.stopTime = stopTime;
    this.price = price;
    this.user = user;
    this.car = car;
    this.updated = updated;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  get comment => _comment;

  set comment(value) {
    _comment = value;
  }

  get mapUrl => _mapUrl;

  set mapUrl(value) {
    _mapUrl = value;
  }

  get mapBase64 => _mapBase64;

  set mapBase64(value) {
    _mapBase64 = value;
  }

  Location get from => _from;

  set from(Location value) {
    _from = value;
  }

  get to => _to;

  set to(value) {
    _to = value;
  }

  DateTime get leavingDate => _leavingDate;

  set leavingDate(DateTime value) {
    _leavingDate = value;
  }

  bool get musicAllowed => _musicAllowed;

  set musicAllowed(bool value) {
    _musicAllowed = value;
  }

  get acAllowed => _acAllowed;

  set acAllowed(value) {
    _acAllowed = value;
  }

  get smokingAllowed => _smokingAllowed;

  set smokingAllowed(value) {
    _smokingAllowed = value;
  }

  get petsAllowed => _petsAllowed;

  set petsAllowed(value) {
    _petsAllowed = value;
  }

  get kidSeat => _kidSeat;

  set kidSeat(value) {
    _kidSeat = value;
  }

  get reserved => _reserved;

  set reserved(value) {
    _reserved = value;
  }

  int get availableSeats => _availableSeats;

  set availableSeats(int value) {
    _availableSeats = value;
  }

  get maxSeats => _maxSeats;

  set maxSeats(value) {
    _maxSeats = value;
  }

  get maxLuggages => _maxLuggages;

  set maxLuggages(value) {
    _maxLuggages = value;
  }

  get reservedSeats => _reservedSeats;

  set reservedSeats(value) {
    _reservedSeats = value;
  }

  get availableLuggages => _availableLuggages;

  set availableLuggages(value) {
    _availableLuggages = value;
  }

  get reservedLuggages => _reservedLuggages;

  set reservedLuggages(value) {
    _reservedLuggages = value;
  }

  get stopTime => _stopTime;

  set stopTime(value) {
    _stopTime = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  Car get car => _car;

  set car(Car value) {
    _car = value;
  }

  DateTime get updated => _updated;

  set updated(DateTime value) {
    _updated = value;
  }

/*public static string Valid(Ride ride) {
    string validateUser = User.ValidateLogin(Program.User);
    if (!string.IsNullOrEmpty(validateUser)) {
      return validateUser;
    }

    string fromValidation = Location.Validate(ride.From);
    if (!string.IsNullOrEmpty(fromValidation)) {
      return fromValidation;
    }
    string toValidation = Location.Validate(ride.To);
    if (!string.IsNullOrEmpty(toValidation)) {
      return toValidation;
    }


    //   if (ride.From.Equals(ride.To))
    //   {
    //       return "From and To are too close (1 km)";
    //   }
    if (ride.From.Latitude == ride.To.Latitude && ride.From.Longitude == ride.To.Longitude) {
      return "From and To must be different";
    }
    if (DateTime.Compare(ride.LeavingDate, DateTime.Now.AddMinutes(30)) < 0) {
      return "Your ride must be after one hour or more from now";
    }
    if (ride.AvailableSeats <= 0 || ride.AvailableSeats > ride.Car.MaxSeats) {
      return "Invalid number of seats";
    }
    if (ride.AvailableLuggages < 0 || ride.AvailableLuggages > ride.Car.MaxLuggage) {
      return "Invalid number of luggage";
    }
    if (ride.StopTime != 0 && (ride.StopTime < 5 || ride.StopTime > 30)) {
      return "Your stop time must be between 5 and 30 minutes";
    }
    if (string.IsNullOrEmpty(ride.Comment) || ride.Comment.Length < 25 || ride.Comment.Length > 400) {
      return "Please add a comment between 25 and 400 characters";
    }
    if (string.IsNullOrEmpty(ride.MapBase64)) {
      return "Please choose your ride's road";
    }
    if (string.IsNullOrEmpty(ride.Car.id)) {
      return "Please choose a car";
    }
    if (ride.Price <= 0) {
      return "Please set a price";
    }
    if (string.IsNullOrEmpty(ride.CountryInformations.Id)) {
      return "Please choose a country info";
    }
    if (string.IsNullOrEmpty(ride.Driver.Id)) {
      return "You're not a driver";
    }
    var rideDate = ride.LeavingDate.AddMinutes(-20);
    foreach (var item in Program.Person.UpcomingRides) {
      if (DateTime.Compare(rideDate, item.LeavingDate) >= 0) {
        return "you have an upcoming ride in this ride time";
      }
    }
    return string.Empty;
  }*/
  /*ublic JObject ToJson() {
    JObject rideJ = new JObject();

    rideJ[nameof(this.kidSeat)] = this.KidSeat;
    rideJ[nameof(this.acAllowed)] = this.AcAllowed;
    rideJ[nameof(this.musicAllowed)] = this.MusicAllowed;
    rideJ[nameof(this.smokingAllowed)] = this.SmokingAllowed;
    rideJ[nameof(this.petsAllowed)] = this.PetsAllowed;

    rideJ[nameof(this.availableLuggages)] = this.AvailableLuggages;
    rideJ[nameof(this.availableSeats)] = this.AvailableSeats;
    rideJ[nameof(this.maxSeats)] = this.MaxSeats;
    rideJ[nameof(this.maxLuggages)] = this.MaxLuggages;
    rideJ[nameof(this.stopTime)] = this.StopTime;
    rideJ[nameof(this.leavingDate)] = this.LeavingDate;

    rideJ[nameof(this.car)] = this.Car.Id;
    rideJ[nameof(this.comment)] = this.Comment;
    rideJ[nameof(this.user)] = this.user.Id;
    rideJ[nameof(this.price)] = this.Price;

    rideJ[nameof(this.to)] = to.ToJson();
    rideJ[nameof(this.from)] = from.ToJson();


    rideJ[nameof(this.map)] = this.mapBase64;
    return rideJ;
  }*/
  /* public JObject removeToJson() {
    JObject userJ = new JObject();
    userJ[nameof(this.user)] = Program.User.Id;
    userJ[nameof(this.id)] = this.Id;
    return userJ;
  }*/
  /* public static Ride ToObject(JObject json) {
    bool kidSeat = false;
    var ks = json[nameof(Ride.kidSeat)];

    if (ks != null)
      bool.TryParse(ks.ToString(), out kidSeat);

    string id = "";
    var oId = json["objectId"];
    if (oId != null)
      id = oId.ToString();

    bool acAllowed = false;
    var aAllowed = json[nameof(Ride.acAllowed)];
    if (aAllowed != null)
      bool.TryParse(aAllowed.ToString(), out acAllowed);

    bool musicAllowed = false;
    var mAllowed = json[nameof(Ride.musicAllowed)];
    if (mAllowed != null)
      bool.TryParse(mAllowed.ToString(), out musicAllowed);

    bool smokingAllowed = false;
    var sAllowed = json[nameof(Ride.smokingAllowed)];
    if (sAllowed != null)
      bool.TryParse(sAllowed.ToString(), out smokingAllowed);

    bool petsAllowed = false;
    var pAllowed = json[nameof(Ride.petsAllowed)];
    if (pAllowed != null)
      bool.TryParse(pAllowed.ToString(), out petsAllowed);

    int availableLuggages = -1;
    var aL = json[nameof(Ride.availableLuggages)];
    if (aL != null)
      int.TryParse(aL.ToString(), out availableLuggages);

    int maxLuggages = -1;
    var mL = json[nameof(Ride.maxLuggages)];
    if (mL != null)
      int.TryParse(mL.ToString(), out maxLuggages);

    int availableSeats = -1;
    var aS = json[nameof(Ride.availableSeats)];
    if (aS != null)
      int.TryParse(aS.ToString(), out availableSeats);

    int maxSeats = -1;
    var mS = json[nameof(Ride.maxSeats)];
    if (mS != null)
      int.TryParse(mS.ToString(), out maxSeats);

    int stopTime = -1;
    var sT = json[nameof(Ride.stopTime)];
    if (sT != null)
      int.TryParse(sT.ToString(), out stopTime);


    string comment = "";
    var c = json[nameof(Ride.comment)];
    if (c != null)
      comment = c.ToString();

    JObject carJ = (JObject)json[nameof(Ride.car)];
    Car car = null;
    if (carJ != null) {
      car = Car.ToObject(carJ);
    }

    JArray passengersJ = (JArray)json.GetValue("passengers");
    List<Passenger> passengers = null;
    if (passengersJ != null&& passengersJ.HasValues) {
      passengers = new List<Passenger>();
      foreach (var passenger in passengersJ) {
        passengers.Add(Passenger.ToObject((JObject)passenger));
      }
    }

    double leavingDateDouble = -1;
    var ld = json[nameof(Ride.leavingDate)];
    if (ld != null) {
      double.TryParse(ld.ToString(), out leavingDateDouble);
    }

    DateTime leavingDate = Program.UnixToUtc(leavingDateDouble);

    int reservedLuggages = -1;
    var rL = json[nameof(Ride.reservedLuggages)];
    if (rL != null)
      int.TryParse(rL.ToString(), out reservedLuggages);

    int reservedSeats = -1;
    var rs = json[nameof(Ride.reservedSeats)];
    if (rs != null)
      int.TryParse(rs.ToString(), out reservedSeats);

    Location from = Location.ToObject((JObject)json[nameof(Ride.from)]);
    Location to = Location.ToObject((JObject)json[nameof(Ride.to)]);


    User user;
    if (json.GetValue("driver") != null && json.GetValue("driver").HasValues) {
    JObject driverJ = (JObject)json["driver"];
    Driver driver = Driver.ToObject(driverJ);
    JObject personJ = (JObject)driverJ["person"];
    Person person = Person.ToObject(personJ);
    user = new User(person, driver);
    } else {
    user = new User(Program.Person, Program.Driver);
    }
    string price = "";
    var p = json[nameof(price)];
    if (p != null)
    price = p.ToString();

    string mapUrl = json["map"].ToString();
    //Texture2D map = json[nameof(map)].ToString();
    /*
        rideJ[nameof(this.Date)] = this.Date;

        rideJ[nameof(this.Car)] = this.Car.Id;
        rideJ[nameof(this.Comment)] = this.Comment;
        rideJ[nameof(this.Driver.Id)] = this.Driver.Id;

        rideJ[nameof(this.ReservedLuggages)] = this.ReservedLuggages;


        rideJ[nameof(this.To)] = To.ToJson();
        rideJ[nameof(this.From)] = from.ToJson();
        rideJ[nameof(this.CountryInfo)] = CountryInfo.ToJson();


        rideJ[nameof(this.Map)] = this.MapBase64;
        */
    return new Ride(id, user, car, from, to, comment, price, leavingDate, maxSeats, maxLuggages, musicAllowed, acAllowed, smokingAllowed, petsAllowed,
    kidSeat, availableSeats, availableLuggages, stopTime, mapUrl, passengers);
  }*/

}
