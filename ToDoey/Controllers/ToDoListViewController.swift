//
//  ViewController.swift
//  ToDoey
//
//  Created by Jawahar Tunuguntla on 27/06/2018.
//  Copyright © 2018 Jawahar Tunuguntla. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCatagory: Catagory?{
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item.", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create New Item"
            textfield = alertTextfield
        }
        
        let action = UIAlertAction(title: "Add Item.", style: .default) { (action) in
            // What will happen once user clicks add item button.
            
            if textfield.text != ""{
                let newItem: Item = Item(context: self.context)
                newItem.title = textfield.text!
                newItem.done = false
                newItem.parentCatagory = self.selectedCatagory
                self.itemArray.append(newItem)
                self.saveData()
            }else{
                let tryAgainAlert = UIAlertController(title: "No Item Added.", message: "Please Try Again.", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try Again.", style: .default){ (action) in
                }
                tryAgainAlert.addAction(tryAgainAction)
                self.present(tryAgainAlert, animated: true, completion: nil)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Loads items saved
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let catagoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCatagory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catagoryPredicate, additionalPredicate])
        }else{
            request.predicate = catagoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error with fetching data from request \(error)")
        }
        tableView.reloadData()
    }
}

// MARK:- Search bar methods

extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: request.predicate!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
