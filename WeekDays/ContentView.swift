//
//  ContentView.swift
//  WeekDays
//
//  Created by Sebastian Rabuini on 26/01/2022.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject private var game: Game
  @State private var confirmationShown = false

  init(confirmationShown: Bool = false) {
    self._confirmationShown = State(initialValue: confirmationShown)
  }

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

  private var date: String {
    DateFormatter
      .localizedString(from: game.date, dateStyle: .medium, timeStyle: .none)
  }

  private var score: Int {
    game.score
  }

  private var highScore: Int {
    game.highScore
  }

  private var state: Game.State {
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

  private func daysList() -> some View {
    VStack(spacing: 8) {
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
}


private enum ContentView_Previews {
  static func lost() -> Game {
    let game = Game()
    game.tryWith(weekDay: "")
    return game
  }

  static func win() -> Game {
    let game = Game()
    game.tryWith(weekDay: game.currentWeekDay)
    return game
  }

  static func fresh() -> Game { Game() }
}

#Preview("Lost Game") {
  ContentView()
    .environmentObject(ContentView_Previews.lost())
}

#Preview("Win Game") {
  ContentView()
    .environmentObject(ContentView_Previews.win())
}

#Preview("Confirmation Dialog") {
  ContentView(confirmationShown: true)
    .environmentObject(ContentView_Previews.fresh())
}
