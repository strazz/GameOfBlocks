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

enum ScoreStatus {
    case ready
    case unknown
}

protocol BoardGameBusinessLogicProtocol: Resettable {
    func nextPosition(for position: BlockPosition, blockMatrix: [[BlockModel?]]) -> BlockPosition
    func getScore(for position: BlockPosition) throws -> Int
    @discardableResult func calculateTotalScore(blockMatrix: [[BlockModel?]]) -> Int
}

class BoardGameBusinessLogic {
    private let blockPoints: Int = 5
    let rows: Int
    let columns: Int
    private var scores: [[Int]]
    private var scoreStatus: ScoreStatus
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        scores = Array(repeating: Array(repeating: 0, count: columns), count: rows)
        scoreStatus = .unknown
    }
}

extension BoardGameBusinessLogic: BoardGameBusinessLogicProtocol, SafeIndexesProtocol {
    
    func nextPosition(for position: BlockPosition, blockMatrix: [[BlockModel?]]) -> BlockPosition {
        let stopPosition = isFinalPosition(position: position, blockMatrix: blockMatrix)
        if stopPosition == .none {
            let newPosition = BlockPosition(row: position.row + 1, column: position.column)
            return nextPosition(for: newPosition, blockMatrix: blockMatrix)
        }
        switch stopPosition {
        case .bridge:
            return BlockPosition(row: position.row, column: position.column)
        default:
            return BlockPosition(row: position.row - 1, column: position.column)
        }
    }
    
    private func isFinalPosition(position: BlockPosition, blockMatrix: [[BlockModel?]]) -> StopPosition {
        do {
            try checkRow(row: position.row, blockMatrix: blockMatrix)
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
    
    private func checkRow(row: Int, blockMatrix: [[BlockModel?]]) throws {
        guard row >= 0, row < blockMatrix.count else {
            throw InvalidArgumentError.rowOutOfBounds(row: row)
        }
    }
    
    func getScore(for position: BlockPosition) throws -> Int {
        guard scoreStatus == .ready else {
            throw ApplicationError.scoreNotReady
        }
        try checkIndexes(row: position.row, column: position.column)
        return scores[position.row][position.column]
    }
    
    private func calculateScore(for position: BlockPosition, blockMatrix: [[BlockModel?]]) -> Int {
        if blockMatrix[position.row][position.column] == nil {
            if isUnderBridge(position: position, blockMatrix: blockMatrix) {
                return 2 * blockPoints
            }
            return 0
        }
        var result: Int = blockPoints
        let row = position.row + 1
        if row < blockMatrix.count && blockMatrix[row][position.column] != nil {
            result += calculateScore(for: BlockPosition(row: row, column: position.column), blockMatrix: blockMatrix)
        }
        return result
    }
    
    private func isUnderBridge(position: BlockPosition, blockMatrix: [[BlockModel?]]) -> Bool {
        var result = false
        let row = position.row - 1
        guard row >= 0 else {
            return result
        }
        if blockMatrix[row][position.column] != nil {
            result = true
        } else {
            result = isUnderBridge(position: BlockPosition(row: row, column: position.column), blockMatrix: blockMatrix)
        }
        return result
    }
    
    @discardableResult func calculateTotalScore(blockMatrix: [[BlockModel?]]) -> Int {
        scoreStatus = .ready
        return blockMatrix.enumerated().reduce(0) { [weak self] partialResult, rowIterator in
            rowIterator.element.enumerated().reduce(partialResult) { partialResult, columnIterator in
                guard let self = self else { return -1 }
                let position = BlockPosition(row: rowIterator.offset, column: columnIterator.offset)
                let positionScore = self.calculateScore(for: position, blockMatrix: blockMatrix)
                self.scores[position.row][position.column] = positionScore
                return partialResult + positionScore
            }
        }
    }
}

extension BoardGameBusinessLogic: Resettable {
    func reset() {
        scores = Array(repeating: Array(repeating: 0, count: columns), count: rows)
        scoreStatus = .unknown
    }
}
