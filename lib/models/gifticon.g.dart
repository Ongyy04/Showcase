// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gifticon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GifticonAdapter extends TypeAdapter<Gifticon> {
  @override
  final int typeId = 0;

  @override
  Gifticon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gifticon(
      id: fields[0] as String,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      brand: fields[3] as String,
      price: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Gifticon obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.brand)
      ..writeByte(4)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GifticonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
