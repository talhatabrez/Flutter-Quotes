// main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse('https://dummyjson.com/quotes/random'));

  if(response.statusCode == 200){
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load the server');
  }
}

class Album{
  final int id;
  final String quote;
  final String author;

  const Album({
    required this.id,
    required this.quote,
    required this.author,
  });

  factory Album.fromJson(Map<String, dynamic> json){
    return switch(json){
      { 'id': int id, 'quote' : String quote, 'author' : String author, } => 
        Album(id: id, quote: quote, author: author), 
        _ => throw const FormatException('Failed to load album')
    };
  }
}

void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  late Future<Album> futureAlbum;
  
  @override
  void initState(){
    super .initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'I generate quotes :-)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetching....'),
        ),
        body: Center(
          child: FutureBuilder(
            future: futureAlbum, 
            builder: (context, snapshot){
              if(snapshot.hasData){
                //return Text(snapshot.data!.quote);
                return Container(
                  color: Colors.amber[700],
                  height: 50,
                  child: Text(snapshot.data!.quote),
                );
              } else if (snapshot.hasError){
                return Text('{$snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
        ),
      ),
    );
  }
}
