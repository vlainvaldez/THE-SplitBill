//
//  THE_SplitBillApp.swift
//  THE-SplitBill
//
//  Created by alvin joseph valdez on 6/12/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct THE_SplitBillApp: App {
  var body: some Scene {
    WindowGroup {
      MainView(store: Store(
          initialState: MainFeature.State(amount: "", personCount: ""),
          reducer: MainFeature()
        )
      )
    }
  }
}
