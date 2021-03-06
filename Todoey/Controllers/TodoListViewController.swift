//
//  ViewController.swift
//  Todoey
//
//  Created by Radhakrishnan, Sathish on 10/4/18.
//  Copyright © 2018 Radhakrishnan, Sathish. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
//    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
      print(dataFilePath)
        
      

        loadItems()

    }
   // Mark - Tableview Datasource Methods
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    
    //Ternary operator ==>
    
    // value = condition ? valueIfTrue : valueIfFalse
    
    cell.accessoryType = item.done ? .checkmark  : .none
 
    
    return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // mark - tableview Delegate methods
    
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("\(itemArray[indexPath.row])")
    
    itemArray[indexPath.row].done  = !itemArray[indexPath.row].done
 
    self.saveItems()
    tableView.deselectRow(at: indexPath, animated: true)
    }
//Mark - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once user clicks on the add item button uialert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField  = alertTextField
           
 
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - Save to items
    
    func saveItems()
    {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{ print("Error encoding item Array, \(error)")
            
        }
        self.tableView.reloadData()
    }
    
    func loadItems()
    {
        if  let data = try? Data(contentsOf: dataFilePath!) {
            let decoder =  PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error \(error)")
            }
        }
    }
}

