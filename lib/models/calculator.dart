import 'package:intl/intl.dart';

class Buttons {
  static const ADD = '+';
  static const SUBTRACT = '-';
  static const MULTIFLY = '×';
  static const DEVIDE = '÷';
  static const one = '1';
  static const two = '2';
  static const three = '3';
  static const four = '4';
  static const five = '5';
  static const six = '6';
  static const seven = '7';
  static const eight = '8';
  static const nine = '9';
  static const zero = '0';
  static const point = '.';
  static const equal = '=';
  static const percentage = '%';
  static const clear = 'C';
  static const delete = '⌫';

  static const OPERATER = [
    Buttons.ADD,
    Buttons.SUBTRACT,
    Buttons.MULTIFLY,
    Buttons.DEVIDE
  ];

  static const NUMBER = [
    Buttons.one,
    Buttons.two,
    Buttons.three,
    Buttons.four,
    Buttons.five,
    Buttons.six,
    Buttons.seven,
    Buttons.eight,
    Buttons.nine,
    Buttons.zero,
  ];

  static const keyboard = [
    Buttons.one,
    Buttons.two,
    Buttons.three,
    Buttons.four,
    Buttons.five,
    Buttons.six,
    Buttons.seven,
    Buttons,eight,
    Buttons,nine,
    Buttons.zero,
    Buttons.ADD,
    Buttons.SUBTRACT,
    Buttons.MULTIFLY,
    Buttons.DEVIDE,
    Buttons.equal,
    Buttons.point,
    Buttons.delete,
    Buttons.clear
  ];
}

// 마지막 배열 연산자 확인 : 연산자면 True
bool isOperator(String lastValue) {
  bool isOperator = false;
  if (Buttons.OPERATER.contains(lastValue)) { isOperator = true; }
  return isOperator;
}

// 숫자 사이에 ,찍기 + 소숫점 아래 6글자 제한
String numberWithComma(num param){
  return new NumberFormat('###,###,###,###.##########').format(param);
}

// 마지막 글자
String lastChar(String sentence){
  return sentence.substring(sentence.length-1);
}

// 마지막 글자 삭제
String delLastChar(String sentence) {
  return sentence.substring(0,sentence.length-1);
}