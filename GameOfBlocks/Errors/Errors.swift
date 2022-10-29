//
//  Errors.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 26/10/22.
//

import Foundation

enum InvalidArgumentError: LocalizedError, Equatable {
    
    case columnOutOfBounds(column: Int)
    case rowOutOfBounds(row: Int)
    
    var errorDescription: String? {
        switch self {
        case .columnOutOfBounds(let column):
            return "Column \(column) is out of bounds"
        case .rowOutOfBounds(let row):
            return "Row \(row) is out of bounds"
        }
    }
}

enum ApplicationError: LocalizedError, Equatable {
    case scoreNotReady
    case cellIsFull(position: BlockPosition)
    case maxBlocksReached(maxBlocks: Int)
    case invalidStatus(status: BoardStatus)
    
    var errorDescription: String? {
        switch self {
        case .scoreNotReady:
            return "Total Score not calculated"
        case .cellIsFull(let position):
            return "Cell at \(position) is full"
        case .invalidStatus(let status):
            return "Board status \(status) is invalid"
        case .maxBlocksReached(let maxBlocks):
            return "max number of blocks \(maxBlocks) is reached"
        }
    }
}
