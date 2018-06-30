//
//  ViewController.swift
//  ToDoey
//
//  Created by Jawahar Tunuguntla on 27/06/2018.
//  Copyright © 2018 Jawahar Tunuguntla. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCatagory: Catagory?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCatagory?.name
        guard let colorHex = selectedCatagory?.colour else{fatalError()}
        changeNavigationBarUI(with: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        changeNavigationBarUI(with: "0096FF")
    }
    
    // MARK: - Changing navigation bar UI
    
    func changeNavigationBarUI(with colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        navBar.tintColor = navBarColour
        searchBar.barTintColor = navBarColour
        
        //                navBar.barTintColor = UIColor(contrastingBlackOrWhiteColorOn: navBarColour, isFlat: true)
        //
        //                navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn: navBarColour, isFlat: true)]
    }
    
    // MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let backgroundColour = UIColor(hexString: selectedCatagory!.colour)?.darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(toDoItems!.count))){
                cell.backgroundColor = backgroundColour
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: backgroundColour, isFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print("Error is checking item done. \(error)")
            }
        }
        tableView.reloadData()
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
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once user clicks add item button.
            
            if textfield.text != ""{
                if let currentCatagory = self.selectedCatagory{
                    do{
                        try self.realm.write {
                            let newItem: Item = Item()
                            newItem.title = textfield.text!
                            currentCatagory.items.append(newItem)
                            self.realm.add(newItem)
                        }
                    }catch{
                        print("Error saving new item, \(error)")
                    }
                }
                self.tableView.reloadData()
            }else{
                let tryAgainAlert = UIAlertController(title: "No Item Added.", message: "Please Try Again.", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default){ (action) in
                }
                tryAgainAlert.addAction(tryAgainAction)
                self.present(tryAgainAlert, animated: true, completion: nil)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems(){
        toDoItems = selectedCatagory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemDeletion = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(itemDeletion)
                }
            }catch{
                print("Error deleting item in catagory \(error)")
            }
        }
    }
}

// MARK:- Search bar methods

extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
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
