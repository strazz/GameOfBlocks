//
//  BlockViewModelTests.swift
//  GameOfBlocksTests
//
//  Created by Giovanni Romaniello on 28/10/22.
//

import XCTest
@testable import GameOfBlocks

final class BlockViewModelTests: XCTestCase {
    
    private var viewModel: BlockViewModel!
    private var mockBoardViewModel: MockBoardViewModel!

    override func setUpWithError() throws {
        mockBoardViewModel = MockBoardViewModel()
        viewModel = BlockViewModel(blockModel: BlockModel(id: 0, position: BlockPosition(row: 0, column: 0), points: 0), boardViewModel: mockBoardViewModel)
    }

    override func tearDownWithError() throws {
        mockBoardViewModel = nil
        viewModel = nil
    }

    func testMove() throws {
        try viewModel.moveBlock()
        XCTAssertTrue(mockBoardViewModel.isUpdateBlockPositionCalled)
    }

    func testScore() {
        let result = viewModel.score
        XCTAssertEqual(result, mockBoardViewModel.score(for: BlockPosition(row: 0, column: 0)))
    }
}
