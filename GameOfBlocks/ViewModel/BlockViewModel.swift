//
//  BlockViewModel.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 27/10/22.
//

import Foundation

protocol ScoreProtocol {
    var score: Int { get }
}

protocol BlockViewModelProtocol: ObservableObject, ScoreProtocol, StatusProtocol {
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
    
    var score: Int {
        let result = try? boardViewModel?.score(for: blockModel.position)
        return result ?? 0
    }
    
    var currentStatus: BoardStatus {
        boardViewModel?.currentStatus ?? .unknown
    }
}
