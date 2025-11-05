// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gifticon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GifticonAdapter extends TypeAdapter<Gifticon> {
  @override
  final int typeId = 2;

  @override
  Gifticon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gifticon(
      id: fields[0] as String,
      name: fields[1] as String,
      brand: fields[2] as String,
      ownerUserKey: fields[3] as int,
      imagePath: fields[4] as String,
      purchaseDate: fields[5] as DateTime,
      expiryDate: fields[6] as DateTime,
      price: fields[9] as int,
      isUsed: fields[7] as bool,
      canConvert: fields[8] as bool,
      usableAmount: fields[10] as int,
      pointAmount: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Gifticon obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.ownerUserKey)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.purchaseDate)
      ..writeByte(6)
      ..write(obj.expiryDate)
      ..writeByte(7)
      ..write(obj.isUsed)
      ..writeByte(8)
      ..write(obj.canConvert)
      ..writeByte(9)
      ..write(obj.price)
      ..writeByte(10)
      ..write(obj.usableAmount)
      ..writeByte(11)
      ..write(obj.pointAmount);
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
