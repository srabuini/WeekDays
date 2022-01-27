//
//  WeekDaysApp.swift
//  WeekDays
//
//  Created by Sebastian Rabuini on 26/01/2022.
//

import SwiftUI

@main
struct WeekDaysApp: App {
  @StateObject private var game = Game()
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(game)
    }
  }
}
