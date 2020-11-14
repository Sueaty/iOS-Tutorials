//
//  ViewController.swift
//  HolidayList
//
//  Created by Sue Cho on 2020/11/14.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- Properties
    var names = [String]()
    
    // MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Holiday List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
                names.append(dayToSave)
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

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}

