//
//  ViewController.swift
//  sprint-task
//
//  Created by Maurice Tin on 03/05/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var sprintLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var tapToStartLabel: UILabel!
    
    
    var timer = Timer()
    var seconds: Int?
    var resumeTapped = false
    var center: UNUserNotificationCenter?
    var notificationCenter: NotificationCenter?
    var moveToBackgroundDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(stopTapped))
        
        title = "Timer"
        notificationCenter = NotificationCenter.default
        notificationCenter!.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        notificationCenter!.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //1. Ask the user permission for notification
        center = UNUserNotificationCenter.current()
        center!.requestAuthorization(options: [.alert, .sound]){
            granted, error in
            }
        
        reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @objc func appMovedToBackground(){
        if mySprintTimer.isTimerRunning{
            setNotification(for: seconds!)
        }
        
        moveToBackgroundDate = Date()
    }
    
    @objc func appMovedToForeground(){
        let secondsLeft = seconds! - abs(Int(moveToBackgroundDate?.timeIntervalSinceNow ?? 0))
        
        if secondsLeft < 0{
            timer.invalidate()
            finishTimerfromNotif()
            
        }else{
            seconds = secondsLeft
        }
    }
    
    func reloadData(){
        if mySprintTimer.modeIsSprint{
            sprintLabel.text = "Sprint \(mySprintTimer.currentSprint)/\(mySprintTimer.totalSprints)"
            
            if mySprintTimer.currentSprint == 1{
                instructionLabel.text = "swipe to change settings"
                timerLabel.text = timeString(time: TimeInterval(mySprintTimer.sprintDuration * 60))
            }else{
                instructionLabel.text = "100% focus on your task"
                timerLabel.text = timeString(time: TimeInterval(mySprintTimer.sprintDuration * 60))
            }
            seconds = mySprintTimer.sprintDuration * 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
            
            //For testing
            seconds = 5
        }else{
            sprintLabel.text = "Rest"
            instructionLabel.text = "Relax! Take a rest"
            timerLabel.text = timeString(time: TimeInterval(mySprintTimer.breakDuration * 60))
            seconds = mySprintTimer.breakDuration * 60
            
            //For testing
            seconds = 5
        }
    }
        
    func runTimer(){
        tapToStartLabel.isHidden = true
        if mySprintTimer.currentSprint == 1 && mySprintTimer.modeIsSprint{
            instructionLabel.text = "100% focus on your task"
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        
        mySprintTimer.isTimerRunning = true
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc func updateTimer(){
        if seconds! < 1{
            timer.invalidate()
            finishTimer()
        }else{
            seconds! -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds!))
        }
    }
    
    func finishTimer(){
        mySprintTimer.isTimerRunning = false
        
        //if just completed a sprint
        if mySprintTimer.currentSprint < mySprintTimer.totalSprints && mySprintTimer.modeIsSprint{
            //increment sprint
            mySprintTimer.modeIsSprint = false
            mySprintTimer.currentSprint += 1
            
            if let vc = storyboard?.instantiateViewController(identifier: "afterTimer") as? AfterTimerViewController{
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        //if on last sprint, go to GoalViewController
        else if mySprintTimer.currentSprint == mySprintTimer.totalSprints && mySprintTimer.modeIsSprint{//if completed all sprints
            //reset sprint to 1, set mode to sprint, and go to goal controller
            mySprintTimer.currentSprint = 1
            mySprintTimer.modeIsSprint = true
            if let vc = storyboard?.instantiateViewController(identifier: "goal"){
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        //if still on a rest, go to afterTimer view controller
        else if !mySprintTimer.modeIsSprint{
            //dont increment sprint
            mySprintTimer.modeIsSprint = true
            
            if let vc = storyboard?.instantiateViewController(identifier: "afterTimer") as? AfterTimerViewController{
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func finishTimerfromNotif(){
        mySprintTimer.isTimerRunning = false
        
        //if just completed a sprint
        if mySprintTimer.currentSprint < mySprintTimer.totalSprints && mySprintTimer.modeIsSprint{
            //increment sprint
            mySprintTimer.modeIsSprint = false
            mySprintTimer.currentSprint += 1
            
            if let vc = storyboard?.instantiateViewController(identifier: "afterTimer") as? AfterTimerViewController{
                
                vc.directedFromNotification = true
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        //if on last sprint, go to GoalViewController
        else if mySprintTimer.currentSprint == mySprintTimer.totalSprints && mySprintTimer.modeIsSprint{//if completed all sprints
            //reset sprint to 1, set mode to sprint, and go to goal controller
            mySprintTimer.currentSprint = 1
            mySprintTimer.modeIsSprint = true
            if let vc = storyboard?.instantiateViewController(identifier: "goal") as? GoalViewController{
                
                vc.directedFromNotification = true
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        //if still on a rest, go to afterTimer view controller
        else if !mySprintTimer.modeIsSprint{
            //dont increment sprint
            mySprintTimer.modeIsSprint = true
            
            if let vc = storyboard?.instantiateViewController(identifier: "afterTimer") as? AfterTimerViewController{
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func setNotification(for timeRemaining: Int){
        
        //2. Create the notification content
        let content = UNMutableNotificationContent()
        
        if mySprintTimer.modeIsSprint{
            content.title = "Sprint Finished"
            content.body = "Let's rest!"
        }else{
            content.title = "Rest Finished"
            content.body = "Let's get back to work!"
        }
        
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "mixkit-alarm-digital-clock-beep-989.wav"))
        
        //3. Create the notification trigger
        let date = Date().addingTimeInterval(TimeInterval(timeRemaining))
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Step 4: Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        // Step 5: Register the request
        center!.add(request) { (error) in
            //check the error parameter and handle any errors
        }
    }
    
    
    @IBAction func timerButton(_ sender: UIButton) {
        
        if !mySprintTimer.isTimerRunning{
            runTimer()
        }
        else if self.resumeTapped == false { // pause
            instructionLabel.text = "Paused"
            timer.invalidate()
            self.resumeTapped = true
        }else { //resume
            if mySprintTimer.modeIsSprint{
                instructionLabel.text = "100% focus on your task"
            }else{
                instructionLabel.text = "Relax!! Take a rest"
            }
            runTimer()
            self.resumeTapped = false
        }
    }
    
    
    func timeString(time: TimeInterval) -> String{
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    @objc func stopTapped(){
        let ac = UIAlertController(title: "You are still on a task", message: "Are you sure you want to stop?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Nevermind", style: .default, handler: {
            action in print("Nevermind")
        }))
        
        ac.addAction(UIAlertAction(title: "Stop", style: .destructive, handler: {
            action in self.stopTimer()
        }))
        
        present(ac, animated: true)
    }
    
    func stopTimer(){
        mySprintTimer.isTimerRunning = false
        mySprintTimer.currentSprint = 1
        mySprintTimer.modeIsSprint = true
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func unwindToTimer(segue: UIStoryboardSegue){
        print("Unwind to ViewController(timer view controller)")
    }
    
    @IBAction func didSwipeView(_ sender: UISwipeGestureRecognizer) {
        
        print("you swiped!")
    }
    
    
}

