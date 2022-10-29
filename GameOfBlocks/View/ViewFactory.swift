//
//  ViewFactory.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 29/10/22.
//

import Foundation

class ViewFactory {
    
    static func buildBoardView(rows: Int, columns: Int, maxBlocks: Int) -> BoardView<BoardViewModel> {
        let gameLogic = BoardGameBusinessLogic()
        let viewModel = BoardViewModel(rows: rows, columns: columns, maxBlocks: maxBlocks, gameLogic: gameLogic)
        return BoardView(viewModel: viewModel)
    }
    
    static func buildBlockView(block: BlockModel, boardViewModel: (any BoardViewModelProtocol)?) -> BlockView<BlockViewModel> {
        let viewModel = BlockViewModel(blockModel: block, boardViewModel: boardViewModel)
        return BlockView(viewModel: viewModel)
    }
    
    static func buildCellView(position: BlockPosition, boardViewModel: (any BoardViewModelProtocol)?) -> BoardCellView<BoardCellViewModel> {
        let viewModel = BoardCellViewModel(position: position, boardViewModel: boardViewModel)
        return BoardCellView(viewModel: viewModel)
    }
}
