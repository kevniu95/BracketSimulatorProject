//
//  SplashScreenViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/16/22.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var splashImage: UIImageView!
    @IBOutlet weak var splashLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        splashImage.image = UIImage(named: "march-madness")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
