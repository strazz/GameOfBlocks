//
//  BoardGameBusinessLogic.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 28/10/22.
//

import Foundation

enum StopPosition {
    case block
    case bridge
    case bottom
    case none
}

protocol BoardGameBusinessLogicProtocol {
    func nextPosition(for block: BlockModel, blockMatrix: [[BlockModel?]]) -> BlockPosition
}

class BoardGameBusinessLogic {
    
}

extension BoardGameBusinessLogic: BoardGameBusinessLogicProtocol {
    
    func nextPosition(for block: BlockModel, blockMatrix: [[BlockModel?]]) -> BlockPosition {
        var blockPosition = block.position
        var stopPosition = isFinalPosition(position: blockPosition, blockMatrix: blockMatrix)
        while stopPosition == .none {
            blockPosition = BlockPosition(row: blockPosition.row + 1, column: blockPosition.column)
            stopPosition = isFinalPosition(position: blockPosition, blockMatrix: blockMatrix)
        }
        switch stopPosition {
        case .bridge:
            return BlockPosition(row: blockPosition.row, column: blockPosition.column)
        default:
            return BlockPosition(row: blockPosition.row - 1, column: blockPosition.column)
        }
    }
    
    private func isFinalPosition(position: BlockPosition, blockMatrix: [[BlockModel?]]) -> StopPosition {
        do {
            try checkIndexes(row: position.row, column: position.column, blockMatrix: blockMatrix)
        } catch {
            return .bottom
        }
        if blockMatrix[position.row][position.column] != nil {
            return .block
        } else if isOverBridge(position: position, blockMatrix: blockMatrix) {
            return .bridge
        }
        return .none
    }
    
    private func isOverBridge(position: BlockPosition, blockMatrix: [[BlockModel?]]) -> Bool {
        guard position.column > 0, position.column < blockMatrix[0].count - 1 else {
            return false
        }
        return (blockMatrix[position.row][position.column - 1] != nil) && (blockMatrix[position.row][position.column + 1] != nil)
    }
    
    private func checkIndexes(row: Int, column: Int, blockMatrix: [[BlockModel?]]) throws {
        guard column >= 0, column < blockMatrix[0].count else {
            throw InvalidArgumentError.columnOutOfBounds(column: column)
        }
        guard row >= 0, row < blockMatrix.count else {
            throw InvalidArgumentError.rowOutOfBounds(row: row)
        }
    }
}
