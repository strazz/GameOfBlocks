//
//  BlockModel.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 26/10/22.
//

import Foundation

struct BlockPosition {
    var row: Int
    var column: Int
}

extension BlockPosition: Equatable {
    static func == (lhs: BlockPosition, rhs: BlockPosition) -> Bool {
        lhs.row == rhs.row && lhs.column == rhs.column
    }
}

struct BlockModel: Hashable, Identifiable {
    var id: Int
    var position: BlockPosition
    var points: Int
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(position.row)
        hasher.combine(position.column)
    }
}
