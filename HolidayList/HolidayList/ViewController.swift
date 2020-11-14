//
//  ViewController.swift
//  HolidayList
//
//  Created by Sue Cho on 2020/11/14.
//

import UIKit
import CoreData

final class ViewController: UIViewController {

    // MARK:- Properties
    var holidays = [NSManagedObject]()
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    var entity: NSEntityDescription!
    
    // MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "Holiday", in: managedContext)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFromDataModel()
    }

    // MARK:- IBActions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addHolidayAlert = UIAlertController(
            title: "New Holiday",
            message: "Add a New Holiday",
            preferredStyle: .alert
        )
        let saveAction = UIAlertAction(
            title: "Save",
            style: .default,
            handler: { [unowned self] action in
                guard let textField = addHolidayAlert.textFields?.first,
                      let dayToSave = textField.text else { return }
                save(name: dayToSave)
                tableView.reloadData()
            })
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)

        addHolidayAlert.addTextField(configurationHandler: nil)
        addHolidayAlert.addAction(saveAction)
        addHolidayAlert.addAction(cancelAction)
        present(addHolidayAlert, animated: true)
    }
    
    // MARK:- CoreData related Functions
    private func save(name: String) {
        let holiday = NSManagedObject(entity: entity, insertInto: managedContext)
        holiday.setValue(name, forKey: "name")
        do {
            try managedContext.save()
            holidays.append(holiday)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func fetchFromDataModel() {
        let fetchedRequest = NSFetchRequest<NSManagedObject>(entityName: "Holiday")
        do {
            holidays = try managedContext.fetch(fetchedRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holidays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let holiday = holidays[indexPath.row]
        cell.textLabel?.text = holiday.value(forKeyPath: "name") as? String
        /// Why you need **as? String**
            /// NSManagedObject doesn’t know about the attributes and properties defined in the Data Model
        return cell
    }
}

