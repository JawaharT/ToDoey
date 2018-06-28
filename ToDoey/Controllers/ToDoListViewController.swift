//
//  ViewController.swift
//  ToDoey
//
//  Created by Jawahar Tunuguntla on 27/06/2018.
//  Copyright © 2018 Jawahar Tunuguntla. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = items
        }
        
        let newItem = Item()
        newItem.title = "Hello there"
        itemArray.append(newItem)
    }
    
    // MARK - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item.", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item.", style: .default) { (action) in
            // What will happen once user clicks add item button.
            if textfield.text != ""{
                let newItem: Item = Item()
                newItem.title = textfield.text!
                self.itemArray.append(newItem)
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                self.tableView.reloadData()
            }else{
                let tryAgainAlert = UIAlertController(title: "No Item Added.", message: "Please Try Again.", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try Again.", style: .default){ (action) in
                }
                tryAgainAlert.addAction(tryAgainAction)
                self.present(tryAgainAlert, animated: true, completion: nil)
            }
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create New Item"
            textfield = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
