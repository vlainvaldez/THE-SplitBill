//
//  MainView.swift
//  THE-SplitBill
//
//  Created by alvin joseph valdez on 6/12/23.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
  let store: StoreOf<MainFeature>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack {
        LinearGradient(
          gradient: Gradient(
            colors: [
              Color.pink,
              Color.black
            ]
          ),
          startPoint: .top,
          endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
        
        
        
        VStack {
          Text("Split Bill")
            .font(.largeTitle)
            .foregroundColor(Color.white)
          
          TextField(
            "Amount",
            text: viewStore.binding(\.$amount)
          )
          .padding()
          .background()
          .cornerRadius(10)
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(
                viewStore.invalidAmount ? Color.red : Color.clear,
                lineWidth: 2
              )
          )
          .padding()
          
          HStack {
            TextField(
              "Number Of Persons",
              text: viewStore.binding(\.$personCount)
            )
            .padding()
            .background()
            .cornerRadius(10)
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(
                  viewStore.invalidPersonCount ? Color.red : Color.clear,
                  lineWidth: 2
                )
            )
            .padding()
            
            Button{
              viewStore.send(.increasePersonCount)
            } label: {
              Text("+")
                .font(.title)
                .bold()
                .padding(10)
                .background()
                .cornerRadius(12)
            }
            .padding([.horizontal])
            
            Button {
              viewStore.send(.decreasePersonCount)
            } label: {
              Text("-")
                .font(.title)
                .bold()
                .padding(10)
                .background()
                .cornerRadius(12)
            }
            .padding([.horizontal])
          }
          
          if !viewStore.personItems.isEmpty {
            ScrollView {
              ForEach(viewStore.personItems, id: \.id) { item in
                ZStack {
                  RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.pink)
                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
                  
                  HStack {
                    Text("\(item.name): ")
                      .font(.largeTitle)
                      .foregroundColor(.white)
                      .fontWeight(.bold)
                                      
                    Text("\(item.amount)")
                      .font(.largeTitle)
                      .foregroundColor(.white)
                      .fontWeight(.bold)
                  }
                }
                .padding()
                .frame(height: 100)
              }
            }
          } else {
            Text("Please Input the amount and number of person")
              .foregroundColor(.white)
              .padding()              
          }
        }        
      }
    }
    
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(
      store: Store(
        initialState: MainFeature.State(amount: "0", personCount: "0"),
        reducer: MainFeature()
      )
    )
  }
}
