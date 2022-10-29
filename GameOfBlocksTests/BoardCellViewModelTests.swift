//
//  BoardCellViewModelTests.swift
//  GameOfBlocksTests
//
//  Created by Giovanni Romaniello on 29/10/22.
//

import XCTest
@testable import GameOfBlocks

final class BoardCellViewModelTests: XCTestCase {
    
    private var viewModel: BoardCellViewModel!
    private var mockBoardViewModel: MockBoardViewModel!

    override func setUpWithError() throws {
        mockBoardViewModel = MockBoardViewModel()
        viewModel = BoardCellViewModel(position: BlockPosition(row: 0, column: 0), boardViewModel: mockBoardViewModel)
    }

    override func tearDownWithError() throws {
        mockBoardViewModel = nil
        viewModel = nil
    }

    func testScore() throws {
        let result = viewModel.score
        XCTAssertEqual(result, mockBoardViewModel.score(for: BlockPosition(row: 0, column: 0)))
    }
    
    func testCurrentStatus() {
        XCTAssertEqual(viewModel.currentStatus, mockBoardViewModel.currentStatus)
    }
    
    func testUpdateStatus() {
        viewModel.updateStatus(requestedStatus: .animating)
        XCTAssertEqual(mockBoardViewModel.currentStatus, .animating)
    }
}
