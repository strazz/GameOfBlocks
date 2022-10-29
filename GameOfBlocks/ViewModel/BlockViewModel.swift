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
    func moveBlock(animationDuration: Double, completion: @escaping() -> Void) throws
}

class BlockViewModel: BlockViewModelProtocol {
    weak var boardViewModel: (any BoardViewModelProtocol)?
    var blockModel: BlockModel
    
    init(blockModel: BlockModel, boardViewModel: (any BoardViewModelProtocol)?) {
        self.blockModel = blockModel
        self.boardViewModel = boardViewModel
    }
    
    func moveBlock(animationDuration: Double, completion: @escaping() -> Void) throws {
        boardViewModel?.updateStatus(requestedStatus: .animating)
        try boardViewModel?.updateBlockPosition(block: blockModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, execute: {
            completion()
        })
    }
    
    var score: Int {
        let result = try? boardViewModel?.score(for: blockModel.position)
        return result ?? 0
    }
    
    var currentStatus: BoardStatus {
        boardViewModel?.currentStatus ?? .unknown
    }
    
    func updateStatus(requestedStatus: BoardStatus?) {
        boardViewModel?.updateStatus(requestedStatus: requestedStatus)
    }
}
