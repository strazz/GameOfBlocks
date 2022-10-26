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
        guard column >= 0, column < columns else {
            throw InvalidArgumentError.columnOutOfBounds(column: column)
        }
        guard row >= 0, row < rows else {
            throw InvalidArgumentError.rowOutOfBounds(row: row)
        }
        guard blocks[column][row] == nil else {
            throw InvalidArgumentError.cellIsFull(position: position)
        }
        let block = BlockModel(id: count, position: position, points: 0)
        blocks[column][row] = block
        currentBlocks = blocks.flatMap({ $0 }).compactMap({ $0 })
    }
}
