//
//  BlockViewModel.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 27/10/22.
//

import Foundation

protocol BlockViewModelProtocol: ObservableObject, Identifiable {
    var id: Int { get }
    var boardViewModel: (any BoardViewModelProtocol)? { get }
    var blockModel: BlockModel { get }
    func updateBlockPosition()
}

class BlockViewModel: BlockViewModelProtocol {
    weak var boardViewModel: (any BoardViewModelProtocol)?
    var blockModel: BlockModel
    
    var id: Int {
        blockModel.id
    }
    
    init(blockModel: BlockModel, boardViewModel: (any BoardViewModelProtocol)?) {
        self.blockModel = blockModel
        self.boardViewModel = boardViewModel
    }
    
    func updateBlockPosition() {
        try? boardViewModel?.updateBlockPosition(startingPosition: blockModel.position)
    }
}
