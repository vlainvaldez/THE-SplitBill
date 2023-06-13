//
//  MainFeature.swift
//  THE-SplitBill
//
//  Created by alvin joseph valdez on 6/12/23.
//

import ComposableArchitecture
import Foundation

struct MainFeature: ReducerProtocol {
  
  struct State: Equatable {

    @BindingState var amount: String
    @BindingState var personCount: String
    @BindingState var invalidAmount: Bool = false
    @BindingState var invalidPersonCount: Bool = false
    var personItems: IdentifiedArrayOf<Person> = []

  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case increasePersonCount
    case decreasePersonCount
  }
  
  var body: some ReducerProtocolOf<Self> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .binding:
        state.invalidAmount = Double(state.amount) == nil && !state.amount.isEmpty
        state.invalidPersonCount = Double(state.personCount) == nil && !state.personCount.isEmpty
        
        if !state.invalidAmount && !state.invalidPersonCount {
          let bill = splitBillComputation(
            amountString: state.amount,
            personcountString: state.personCount
          )
          
          guard
            let personCount = Int(state.personCount),
            personCount > 1
          else {
            state.personItems = []
            return .none
          }
          
          var personItems: IdentifiedArrayOf<Person> = []
          
          let formatter = NumberFormatter()
          formatter.numberStyle = .currency
          formatter.currencyCode = "PHP"

          if let formattedValue = formatter.string(from: NSNumber(value: bill)) {
            for item in 1...personCount {
              personItems.append(.init(name: "Person \(item)", amount: "\(formattedValue)" ))
            }
            state.personItems = personItems
          }
        } else {
          state.personItems = []
        }
        
        return .none
        
      case .increasePersonCount:
        guard
          var personCountInt = Int(state.personCount)
        else { return .none }
        
        personCountInt += 1
        state.personCount = "\(max(0, personCountInt))"
        return .send(.binding(.set(\.$personCount, state.personCount)))
        
      case .decreasePersonCount:
        guard
          var personCountInt = Int(state.personCount)
        else { return .none }
        
        personCountInt -= 1
        state.personCount = "\(max(0, personCountInt))"

        return .send(.binding(.set(\.$personCount, state.personCount)))
      }
    }
  }
  
  
  func formatAmount(_ amount: String) -> Double {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    
    if let doubleValue = Double(amount) {
      return doubleValue
    }
    
    return 0
  }
  
  func splitBillComputation(amountString: String, personcountString: String) ->  Double {
    let amount = self.formatAmount(amountString)
    
    if let personCount = Double(personcountString), amount != 0.0 {
      let billAmount = amount / personCount
      return billAmount
    }
    
    return 0.0
  }

}

// Model

struct Person: Identifiable, Equatable {
  var id = UUID()
  var name: String
  var amount: String
}
