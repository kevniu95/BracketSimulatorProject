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
    var teamCells: [UIStackView] = []
    
    
    let bracketImageView = UIImageView(image: UIImage(named: "bracket2022"))
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        initiateScrollView()
//        scrollView.addSubview(teamCell)
//        initiateTeamCells()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        scrollView.setZoomScale(0.1, animated: true)
    }
    
    func initiateScrollView(){
        addBracketImage()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 0.6
        scrollView.setZoomScale(0.5, animated: true)
        scrollView.contentOffset = CGPoint(x:scrollView.contentSize.width * 0.45 ,
                                           y:scrollView.contentSize.height * 0.5)
    }
//    
//    func initiateTeamCells(){
//        for _ in 1...5{
//            teamCells.append(teamCell)
//        }
//        for cell in teamCells{
//            scrollView.addSubview(cell)
//            fitToConstraint(teamCell: cell)
//        }
//        
//    }
//    
//    
//    func fitToConstraint(teamCell: UIStackView){
//        let leadingConstraint = NSLayoutConstraint(item: teamCell, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
//        let trailingConstraint = NSLayoutConstraint(item: teamCell, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
//        let topConstraint = NSLayoutConstraint(item: teamCell, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
//        let bottomConstraint = NSLayoutConstraint(item: teamCell, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
//        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
//    }
    
    
    
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        for index, imageView in
//    }
//
    func addBracketImage(){
        scrollView.addSubview(bracketImageView)
//        print(bracketImageView)
//        bracketImageView.translatesAutoresizingMaskIntoConstraints = false


    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return bracketImageView
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
