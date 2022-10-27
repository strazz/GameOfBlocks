//
//  BoardViewModel.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 25/10/22.
//

import Foundation

enum BoardStatus {
    case ready
    case animating
    case done
}

protocol BoardViewModelProtocol: ObservableObject {
    var currentStatus: BoardStatus { get }
    var rows: Int { get }
    var columns: Int { get }
    var maxBlocks: Int { get }
    func addBlock(position: CGPoint) throws
    func updateBlockPosition(startingPosition: CGPoint) throws -> CGPoint
    var currentBlocks: [BlockModel] { get }
}

class BoardViewModel: ObservableObject, BoardViewModelProtocol {
    
    let rows: Int
    let columns: Int
    let maxBlocks: Int
    private var blocks: [[BlockModel?]]
    var currentStatus: BoardStatus
    
    @Published var currentBlocks: [BlockModel]
    
    init(rows: Int, columns: Int, maxBlocks: Int) {
        self.rows = rows
        self.columns = columns
        self.maxBlocks = min(rows * columns, maxBlocks)
        blocks = Array(repeating: Array(repeating: nil, count: rows), count: columns)
        currentStatus = .ready
        currentBlocks = []
    }
    
    private func checkIndexes(row: Int, column: Int) throws {
        guard column >= 0, column < columns else {
            throw InvalidArgumentError.columnOutOfBounds(column: column)
        }
        guard row >= 0, row < rows else {
            throw InvalidArgumentError.rowOutOfBounds(row: row)
        }
    }
    
    func addBlock(position: CGPoint) throws {
        let count = currentBlocks.count
        guard count < maxBlocks else {
            throw InvalidArgumentError.maxBlocksReached(maxBlocks: maxBlocks)
        }
        guard currentStatus == .ready else {
            throw InvalidArgumentError.invalidStatus(status: currentStatus)
        }
        let column = Int(position.x)
        let row = Int(position.y)
        try checkIndexes(row: row, column: column)
        guard blocks[column][row] == nil else {
            throw InvalidArgumentError.cellIsFull(position: position)
        }
        let block = BlockModel(id: count, position: position, points: 0)
        blocks[column][row] = block
        currentBlocks = blocks.flatMap({ $0 }).compactMap({ $0 })
    }
    
    @discardableResult
    func updateBlockPosition(startingPosition: CGPoint) throws -> CGPoint {
        let column = Int(startingPosition.x)
        let row = Int(startingPosition.y)
        try checkIndexes(row: row, column: column)
        let currentBlockId = blocks[column][row]?.id
        blocks[column][row] = nil
        let newPosition = CGPoint(x: startingPosition.x, y: startingPosition.y + 1)
        let block = BlockModel(id: currentBlockId ?? 0, position: newPosition, points: 0)
        blocks[column][row] = block
        currentBlocks = blocks.flatMap({ $0 }).compactMap({ $0 })
        return newPosition
    }
}
