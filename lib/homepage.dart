import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pacman/ghost_blue.dart';
import 'package:pacman/ghost_pink.dart';
import 'package:pacman/ghost_red.dart';
import 'package:pacman/ghost_yellow.dart';
import 'package:pacman/path.dart';
import 'package:pacman/pixel.dart';
import 'package:pacman/player.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  static int rows = 17;
  static int cols = 11;
  static int numberOfFields = rows * cols;
  static int teleport_topPoint = 5;
  static int teleport_bottomPoint = 181;
  static Random generator = new Random();
  static List<int> barriers = [
    0,1,2,3,4,6,7,8,9,10,11,21,22,24,26,28,30,32,33,35,37,39,41,43,44,46,52,54,55,57,59,61,63,65,66,70,72,76,
    77,79,80,81,83,84,85,87,88,98,99,101,102,103,105,106,107,109,110,114,116,120,121,123,125,127,129,131,132,
    134,140,142,143,145,147,149,151,153,154,156,158,160,162,164,165,175,176,177,178,179,180,182,183,184,185,186
  ];

  int player = 93;
  String direction = "";
  bool preGame = true;
  bool mouthClosed = false;
  List<int> eatenFood = [];

  int ghost_blue = 12;
  int ghost_pink = 20;
  int ghost_red = 166;
  int ghost_yellow = 174;

  void startGame(){
    preGame = false;

    Timer.periodic(const Duration(milliseconds: 250), (timer) {
      setState(() {
        mouthClosed = !mouthClosed;
      });

      if (!eatenFood.contains(player)) {
        eatenFood.add(player);
        if (eatenFood.length == numberOfFields - barriers.length) {
          resetGame();
          timer.cancel();
          return;
        }
      }

      if (isMoveAllowed(player, direction)) {
        player = makeMove(player, direction);
      }

      if (isCollisionWithGhost()) {
        resetGame();
        timer.cancel();
        return;
      }

      moveGhosts();

      if (isCollisionWithGhost()) {
        resetGame();
        timer.cancel();
        return;
      }
    });
  }

  bool isCollisionWithGhost(){
    if(player == ghost_red || player == ghost_blue || player == ghost_pink || player == ghost_yellow){
      return true;
    }

    return false;
  }

  void resetGame(){
    setState(() {
      preGame = true;
      mouthClosed = false;
      direction = "";
      eatenFood.clear();
      player = 93;
      ghost_blue = 12;
      ghost_pink = 20;
      ghost_red = 166;
      ghost_yellow = 174;
    });
  }

  void moveGhosts(){
    ghost_red = moveSingleGhost(ghost_red);
    ghost_blue = moveSingleGhost(ghost_blue);
    ghost_yellow = moveSingleGhost(ghost_yellow);
    ghost_pink = moveSingleGhost(ghost_pink);
  }

  int moveSingleGhost(int ghost){
    return makeMove(ghost, generateDirection(ghost));
  }

  String generateDirection(ghost){
    List<String> possibleMoves = [];

    if(isMoveAllowed(ghost, "left")){
      possibleMoves.add("left");
    }

    if(isMoveAllowed(ghost, "right")){
      possibleMoves.add("right");
    }

    if(isMoveAllowed(ghost, "up")){
      possibleMoves.add("up");
    }

    if(isMoveAllowed(ghost, "down")){
      possibleMoves.add("down");
    }

    return possibleMoves.elementAt(generator.nextInt(possibleMoves.length));
  }

  bool isMoveAllowed(index, direction){
    switch(direction){
      case "left":
        if(!barriers.contains(index - 1)){
          return true;
        } else {
            return false;
        }

      case "right":
        if(!barriers.contains(index + 1)){
          return true;
        } else {
            return false;
        }

      case "up":
        if(!barriers.contains(index - cols)){
          return true;
        } else {
            return false;
        }

      case "down":
        if(!barriers.contains(index + cols)){
          return true;
        } else {
            return false;
        }
    }

    return false;
  }

  int makeMove(index, direction){
    switch (direction) {
      case "left":
        index = moveLeft(index);
        break;

      case "right":
        index = moveRight(index);
        break;

      case "up":
        index = moveUp(index);
        break;

      case "down":
        index = moveDown(index);
        break;
    }

    return index;
  }

  int moveLeft(index){
    setState(() {
      index--;
    });

    return index;
  }

  int moveRight(index){
    setState(() {
      index++;
    });

    return index;
  }

  int moveUp(index){
    if(index == teleport_topPoint){
      setState(() {
        index = teleport_bottomPoint;
      });
    } else {
        setState(() {
          index -= cols;
        });
    }

    return index;
  }

  int moveDown(index){
    if(index == teleport_bottomPoint){
      setState(() {
        index = teleport_topPoint;
      });
    } else {
        setState(() {
          index += cols;
        });
    }

    return index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details){
                if(details.delta.dy > 0){
                  direction = "down";
                } else if (details.delta.dy < 0){
                  direction = "up";
                }

                if(preGame){
                  startGame();
                  preGame = false;
                }
              },
              onHorizontalDragUpdate: ((details) {
                if(details.delta.dx > 0){
                  direction = "right";
                } else if (details.delta.dx < 0){
                  direction = "left";
                }

                if(preGame){
                  startGame();
                  preGame = false;
                }
              }),
              child: Container(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: numberOfFields,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if(mouthClosed && player == index){
                        return Padding(padding: EdgeInsets.all(4),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                        ),);
                      } else if(ghost_red == index){
                        return RedGhost();
                      } else if(ghost_blue == index){
                        return BlueGhost();
                      } else if(ghost_pink == index){
                        return PinkGhost();
                      } else if(ghost_yellow == index){
                        return YellowGhost();
                      } else if(player == index){
                          switch(direction){
                            case "left":
                              return Transform.rotate(angle: pi, child: MyPlayer(),);

                            case "right":
                              return MyPlayer();

                            case "up":
                              return Transform.rotate(angle: 3*pi/2, child: MyPlayer(),);

                            case "down":
                              return Transform.rotate(angle: pi/2, child: MyPlayer(),);

                            default: return MyPlayer();
                          }
                      } else if(barriers.contains(index)){
                          return MyPixel(
                            color: Colors.blue[900],
                          );
                      } else if(eatenFood.contains(index)){
                          return MyPixel(
                            color: Colors.black,
                          );
                      } else {
                          return MyPath(
                            innerColor: Colors.yellow,
                            outerColor: Colors.black,
                          );
                      }
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}