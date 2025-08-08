// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginEventAdapter extends TypeAdapter<LoginEvent> {
  @override
  final int typeId = 1;

  @override
  LoginEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginEvent(
      userKey: fields[0] as int,
      at: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LoginEvent obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userKey)
      ..writeByte(1)
      ..write(obj.at);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
