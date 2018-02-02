//
//  SettingViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 01/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var aboutTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == settingTableView
        {
            return 3
        }
        if tableView == aboutTableView
        {
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView == self.settingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingTableViewCell
            
            if indexPath.row == 1
            {
                cell.iconImage.image = #imageLiteral(resourceName: "icon_nutritionSetting")
                cell.infoMessage.text = "Nutrition Settings"
            }else if indexPath.row == 2
            {
                cell.iconImage.image = #imageLiteral(resourceName: "icon_notification")
                cell.infoMessage.text = "Notification"
            }else
            {
                cell.iconImage.image = #imageLiteral(resourceName: "icon_dataSetting")
                cell.infoMessage.text = "Data Settings"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingTableViewCell
            if indexPath.row == 1
            {
                cell.iconImage.image = #imageLiteral(resourceName: "icon_nutritionSetting")
                cell.infoMessage.text = "About Foody Life!"
            }else if indexPath.row == 2
            {
                cell.iconImage.image = #imageLiteral(resourceName: "icon_reportABug")
                cell.infoMessage.text = "Report a Bug"
            }else if indexPath.row == 3
            {
                cell.iconImage.image = #imageLiteral(resourceName: "icon_terms")
                cell.infoMessage.text = "Terms & Conditions"
            }else
            {
                cell.iconImage.image = #imageLiteral(resourceName: "icon_copyright")
                cell.infoMessage.text = "Copyright"
            }
            return cell
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.dataSource = self
        settingTableView.delegate = self
        
        aboutTableView.dataSource = self
        aboutTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
