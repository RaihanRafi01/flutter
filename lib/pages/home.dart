import 'package:flutter/material.dart';
import 'package:rest_api_practise/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> posts;

  @override
  void initState() {
    super.initState();
    posts = apiService.fetchPosts();
  }

  void _createPost() async {
    try {
      var newPost = await apiService.createPost('New Post', 'This is a new post', 1);
      print('Created Post: $newPost');
      setState(() {
        posts = apiService.fetchPosts();
      });
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  void _updatePost(int id) async {
    try {
      var updatedPost = await apiService.updatePost(id, 'Updated Post', 'This is an updated post');
      print('Updated Post: $updatedPost');
      setState(() {
        posts = apiService.fetchPosts();
      });
    } catch (e) {
      print('Error updating post: $e');
    }
  }

  void _deletePost(int id) async {
    try {
      await apiService.deletePost(id);
      print('Deleted Post with ID: $id');
      setState(() {
        posts = apiService.fetchPosts();
      });
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD REST API Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _createPost,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return ListTile(
                  title: Text(post['title']),
                  subtitle: Text(post['body']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _updatePost(post['id']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePost(post['id']),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}