import CoreLocation

/// Full route spine for the PATCO Speedline.
///
/// `coordinates` traces the line from Lindenwold (index 0) to 15/16th & Locust (index 159).
/// `stationCoordIndex` maps each station id to its position in `coordinates`.
enum PATCORoute {

    static let coordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 39.833809,           longitude: -75.000325),           // 0   Lindenwold
        CLLocationCoordinate2D(latitude: 39.83416727053506,   longitude: -75.00069558620453),
        CLLocationCoordinate2D(latitude: 39.83473573787002,   longitude: -75.00112473964691),
        CLLocationCoordinate2D(latitude: 39.83505704341295,   longitude: -75.00135540962219),
        CLLocationCoordinate2D(latitude: 39.836078620280325,  longitude: -75.00183820724487),
        CLLocationCoordinate2D(latitude: 39.83734733168736,   longitude: -75.0023478269577),
        CLLocationCoordinate2D(latitude: 39.83812996664616,   longitude: -75.00266432762146),
        CLLocationCoordinate2D(latitude: 39.8387766635402,    longitude: -75.00292718410492),
        CLLocationCoordinate2D(latitude: 39.8400865150229,    longitude: -75.00348508358002),
        CLLocationCoordinate2D(latitude: 39.841252179451175,  longitude: -75.0039678812027),
        CLLocationCoordinate2D(latitude: 39.84251667643779,   longitude: -75.00452041625977),
        CLLocationCoordinate2D(latitude: 39.84436601283382,   longitude: -75.00527679920195),
        CLLocationCoordinate2D(latitude: 39.84705549335026,   longitude: -75.0064355134964),
        CLLocationCoordinate2D(latitude: 39.84910239336525,   longitude: -75.00730454921722),
        CLLocationCoordinate2D(latitude: 39.850840357137336,  longitude: -75.00804483890533),
        CLLocationCoordinate2D(latitude: 39.851956419675986,  longitude: -75.00847935676573),
        CLLocationCoordinate2D(latitude: 39.85302304551273,   longitude: -75.00879049301147),
        CLLocationCoordinate2D(latitude: 39.85378902913127,   longitude: -75.00895142555237),
        CLLocationCoordinate2D(latitude: 39.854872098906334,  longitude: -75.0091016292572),
        CLLocationCoordinate2D(latitude: 39.85796060706381,   longitude: -75.00913918018341),
        CLLocationCoordinate2D(latitude: 39.85857005625387,   longitude: -75.00912845134735),
        CLLocationCoordinate2D(latitude: 39.858698,           longitude: -75.009198),           // 21  Ashland
        CLLocationCoordinate2D(latitude: 39.8589900788966,    longitude: -75.00914454460144),
        CLLocationCoordinate2D(latitude: 39.86068249702552,   longitude: -75.00923573970795),
        CLLocationCoordinate2D(latitude: 39.862918401501695,  longitude: -75.00929474830627),
        CLLocationCoordinate2D(latitude: 39.86456543001931,   longitude: -75.00933766365051),
        CLLocationCoordinate2D(latitude: 39.865607155144936,  longitude: -75.0094449520111),
        CLLocationCoordinate2D(latitude: 39.86670650798521,   longitude: -75.00971853733063),
        CLLocationCoordinate2D(latitude: 39.8680240612148,    longitude: -75.01015305519104),
        CLLocationCoordinate2D(latitude: 39.868724001076004,  longitude: -75.01038432139467),
        CLLocationCoordinate2D(latitude: 39.870157,           longitude: -75.011247),           // 30  Woodcrest
        CLLocationCoordinate2D(latitude: 39.87074966913789,   longitude: -75.01154005536591),
        CLLocationCoordinate2D(latitude: 39.87158956274255,   longitude: -75.01200914382935),
        CLLocationCoordinate2D(latitude: 39.87242944606333,   longitude: -75.01269340524232),
        CLLocationCoordinate2D(latitude: 39.873302255088184,  longitude: -75.01341760167634),
        CLLocationCoordinate2D(latitude: 39.87414623438474,   longitude: -75.01431047916412),
        CLLocationCoordinate2D(latitude: 39.87510547629264,   longitude: -75.01550137996674),
        CLLocationCoordinate2D(latitude: 39.87598648493797,   longitude: -75.01672208318269),
        CLLocationCoordinate2D(latitude: 39.87661224121403,   longitude: -75.01771688461304),
        CLLocationCoordinate2D(latitude: 39.877773168656454,  longitude: -75.01994073400056),
        CLLocationCoordinate2D(latitude: 39.87910285927629,   longitude: -75.02238690862212),
        CLLocationCoordinate2D(latitude: 39.87966683791328,   longitude: -75.02341687688386),
        CLLocationCoordinate2D(latitude: 39.880053798674574,  longitude: -75.02403378495728),
        CLLocationCoordinate2D(latitude: 39.88105823982194,   longitude: -75.025423169227),
        CLLocationCoordinate2D(latitude: 39.88157692088336,   longitude: -75.02608299264466),
        CLLocationCoordinate2D(latitude: 39.88309589285074,   longitude: -75.02794146537781),
        CLLocationCoordinate2D(latitude: 39.883894471662714,  longitude: -75.02887249002013),
        CLLocationCoordinate2D(latitude: 39.88476713478039,   longitude: -75.02989947795868),
        CLLocationCoordinate2D(latitude: 39.88530636917352,   longitude: -75.03047645101105),
        CLLocationCoordinate2D(latitude: 39.88609257355167,   longitude: -75.03115236768281),
        CLLocationCoordinate2D(latitude: 39.8862201765532,    longitude: -75.03125429162537),
        CLLocationCoordinate2D(latitude: 39.88668119187008,   longitude: -75.03156006345307),
        CLLocationCoordinate2D(latitude: 39.88770200046809,   longitude: -75.03210723409211),
        CLLocationCoordinate2D(latitude: 39.889010918284214,  longitude: -75.03263294705903),
        CLLocationCoordinate2D(latitude: 39.890682016028556,  longitude: -75.03329277047669),
        CLLocationCoordinate2D(latitude: 39.89210612136281,   longitude: -75.03383994111573),
        CLLocationCoordinate2D(latitude: 39.893270902283916,  longitude: -75.03432810315644),
        CLLocationCoordinate2D(latitude: 39.89421341369951,   longitude: -75.03479480752502),
        CLLocationCoordinate2D(latitude: 39.895752683950555,  longitude: -75.03574967393433),
        CLLocationCoordinate2D(latitude: 39.897609,           longitude: -75.037141),           // 59  Haddonfield
        CLLocationCoordinate2D(latitude: 39.89802448489844,   longitude: -75.03727853307282),
        CLLocationCoordinate2D(latitude: 39.89954720786948,   longitude: -75.03809094429016),
        CLLocationCoordinate2D(latitude: 39.90027974902823,   longitude: -75.0385177136377),
        CLLocationCoordinate2D(latitude: 39.90102051302311,   longitude: -75.03902733335053),
        CLLocationCoordinate2D(latitude: 39.901399122639155,  longitude: -75.03931701192414),
        CLLocationCoordinate2D(latitude: 39.90214398979901,   longitude: -75.03993391999757),
        CLLocationCoordinate2D(latitude: 39.902250986626484,  longitude: -75.04002511510407),
        CLLocationCoordinate2D(latitude: 39.90339913437438,   longitude: -75.04127740859985),
        CLLocationCoordinate2D(latitude: 39.90429212487698,   longitude: -75.04237473020112),
        CLLocationCoordinate2D(latitude: 39.90569948720416,   longitude: -75.04435420045411),
        CLLocationCoordinate2D(latitude: 39.907086,           longitude: -75.046545),           // 70  Westmont
        CLLocationCoordinate2D(latitude: 39.90743190230095,   longitude: -75.04714906224763),
        CLLocationCoordinate2D(latitude: 39.90767879874811,   longitude: -75.04761040219819),
        CLLocationCoordinate2D(latitude: 39.90809440575787,   longitude: -75.04842579373872),
        CLLocationCoordinate2D(latitude: 39.90890503791777,   longitude: -75.05019068727051),
        CLLocationCoordinate2D(latitude: 39.90953872338275,   longitude: -75.05177855500733),
        CLLocationCoordinate2D(latitude: 39.91018063255249,   longitude: -75.05355954179322),
        CLLocationCoordinate2D(latitude: 39.911534382812064,  longitude: -75.05788326272523),
        CLLocationCoordinate2D(latitude: 39.912456069807426,  longitude: -75.06078541287934),
        CLLocationCoordinate2D(latitude: 39.9134641507577,    longitude: -75.06399869927918),
        CLLocationCoordinate2D(latitude: 39.913588,           longitude: -75.064559),           // 80  Collingswood
        CLLocationCoordinate2D(latitude: 39.91387149354497,   longitude: -75.06527006635224),
        CLLocationCoordinate2D(latitude: 39.91508116390612,   longitude: -75.06910562524354),
        CLLocationCoordinate2D(latitude: 39.91603983306419,   longitude: -75.07213652143037),
        CLLocationCoordinate2D(latitude: 39.91699437442933,   longitude: -75.07514595994508),
        CLLocationCoordinate2D(latitude: 39.91784193017968,   longitude: -75.07786035546815),
        CLLocationCoordinate2D(latitude: 39.91879644642689,   longitude: -75.08088588723695),
        CLLocationCoordinate2D(latitude: 39.91975917778532,   longitude: -75.08390605458771),
        CLLocationCoordinate2D(latitude: 39.92088234726338,   longitude: -75.08742511281525),
        CLLocationCoordinate2D(latitude: 39.92130198827494,   longitude: -75.08861601361787),
        CLLocationCoordinate2D(latitude: 39.921853277459974,  longitude: -75.08994638928925),
        CLLocationCoordinate2D(latitude: 39.92275836948137,   longitude: -75.09167909631286),
        CLLocationCoordinate2D(latitude: 39.922869,           longitude: -75.092025),           // 92  Ferry Ave
        CLLocationCoordinate2D(latitude: 39.92347009253138,   longitude: -75.09290218362366),
        CLLocationCoordinate2D(latitude: 39.92424351728416,   longitude: -75.09418427953278),
        CLLocationCoordinate2D(latitude: 39.92535838546318,   longitude: -75.09590625772034),
        CLLocationCoordinate2D(latitude: 39.92717669239761,   longitude: -75.09873032569885),
        CLLocationCoordinate2D(latitude: 39.9282832854218,    longitude: -75.10050058364868),
        CLLocationCoordinate2D(latitude: 39.928929132563276,  longitude: -75.10161936292207),
        CLLocationCoordinate2D(latitude: 39.9293117015632,    longitude: -75.10230302810669),
        CLLocationCoordinate2D(latitude: 39.93053343985901,   longitude: -75.1046878100351),
        CLLocationCoordinate2D(latitude: 39.931783950750834,  longitude: -75.10709106931245),
        CLLocationCoordinate2D(latitude: 39.932417424524104,  longitude: -75.10820150384461),
        CLLocationCoordinate2D(latitude: 39.933013871744,     longitude: -75.10899782180786),
        CLLocationCoordinate2D(latitude: 39.93384477575881,   longitude: -75.10985910901582),
        CLLocationCoordinate2D(latitude: 39.934848428543326,  longitude: -75.11061012753999),
        CLLocationCoordinate2D(latitude: 39.936312748007055,  longitude: -75.11127531537568),
        CLLocationCoordinate2D(latitude: 39.93691327445807,   longitude: -75.11143624791657),
        CLLocationCoordinate2D(latitude: 39.93861199540246,   longitude: -75.11191904553925),
        CLLocationCoordinate2D(latitude: 39.94028599633902,   longitude: -75.11240720757995),
        CLLocationCoordinate2D(latitude: 39.941314232139696,  longitude: -75.1127022505716),
        CLLocationCoordinate2D(latitude: 39.94158568381304,   longitude: -75.11284172544038),
        CLLocationCoordinate2D(latitude: 39.94191471470058,   longitude: -75.11310994634186),
        CLLocationCoordinate2D(latitude: 39.94235890388898,   longitude: -75.11358201512849),
        CLLocationCoordinate2D(latitude: 39.94274551065027,   longitude: -75.11424183854615),
        CLLocationCoordinate2D(latitude: 39.94290179786988,   longitude: -75.1147729159311),
        CLLocationCoordinate2D(latitude: 39.94295526446835,   longitude: -75.11533856391905),
        CLLocationCoordinate2D(latitude: 39.94295526446835,   longitude: -75.11900007733857),
        CLLocationCoordinate2D(latitude: 39.94261,            longitude: -75.119217),           // 118 Broadway
        CLLocationCoordinate2D(latitude: 39.94318146884561,   longitude: -75.1201051474527),
        CLLocationCoordinate2D(latitude: 39.94394644538041,   longitude: -75.12111902246033),
        CLLocationCoordinate2D(latitude: 39.94405748965038,   longitude: -75.1212877035141),
        CLLocationCoordinate2D(latitude: 39.94416442099927,   longitude: -75.12135207653046),
        CLLocationCoordinate2D(latitude: 39.944283690383536,  longitude: -75.12136816978455),
        CLLocationCoordinate2D(latitude: 39.94433304317139,   longitude: -75.12137115010772),
        CLLocationCoordinate2D(latitude: 39.945686,           longitude: -75.1211),             // 125 City Hall
        CLLocationCoordinate2D(latitude: 39.94662379589698,   longitude: -75.12067914018189),
        CLLocationCoordinate2D(latitude: 39.948075525868894,  longitude: -75.12021780023133),
        CLLocationCoordinate2D(latitude: 39.9485813622194,    longitude: -75.12009978303468),
        CLLocationCoordinate2D(latitude: 39.949037845471246,  longitude: -75.12011587628876),
        CLLocationCoordinate2D(latitude: 39.949395627512175,  longitude: -75.12029290208375),
        CLLocationCoordinate2D(latitude: 39.949872667322495,  longitude: -75.12065470218658),
        CLLocationCoordinate2D(latitude: 39.95002893826108,   longitude: -75.12090981015717),
        CLLocationCoordinate2D(latitude: 39.950510086014404,  longitude: -75.12189149865662),
        CLLocationCoordinate2D(latitude: 39.95082673696273,   longitude: -75.12279510498047),
        CLLocationCoordinate2D(latitude: 39.9513572268249,    longitude: -75.12578606614625),
        CLLocationCoordinate2D(latitude: 39.95176845644535,   longitude: -75.12805521497285),
        CLLocationCoordinate2D(latitude: 39.95228660224692,   longitude: -75.1309466362909),
        CLLocationCoordinate2D(latitude: 39.95293222287223,   longitude: -75.13453543195283),
        CLLocationCoordinate2D(latitude: 39.95356550087704,   longitude: -75.13814568528687),
        CLLocationCoordinate2D(latitude: 39.95393559569764,   longitude: -75.1402056218103),
        CLLocationCoordinate2D(latitude: 39.95463877033943,   longitude: -75.1442021132425),
        CLLocationCoordinate2D(latitude: 39.95504175605654,   longitude: -75.14659464368378),
        CLLocationCoordinate2D(latitude: 39.95534193775165,   longitude: -75.14821469792878),
        CLLocationCoordinate2D(latitude: 39.9556051096607,    longitude: -75.15011906632935),
        CLLocationCoordinate2D(latitude: 39.955609221713715,  longitude: -75.15061497688293),
        CLLocationCoordinate2D(latitude: 39.95553931677836,   longitude: -75.15119194993531),   // 146 Franklin Square
        CLLocationCoordinate2D(latitude: 39.95525558424833,   longitude: -75.15190541753327),
        CLLocationCoordinate2D(latitude: 39.95513222191157,   longitude: -75.15211164951324),
        CLLocationCoordinate2D(latitude: 39.95505409231656,   longitude: -75.15222728261506),
        CLLocationCoordinate2D(latitude: 39.954716900408926,  longitude: -75.1525223256067),
        CLLocationCoordinate2D(latitude: 39.95432213703875,   longitude: -75.15276074409485),
        CLLocationCoordinate2D(latitude: 39.95384101610066,   longitude: -75.1529729367212),
        CLLocationCoordinate2D(latitude: 39.951152,           longitude: -75.153587),           // 153 8th & Market
        CLLocationCoordinate2D(latitude: 39.95019754597862,   longitude: -75.15380442151582),
        CLLocationCoordinate2D(latitude: 39.948108425907854,  longitude: -75.15424430379424),
        CLLocationCoordinate2D(latitude: 39.946961027702585,  longitude: -75.15451252469575),
        CLLocationCoordinate2D(latitude: 39.947352,           longitude: -75.157642),           // 157 9/10th & Locust
        CLLocationCoordinate2D(latitude: 39.947944,           longitude: -75.162363),           // 158 12/13th & Locust
        CLLocationCoordinate2D(latitude: 39.948635,           longitude: -75.167792),           // 159 15/16th & Locust
    ]

    /// Maps each station's stable id to its index in `coordinates`.
    static let stationCoordIndex: [String: Int] = [
        "lindenwold":      0,
        "ashland":         21,
        "woodcrest":       30,
        "haddonfield":     59,
        "westmont":        70,
        "collingswood":    80,
        "ferry-avenue":    92,
        "broadway":        118,
        "city-hall":       125,
        "franklin-square": 146,
        "8th-market":      153,
        "9-10th-locust":   157,
        "12-13th-locust":  158,
        "15-16th-locust":  159,
    ]

    /// Slice of `coordinates` between two stations (inclusive, order-independent).
    static func segment(from origin: Station, to dest: Station) -> [CLLocationCoordinate2D] {
        guard let i = stationCoordIndex[origin.id],
              let j = stationCoordIndex[dest.id] else { return [] }
        let lo = min(i, j)
        let hi = max(i, j)
        return Array(coordinates[lo...hi])
    }
}

extension Station {
    /// The station's geographic coordinate, sourced from `PATCORoute`.
    var coordinate: CLLocationCoordinate2D? {
        PATCORoute.stationCoordIndex[id].map { PATCORoute.coordinates[$0] }
    }
}
