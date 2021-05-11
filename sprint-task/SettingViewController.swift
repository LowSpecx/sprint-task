//
//  SettingViewController.swift
//  sprint-task
//
//  Created by Maurice Tin on 05/05/21.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var sprintDurationLabel: UILabel!
    @IBOutlet weak var breakDurationLabel: UILabel!
    @IBOutlet weak var totalSprints: UILabel!
    var sprintDurationData: [Int] = []
    var breakDurationData: [Int] = []
    var totalSprintsData: [Int] = []
    var selectedSetting: settingSelection?
    var picker: UIPickerView?
    
    enum settingSelection {
        case sprintDuration
        case breakDuration
        case totalSprints
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sprint Settings"
        setData()
        picker = UIPickerView()
        picker?.dataSource = self
        picker?.delegate = self
        picker?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker!)
        picker?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        picker?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        picker?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        sprintDurationLabel.text = "\(mySprintTimer.sprintDuration) min"
        breakDurationLabel.text = "\(mySprintTimer.breakDuration) min"
        totalSprints.text = "\(mySprintTimer.totalSprints) Sprints"
        
        // Initialize Tap Gesture Recognizer
        let tapGestureSprintDuration = UITapGestureRecognizer(target: self, action: #selector(didTapSprintDuration(_:)))
        
        let tapGestureBreakDuration = UITapGestureRecognizer(target: self, action: #selector(didTapBreakDuration(_:)))
        
        
        let tapGestureTotalSprints = UITapGestureRecognizer(target: self, action: #selector(didTapTotalSprints(_:)))
        
        sprintDurationLabel.isUserInteractionEnabled = true
        breakDurationLabel.isUserInteractionEnabled = true
        totalSprints.isUserInteractionEnabled = true
        
        sprintDurationLabel.addGestureRecognizer(tapGestureSprintDuration)
        breakDurationLabel.addGestureRecognizer(tapGestureBreakDuration)
        totalSprints.addGestureRecognizer(tapGestureTotalSprints)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @objc func didTapSprintDuration(_ sender: UITapGestureRecognizer) {
        selectedSetting = .sprintDuration
        picker?.reloadAllComponents()
    }
    
    
    @objc func didTapBreakDuration(_ sender: UITapGestureRecognizer) {
        selectedSetting = .breakDuration
        picker?.reloadAllComponents()
    }
    
    
    @objc func didTapTotalSprints(_ sender: UITapGestureRecognizer) {
        selectedSetting = .totalSprints
        picker?.reloadAllComponents()
    }
    
    func setData(){
        for i in 1...120 {
            sprintDurationData.append(i)
        }
        
        for i in 1...120{
            breakDurationData.append(i)
        }
        
        for i in 3...30{
            totalSprintsData.append(i)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let selection = selectedSetting{
            if selection == settingSelection.sprintDuration{
                return sprintDurationData.count
            }
            if selection == settingSelection.breakDuration{
                return breakDurationData.count
            }
            if selection == settingSelection.totalSprints{
                return totalSprintsData.count
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let selection = selectedSetting{
            if selection == settingSelection.sprintDuration{
                return "\(sprintDurationData[row])"
            }
            if selection == settingSelection.breakDuration{
                return "\(breakDurationData[row])"
            }
            if selection == settingSelection.totalSprints{
                return "\(totalSprintsData[row])"
            }
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let selection = selectedSetting{
            if selection == settingSelection.sprintDuration{
                sprintDurationLabel.text = "\(sprintDurationData[row]) min"
                mySprintTimer.sprintDuration = sprintDurationData[row]
            }
            if selection == settingSelection.breakDuration{
                breakDurationLabel.text = "\(breakDurationData[row]) min"
                mySprintTimer.breakDuration = breakDurationData[row]
            }
            if selection == settingSelection.totalSprints{
                totalSprints.text = "\(totalSprintsData[row]) Sprints"
                mySprintTimer.totalSprints = totalSprintsData[row]
            }
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
