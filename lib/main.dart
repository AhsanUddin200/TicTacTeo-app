import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// The root widget of your app.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon Tic Tac Toe',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 36,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const TicTacToeHome(),
    );
  }
}

/// A StatefulWidget that holds the Tic Tac Toe game logic.
class TicTacToeHome extends StatefulWidget {
  const TicTacToeHome({Key? key}) : super(key: key);

  @override
  State<TicTacToeHome> createState() => _TicTacToeHomeState();
}

class _TicTacToeHomeState extends State<TicTacToeHome> {
  List<String> board = List.generate(9, (_) => '');
  bool isXTurn = true;
  String? gameResult;
  List<int> winningCombo = [];

  void _handleTap(int index) {
    if (board[index].isNotEmpty || gameResult != null) return;

    setState(() {
      board[index] = isXTurn ? 'X' : 'O';
      gameResult = _checkForWinner();
      if (gameResult == null) {
        isXTurn = !isXTurn;
      }
    });
  }

  String? _checkForWinner() {
    List<List<int>> winningCombos = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combo in winningCombos) {
      final a = combo[0];
      final b = combo[1];
      final c = combo[2];
      if (board[a].isNotEmpty &&
          board[a] == board[b] &&
          board[b] == board[c]) {
        setState(() {
          winningCombo = combo;
        });
        return '${board[a]} wins!';
      }
    }

    if (!board.contains('')) {
      return 'Draw!';
    }

    return null;
  }

  void _resetGame() {
    setState(() {
      board = List.generate(9, (_) => '');
      isXTurn = true;
      gameResult = null;
      winningCombo.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              gameResult ?? (isXTurn ? "X's Turn" : "O's Turn"),
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final value = board[index];
                  final isWinningCell = winningCombo.contains(index);
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isWinningCell
                            ? Colors.black.withOpacity(0.5)
                            : Colors.transparent,
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: isWinningCell
                                ? Colors.yellowAccent.withOpacity(0.5)
                                : Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: value == 'X'
                                ? Colors.redAccent
                                : Colors.blueAccent,
                            shadows: [
                              Shadow(
                                color: value == 'X'
                                    ? Colors.red.withOpacity(0.6)
                                    : Colors.blue.withOpacity(0.6),
                                blurRadius: 20,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: theme.textTheme.headlineSmall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 10,
                  backgroundColor: Colors.purpleAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: _resetGame,
                child: const Text('Reset Game'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
