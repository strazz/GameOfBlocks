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
}

class MockBlockViewModel: BlockViewModelProtocol {
    var id: Int = 0
    var boardViewModel: (any BoardViewModelProtocol)?
    var blockModel: BlockModel = BlockModel(id: 0, position: BlockPosition(row: 0, column: 0), points: 0)
    func moveBlock() throws {
        try boardViewModel?.updateBlockPosition(block: blockModel)
    }
}

class MockBoardGameBusinessLogic: BoardGameBusinessLogicProtocol {
    var mockPosition = BlockPosition(row: 0, column: 0)
    func nextPosition(for position: BlockPosition, blockMatrix: [[BlockModel?]]) -> BlockPosition {
        mockPosition
    }
    
    var mockPoints: Int = 0
    func calculatePoints(for position: GameOfBlocks.BlockPosition, blockMatrix: [[GameOfBlocks.BlockModel?]]) -> Int {
        mockPoints
    }
}
