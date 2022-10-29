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
        VStack {
            drawBoard()
            HStack {
                if viewModel.currentStatus == .done {
                    Text("Score: \(viewModel.score)")
                }
                Button("Reset") {
                    viewModel.reset()
                }
            }
        }
    }
    
    func drawBoard() -> some View {
        GeometryReader { (geometry: GeometryProxy) in
            let columns = viewModel.columns
            let rows = viewModel.rows
            let bounds = geometry.size
            let squareSize = min((bounds.width/CGFloat(columns)), (bounds.height/CGFloat(rows)))
            let horizontalPadding = (bounds.width - squareSize * CGFloat(columns))/2
            let verticalPadding = (bounds.height - squareSize * CGFloat(rows))/2
            Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0 ..< viewModel.rows, id: \.self) { row in
                    GridRow {
                        ForEach(0 ..< viewModel.columns, id: \.self) { column in
                            ViewFactory.buildCellView(
                                position: BlockPosition(row: row, column: column),
                                boardViewModel: viewModel)
                                .frame(width: squareSize, height: squareSize)
                                .onTapGesture {
                                    do {
                                        try viewModel.addBlock(position: BlockPosition(row: row, column: column))
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
        ForEach(viewModel.currentBlocks) { (blockModel: BlockModel) in
            let row: CGFloat = CGFloat(blockModel.position.row)
            let column: CGFloat = CGFloat(blockModel.position.column)
            
            let viewPosition = CGPoint(
                x: (column * size) + origin.x + size * 0.5,
                y: (row * size) + origin.y + size * 0.5)
            ViewFactory.buildBlockView(block: blockModel, boardViewModel: self.viewModel)
                .frame(width: size, height: size)
                .position(viewPosition)
        }
    }
    
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.buildBoardView(rows: 5, columns: 5, maxBlocks: 10)
    }
}
