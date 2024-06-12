import UIKit
import PlaygroundSupport

class GameViewController: UIViewController {
    var grid: [[Int]] = []
    var dadPos: (Int, Int) = (0, 0)
    var numGifts = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Initialize grid
        let gridSize = 5
        grid = Array(repeating: Array(repeating: 0, count: gridSize), count: gridSize)
        
        // Place obstacles randomly
        for _ in 0..<gridSize {
            let x = Int.random(in: 0..<gridSize)
            let y = Int.random(in: 0..<gridSize)
            grid[x][y] = 1
        }
        
        // Place gifts randomly
        for _ in 0..<numGifts {
            var x = Int.random(in: 0..<gridSize)
            var y = Int.random(in: 0..<gridSize)
            while grid[x][y] != 0 {
                x = Int.random(in: 0..<gridSize)
                y = Int.random(in: 0..<gridSize)
            }
            grid[x][y] = 2
        }
        
        // Display the grid
        let gridWidth = 40
        let gridHeight = 40
        let startX = 50
        let startY = 50
        
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                let squareView = UIView(frame: CGRect(x: startX + j * gridWidth, y: startY + i * gridHeight, width: gridWidth, height: gridHeight))
                squareView.layer.borderWidth = 1
                if grid[i][j] == 1 {
                    squareView.backgroundColor = .gray // Obstacle
                } else if grid[i][j] == 2 {
                    squareView.backgroundColor = .green // Gift
                } else {
                    squareView.backgroundColor = .white // Empty space
                }
                view.addSubview(squareView)
            }
        }
        
        // Add Dad's character
        let dadView = UIView(frame: CGRect(x: startX, y: startY, width: gridWidth, height: gridHeight))
        dadView.backgroundColor = .blue
        view.addSubview(dadView)
        
        // Update Dad's position
        dadPos = (0, 0)
        
        // Main game loop
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.playGame()
        }
    }
    
    func playGame() {
        // Check if Dad reached a gift
        if grid[dadPos.0][dadPos.1] == 2 {
            print("Dad found a gift!")
            numGifts -= 1
            grid[dadPos.0][dadPos.1] = 0
        }
        
        if numGifts == 0 {
            print("Dad collected all the gifts! Happy Father's Day!")
        } else {
            // Move Dad randomly
            let directions = ["up", "down", "left", "right"]
            let direction = directions.randomElement()!
            dadPos = moveDad(direction: direction)
            
            // Update Dad's position on the view
            let startX = 50
            let startY = 50
            let gridWidth = 40
            let gridHeight = 40
            UIView.animate(withDuration: 0.5) {
                self.view.subviews.last?.frame.origin.x = CGFloat(startX + self.dadPos.1 * gridWidth)
                self.view.subviews.last?.frame.origin.y = CGFloat(startY + self.dadPos.0 * gridHeight)
            }
            
            // Continue game loop
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.playGame()
            }
        }
    }
    
    func moveDad(direction: String) -> (Int, Int) {
        var newPos = dadPos
        switch direction {
        case "up":
            if dadPos.0 - 1 >= 0 && grid[dadPos.0 - 1][dadPos.1] != 1 {
                newPos = (dadPos.0 - 1, dadPos.1)
            }
        case "down":
            if dadPos.0 + 1 < grid.count && grid[dadPos.0 + 1][dadPos.1] != 1 {
                newPos = (dadPos.0 + 1, dadPos.1)
            }
        case "left":
            if dadPos.1 - 1 >= 0 && grid[dadPos.0][dadPos.1 - 1] != 1 {
                newPos = (dadPos.0, dadPos.1 - 1)
            }
        case "right":
            if dadPos.1 + 1 < grid.count && grid[dadPos.0][dadPos.1 + 1] != 1 {
                newPos = (dadPos.0, dadPos.1 + 1)
            }
        default:
            break
        }
        return newPos
    }
}

// Present the view controller in the Live View window
let viewController = GameViewController()
viewController.preferredContentSize = CGSize(width: 300, height: 300)
PlaygroundPage.current.liveView = viewController
