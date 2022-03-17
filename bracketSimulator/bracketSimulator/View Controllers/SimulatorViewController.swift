//
//  SimulatorViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/11/22.
//

import UIKit

class SimulatorViewController: UIViewController {

    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var simButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var instrLabel: UILabel!
    
    let simulator = SimulationBasic()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numLabel.text = "\(Int(slider.value))"
        simButton.addTarget(self, action: #selector(runSimulations), for: UIControl.Event.touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func runSimulations() {
        let numberToRun = Int(slider.value)
        DataManager.sharedInstance.runSimulations(n: numberToRun)
    }
    
    //Attribution: https://www.youtube.com/watch?v=zTDUcwn6zyU
    @IBAction func sliderDidSlide(_ sender: UISlider){
        numLabel.text = "\(Int(slider.value))"
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
