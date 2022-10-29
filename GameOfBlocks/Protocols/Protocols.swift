//
//  Protocols.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 29/10/22.
//

import Foundation

enum BoardStatus {
    case ready
    case animating
    case done
    case unknown
}

protocol StatusProtocol {
    var currentStatus: BoardStatus { get }
    func updateStatus(requestedStatus: BoardStatus?)
}

protocol Resettable {
    func reset()
}

protocol SafeIndexesProtocol {
    var rows: Int { get }
    var columns: Int { get }
    func checkIndexes(row: Int, column: Int) throws
}

extension SafeIndexesProtocol {
    func checkIndexes(row: Int, column: Int) throws {
        guard column >= 0, column < columns else {
            throw InvalidArgumentError.columnOutOfBounds(column: column)
        }
        guard row >= 0, row < rows else {
            throw InvalidArgumentError.rowOutOfBounds(row: row)
        }
    }
}
