//
//  BoardCellViewModel.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 29/10/22.
//

import Foundation

protocol BoardCellViewModelProtocol: ObservableObject, ScoreProtocol, StatusProtocol {
    var boardViewModel: (any BoardViewModelProtocol)? { get }
}

class BoardCellViewModel: BoardCellViewModelProtocol {
    weak var boardViewModel: (any BoardViewModelProtocol)?
    
    private let position: BlockPosition
    
    init(position: BlockPosition, boardViewModel: (any BoardViewModelProtocol)?) {
        self.boardViewModel = boardViewModel
        self.position = position
    }
    
    var score: Int {
        let result = try? boardViewModel?.score(for: position)
        return result ?? 0
    }
    
    var currentStatus: BoardStatus {
        boardViewModel?.currentStatus ?? .unknown
    }
}
