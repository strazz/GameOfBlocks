//
//  BlockView.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 26/10/22.
//

import SwiftUI

struct BlockView<ViewModel>: View where ViewModel: BlockViewModelProtocol {
    
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.3)) {
                        try? viewModel.moveBlock(animationDuration: 0.3) {
                            viewModel.updateStatus(requestedStatus: .ready)
                        }
                    }

                }
            if viewModel.currentStatus == .done {
                Text("\(viewModel.score)")
            }
        }
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        let block = BlockModel(id: 0, position: BlockPosition(row: 0, column: 0))
        ViewFactory.buildBlockView(block: block, boardViewModel: nil)
    }
}
