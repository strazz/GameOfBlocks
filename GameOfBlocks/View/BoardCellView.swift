//
//  BoardCellView.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 27/10/22.
//

import SwiftUI

struct BoardCellView<ViewModel>: View where ViewModel: BoardCellViewModelProtocol {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .border(.black)
            if viewModel.currentStatus == .done && viewModel.score > 0 {
                Text("\(viewModel.score)")
            }
        }
    }
}

struct BoardCellView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.buildCellView(position: BlockPosition(row: 0, column: 0), boardViewModel: nil)
    }
}
