//
//  Game.swift
//  WeekDays
//
//  Created by Sebastian Rabuini on 26/01/2022.
//

import Foundation
import SwiftUI
import Combine

class Game: ObservableObject {
  enum State {
    case playing
    case win
    case lose
  }
  
  static let userDefaults = UserDefaults.standard
  static var highScore: Int {
    get {
      if let highScore = userDefaults.value(forKey: "highScore") {
        return highScore as! Int
      } else {
        return 0
      }
    }
    
    set {
      userDefaults.setValue(newValue, forKey: "highScore")
    }
  }
  
  static var date: Date {
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
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    
    return dateFormatter.string(from: date)
  }
  
  init() {
    self.highScore = Self.highScore
    self.date = Self.date
    self.score = 0
    self.state = .playing
  }
  
  func tryWith(weekDay: String) {
    if weekDay == currentWeekDay {
      incrementScore(by: 1)
      state = .win
      self.date = Self.date
    } else {
      state = .lose
    }
  }
  
  func restart() {
    self.highScore = Self.highScore
    self.date = Self.date
    self.score = 0
    self.state = .playing
  }
  
  private func incrementScore(by value: Int) {
    self.score += value
    
    if score > Game.highScore {
      Game.highScore = score
      self.highScore = score
    }
  }
}
