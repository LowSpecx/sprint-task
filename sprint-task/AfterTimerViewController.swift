//
//  AfterTimerViewController.swift
//  sprint-task
//
//  Created by Maurice Tin on 04/05/21.
//

import UIKit
import AVFoundation

class AfterTimerViewController: UIViewController {
    
    var alarmSoundEffect: AVAudioPlayer?
    var directedFromNotification: Bool?
    
    
    @IBOutlet weak var finishLabel: UILabel!
    
    let path = Bundle.main.path(forResource: "mixkit-alarm-digital-clock-beep-989.wav", ofType: nil)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFinishLabel()
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
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setFinishLabel(){
        if !mySprintTimer.modeIsSprint{
            finishLabel.text = "Sprint \(mySprintTimer.currentSprint-1)/\(mySprintTimer.totalSprints) Finished"
        }else{
            finishLabel.text = "Rest Finished"
        }
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
