//
//  TestMocks.swift
//  GameOfBlocksTests
//
//  Created by Giovanni Romaniello on 28/10/22.
//

import Foundation
@testable import GameOfBlocks

class MockBoardViewModel: BoardViewModelProtocol {
    var currentBlocks: [BlockModel] = []
    var blocks: [[BlockModel?]] = [[]]
    var blockCount: Int = 0
    var currentStatus: BoardStatus = .ready
    var rows: Int = 5
    var columns: Int = 5
    var maxBlocks: Int = 10
    
    func addBlock(position: BlockPosition) throws { }
    
    var isUpdateBlockPositionCalled = false
    func updateBlockPosition(block: GameOfBlocks.BlockModel) throws -> BlockPosition {
        isUpdateBlockPositionCalled = true
        return BlockPosition(row: 0, column: 0)
    }
    
    var mockScoreForPosition = 5
    func score(for position: GameOfBlocks.BlockPosition) -> Int {
        mockScoreForPosition
    }
    
    var mockTotalScore: Int = 0
    var score: Int {
        mockTotalScore
    }
    
    func reset() {
        isUpdateBlockPositionCalled = false
    }
    
    func updateStatus(requestedStatus: BoardStatus?) {
        if let requestedStatus = requestedStatus {
            currentStatus = requestedStatus
        }
    }
}

class MockBlockViewModel: BlockViewModelProtocol {
    var currentStatus: BoardStatus = .ready
    var id: Int = 0
    var boardViewModel: (any BoardViewModelProtocol)?
    var blockModel: BlockModel = BlockModel(id: 0, position: BlockPosition(row: 0, column: 0), points: 0)
    
    func moveBlock(animationDuration: Double, completion: @escaping () -> Void) throws {
        try boardViewModel?.updateBlockPosition(block: blockModel)
        DispatchQueue.main.async {
            completion()
        }
    }
    
    var score: Int {
        0
    }
    
    func updateStatus(requestedStatus: BoardStatus?) {
        if let requestedStatus {
            currentStatus = requestedStatus
        }
    }
}

class MockBoardGameBusinessLogic: BoardGameBusinessLogicProtocol {
 
    var mockPosition = BlockPosition(row: 0, column: 0)
    func nextPosition(for position: BlockPosition, blockMatrix: [[BlockModel?]]) -> BlockPosition {
        mockPosition
    }
    
    var mockBlockScore: Int = 5
    func calculateScore(for position: BlockPosition, blockMatrix: [[BlockModel?]]) -> Int {
        mockBlockScore
    }
    
    var mockScore: Int = 42
}

extension MockBoardGameBusinessLogic: ScoreProtocol {
    var score: Int {
        mockScore
    }
}
