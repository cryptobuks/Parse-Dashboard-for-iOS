//
//  SchemaViewController.swift
//  Parse Dashboard for iOS
//
//  Created by Nathan Tannar on 2/28/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents

class SchemaViewController: NTTableViewController {
    
    var server: ParseServer?
    var schemas = [ParseClass]()
    
    convenience init(server: ParseServer) {
        self.init()
        self.server = server
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleView(title: server!.name!.isEmpty ? server?.applicationId : server?.name, subtitle: "Classes")
        view.backgroundColor = UIColor(r: 21, g: 156, b: 238)
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 10
        tableView.backgroundColor = UIColor(r: 21, g: 156, b: 238)
        tableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSchema))
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        handleRefresh()
    }
    
    override func handleRefresh() {
        schemas.removeAll()
        tableView.reloadSections([0], with: .automatic)
        tableView.refreshControl?.beginRefreshing()
        Parse.get(endpoint: "/schemas") { (json) in
            guard let results = json["results"] as? [[String: AnyObject]] else {
                DispatchQueue.main.async {
                    NTToast(text: "Unexpected Results, is your URL correct?", color: UIColor(r: 30, g: 59, b: 77), height: 50).show(duration: 3.0)
                    self.tableView.refreshControl?.endRefreshing()
                }
                return
            }
            for result in results {
                self.schemas.append(ParseClass(result))
            }
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func addSchema() {
        let alertController = UIAlertController(title: "Create Class", message: nil, preferredStyle: .alert)
        alertController.view.tintColor = Color.Default.Tint.View
        
        let saveAction = UIAlertAction(title: "Create", style: .default, handler: {
            alert -> Void in
            
            guard let schemaClassname = alertController.textFields![0].text else { return }
            Parse.post(endpoint: "/schemas/" + schemaClassname, completion: { (response, json, success) in
                DispatchQueue.main.async {
                    NTToast(text: response, color: UIColor(r: 30, g: 59, b: 77), height: 50).show(duration: 2.0)
                    if success {
                        let schema = ParseClass(json)
                        DispatchQueue.main.async {
                            self.schemas.insert(schema, at: 0)
                            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                        }
                    }
                }
            })
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Classname"
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schemas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ParseClassCell()
        cell.parseClass = schemas[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ClassViewController(parseClass: schemas[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let detailAction = UITableViewRowAction(style: .default, title: "Details", handler: { action, indexpath in
            let detailVC = SchemaDetailViewController(self.schemas[indexPath.row])
            self.navigationController?.pushViewController(detailVC, animated: true)
        })
        detailAction.backgroundColor = UIColor(r: 14, g: 105, b: 160)
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { action, indexpath in
            
            let alert = NTAlertViewController(title: "Are you sure?", subtitle: "This cannot be undone", type: .isDanger)
            alert.onConfirm = {
                let classname = self.schemas[indexPath.row].name
                Parse.delete(endpoint: "/schemas/" + classname!, completion: { (response, code, success) in
                    DispatchQueue.main.async {
                        NTToast(text: response, color: UIColor(r: 30, g: 59, b: 77), height: 50).show(duration: 2.0)
                        if success {
                            self.schemas.remove(at: indexPath.row)
                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }
                })
            }
            alert.show(self, sender: nil)
        })
        deleteAction.backgroundColor = Color.Default.Status.Danger
        
        return [deleteAction, detailAction]
    }
}
