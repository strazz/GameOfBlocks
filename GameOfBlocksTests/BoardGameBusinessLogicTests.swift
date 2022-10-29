//
//  BoardGameBusinessLogicTests.swift
//  GameOfBlocksTests
//
//  Created by Giovanni Romaniello on 28/10/22.
//

import XCTest
@testable import GameOfBlocks

final class BoardGameBusinessLogicTests: XCTestCase {
    
    private var businessLogic: BoardGameBusinessLogic!
    private var blockMatrix: [[BlockModel?]]!

    override func setUpWithError() throws {
        businessLogic = BoardGameBusinessLogic()
        blockMatrix = Array(repeating: Array(repeating: nil, count: 5), count: 5)
    }

    override func tearDownWithError() throws {
        businessLogic = nil
        blockMatrix = nil
    }

    // tests if updating a position on empty board moves the block on the bottom
    func testNextPositionOnEmptyBoard() throws {
        let block = BlockModel(id: 0, position: BlockPosition(row: 0, column: 0))
        let result = businessLogic.nextPosition(for: block.position, blockMatrix: blockMatrix)
        blockMatrix[result.row][result.column] = BlockModel(id: 0, position: result)
        XCTAssertEqual(result, BlockPosition(row: 4, column: 0))
        XCTAssertEqual(blockMatrix[4][0]?.position, result)
    }

    // tests if updating a position on a board with some blocks stops the block on another one
    func testNextPositionOverBlock() throws {
        let bottomBlock = BlockModel(id: 0, position: BlockPosition(row: 4, column: 0))
        blockMatrix[4][0] = bottomBlock
        let block = BlockModel(id: 0, position: BlockPosition(row: 0, column: 0))
        let result = businessLogic.nextPosition(for: block.position, blockMatrix: blockMatrix)
        blockMatrix[result.row][result.column] = BlockModel(id: 0, position: result)
        XCTAssertEqual(result, BlockPosition(row: 3, column: 0))
        XCTAssertEqual(blockMatrix[3][0]?.position, result)
        XCTAssertEqual(blockMatrix[4][0]?.position, bottomBlock.position)
    }

    // tests if updating a position on a board with some blocks stops the block in bridge position
    func testNextPositionOverBridge() throws {
        let block1 = BlockModel(id: 0, position: BlockPosition(row: 3, column: 0))
        blockMatrix[3][0] = block1
        let block2 = BlockModel(id: 1, position: BlockPosition(row: 4, column: 0))
        blockMatrix[4][0] = block2
        let block3 = BlockModel(id: 2, position: BlockPosition(row: 3, column: 2))
        blockMatrix[3][2] = block3
        let block4 = BlockModel(id: 3, position: BlockPosition(row: 4, column: 2))
        blockMatrix[4][2] = block4
        let newBlock = BlockModel(id: 3, position: BlockPosition(row: 0, column: 1))
        let result = businessLogic.nextPosition(for: newBlock.position, blockMatrix: blockMatrix)
        blockMatrix[result.row][result.column] = BlockModel(id: 0, position: result)
        XCTAssertEqual(result, BlockPosition(row: 3, column: 1))
        XCTAssertEqual(blockMatrix[3][1]?.position, result)
    }
    
    //test invalid column
    func testNextPositionInvalidRow() throws {
        let block = BlockModel(id: 0, position: BlockPosition(row: 5, column: 0))
        let result = businessLogic.nextPosition(for: block.position, blockMatrix: blockMatrix)
        XCTAssertEqual(result, BlockPosition(row: 4, column: 0))
    }
    
    func testPointsForSingleBlock() throws {
        let block = BlockModel(id: 0, position: BlockPosition(row: 0, column: 0))
        blockMatrix[0][0] = block
        let result = businessLogic.calculateScore(for: BlockPosition(row: 0, column: 0), blockMatrix: blockMatrix)
        XCTAssertEqual(result, 5)
    }
    
    func testPointsForBlockOnTop() throws {
        let block1 = BlockModel(id: 0, position: BlockPosition(row: 0, column: 0))
        blockMatrix[0][0] = block1
        let block2 = BlockModel(id: 0, position: BlockPosition(row: 1, column: 0))
        blockMatrix[1][0] = block2
        let block3 = BlockModel(id: 0, position: BlockPosition(row: 2, column: 0))
        blockMatrix[2][0] = block3
        let result_00 = businessLogic.calculateScore(for: BlockPosition(row:0 , column: 0), blockMatrix: blockMatrix)
        XCTAssertEqual(result_00, 15)
        let result_10 = businessLogic.calculateScore(for: BlockPosition(row:1 , column: 0), blockMatrix: blockMatrix)
        XCTAssertEqual(result_10, 10)
        let result_20 = businessLogic.calculateScore(for: BlockPosition(row:2 , column: 0), blockMatrix: blockMatrix)
        XCTAssertEqual(result_20, 5)
    }
    
    func testPointsForEmptyCell() throws {
        let result = businessLogic.calculateScore(for: BlockPosition(row: 0, column: 0), blockMatrix: blockMatrix)
        XCTAssertEqual(result, 0)
    }
    
    func testPointsForEmptyCellUnderBridge() throws {
        let block1 = BlockModel(id: 0, position: BlockPosition(row: 3, column: 0))
        blockMatrix[3][0] = block1
        let block2 = BlockModel(id: 1, position: BlockPosition(row: 4, column: 0))
        blockMatrix[4][0] = block2
        let block3 = BlockModel(id: 2, position: BlockPosition(row: 3, column: 2))
        blockMatrix[3][2] = block3
        let block4 = BlockModel(id: 3, position: BlockPosition(row: 4, column: 2))
        blockMatrix[4][2] = block4
        let block5 = BlockModel(id: 4, position: BlockPosition(row: 3, column: 1))
        blockMatrix[3][1] = block5
        let result = businessLogic.calculateScore(for: BlockPosition(row: 4, column: 1), blockMatrix: blockMatrix)
        XCTAssertEqual(result, 10)
    }
    
    // tests for bridges of two empty rows
    func testPointsForEmptyCellUnderDoubleBridge() throws {
        let block20 = BlockModel(id: 0, position: BlockPosition(row: 2, column: 0))
        blockMatrix[2][0] = block20
        let block30 = BlockModel(id: 1, position: BlockPosition(row: 3, column: 0))
        blockMatrix[3][0] = block30
        let block40 = BlockModel(id: 1, position: BlockPosition(row: 4, column: 0))
        blockMatrix[4][0] = block40
        let block22 = BlockModel(id: 2, position: BlockPosition(row: 2, column: 2))
        blockMatrix[2][2] = block22
        let block32 = BlockModel(id: 2, position: BlockPosition(row: 3, column: 2))
        blockMatrix[3][2] = block32
        let block42 = BlockModel(id: 3, position: BlockPosition(row: 4, column: 2))
        blockMatrix[4][2] = block42
        let block21 = BlockModel(id: 4, position: BlockPosition(row: 2, column: 1))
        blockMatrix[2][1] = block21
        let result41 = businessLogic.calculateScore(for: BlockPosition(row: 4, column: 1), blockMatrix: blockMatrix)
        XCTAssertEqual(result41, 10)
        let result31 = businessLogic.calculateScore(for: BlockPosition(row: 3, column: 1), blockMatrix: blockMatrix)
        XCTAssertEqual(result31, 10)
    }
    
    func testScore() throws {
        let block20 = BlockModel(id: 0, position: BlockPosition(row: 2, column: 0))
        blockMatrix[2][0] = block20
        let block30 = BlockModel(id: 1, position: BlockPosition(row: 3, column: 0))
        blockMatrix[3][0] = block30
        let block40 = BlockModel(id: 1, position: BlockPosition(row: 4, column: 0))
        blockMatrix[4][0] = block40
        let block22 = BlockModel(id: 2, position: BlockPosition(row: 2, column: 2))
        blockMatrix[2][2] = block22
        let block32 = BlockModel(id: 2, position: BlockPosition(row: 3, column: 2))
        blockMatrix[3][2] = block32
        let block42 = BlockModel(id: 3, position: BlockPosition(row: 4, column: 2))
        blockMatrix[4][2] = block42
        let block21 = BlockModel(id: 4, position: BlockPosition(row: 2, column: 1))
        blockMatrix[2][1] = block21
        let result = businessLogic.calculateTotalScore(blockMatrix: blockMatrix)
        XCTAssertEqual(result, 85)
    }
}
