//
//  ContentView.swift
//  Challenge3
//
//  Created by Neloy Kundu on 5/30/20.
//  Copyright © 2020 Neloy Kundu. All rights reserved.
//

import SwiftUI

struct Question {
    let number1:Int
    let number2:Int
    func currentAnswer() -> Int{
        number1*number2
    }
}

struct ContentView: View {
    
    @State private var timesTablesLimit = 1
    @State private var currentTimesTable = []
    @State private var curFirstNumber = 0
    @State private var curSecondNumber = 0
    @State private var curAnswer = 0
    @State private var answerRevealed = false
    @State private var colorsOptions = [Color.red,Color.red,Color.red]
    
    let questionsNumbersString = ["5","10","20","All (30)"]
    let questionsNumbers = [5,10,20,30]
    @State private var decidedQuestions = 0
    @State private var curQuestion = 1
    @State private var score = 0
    @State private var highScore = 0
    
    @State private var choiceColor = Color.white

    @State private var givenChoices:[Int] = [0,0,0]
    
    @State private var gameStarted = false
    var theTitle : some View {
        HStack{
        Spacer()
            Text("Edutainment App").bold()
            
        Spacer()
        }
    }
    
    var body: some View {
        Group{
            VStack{
                Group{
                    theTitle.font(.largeTitle)
                    
                    VStack{
                        Group{
                            Stepper("Questions up to...", value: $timesTablesLimit, in: 1...12).padding()
                            Text("The \(timesTablesLimit) times table").bold().font(.title)
                            Stepper("How many questions", value: $decidedQuestions, in: 0...3).padding()
                            Text("Game type: \(questionsNumbersString[decidedQuestions]) questions").bold().multilineTextAlignment(.center).font(.title)
                            Button(!self.gameStarted ? "Start Game (Highscore : \(self.highScore))": "Question #\(self.curQuestion)"){
                    if !self.gameStarted{
                        self.startGame()
                        }
                    
                        }.font(.title)
                            
                        }
                    }
                Spacer()
                    HStack(spacing: 30){
                        Spacer()
                        Text(!self.gameStarted ? "" : "Score: \(self.score)").font(.title)
                        Spacer()
                    }
                HStack(spacing: 20){
                    Text(!self.gameStarted ? "": "What is ")
                    Text(!self.gameStarted ? "": "\(self.curFirstNumber)")
                    Text(!self.gameStarted ? "": "times")
                    Text(!self.gameStarted ? "": "\(self.curSecondNumber)")
                }.font(.title)
                Spacer()
                    HStack(spacing:100){
                        ForEach(0...2,id:\.self){index in
                            Button(action: {
                                if !self.answerRevealed{
                                    self.questionTransition(response: self.givenChoices[index])
                                    
                                }
                            }) {
                                Text(!self.gameStarted ? "" : "\(self.givenChoices[index])")
                            }.frame(width:50,height: 50).background(self.answerRevealed ? self.colorsOptions[index] : Color.blue)
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .opacity(self.gameStarted ? 0.9 : 0)
                                .animation(.default)
                        }
                    }
                    Spacer()
                }
            }.background(LinearGradient(gradient: Gradient(colors: [.white,.blue]), startPoint: .bottomTrailing, endPoint: .topLeading)).foregroundColor(.white)
        }
    }
    
    func startGame() {
        self.choiceColor = Color.blue
        self.gameStarted = true
        currentTimesTable = []
        for element in 1...timesTablesLimit{
            currentTimesTable.append(element)
        }
        self.newQuestion()
    }
    
    func newQuestion(){
        self.answerRevealed = false
        self.choiceColor = Color.blue
        givenChoices = []
        let question = Question(number1: currentTimesTable.randomElement() as! Int, number2: currentTimesTable.randomElement() as! Int)
        curFirstNumber = question.number1
        curSecondNumber = question.number2
        curAnswer = question.currentAnswer()
        givenChoices.append(curAnswer)
        for _ in 1...2{
            let fake1 = currentTimesTable.randomElement() as! Int
            let fake2 = currentTimesTable.randomElement() as! Int
            givenChoices.append(fake1*fake2)
        }
        givenChoices.shuffle()
        for var i in 0...2 {
            if givenChoices[i] == curAnswer{
                colorsOptions[i] = Color.green
            } else {
                colorsOptions[i] = Color.red
            }
        }
        
    }
    
    func questionTransition(response:Int){
        self.answerRevealed = true
        if response == curAnswer{
            self.score = self.score + 1
            if self.highScore < self.score {
                self.highScore = self.score
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.curQuestion == self.questionsNumbers[self.decidedQuestions]{
                self.gameStarted = false
                self.curQuestion = 1
                self.score = 0
            }else {
                self.curQuestion = self.curQuestion + 1
                self.newQuestion()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
