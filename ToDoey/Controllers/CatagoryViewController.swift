//
//  CatagoryViewController.swift
//  ToDoey
//
//  Created by Jawahar Tunuguntla on 29/06/2018.
//  Copyright © 2018 Jawahar Tunuguntla. All rights reserved.
//

import UIKit
import RealmSwift

class CatagoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var catagoryArray: Results<Catagory>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCatagories()
    }
    
    //MARK: - Function for when add button pressed, to add item to list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Catagory.", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextfield) in
            textfield = alertTextfield
            textfield.placeholder = "Create New Catagory"
        }
        
        let action = UIAlertAction(title: "Add Catagory.", style: .default) { (action) in
            // What will happen once user clicks add catagory button.
            
            if textfield.text != ""{
                let newCatagory: Catagory = Catagory()
                newCatagory.name = textfield.text!
                self.saveData(with: newCatagory)
            }else{
                let tryAgainAlert = UIAlertController(title: "No Catagory Added.", message: "Please Try Again.", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try Again.", style: .default){ (action) in
                }
                tryAgainAlert.addAction(tryAgainAction)
                self.present(tryAgainAlert, animated: true, completion: nil)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catagoryCell", for: indexPath)
        cell.textLabel?.text = catagoryArray?[indexPath.row].name ?? "No Catagories Added Yet."
        return cell
    }
    
    //MARK: - Data manipulation methods
    
    func saveData(with catagory: Catagory){
        do{
            try realm.write {
                realm.add(catagory)
            }
        }catch{
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCatagories(){
        catagoryArray = realm.objects(Catagory.self)
        tableView.reloadData()
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCatagory = catagoryArray?[indexPath.row]
        }
    }
}
