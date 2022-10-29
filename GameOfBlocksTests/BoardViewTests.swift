//
//  BoardViewTests.swift
//  GameOfBlocksTests
//
//  Created by Giovanni Romaniello on 29/10/22.
//

import XCTest
@testable import GameOfBlocks

final class BoardViewTests: XCTestCase {
    
    private var view: BoardView<MockBoardViewModel>!

    override func setUpWithError() throws {
        view = MockViewFactory.buildBoardView(rows: 5, columns: 5, maxBlocks: 10)
    }

    override func tearDownWithError() throws {
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
    
    func testDrawBoard() {
        let result = view.drawBoard()
        XCTAssertNotNil(result)
    }
}
