import 'package:flutter_test/flutter_test.dart';
import 'package:gif_explorer/app/modules/explorer/data/mapper/gif_mapper.dart';

void main(){
test('Validar a conversão do map pra Gif ',
 (){
  final gifMap = <String,dynamic> {
    'id': 'gif-123',
      'title': 'GIF de teste',
      'images': {
        'original': {'url': 'https://example.com/original.gif'},
        'fixed_height': {'url': 'https://example.com/preview.gif'},
      },
  };
  final gif = GifMapper.fromMap(gifMap);
  
  expect(gif.id,'gif-123' );
  expect(gif.title, 'GIF de teste');
  expect(gif.originalUrl, 'https://example.com/original.gif' );
  expect(gif.previewUrl,  'https://example.com/preview.gif');
 }
 );

 test('Validar a conversão do map pra Gif sem existir o fixed_height usar o dowsized no lugar ',
 (){
  final gifMap = <String,dynamic> {
    'id': 'gif-123',
      'title': 'GIF de teste',
      'images': {
        'original': {'url': 'https://example.com/original.gif'},
        'downsized': {'url': 'https://example.com/downsized.gif'},
      },
  };
  final gif = GifMapper.fromMap(gifMap);
  
  expect(gif.id,'gif-123' );
  expect(gif.title, 'GIF de teste');
  expect(gif.originalUrl, 'https://example.com/original.gif' );
  expect(gif.previewUrl,  'https://example.com/downsized.gif');
 }
 );
test('Validar a conversão do map pra Gif sem existir o urlPreview ',
 (){
  final gifMap = <String,dynamic> {
    'id': 'gif-123',
      'title': 'GIF de teste',
      'images': {
        'original': {'url': 'https://example.com/original.gif'},
        
      },
  };
  final gif = GifMapper.fromMap(gifMap);
  
  expect(gif.id,'gif-123' );
  expect(gif.title, 'GIF de teste');
  expect(gif.originalUrl, 'https://example.com/original.gif' );
  expect(gif.previewUrl,  'https://example.com/original.gif');
 }
 );
 test('lança FormatException quando não existe URL original ',
 (){
  final gifMap = <String,dynamic> {
    'id': 'gif-123',
      'title': 'GIF de teste',
      'images': {
        
        
      },
  };
  expect(()=>GifMapper.fromMap(gifMap),
  throwsA(isA<FormatException>()),
  );
 }
 );

  test('lança FormatException quando não existir Id ',
 (){
  final gifMap = <String,dynamic> {
    
      'title': 'GIF de teste',
      'images': {
        'original': {'url': 'https://example.com/original.gif'},
        
      },
  };
  expect(()=>GifMapper.fromMap(gifMap),
  throwsA(isA<FormatException>()),
  );
 }
 );
}