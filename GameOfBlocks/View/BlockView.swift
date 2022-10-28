//
//  BlockView.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 26/10/22.
//

import SwiftUI

struct BlockView: View {
    
    var viewModel: any BlockViewModelProtocol
    
    init(viewModel: any BlockViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .onAppear {
                withAnimation {
                    try? self.viewModel.moveBlock()
                }
            }
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BlockViewModel(
            blockModel: BlockModel(
                id: 0,
                position: BlockPosition(row: 0, column: 0),
                points: 0),
            boardViewModel: nil)
        BlockView(viewModel: viewModel)
    }
}
