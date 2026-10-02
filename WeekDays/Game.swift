//
//  Game.swift
//  WeekDays
//
//  Created by Sebastian Rabuini on 26/01/2022.
//

import Foundation
import Combine

final class Game: ObservableObject {
  enum State {
    case playing
    case win
    case lose
  }

  private static let highScoreKey = "highScore"
  private static let userDefaults = UserDefaults.standard
  private static let weekDayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    return formatter
  }()

  static var persistedHighScore: Int {
    get { userDefaults.integer(forKey: highScoreKey) }
    set { userDefaults.set(newValue, forKey: highScoreKey) }
  }

  static var randomDateInCurrentYear: Date {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: Date())
    let from = DateComponents(calendar: calendar, year: year, month: 1, day: 1).date!
    let to = DateComponents(calendar: calendar, year: year, month: 12, day: 31).date!
    return Date.randomBetween(start: from, end: to)
  }

  @Published var highScore: Int
  @Published var score: Int
  @Published var date: Date
  @Published var state: State

  var currentWeekDay: String {
    Self.weekDayFormatter.string(from: date)
  }

  init() {
    highScore = Self.persistedHighScore
    date = Self.randomDateInCurrentYear
    score = 0
    state = .playing
  }

  func tryWith(weekDay: String) {
    if weekDay == currentWeekDay {
      incrementScore(by: 1)
      state = .win
      date = Self.randomDateInCurrentYear
    } else {
      state = .lose
    }
  }

  func restart() {
    highScore = Self.persistedHighScore
    date = Self.randomDateInCurrentYear
    score = 0
    state = .playing
  }

  private func incrementScore(by value: Int) {
    score += value
    updateHighScore()
  }

  private func updateHighScore() {
    guard score > Self.persistedHighScore else { return }
    Self.persistedHighScore = score
    highScore = score
  }
}

