//
//  BoardView.swift
//  GameOfBlocks
//
//  Created by Giovanni Romaniello on 25/10/22.
//

import SwiftUI

struct BoardView<ViewModel>: View where ViewModel: BoardViewModelProtocol {
    
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            let columns = viewModel.rows
            let rows = viewModel.columns
            let bounds = geometry.size
            let squareSize = min((bounds.width/CGFloat(columns)), (bounds.height/CGFloat(rows)))
            let horizontalPadding = (bounds.width - squareSize * CGFloat(columns))/2
            let verticalPadding = (bounds.height - squareSize * CGFloat(rows))/2
            Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0 ..< viewModel.rows, id: \.self) { row in
                    GridRow {
                        ForEach(0 ..< viewModel.columns, id: \.self) { column in
                            BoardCellView()
                                .frame(width: squareSize, height: squareSize)
                                .onTapGesture {
                                    do {
                                        try self.viewModel.addBlock(position: CGPoint(x: column, y: row))
                                    }
                                    catch let error {
                                        print(error.localizedDescription)
                                    }
                                }
                        }
                    }
                }
            }
            .border(.black)
            .padding(EdgeInsets(
                top: verticalPadding,
                leading: horizontalPadding,
                bottom: verticalPadding,
                trailing: horizontalPadding))
            drawBlocks(size: squareSize, origin: CGPoint(x: horizontalPadding, y: verticalPadding))
        }
    }
    
    
    func drawBlocks(size: CGFloat, origin: CGPoint) -> some View {
        ForEach(viewModel.currentBlocks) { blockModel in
            let blockPosition = CGPoint(
                x: (blockModel.position.x * size) + origin.x + size/2,
                y: (blockModel.position.y * size) + origin.y + size/2)
            let viewModel = BlockViewModel(blockModel: blockModel, boardViewModel: self.viewModel)
            BlockView(viewModel: viewModel)
                .frame(width: size, height: size)
                .position(blockPosition)
        }
    }
    
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BoardViewModel(rows: 5, columns: 5, maxBlocks: 10)
        BoardView(viewModel: viewModel)
    }
}
