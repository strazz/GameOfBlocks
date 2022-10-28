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
    
    func updateBlockPosition(block: GameOfBlocks.BlockModel) throws -> BlockPosition {
        BlockPosition(row: 0, column: 0)
    }
}

class MockBlockViewModel: BlockViewModelProtocol {
    var id: Int = 0
    var boardViewModel: (any BoardViewModelProtocol)?
    var blockModel: BlockModel = BlockModel(id: 0, position: BlockPosition(row: 0, column: 0), points: 0)
    func moveBlock() throws { }
}

class MockBoardGameBusinessLogic: BoardGameBusinessLogicProtocol {
    var mockValue = BlockPosition(row: 0, column: 0)
    func nextPosition(for block: BlockModel, blockMatrix: [[BlockModel?]]) -> BlockPosition {
        mockValue
    }
}
