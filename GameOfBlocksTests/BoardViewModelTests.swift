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
    private var businessLogic: MockBoardGameBusinessLogic!
    
    override func setUpWithError() throws {
        businessLogic = MockBoardGameBusinessLogic()
        viewModel = BoardViewModel(rows: 5, columns: 5, maxBlocks: 10, gameLogic: businessLogic)
    }
    
    override func tearDownWithError() throws {
        businessLogic = nil
        viewModel = nil
    }
    
    func testBoardSize() throws {
        XCTAssertEqual(viewModel.rows, 5)
        XCTAssertEqual(viewModel.columns, 5)
    }
    
    // tests maxBlocks variable init
    func testMaxBlocks() throws {
        let testViewModel = BoardViewModel(rows: 1, columns: 1, maxBlocks: 10, gameLogic: MockBoardGameBusinessLogic())
        XCTAssertEqual(testViewModel.maxBlocks, 1)
        let testViewModel2 = BoardViewModel(rows: 5, columns: 5, maxBlocks: 10, gameLogic: MockBoardGameBusinessLogic())
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
            XCTAssertEqual(error.localizedDescription, InvalidArgumentError.maxBlocksReached(maxBlocks: 10).localizedDescription)
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
            XCTAssertEqual(error.localizedDescription, InvalidArgumentError.invalidStatus(status: .done).localizedDescription)
        }
    }
    
    // tests if we cannot add blocks at same position
    func testAddSameBlocks() throws {
        try viewModel.addBlock(position: BlockPosition(row: 0, column: 0))
        XCTAssertThrowsError(try viewModel.addBlock(position: BlockPosition(row: 0, column: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.cellIsFull(position: BlockPosition(row: 0, column: 0)))
            XCTAssertEqual(error.localizedDescription, InvalidArgumentError.cellIsFull(position: BlockPosition(row: 0, column: 0)).localizedDescription)
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
            XCTAssertEqual(error.localizedDescription, InvalidArgumentError.rowOutOfBounds(row: -1).localizedDescription)
        }
        XCTAssertThrowsError(try viewModel.addBlock(position: BlockPosition(row: 0, column: -1))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.columnOutOfBounds(column: -1))
            XCTAssertEqual(error.localizedDescription, InvalidArgumentError.columnOutOfBounds(column: -1).localizedDescription)
        }
        let result = viewModel.blocks
        XCTAssertEqual(result.flatMap({ $0 }).compactMap({ $0 }).count, 0)
        XCTAssertEqual(viewModel.blockCount, 0)
    }
    
    // out of bounds indexes are not valid
    func testOutOfBoundsIndexes() throws {
        XCTAssertThrowsError(try viewModel.addBlock(position: BlockPosition(row: 5, column: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.rowOutOfBounds(row: 5))
            XCTAssertEqual(error.localizedDescription, InvalidArgumentError.rowOutOfBounds(row: 5).localizedDescription)
        }
        XCTAssertThrowsError(try viewModel.addBlock(position: BlockPosition(row: 0, column: 6))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.columnOutOfBounds(column: 6))
            XCTAssertEqual(error.localizedDescription, InvalidArgumentError.columnOutOfBounds(column: 6).localizedDescription)
        }
        let result = viewModel.blocks
        XCTAssertEqual(result.flatMap({ $0 }).compactMap({ $0 }).count, 0)
        XCTAssertEqual(viewModel.blockCount, 0)
    }
    
    // tests that updateBlockPosition returns business logic result and updates matrix
    func testUpdateBlockPosition() throws {
        let block = BlockModel(id: 0, position: BlockPosition(row: 0, column: 0), points: 0)
        businessLogic.mockPosition = BlockPosition(row: 4, column: 0)
        try viewModel.addBlock(position: BlockPosition(row: 0, column: 0))
        let result = try viewModel.updateBlockPosition(block: block)
        XCTAssertEqual(result, businessLogic.mockPosition)
        XCTAssertEqual(viewModel.blocks[4][0]?.position, result)
    }
}
