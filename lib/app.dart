
import 'package:flutter/material.dart';

class App extends StatelessWidget {
	const App({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('IT Asset Management System')),
			body: const Center(child: Text('Welcome to IT Asset Management System')),
		);
	}
}

