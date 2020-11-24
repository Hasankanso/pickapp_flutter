class Person {
  String _id,
      _firstName,
      _lastName,
      _bio,
      _chattiness,
      _image,
      _profilePictureUrl;
  DateTime _birthday, _updated;
  bool _gender;
  double _rateAverage;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  int _acomplishedRides, _canceledRides, _rateCount;
  //user
  String _phone;
  //private List<Rate> rates = new List<Rate>();
  //private List<Ride> upcomingRides = new List<Ride>();
  //public Texture2D profilePicture;
  //private CountryInformations countryInformations;

  Person({
    id,
    firstName,
    lastName,
    rateCount,
    acomplishedRides,
    canceledRides,
    chattiness,
    phone,
    bio,
    rateAverage,
    gender,
    birthday,
    profilePictureUrl,
  }) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.rateCount = rateCount;
    this.acomplishedRides = acomplishedRides;
    this.canceledRides = canceledRides;
    this.chattiness = chattiness;
    this.phone = phone;
    this.bio = bio;
    this.rateAverage = rateAverage;
    this.gender = gender;
    this.birthday = birthday;
    this.profilePictureUrl = profilePictureUrl;
  }


  Person.name(this._firstName, this._lastName);

  @override
  String toString() {
    return 'Person{_id: $_id, _firstName: $_firstName, _lastName: $_lastName, _bio: $_bio, _chattiness: $_chattiness, _image: $_image, _profilePictureUrl: $_profilePictureUrl, _birthday: $_birthday, _updated: $_updated, _gender: $_gender, _rateAverage: $_rateAverage, _acomplishedRides: $_acomplishedRides, _canceledRides: $_canceledRides, _rateCount: $_rateCount, _phone: $_phone}';
  }

  get firstName => _firstName;

  set firstName(value) {
    _firstName = value;
  }

  get lastName => _lastName;

  set lastName(value) {
    _lastName = value;
  }

  get bio => _bio;

  set bio(value) {
    _bio = value;
  }

  get chattiness => _chattiness;

  set chattiness(value) {
    _chattiness = value;
  }

  get image => _image;

  set image(value) {
    _image = value;
  }

  get profilePictureUrl => _profilePictureUrl;

  set profilePictureUrl(value) {
    _profilePictureUrl = value;
  }

  DateTime get birthday => _birthday;

  set birthday(DateTime value) {
    _birthday = value;
  }

  get updated => _updated;

  set updated(value) {
    _updated = value;
  }

  bool get gender => _gender;

  set gender(bool value) {
    _gender = value;
  }

  double get rateAverage => _rateAverage;

  set rateAverage(double value) {
    _rateAverage = value;
  }

  int get acomplishedRides => _acomplishedRides;

  set acomplishedRides(int value) {
    _acomplishedRides = value;
  }

  get canceledRides => _canceledRides;

  set canceledRides(value) {
    _canceledRides = value;
  }

  get rateCount => _rateCount;

  set rateCount(value) {
    _rateCount = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }
/*CountryInformations countryInformations Texture2D profilePicture,List<Rate> rates,*/

  /* public JObject ToJson() {
    JObject personJ = new JObject();
    personJ[nameof(this.firstName)] = this.firstName;
    personJ[nameof(this.lastName)] = this.lastName;
    personJ[nameof(this.bio)] = this.bio;
    personJ[nameof(this.image)] = this.Image;
    personJ[nameof(this.chattiness)] = this.chattiness;
    personJ[nameof(this.countryInformations)] = this.countryInformations.ToJson();
    personJ[nameof(this.birthday)] = this.birthday;
    personJ[nameof(this.gender)] = this.gender;
    return personJ;
  }*/
/*
  public static Person ToObject(JObject json) {
    string phone = "";
    var ph = json[nameof(phone)];
    if (ph != null)
      phone = ph.ToString();

    string id = "";
    var oId = json["objectId"];
    if (oId != null)
      id = oId.ToString();
    string firstName = "";
    var fn = json[nameof(firstName)];
    if (fn != null)
      firstName = fn.ToString();
    string lastName = "";
    var ln = json[nameof(lastName)];
    if (ln != null)
      lastName = ln.ToString();
    string chattiness = "";
    var cn = json[nameof(chattiness)];
    if (cn != null)
      chattiness = cn.ToString();
    string bio = "";
    var bi = json[nameof(bio)];
    if (bi != null)
      bio = bi.ToString();

    double birthdayDouble = -1;
    var br = json[nameof(Person.birthday)];
    if (br != null) {
      double.TryParse(br.ToString(), out birthdayDouble);
    }
    DateTime birthday = Program.UnixToUtc(birthdayDouble);

    double updatedDouble = -1;
    var up = json[nameof(Person.updated)];
    if (up != null) {
      double.TryParse(up.ToString(), out updatedDouble);
    }
    DateTime updated = Program.UnixToUtc(updatedDouble);

    float rateAverage = -1;
    var ra = json[nameof(Person.rateAverage)];
    if (ra != null)
      float.TryParse(ra.ToString(), out rateAverage);
    int acomplishedRides = -1;
    var ar = json[nameof(Person.acomplishedRides)];
    if (ar != null)
      int.TryParse(ar.ToString(), out acomplishedRides);
    int canceledRides = -1;
    var cr = json[nameof(Person.canceledRides)];
    if (cr != null)
      int.TryParse(cr.ToString(), out canceledRides);
    int rateCount = -1;
    var rc = json[nameof(Person.rateCount)];
    if (rc != null)
      int.TryParse(rc.ToString(), out rateCount);
    JObject driverJ = (JObject)json["driver"];

    Driver driver = null;
    if (driverJ != null) {
      driver = Driver.ToObject(driverJ);
    }
    JObject countryJ = (JObject)json[nameof(Person.countryInformations)];
    CountryInformations countryInformations = null;
    if (countryJ != null && countryJ.HasValues) {
      countryInformations = CountryInformations.ToObject(countryJ);
    }
    bool gender = false;
    var gn = json[nameof(Person.gender)];
    if (gn != null)
      bool.TryParse(gn.ToString(), out gender);

    string image = json[nameof(image)].ToString();
    Person p = new Person(id, firstName, lastName, rateCount, acomplishedRides, canceledRides, chattiness, phone, countryInformations, bio, rateAverage, gender, birthday, image);

    JArray upcomingRidesArray = (JArray)json.GetValue("upcomingRides");
    List<Ride> rides = new List<Ride>();
    if (upcomingRidesArray != null) {
      foreach (var ride in upcomingRidesArray) {
        if (ride.HasValues == true) {
          if (ride["ride"] != null && ((JObject)ride["ride"]).HasValues == true) {
            rides.Add(Ride.ToObject(((JObject)ride["ride"])));
          } else {
            rides.Add(Ride.ToObject((JObject)ride));
          }
        }
      }
      p.UpcomingRides = rides;
    }
    JArray ratesArray = (JArray)json.GetValue("rates");
    List<Rate> rates = new List<Rate>();
    if (ratesArray != null) {
      foreach (var rate in ratesArray) {
        if (rate.HasValues == true) {
          rates.Add(Rate.ToObject((JObject)rate));
        }
      }
      p.rates = rates;
    }
    return p;
  }
*/

}
