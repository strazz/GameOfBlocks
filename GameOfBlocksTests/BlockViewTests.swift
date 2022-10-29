//
//  BlockViewTests.swift
//  GameOfBlocksTests
//
//  Created by Giovanni Romaniello on 29/10/22.
//

import XCTest

import XCTest
@testable import GameOfBlocks

final class BlockViewTests: XCTestCase {
    
    private var view: BlockView<MockBlockViewModel>!
    private var mockBoardViewModel: MockBoardViewModel!

    override func setUpWithError() throws {
        mockBoardViewModel = MockBoardViewModel()
        view = MockViewFactory.buildBlockView(block: BlockModel(id: 0, position: BlockPosition(row: 0, column: 0), points: 0), boardViewModel: mockBoardViewModel)
    }

    override func tearDownWithError() throws {
        mockBoardViewModel = nil
        view = nil
    }

    func testView() throws {
        let viewBody = view.body
        XCTAssertNotNil(viewBody)
    }

    func testViewInDoneStatus() {
        view.viewModel.updateStatus(requestedStatus: .done)
        let viewBody = view.body
        XCTAssertNotNil(viewBody)
    }
}
