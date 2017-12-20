//
//  ViewController.swift
//  ToDoList
//
//  Created by Göran Macbook Air on 2017-12-20.
//  Copyright © 2017 gemeDesign. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let itemArray = ["Sjukgymnast", "Trysil", "Bröllopsdag"]
    var itemKlicked = [false, false, false]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //Mark - Tableview Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if itemKlicked[indexPath.row] == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    // Mark - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Du klickade på: \(itemArray[indexPath.row])")
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            itemKlicked[indexPath.row] = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            itemKlicked[indexPath.row] = true
            
        }
        
//        if itemKlicked[indexPath.row] == true {
//            itemKlicked[indexPath.row] = false
//        } else {
//            itemKlicked[indexPath.row] = true
//        }

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

}

