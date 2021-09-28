
import 'package:flutter/material.dart';

class TDFrom {
  String name;
  String time;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  TDFrom({
    @required this.name,
    @required this.time,
  });

  TDFrom copyWith({
    String name,
    String time,
  }) {
    return new TDFrom(
      name: name ?? this.name,
      time: time ?? this.time,
    );
  }

  @override
  String toString() {
    return 'TDFrom{name: $name, time: $time}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TDFrom &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          time == other.time);

  @override
  int get hashCode => name.hashCode ^ time.hashCode;

  factory TDFrom.fromMap(Map<String, dynamic> map) {
    return new TDFrom(
      name: map['name'] as String,
      time: map['time'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': this.name,
      'time': this.time,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class TDTo {
  String name;
  String time;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  TDTo({
    @required this.name,
    @required this.time,
  });

  TDTo copyWith({
    String name,
    String time,
  }) {
    return new TDTo(
      name: name ?? this.name,
      time: time ?? this.time,
    );
  }

  @override
  String toString() {
    return 'TDTo{name: $name, time: $time}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TDTo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          time == other.time);

  @override
  int get hashCode => name.hashCode ^ time.hashCode;

  factory TDTo.fromMap(Map<String, dynamic> map) {
    return new TDTo(
      name: map['name'] as String,
      time: map['time'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': this.name,
      'time': this.time,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class TDState {
  String id;
  String text;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  TDState({
    @required this.id,
    @required this.text,
  });

  TDState copyWith({
    String id,
    String text,
  }) {
    return new TDState(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }

  @override
  String toString() {
    return 'TDState{id: $id, text: $text}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TDState &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text);

  @override
  int get hashCode => id.hashCode ^ text.hashCode;

  factory TDState.fromMap(Map<String, dynamic> map) {
    return new TDState(
      id: map['id'] as String,
      text: map['text'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'text': this.text,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class TDLocation {
  String name;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  TDLocation({
    @required this.name,
  });

  TDLocation copyWith({
    String name,
  }) {
    return new TDLocation(
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'TDLocation{name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TDLocation &&
          runtimeType == other.runtimeType &&
          name == other.name);

  @override
  int get hashCode => name.hashCode;

  factory TDLocation.fromMap(Map<String, dynamic> map) {
    return new TDLocation(
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': this.name,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class TDStatus {
  String id;
  String text;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  TDStatus({
    @required this.id,
    @required this.text,
  });

  TDStatus copyWith({
    String id,
    String text,
  }) {
    return new TDStatus(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }

  @override
  String toString() {
    return 'TDStatus{id: $id, text: $text}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TDStatus &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text);

  @override
  int get hashCode => id.hashCode ^ text.hashCode;

  factory TDStatus.fromMap(Map<String, dynamic> map) {
    return new TDStatus(
      id: map['id'] as String,
      text: map['text'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'text': this.text,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class TDProgress {
  String time;
  TDLocation location;
  TDStatus status;
  String description;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  TDProgress({
    @required this.time,
    @required this.location,
    @required this.status,
    @required this.description,
  });

  TDProgress copyWith({
    String time,
    TDLocation location,
    TDStatus status,
    String description,
  }) {
    return new TDProgress(
      time: time ?? this.time,
      location: location ?? this.location,
      status: status ?? this.status,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'TDProgress{time: $time, location: $location, status: $status, description: $description}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TDProgress &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          location == other.location &&
          status == other.status &&
          description == other.description);

  @override
  int get hashCode =>
      time.hashCode ^
      location.hashCode ^
      status.hashCode ^
      description.hashCode;

  factory TDProgress.fromMap(Map<String, dynamic> map) {
    return new TDProgress(
      time: map['time'] as String,
      location: TDLocation.fromMap(map['location']),
      status: TDStatus.fromMap(map['status']),
      description: map['description'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'time': this.time,
      'location': this.location,
      'status': this.status,
      'description': this.description,
    } as Map<String, dynamic>;
  }



//</editor-fold>

}

class TDCarrier {
  String id;
  String name;
  String tel;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  TDCarrier({
    @required this.id,
    @required this.name,
    @required this.tel,
  });

  TDCarrier copyWith({
    String id,
    String name,
    String tel,
  }) {
    return new TDCarrier(
      id: id ?? this.id,
      name: name ?? this.name,
      tel: tel ?? this.tel,
    );
  }

  @override
  String toString() {
    return 'TDCarrier{id: $id, name: $name, tel: $tel}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TDCarrier &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          tel == other.tel);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ tel.hashCode;

  factory TDCarrier.fromMap(Map<String, dynamic> map) {
    return new TDCarrier(
      id: map['id'] as String,
      name: map['name'] as String,
      tel: map['tel'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'name': this.name,
      'tel': this.tel,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class TrackerDeliveryData {
  TDFrom from;
  TDTo to;
  TDState state;
  List<TDProgress> progresses;
  TDCarrier carrier;
  String message;
  String link;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  TrackerDeliveryData({
    @required this.from,
    @required this.to,
    @required this.state,
    @required this.progresses,
    @required this.carrier,
    @required this.message,
    @required this.link,
  });

  TrackerDeliveryData copyWith({
    TDFrom from,
    TDTo to,
    TDState state,
    List<TDProgress> progresses,
    TDCarrier carrier,
  }) {
    return new TrackerDeliveryData(
      from: from ?? this.from,
      to: to ?? this.to,
      state: state ?? this.state,
      progresses: progresses ?? this.progresses,
      carrier: carrier ?? this.carrier,
    );
  }

  @override
  String toString() {
    return 'TrackerDeliveryData{from: $from, to: $to, state: $state, progresses: $progresses, carrier: $carrier}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackerDeliveryData &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to &&
          state == other.state &&
          progresses == other.progresses &&
          carrier == other.carrier);

  @override
  int get hashCode =>
      from.hashCode ^
      to.hashCode ^
      state.hashCode ^
      progresses.hashCode ^
      carrier.hashCode;

  factory TrackerDeliveryData.fromMap(Map<String, dynamic> map) {
    return new TrackerDeliveryData(
        from: TDFrom.fromMap(map['from']),
        to: TDTo.fromMap(map['to']),
        state: TDState.fromMap(map['state']),
        progresses: List.from(map['progresses']).map((element) => TDProgress.fromMap(element)).toList(),
        carrier: TDCarrier.fromMap(map['carrier'])
    );
  }

  factory TrackerDeliveryData.fromMessageMap(Map<String, dynamic> map) {
    return new TrackerDeliveryData(
        message: map['message'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'from': this.from,
      'to': this.to,
      'state': this.state,
      'progresses': this.progresses,
      'carrier': this.carrier,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}