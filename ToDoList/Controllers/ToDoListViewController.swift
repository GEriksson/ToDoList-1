//
//  ViewController.swift
//  ToDoList
//
//  Created by Göran Macbook Air on 2017-12-20.
//  Copyright © 2017 gemeDesign. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
    }
    

    //Mark - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none  // Ternary operator, .checkmarkt if item.done == true
        
        return cell
    }
    
    
    
    // Mark - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Uppdate Item
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Delete from Item
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let ac = UIAlertController(title: "Add a ToDo List Item", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel Pressed")
        })
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            // What will happen when the button is pressed on alert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()

        }
        
        ac.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        ac.addAction(action)
        ac.addAction(cancelAction)
        present(ac, animated: true, completion: nil)

    }
    
    // Mark - Create Item
    func saveItems() {
        
        do {
         try context.save()
            
        } catch {
            print("Error saving to Context: \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    
    // Mark - Read item
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {

            do {
                itemArray = try context.fetch(request)
                
            } catch {
                print("Error fetching data drom context: \(error.localizedDescription)")
            }
        }
    
    
    
    } // End of Class ToDoListViewController


//Mark - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request)
    }
    
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           loadItems()
        }
    }
    
    
    
}


