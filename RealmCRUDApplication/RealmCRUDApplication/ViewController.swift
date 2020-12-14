//
//  ViewController.swift
//  RealmCRUDApplication
//
//  Created by Johan Lindström on 2020-12-06.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var addBtn: UIButton!
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Quick button design
        addBtn.backgroundColor = UIColor.systemBlue
        addBtn.setTitle("Add Todo Item", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.layer.cornerRadius = 5
        
        // Important for the tableView to know what to display and user interaction
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK: UITableViewDelegate Methods
    
    // Define what kind of cell we want to show
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = todoList[indexPath.row]
        
        cell.textLabel!.text = item.detail
        cell.detailTextLabel!.text = "\(item.status)"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // The numbers of row is equal to the amount/length in our todoList
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    //MARK: UPDATE
    // The changing status of the row selected either 1 or 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = todoList[indexPath.row]
        try! self.realm.write({
            if (item.status == 0){      // set status = 1 if it is currently 0
                item.status = 1
            }else{
                item.status = 0         // otherwise we set it back to 0
            }
        })
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    // Enables the edit of UITableView, for features like swipe to delete if so return true
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: DELETE
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if (editingStyle == .delete){           // Swiping edit style call .delete
            let item = todoList[indexPath.row]
            try! self.realm.write({
                self.realm.delete(item)         // Ask Realm to delete the item based on the indexPath
            })
                                                // Update the table view by delete the specific row.
            tableView.deleteRows(at:[indexPath], with: .automatic)

        }
    }
    
    let realm = try! Realm() // Declare the realm object
    var todoList: Results<TodoItem> { // Result we will get from the database
        get {
            return realm.objects(TodoItem.self)
        }
    }
    
    //MARK: Add Todo Button
    @IBAction func addNew(_ sender: Any) {
        // Create our UIAlertController
        let alertController : UIAlertController = UIAlertController(title: "New Todo Item", message: "What do you plan to do?", preferredStyle: .alert)
        // Adding a UITextField helps us get the user input
        alertController.addTextField { (UITextField) in

        }

        let action_cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (UIAlertAction) -> Void in

        }
        alertController.addAction(action_cancel)
        //MARK: WRITE/CREATE
        let action_add = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) -> Void in
            // Print the message typed by the user after pressing add in the alert
            let textField_todo = (alertController.textFields?.first)! as UITextField
            print("You entered \(String(describing: textField_todo.text))")
            
            let todoItem = TodoItem()               // Instanstiate a new TodoItem and sets detail and status
            todoItem.detail = textField_todo.text!
            todoItem.status = 0

            try! self.realm.write({                 // The TodoItem is saved into realm persistent with the write method
                self.realm.add(todoItem)
                self.tableView.insertRows(at: [IndexPath.init(row: self.todoList.count-1, section: 0)], with: .automatic)
            })

        }
        alertController.addAction(action_add)

        present(alertController, animated: true, completion: nil)
    }
    
}

