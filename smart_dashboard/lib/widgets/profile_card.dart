import 'package:flutter/material.dart'; 
      
class ProfileCard extends StatelessWidget { 
  const ProfileCard({super.key}); 

  @override 
  Widget build(BuildContext context) { 
    return Card( 
      child: ListTile( 
        leading: const CircleAvatar( 
          child: Icon(Icons.person), 
        ), 
        title: const Text("Clyde Ivan Lucido"), 
        subtitle: const Text("Bachelor of Science in Information Technology"), 
      ), 
    ); 
  } 
} 