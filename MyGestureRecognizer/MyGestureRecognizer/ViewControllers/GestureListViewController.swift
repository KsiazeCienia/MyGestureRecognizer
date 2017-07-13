//
//  GestureListViewController.swift
//  MyGestureRecognizer
//
//  Created by Marcin on 12.07.2017.
//  Copyright © 2017 Marcin Włoczko. All rights reserved.
//

import UIKit

class GestureListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let database = Database()
    
    fileprivate var multistrokes = [Multistroke]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        multistrokes = database.getMultistrokes()
        tableView.reloadData()
    }

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: GestureTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: GestureTableViewCell.identifier)
    }
}

extension GestureListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multistrokes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let gestureLabel = tableView.dequeueReusableCell(withIdentifier: GestureTableViewCell.identifier) as! GestureTableViewCell
        
        if indexPath.row < multistrokes.count {
            gestureLabel.label.text = multistrokes[indexPath.row].name
        } else {
            gestureLabel.label.text = "Dodaj gest"
        }
        return gestureLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= multistrokes.count {
            performSegue(withIdentifier: Segues.goToAddGesture, sender: nil)
        }
    }
    
    
}
