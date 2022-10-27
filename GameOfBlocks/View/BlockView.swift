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
        Rectangle()
            .fill(Color.blue)
            .onAppear {
                withAnimation {
                    self.viewModel.updateBlockPosition()
                }
            }
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BlockViewModel(blockModel: BlockModel(id: 1, position: .zero, points: 0), boardViewModel: nil)
        BlockView(viewModel: viewModel)
    }
}
