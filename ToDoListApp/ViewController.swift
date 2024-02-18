//
//  ViewController.swift
//  ToDoListApp
//
//  Created by user236101 on 2/17/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tblView: UITableView!
    
    //var toDoList: [String] = ["Cooking", "Yoga", "Swimming"]
    var toDoList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.dataSource = self
        self.tblView.delegate = self
        // Do any additional setup after loading the view.
        
        if let saveToDoList = UserDefaults.standard.array(forKey: "toDoList") as? [String] {
            self.toDoList = saveToDoList
        } else {
            // Default tasks if nothing is saved
            self.toDoList = ["Cooking", "Yoga", "Swimming"]
        }
    }
        func saveData() {
            UserDefaults.standard.set(toDoList, forKey: "toDoList")
            UserDefaults.standard.synchronize() // Synchronize UserDefaults
        }

        @IBAction func btnAdd(_ sender: UIButton) {
            let alert = UIAlertController(title: "Add To DO Task", message: "Please enter To Do Task", preferredStyle: .alert)
            alert.addTextField{(textField) in
                textField.placeholder = "Enter a To Do Task"
            }
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(_) in
                //let textField = alert?.textFields![0]
                guard let textField = alert.textFields?.first, let task = textField.text, !task.isEmpty else {
                    return
                }
                self.toDoList.append(task)
                self.saveData()
                self.tblView.beginUpdates()
                self.tblView.insertRows(at: [IndexPath(row: self.toDoList.count-1, section: 0)], with: .automatic)
                self.tblView.endUpdates()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(_) in
                alert.dismiss(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        //MARK: Set view movable/editable
        func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        //MARK: Move item
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let movedObject = self.toDoList[sourceIndexPath.row]
            toDoList.insert(movedObject, at: destinationIndexPath.row)
            toDoList.remove(at: sourceIndexPath.row)
            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return toDoList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier:"todocell", for: indexPath)
            cell.textLabel?.text = toDoList[indexPath.row]
            return cell
        }
        //MARK: remove item
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                toDoList.remove(at: indexPath.row)
                saveData()
                tblView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        //MARK: Add delete button at left
        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
        
    }
