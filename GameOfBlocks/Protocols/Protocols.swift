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
