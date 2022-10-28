//
//  BlockViewModel.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 27/10/22.
//

import Foundation

protocol BlockViewModelProtocol: ObservableObject {
    var boardViewModel: (any BoardViewModelProtocol)? { get }
    var blockModel: BlockModel { get }
    func moveBlock() throws
}

class BlockViewModel: BlockViewModelProtocol {
    weak var boardViewModel: (any BoardViewModelProtocol)?
    var blockModel: BlockModel
    
    init(blockModel: BlockModel, boardViewModel: (any BoardViewModelProtocol)?) {
        self.blockModel = blockModel
        self.boardViewModel = boardViewModel
    }
    
    func moveBlock() throws {
        try boardViewModel?.updateBlockPosition(block: blockModel)
    }
}
