import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

class GifMapper {
  GifMapper._();

 static Gif fromMap(Map<String,dynamic>map){
  
  final images = map['images'];
  
  if(images is! Map<String,dynamic>){
    throw const FormatException('Campo "images" não encontrado');
  }

  final originalUrl = _readImageUrl(images,'original');

  if(originalUrl == null){
    throw const FormatException('Url não informada ou não encontrada');
  }
  final preview = 
   _readImageUrl(images, 'fixed_height') ??
  _readImageUrl(images, 'downsized') ??
    originalUrl;

final id = map['id'];

if(id is! String || id.isEmpty){
  throw const FormatException('id não informado,ou ausente');
}
final title = map['title'];
return Gif(
  id: id,
 title: title is String ? title : "", 
 previewUrl: preview, 
 originalUrl: originalUrl
 );

}
static String? _readImageUrl(
  Map<String,dynamic>images,
  String renditionName
){
 final rendition = images[renditionName];

 if(rendition is! Map<String,dynamic>){
  return null;
 }
 final url = rendition['url'];

 if(url is String && url.isNotEmpty){
  return url;
 }
 return null;
}

}