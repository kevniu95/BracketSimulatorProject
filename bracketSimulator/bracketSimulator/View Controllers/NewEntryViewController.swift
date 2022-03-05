//
//  NewEntryViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/4/22.
//

import UIKit

class NewEntryViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var teamCell: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    let bracketFrameScaler = 3.0
    var teamCells = [UIStackView]()
        
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        initiateScrollView()
        initiateTeamCells()
    }
    
    func initiateScrollView(){
        scrollView.delegate = self
        guard let bracketImageView = initializeBracketImage() else{
            return
        }
        addBracketImage(bracketImageView: bracketImageView)
        
//        scrollView.maximumZoomScale = 0.6
//        scrollView.setZoomScale(0.5, animated: true)
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
    
    func initiateTeamCells(){
        for _ in 1...1{
            teamCells.append(teamCell)
        }
        for cell in teamCells{
            scrollView.addSubview(cell)
            print("Added cell")
//            fitToConstraint(teamCell: cell)
        }

    }
    
//
//    func fitToConstraint(teamCell: UIStackView){
//        let leadingConstraint = NSLayoutConstraint(item: teamCell, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: bracketImageView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
//        let trailingConstraint = NSLayoutConstraint(item: teamCell, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: bracketImageView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
//        let topConstraint = NSLayoutConstraint(item: teamCell, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: bracketImageView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 150)
//        let bottomConstraint = NSLayoutConstraint(item: teamCell, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
//        NSLayoutConstraint.activate([leadingConstraint, topConstraint
//                                    ])
//    }
//

    func addBracketImage(bracketImageView: UIImageView){
        scrollView.addSubview(bracketImageView)
    }
}
