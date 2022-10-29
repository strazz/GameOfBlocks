//
//  BoardViewModel.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 25/10/22.
//

import Foundation

protocol BoardViewModelProtocol: ObservableObject, StatusProtocol, ScoreProtocol, Resettable {
    var rows: Int { get }
    var columns: Int { get }
    var maxBlocks: Int { get }
    var currentBlocks: [BlockModel] { get }
    func addBlock(position: BlockPosition) throws
    @discardableResult func updateBlockPosition(block: BlockModel) throws -> BlockPosition
    var blocks: [[BlockModel?]] { get }
    var blockCount: Int { get }
    func score(for position: BlockPosition) throws -> Int
}

class BoardViewModel: BoardViewModelProtocol, SafeIndexesProtocol {
    
    let rows: Int
    let columns: Int
    let maxBlocks: Int
    let gameLogic: BoardGameBusinessLogicProtocol
    var blocks: [[BlockModel?]]
    var blockCount: Int
    @Published var currentStatus: BoardStatus
    @Published var currentBlocks: [BlockModel]
    
    func updateStatus(requestedStatus: BoardStatus?) {
        if let requestedStatus = requestedStatus, requestedStatus == .animating {
            currentStatus = requestedStatus
        }
        else if blockCount >= maxBlocks {
            currentStatus = .done
        } else {
            currentStatus = .ready
        }
    }
    
    init(rows: Int, columns: Int, maxBlocks: Int, gameLogic: BoardGameBusinessLogicProtocol) {
        self.rows = rows
        self.columns = columns
        self.gameLogic = gameLogic
        self.maxBlocks = min(rows * columns, maxBlocks)
        blocks = Array(repeating: Array(repeating: nil, count: columns), count: rows)
        currentStatus = .ready
        currentBlocks = []
        blockCount = 0
    }
    
    func addBlock(position: BlockPosition) throws {
        guard blockCount < maxBlocks else {
            throw ApplicationError.maxBlocksReached(maxBlocks: maxBlocks)
        }
        guard currentStatus == .ready else {
            throw ApplicationError.invalidStatus(status: currentStatus)
        }
        let column = position.column
        let row = position.row
        try checkIndexes(row: row, column: column)
        guard blocks[row][column] == nil else {
            throw ApplicationError.cellIsFull(position: position)
        }
        let block = BlockModel(id: blockCount + 1, position: position)
        blocks[row][column] = block
        blockCount += 1
        currentBlocks = blocks.flatMap({ $0 }).compactMap({ $0 })
    }
    
    @discardableResult func updateBlockPosition(block: BlockModel) throws -> BlockPosition {
        let column = block.position.column
        let row = block.position.row
        try checkIndexes(row: row, column: column)
        blocks[row][column] = nil
        let newPosition = gameLogic.nextPosition(for: block.position, blockMatrix: blocks)
        let newBlock = BlockModel(id: blockCount, position: newPosition)
        blocks[newPosition.row][newPosition.column] = newBlock
        currentBlocks = blocks.flatMap({ $0 }).compactMap({ $0 })
        return newPosition
    }
    
    func score(for position: BlockPosition) throws -> Int {
        try gameLogic.getScore(for: position)
    }
    
    func reset() {
        blocks = Array(repeating: Array(repeating: nil, count: columns), count: rows)
        currentStatus = .ready
        currentBlocks = []
        blockCount = 0
    }
    
    var score: Int {
        gameLogic.calculateTotalScore(blockMatrix: blocks)
    }
}
