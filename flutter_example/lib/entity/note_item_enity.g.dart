// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_item_enity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteItemEntityAdapter extends TypeAdapter<NoteItemEntity> {
  @override
  final int typeId = 0;

  @override
  NoteItemEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteItemEntity(
      id: fields[0] as String,
      title: fields[1] as String,
      subTitle: fields[2] as String,
      checked: fields[3] as bool,
      saveTime: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NoteItemEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subTitle)
      ..writeByte(3)
      ..write(obj.checked)
      ..writeByte(4)
      ..write(obj.saveTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteItemEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
