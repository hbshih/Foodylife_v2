//
//  TableViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 02/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(indexPath.row)
        if indexPath.row == 0
        {
            performSegue(withIdentifier: "nutritionSettings", sender: nil)
        }else if indexPath.row == 1
        {
            performSegue(withIdentifier: "dataSettingsSegue", sender: nil)
        }else if indexPath.row == 2
        {
                        performSegue(withIdentifier: "privatePolicySegue", sender: nil)
        }else if indexPath.row == 3
        {
            performSegue(withIdentifier: "privatePolicySegue", sender: nil)
        }else if indexPath.row == 4
        {
            performSegue(withIdentifier: "reportABugSegue", sender: nil)
        }else
        {
            performSegue(withIdentifier: "privatePolicySegue", sender: nil)
        }
        
    }
}
