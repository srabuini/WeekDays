//
//  ContentView.swift
//  WeekDays
//
//  Created by Sebastian Rabuini on 26/01/2022.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var game: Game
  @State var confirmationShown = false

  var body: some View {
    VStack(spacing: 20) {

      HStack {
        Text("High Score: \(highScore)")
        Spacer()
        Text("Score: \(score)")
      }

      Text(date).font(.title)

      Spacer()

      daysList()

      Spacer()

      currentResult()
        .font(.largeTitle)

      Spacer()

      Button(
        action: {
          guard state == .lose else {
            confirmationShown = true
            return
          }
          game.restart()
        }) {
        Text("Restart").font(.title3)
      }
    }
    .padding(.horizontal)
    .confirmationDialog("Please confirm", isPresented: $confirmationShown) {
      Button("Restart Game", role: .destructive) {
        game.restart()
      }

      Button("Cancel", role: .cancel) {}
    }
  }

  var date: String {
    DateFormatter
      .localizedString(from: game.date, dateStyle: .medium, timeStyle: .none)
  }

  var score: Int {
    game.score
  }

  var highScore: Int {
    game.highScore
  }

  var state: Game.State {
    game.state
  }

  private var disabled: Bool {
    state == .lose
  }

  private func dayColor(for day: String) -> Color {
    guard state == .lose else { return .blue }

    return day == game.currentWeekDay ? .red : .gray
  }

  private func currentResult() -> some View {
    switch state {
    case .win:
      return Text("😃")
    case .lose:
      return Text("🙄")
    default:
      return Text("")
    }
  }

  private func daysList() ->  some View {
    ForEach(Calendar.current.weekdaySymbols, id: \.self) { day in
      Button {
        game.tryWith(weekDay: day)
      } label: {
        Text(day).font(.title2)
      }
      .disabled(disabled)
      .foregroundColor(dayColor(for: day))
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  @State static var confirmationShown = true
  static var lostGame = Game()
  static var winGame = Game()
  static var game = Game()

  static var previews: some View {
    lostGame.tryWith(weekDay: "foo")
    winGame.tryWith(weekDay: winGame.currentWeekDay)

    return Group {
      ContentView()
        .environmentObject(lostGame)

      ContentView()
        .environmentObject(winGame)

      ContentView(confirmationShown: confirmationShown)
        .environmentObject(game)
    }
  }
}
