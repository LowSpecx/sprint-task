//
//  GoalViewController.swift
//  sprint-task
//
//  Created by Maurice Tin on 05/05/21.
//

import UIKit
import AVFoundation

class GoalViewController: UIViewController {
    
    var alarmSoundEffect: AVAudioPlayer?
    var directedFromNotification: Bool?
    
    
    
    @IBOutlet weak var sprintLabel: UILabel!
    
    
    let path = Bundle.main.path(forResource: "mixkit-alarm-digital-clock-beep-989.wav", ofType: nil)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        sprintLabel.text = "Sprint \(mySprintTimer.totalSprints)/\(mySprintTimer.totalSprints)"
        
        // Do any additional setup after loading the view.
        if directedFromNotification == nil{
            let url = URL(fileURLWithPath: path)
            do {
               alarmSoundEffect =  try AVAudioPlayer(contentsOf: url)
                alarmSoundEffect?.numberOfLoops = -1
               alarmSoundEffect?.play()
            } catch{
                print("Couldn't load file")
            }
        }
    }
    
    @IBAction func backToHome(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
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
