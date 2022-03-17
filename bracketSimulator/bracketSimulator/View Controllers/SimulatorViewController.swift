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
        simButton.addTarget(self, action: #selector(runSimulations), for: UIControl.Event.touchUpInside)
        numLabel.text = "\(Int(slider.value))"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetForThisAppearance()
    }
    
    func resetForThisAppearance(){
        print("I am resetting")
        instrLabel.text = "How many simulations would you like?"
        simButton.isUserInteractionEnabled = true
        simButton.alpha = 1
    }
    
    @objc func runSimulations() {
        let numberToRun = Int(slider.value)
        DataManager.sharedInstance.runSimulations(n: numberToRun)
        instrLabel.text = "All done! Check out results in My Brackets!"
        simButton.isUserInteractionEnabled = false
        simButton.alpha = 0.5
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
