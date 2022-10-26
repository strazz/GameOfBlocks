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
        viewModel = BoardViewModel(rows: 5, columns: 5, maxBlocks: 10)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testBoardSize() throws {
        XCTAssertEqual(viewModel.rows, 5)
        XCTAssertEqual(viewModel.columns, 5)
    }
    
    // tests if we can add multiple blocks
    func testAddBlocks() throws {
        try viewModel.addBlock(position: CGPoint(x: 0, y: 0))
        try viewModel.addBlock(position: CGPoint(x: 1, y: 1))
        let result = viewModel.currentBlocks
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].position, CGPoint(x: 0, y: 0))
        XCTAssertEqual(result[1].position, CGPoint(x: 1, y: 1))
    }
    
    // tests that we cannot add blocks if status is not ready
    func testAddBlockExceedingMax() throws {
        try viewModel.addBlock(position: CGPoint(x: 0, y: 0))
        try viewModel.addBlock(position: CGPoint(x: 0, y: 1))
        try viewModel.addBlock(position: CGPoint(x: 0, y: 2))
        try viewModel.addBlock(position: CGPoint(x: 0, y: 3))
        try viewModel.addBlock(position: CGPoint(x: 0, y: 4))
        try viewModel.addBlock(position: CGPoint(x: 1, y: 0))
        try viewModel.addBlock(position: CGPoint(x: 1, y: 1))
        try viewModel.addBlock(position: CGPoint(x: 1, y: 2))
        try viewModel.addBlock(position: CGPoint(x: 1, y: 3))
        try viewModel.addBlock(position: CGPoint(x: 1, y: 4))
        XCTAssertThrowsError(try viewModel.addBlock(position: CGPoint(x: 2, y: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.maxBlocksReached(maxBlocks: 10))
        }
        let result = viewModel.currentBlocks
        XCTAssertEqual(result.count, viewModel.maxBlocks)
    }
    
    // tests that we cannot add a block if status is not ready
    func testInvalidStatusAddBlock() throws {
        viewModel.currentStatus = .animating
        XCTAssertThrowsError(try viewModel.addBlock(position: CGPoint(x: 0, y: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.invalidStatus(status: .animating))
        }
        viewModel.currentStatus = .done
        XCTAssertThrowsError(try viewModel.addBlock(position: CGPoint(x: 0, y: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.invalidStatus(status: .done))
        }
    }
    
    // tests if we cannot add blocks at same position
    func testAddSameBlocks() throws {
        try viewModel.addBlock(position: CGPoint(x: 0, y: 0))
        XCTAssertThrowsError(try viewModel.addBlock(position: CGPoint(x: 0, y: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.cellIsFull(position: CGPoint(x: 0, y: 0)))
        }
        let result = viewModel.currentBlocks
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].position, CGPoint(x: 0, y: 0))
    }
    
    // negative indexes are not valid
    func testInvalidIndexes() throws {
        XCTAssertThrowsError(try viewModel.addBlock(position: CGPoint(x: 0, y: -1))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.rowOutOfBounds(row: -1))
        }
        XCTAssertThrowsError(try viewModel.addBlock(position: CGPoint(x: -1, y: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.columnOutOfBounds(column: -1))
        }
        let result = viewModel.currentBlocks
        XCTAssertEqual(result.count, 0)
    }
    
    // out of bounds indexes are not valid
    func testOutOfBoubndsIndexes() throws {
        XCTAssertThrowsError(try viewModel.addBlock(position: CGPoint(x: 0, y: 6))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.rowOutOfBounds(row: 6))
        }
        XCTAssertThrowsError(try viewModel.addBlock(position: CGPoint(x: 6, y: 0))) { error in
            XCTAssertEqual(error as! InvalidArgumentError, InvalidArgumentError.columnOutOfBounds(column: 6))
        }
        let result = viewModel.currentBlocks
        XCTAssertEqual(result.count, 0)
    }
    
    // tests maxBlocks variable init
    func testMaxBlocks() throws {
        let testViewModel = BoardViewModel(rows: 1, columns: 1, maxBlocks: 10)
        XCTAssertEqual(testViewModel.maxBlocks, 1)
        let testViewModel2 = BoardViewModel(rows: 5, columns: 5, maxBlocks: 10)
        XCTAssertEqual(testViewModel2.maxBlocks, 10)
    }
}
