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
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOpenCollectionview()
        title = "Holidays To Celebrate"
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "Holiday", in: managedContext)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFromDataModel()
    }
    
    // MARK:- CollectionView Layout
    private func setupOpenCollectionview() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = layout
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
                collectionView.reloadData()
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

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return holidays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HolidayCollectionViewCell else {
            return UICollectionViewCell()
        }
        let holiday = holidays[indexPath.item]
        cell.titleLabel.text = holiday.value(forKeyPath: "name") as? String
        /// Why you need **as? String**
            /// NSManagedObject doesn’t know about the attributes and properties defined in the Data Model
        return cell
    }
}


