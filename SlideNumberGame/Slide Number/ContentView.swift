import SwiftUI

struct ContentView: View {
    @State private var numbers = (1...15).shuffled() + [0]
    @State private var moves = 0
    @State private var showWinningText = false
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        VStack {
            if showWinningText {
                Text("You Won!!!")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .background(Color.pink.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    .transition(.scale)
            }
            
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(numbers.indices, id: \.self) { index in
                    NumberView(number: numbers[index])
                        .onTapGesture {
                            moveNumber(at: index)
                        }
                }
            }
            .padding()
            
            Text("Moves: \(moves)")
                .padding()
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Color.cyan)
            
            Button(action: resetGame) {
                Text("New Game")
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.cyan))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
            }
            

        }
    }
    
    private func moveNumber(at index: Int) {
        if let zeroIndex = numbers.firstIndex(of: 0),
           isAdjacent(index, zeroIndex) {
            numbers.swapAt(index, zeroIndex)
            withAnimation(.default) {
                moves += 1
            }
            checkForWin()
        }
    }
    
    private func isAdjacent(_ firstIndex: Int, _ secondIndex: Int) -> Bool {
        let difference = abs(firstIndex - secondIndex)
        let notSameRow = (firstIndex / 4 != secondIndex / 4)
        return (difference == 1 && !notSameRow) || (difference == 4)
    }
    
    private func checkForWin() {
        if numbers == Array(1...15) + [0] {
            withAnimation {
                showWinningText = true
            }
        }
    }
    
    private func resetGame() {
        numbers = (1...15).shuffled() + [0]
        moves = 0
        withAnimation {
            showWinningText = false
        }
    }
    
}

struct NumberView: View {
    let number: Int
    
    var body: some View {
        ZStack {
            if number != 0 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.cyan, lineWidth: number == 0 ? 0 : 3)
                                    )
            }
            
            Text(number == 0 ? "" : "\(number)")
                .font(.largeTitle)
                .foregroundColor(.cyan)
        }
        .aspectRatio(1, contentMode: .fit)
        .animation(.snappy(duration: 0.2), value: number)
    }
}
extension Animation {
    static func snappy(duration: Double) -> Animation {
        return Animation.interpolatingSpring(stiffness: 500, damping: 25, initialVelocity: 10)
            .speed(2)
    }
}

