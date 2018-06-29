//
//  CatagoryViewController.swift
//  ToDoey
//
//  Created by Jawahar Tunuguntla on 29/06/2018.
//  Copyright © 2018 Jawahar Tunuguntla. All rights reserved.
//

import UIKit
import CoreData

class CatagoryViewController: UITableViewController {
    
    var catagoryArray = [Catagory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
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
                let newCatagory: Catagory = Catagory(context: self.context)
                newCatagory.name = textfield.text!
                self.catagoryArray.append(newCatagory)
                self.saveData()
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
        return catagoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catagoryCell", for: indexPath)
        cell.textLabel?.text = catagoryArray[indexPath.row].name
        return cell
    }
    
    //MARK: - Data manipulation methods
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Catagory> = Catagory.fetchRequest()){
        do{
            catagoryArray = try context.fetch(request)
        }catch{
            print("Error with fetching data from request \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCatagory = catagoryArray[indexPath.row]
        }
    }
}
