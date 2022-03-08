//
//  NewEntryViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/4/22.
//

import UIKit

class NewEntryViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    let bracketFrameScaler = 3.0
    var gameCells = [GameCell]()
        
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        initiateScrollView()
        
        initiateGameCells()
    }
    
            
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

    func initiateGameCells(){
        for ind in 1...1{
            let currGameCell = GameCell(idNum: ind, referenceScrollView: scrollView)
            gameCells.append(currGameCell)
        }
        for cell in gameCells{

            scrollView.addSubview(cell.cellImage)
            print(cell.cellImage.frame.origin)
//            print(cell.cellImage.frame)

//            addSubview(cell.cellImage)

//            print(cell)

//            fitToConstraint(gameCells: cell)
        }

    }


    func addBracketImage(bracketImageView: UIImageView){
        scrollView.addSubview(bracketImageView)
    }
}
