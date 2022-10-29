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
        viewModel = BlockViewModel(blockModel: BlockModel(id: 0, position: BlockPosition(row: 0, column: 0)), boardViewModel: mockBoardViewModel)
    }

    override func tearDownWithError() throws {
        mockBoardViewModel = nil
        viewModel = nil
    }

    @MainActor func testMove() throws {
        let previousStatus = viewModel.currentStatus
        let expectation = expectation(description: "move")
        try viewModel.moveBlock(animationDuration: 0.5, completion: { [weak self] in
            guard let self = self else { return }
            self.viewModel.updateStatus(requestedStatus: previousStatus)
            expectation.fulfill()
        })
        XCTAssertEqual(viewModel.currentStatus, .animating)
        wait(for: [expectation], timeout: 0.5)
        XCTAssertTrue(mockBoardViewModel.isUpdateBlockPositionCalled)
        XCTAssertEqual(viewModel.currentStatus, previousStatus)
    }

    func testScore() {
        let result = viewModel.score
        XCTAssertEqual(result, mockBoardViewModel.score(for: BlockPosition(row: 0, column: 0)))
    }
}
