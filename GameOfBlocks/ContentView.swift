//
//  ContentView.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 25/10/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            BoardView(
                viewModel: BoardViewModel(
                    rows: 5,
                    columns: 5,
                    maxBlocks: 10,
                    gameLogic: BoardGameBusinessLogic()))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
