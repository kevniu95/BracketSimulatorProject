//
//  NewEntryViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/4/22.
//

import UIKit

class NewEntryViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    let bracketFrameScaler = 3.0
    var gameCells = [GameCell]()
    var gamePositions = [gamePosition]()
    var teams = [Team]()
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        initiateScrollView()
        gamePositions = convertGamePositions()
        teams = convertTeams()
        initiateGameCells(gamePositions: gamePositions)
        fillFirstRoundTeam()
        
    }
    
    

    // MARK: Scroll View Functionality
    func initiateScrollView(){
        scrollView.delegate = self
        guard let bracketImageView = initializeBracketImage() else{
            return
        }
        
        addBracketImage(bracketImageView: bracketImageView)
        scrollView.contentSize = CGSize(width: bracketImageView.frame.size.width, height: bracketImageView.frame.size.height)
        scrollView.contentOffset = CGPoint(x:scrollView.contentSize.width * 0.39 ,
                                           y:scrollView.contentSize.height * 0.5)
        
    }

    func initializeBracketImage()-> UIImageView?{
        let bracketImageView: UIImageView = UIImageView()
        guard let bracketImage = UIImage(named: "bracket2022") else {
            print("Couldn't create UI Image!")
            return nil
        }
        bracketImageView.frame.size.width = bracketImage.size.width/bracketFrameScaler
        bracketImageView.frame.size.height = bracketImage.size.height/bracketFrameScaler
        bracketImageView.image =  UIImage(named: "bracket2022")
        return bracketImageView
    }
    
    func addBracketImage(bracketImageView: UIImageView){
        scrollView.addSubview(bracketImageView)
    }

    // MARK: Interact with data model
    func initiateGameCells(gamePositions: [gamePosition]){
        for ind in 1...127{
            let gamePosition = gamePositions[ind - 1]
            let currGameCell = GameCell(idNum: ind, referenceScrollView: scrollView, gamePos: gamePosition)
            gameCells.append(currGameCell)
            scrollView.addSubview(currGameCell.cellImage)
        }
    }
    
    func fillFirstRoundTeam(){
        for ind in 64...127{
            let currGameCell = gameCells[ind - 1]
            let currTeam = teams[ind - 64]
            currGameCell.setTeam(team: currTeam)
            let nextGames = currGameCell.getNextGames()
            initiateRecognizers(currGameCell: currGameCell, nextGames: nextGames)
            
        }
    }
    
    
    // MARK: Gesture Recognizers
    func initiateRecognizers(currGameCell: GameCell, nextGames: [Int]){
        
        var gestureStartPoint: CGPoint? = nil
        let labelGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                action: #selector(handlePan(_:)))
        labelGestureRecognizer.delegate = self
        func labelGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            gestureStartPoint = touch.location(in: scrollView)
            return true
        }
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(handleLongPress(_:)))
        
        
        longPressRecognizer.delegate = self
        
        
        currGameCell.cellImage.addGestureRecognizer(labelGestureRecognizer)
        currGameCell.cellImage.addGestureRecognizer(longPressRecognizer)
    }
    
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        guard let labelView = gestureRecognizer.view else{
            print ("gestureRecognizer doesn't have a view!")
            return
        }
        print("Wow you pressed for a long time!")
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer){
        guard let labelView = gestureRecognizer.view else{
            print ("gestureRecognizer doesn't have a view!")
            return
        }
        
        let translation = gestureRecognizer.translation(in: self.view)
        labelView.center = CGPoint(x: labelView.center.x + translation.x,
                                  y: labelView.center.y + translation.y)
        gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        
//        print(gestureStartPoint)
        if gestureRecognizer.state == .ended{
//            testLabelOnViews(labelView: labelView)
        }
    }
    
    
//    func testLabelOnViews(labelView: UIView){
//        let returnVal = determineStartPoint()
//        let initX = CGFloat(returnVal.0)
//        let initY = CGFloat(returnVal.1)
//        var gridStatusChanged = false
//        for i in 0...8{
//            let squareGrid = squareGrids[i]
//            let overlapping = squareGrid.frame.intersects(labelView.frame)
//            if overlapping{
//                if gridModel.gridStatus[i] == ""{
//                    guard let currentTurnOfText = globalCurrentTurnOf.text else{
//                        print("Current Turn label doesn't have text!")
//                        return
//                    }
//                    gridModel.gridStatus[i] = currentTurnOfText
//                    gridStatusChanged = true
//                    snapInPlace(grid: squareGrid, labelView: labelView)
//                    labelView.isUserInteractionEnabled = false
//                    turnWillEnd(turnOf: globalCurrentTurnOf)
//                }
//            }
//        }
//        if gridStatusChanged == false{
//            UIView.animate(withDuration: 1, animations: {
//                labelView.frame.origin.x = initX
//                labelView.frame.origin.y = initY
//            })
//        }
//    }
    
    
}
