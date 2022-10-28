//
//  GameOfBlocksTests.swift
//  GameOfBlocksTests
//
//  Created by Giovanni Romaniello on 25/10/22.
//

import XCTest
@testable import GameOfBlocks

final class BoardViewModelTests: XCTestCase {
    
    private var viewModel: BoardViewModel!
    
    override func setUpWithError() throws {
        viewModel = BoardViewModel(rows: 5, columns: 5, maxBlocks: 10, gameLogic: BoardGameBusinessLogic())
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testBoardSize() throws {
        XCTAssertEqual(viewModel.rows, 5)
        XCTAssertEqual(viewModel.columns, 5)
    }
    
    // tests maxBlocks variable init
    func testMaxBlocks() throws {
        let testViewModel = BoardViewModel(rows: 1, columns: 1, maxBlocks: 10, gameLogic: BoardGameBusinessLogic())
        XCTAssertEqual(testViewModel.maxBlocks, 1)
        let testViewModel2 = BoardViewModel(rows: 5, columns: 5, maxBlocks: 10, gameLogic: BoardGameBusinessLogic())
        XCTAssertEqual(testViewModel2.maxBlocks, 10)
    }
    
    // tests if we can add multiple blocks
    func testAddBlocks() throws {
        try viewModel.addBlock(position: BlockPosition(row: 0, column: 0))
        try viewModel.addBlock(position: BlockPosition(row: 1, column: 1))
        let result = viewModel.blocks
        XCTAssertEqual(result.flatMap({ $0 }).compactMap({ $0 }).count, 2)
        XCTAssertEqual(viewModel.blockCount, 2)
        XCTAssertEqual(result[0][0]?.position, BlockPosition(row: 0, column: 0))
        XCTAssertEqual(result[1][1]?.position, BlockPosition(row: 1, column: 1))
    }
    
    func testAddBlocksOnBorders() throws {
        try viewModel.addBlock(position: BlockPosition(row: 0, column: 0))
        try viewModel.addBlock(position: BlockPosition(row: 4, column: 4))
        let result = viewModel.blocks
        XCTAssertEqual(result.flatMap({ $0 }).compactMap({ $0 }).count, 2)
        XCTAssertEqual(viewModel.blockCount, 2)
        XCTAssertEqual(result[0][0]?.position, BlockPosition(row: 0, column: 0))
        XCTAssertEqual(result[4][4]?.position, BlockPosition(row: 4, column: 4))
    }
    
    // tests that we cannot add blocks if reached max limit
    func testAddBlockExceedingMax() throws {
        try viewModel.addBlock(position: BlockPosition(row: 0, column: 0))
        try viewModel.addBlock(position: BlockPosition(row: 0, column: 1))
        try viewModel.addBlock(position: BlockPosition(row: 0, column: 2))
        try viewModel.addBlock(position: BlockPosition(row: 0, column: 3))
        try viewModel.addBlock(position: BlockPosition(row: 0, column: 4))
        try viewModel.addBlock(position: BlockPosition(row: 1, column: 0))
        try viewModel.addBlock(position: BlockPosition(row: 1, column: 1))
        try viewModel.addBlock(position: BlockPosition(row: 1, column: 2))
        try viewModel.addBlock(position: BlockPosition(row: 1, column: 3))
        try viewModel.addBlock(position: BlockPosition(row: 1, column: 4))
        XCTAssertThrowsError(try viewModel.addBlock(position: BlockPosition(row: 2, column: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.maxBlocksReached(maxBlocks: 10))
        }
        let result = viewModel.blocks
        XCTAssertEqual(result.flatMap({ $0 }).compactMap({ $0 }).count, viewModel.maxBlocks)
        XCTAssertEqual(viewModel.blockCount, viewModel.maxBlocks)
    }
    
    // tests that we cannot add a block if status is not ready
    func testInvalidStatusAddBlock() throws {
        viewModel.currentStatus = .done
        XCTAssertThrowsError(try viewModel.addBlock(position: BlockPosition(row: 0, column: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.invalidStatus(status: .done))
        }
    }
    
    // tests if we cannot add blocks at same position
    func testAddSameBlocks() throws {
        try viewModel.addBlock(position: BlockPosition(row: 0, column: 0))
        XCTAssertThrowsError(try viewModel.addBlock(position: BlockPosition(row: 0, column: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.cellIsFull(position: BlockPosition(row: 0, column: 0)))
        }
        let result = viewModel.blocks
        XCTAssertEqual(viewModel.blockCount, 1)
        XCTAssertEqual(result.flatMap({ $0 }).compactMap({ $0 }).count, 1)
        XCTAssertEqual(result[0][0]?.position, BlockPosition(row: 0, column: 0))
    }
    
    // negative indexes are not valid
    func testInvalidIndexes() throws {
        XCTAssertThrowsError(try viewModel.addBlock(position: BlockPosition(row: -1, column: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.rowOutOfBounds(row: -1))
        }
        XCTAssertThrowsError(try viewModel.addBlock(position: BlockPosition(row: 0, column: -1))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.columnOutOfBounds(column: -1))
        }
        let result = viewModel.blocks
        XCTAssertEqual(result.flatMap({ $0 }).compactMap({ $0 }).count, 0)
        XCTAssertEqual(viewModel.blockCount, 0)
    }
    
    // out of bounds indexes are not valid
    func testOutOfBoubndsIndexes() throws {
        XCTAssertThrowsError(try viewModel.addBlock(position: BlockPosition(row: 5, column: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.rowOutOfBounds(row: 5))
        }
        XCTAssertThrowsError(try viewModel.addBlock(position: BlockPosition(row: 0, column: 6))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.columnOutOfBounds(column: 6))
        }
        let result = viewModel.blocks
        XCTAssertEqual(result.flatMap({ $0 }).compactMap({ $0 }).count, 0)
        XCTAssertEqual(viewModel.blockCount, 0)
    }
    
    // tests if updating a position on empty board moves the block on the bottom
    func testUpdateBlockPositionOnEmptyBoard() throws {
        let block = BlockModel(id: 0, position: BlockPosition(row: 0, column: 0), points: 0)
        try viewModel.addBlock(position: BlockPosition(row: 0, column: 0))
        let result = try viewModel.updateBlockPosition(block: block)
        XCTAssertEqual(result, BlockPosition(row: 4, column: 0))
        XCTAssertEqual(viewModel.blocks[4][0]?.position, result)
    }
    
    // tests if updating a position on a board with some blocks stops the block on another one
    func testUpdateBlockPositionOverBlock() throws {
        let bottomBlock = BlockModel(id: 0, position: BlockPosition(row: 4, column: 0), points: 0)
        try viewModel.addBlock(position: bottomBlock.position)
        let block = BlockModel(id: 0, position: BlockPosition(row: 0, column: 0), points: 0)
        try viewModel.addBlock(position: block.position)
        let result = try viewModel.updateBlockPosition(block: block)
        XCTAssertEqual(result, BlockPosition(row: 3, column: 0))
        XCTAssertEqual(viewModel.blocks[3][0]?.position, result)
        XCTAssertEqual(viewModel.blocks[4][0]?.position, bottomBlock.position)
    }
    
    // tests if updating a position on a board with some blocks stops the block in bridge position
    func testUpdateBlockPositionOverBridge() throws {
        let block1 = BlockModel(id: 0, position: BlockPosition(row: 3, column: 0), points: 0)
        let block2 = BlockModel(id: 1, position: BlockPosition(row: 4, column: 0), points: 0)
        let block3 = BlockModel(id: 2, position: BlockPosition(row: 3, column: 2), points: 0)
        let block4 = BlockModel(id: 3, position: BlockPosition(row: 4, column: 2), points: 0)
        let newBlock = BlockModel(id: 3, position: BlockPosition(row: 0, column: 1), points: 0)
        try viewModel.addBlock(position: block1.position)
        try viewModel.addBlock(position: block2.position)
        try viewModel.addBlock(position: block3.position)
        try viewModel.addBlock(position: block4.position)
        try viewModel.addBlock(position: newBlock.position)
        let result = try viewModel.updateBlockPosition(block: newBlock)
        XCTAssertEqual(result, BlockPosition(row: 3, column: 1))
        XCTAssertEqual(viewModel.blocks[3][1]?.position, result)
    }
}
