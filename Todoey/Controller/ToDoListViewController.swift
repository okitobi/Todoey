//
//  ViewController.swift
//  Todoey
//
//  Created by Joseph Ray on 6/27/19.
//  Copyright © 2019 Joseph Ray. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController
{
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let newItem = Item()
        newItem.itemName = "Workout"
        itemArray.append(newItem)
        
       if let items = defaults.array(forKey: "ToDoListArray") as? [Item]
        {
            itemArray = items

        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.itemName
        
        // same as below, but better
        cell.accessoryType = item.itemCompleted ? .checkmark : .none
        cell.textLabel?.textColor = item.itemCompleted ? .lightGray : .black

//        if item.itemCompleted == true
//        {
//            cell.accessoryType = .checkmark
//            cell.textLabel?.textColor = .lightGray
//        }
//        else
//        {
//            cell.accessoryType = .none
//            cell.textLabel?.textColor = .black
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print(itemArray[indexPath.row])
        
        // this is the same as below, but better
        itemArray[indexPath.row].itemCompleted = !itemArray[indexPath.row].itemCompleted
        
//        if itemArray[indexPath.row].itemCompleted == true
//        {
//            itemArray[indexPath.row].itemCompleted = false
//        }
//        else
//        {
//            itemArray[indexPath.row].itemCompleted = true
//        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        { (action) in
            // what will happen once user clicks the Add Item button on our UIalert
            print(textField.text!)
            
            let newItem = Item()
            
            newItem.itemName = textField.text!
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField
        { (alertTextField) in
            alertTextField.placeholder = "Enter New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

