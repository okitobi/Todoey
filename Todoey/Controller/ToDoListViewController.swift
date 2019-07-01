//
//  ViewController.swift
//  Todoey
//
//  Created by Joseph Ray on 6/27/19.
//  Copyright © 2019 Joseph Ray. All rights reserved.
//

// DELETED ITEM.SWIFT AS IT WAS REPLACED BY ATTRIBUTES WITHIN COREDATA, ITEM.SWIFT ORIGINALLY HELD THE
// CLASS ITEM WHICH WAS USED TO HOLD EACH ENTRY IN THE TO DO LIST

import UIKit
import CoreData

class ToDoListViewController: UITableViewController
{
    var itemArray = [Item]()
    
    var selectedCategory : Category?
    {
        didSet
        {
            loadItems()
        }
    }
    
    // used for ecoded data
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
//        let newItem = Item()
//        newItem.itemName = "Workout"
//        itemArray.append(newItem)
        
//       if let items = defaults.array(forKey: "ToDoListArray") as? [Item]
//        {
//            itemArray = items
//
//        }
        
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        saveItems()
        
//        if itemArray[indexPath.row].itemCompleted == true
//        {
//            itemArray[indexPath.row].itemCompleted = false
//        }
//        else
//        {
//            itemArray[indexPath.row].itemCompleted = true
//        }
        
        //tableView.reloadData()
        
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
            
            let newItem = Item(context: self.context)
            newItem.itemName = textField.text!
            newItem.itemCompleted = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField
        { (alertTextField) in
            alertTextField.placeholder = "Enter New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - save data function
    
    func saveItems()
    {
        
        do
        {
           try context.save()
        }
        catch
        {
            print("Error saving context, \(error)")
        }
        
        
        
        // this is the previous method through an encoder
//        let encoder = PropertyListEncoder()
//
//        do
//        {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//
//        }
//        catch
//        {
//            print("Error encoding item array, \(error)")
//        }
        
        //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
        
        self.tableView.reloadData()
    }
    
//    func loadItems()
//    {
//
//            if let data = try? Data(contentsOf: dataFilePath!)
//            {
//                let decoder = PropertyListDecoder()
//                do
//                {
//                    itemArray = try decoder.decode([Item].self, from: data)
//                }
//                catch
//                {
//                    print("Error decoding item array, \(error)")
//                }
//            }
//
//    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)
    {
        // this was redundant with the newly added parameters
        // let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", (selectedCategory?.categoryName!)!)
        
        if let additionalPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        
        // same as above but above now handles unwrapping with nil checks
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do
        {
            itemArray = try context.fetch(request)
        }
        catch
        {
            print("There was an error retrieving data: \(error)")
        }
        
    }
    
}

//MARK: - Search bar methods
extension ToDoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
//        let predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
//
//        request.predicate = predicate
        
        // this is same as above just shorter
        request.predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
        
        // this is same as below but shorter (notice the array braces)
        request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
        
//        let sortDescriptor = NSSortDescriptor(key: "itemName", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
        
//        do
//        {
//            itemArray = try context.fetch(request)
//        }
//        catch
//        {
//            print("There was an error retrieving data: \(error)")
//        }

        // same as above just using a modified version of loadItems that now accepts a request
        loadItems(with : request, predicate: request.predicate!)
        
        
        //tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text?.count == 0
        {
            loadItems()
            
            DispatchQueue.main.async
            {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
    

}
