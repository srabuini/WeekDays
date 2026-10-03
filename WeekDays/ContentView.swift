//
//  ContentView.swift
//  WeekDays
//
//  Created by Sebastian Rabuini on 26/01/2022.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject private var game: Game
  @State private var isConfirmationPresented = false

  init(isConfirmationPresented: Bool = false) {
    self._isConfirmationPresented = State(initialValue: isConfirmationPresented)
  }

  var body: some View {
    VStack(spacing: 20) {

      HStack {
        Text("High Score: \(highScore)")
        Spacer()
        Text("Score: \(score)")
      }

      Text(formattedDate).font(.title)

      Spacer()

      daysList()

      Spacer()

      currentResult
        .font(.largeTitle)

      Spacer()

      Button(
        action: {
          guard state == .lose else {
              isConfirmationPresented = true
            return
          }
          game.restart()
        }) {
        Text("Restart").font(.title3)
      }
    }
    .padding(.horizontal)
    .confirmationDialog("Please confirm", isPresented: $isConfirmationPresented) {
      Button("Restart Game", role: .destructive) {
        game.restart()
      }

      Button("Cancel", role: .cancel) {}
    }
  }

  private var formattedDate: String {
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

  private var isDisabled: Bool {
    state == .lose
  }

  private func dayColor(for day: String) -> Color {
    guard state == .lose else { return .blue }

    return day == game.currentWeekday ? .red : .gray
  }

  private var currentResult: some View {
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
          game.guess(weekday: day)
        } label: {
          Text(day).font(.title2)
        }
        .disabled(isDisabled)
        .foregroundColor(dayColor(for: day))
      }
    }
  }
}


private enum ContentView_Previews {
  static func lost() -> Game {
    let game = Game()
    game.guess(weekday: "")
    return game
  }

  static func win() -> Game {
    let game = Game()
    game.guess(weekday: game.currentWeekday)
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
  ContentView(isConfirmationPresented: true)
    .environmentObject(ContentView_Previews.fresh())
}

