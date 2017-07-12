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
    
    fileprivate var unistrokes = [Unistroke]()
    
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
        unistrokes = database.getUnistrokes()
    }

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: GestureTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: GestureTableViewCell.identifier)
    }
}

extension GestureListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unistrokes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let gestureLabel = tableView.dequeueReusableCell(withIdentifier: GestureTableViewCell.identifier) as! GestureTableViewCell
        
        if indexPath.row < unistrokes.count {
            gestureLabel.label.text = unistrokes[indexPath.row].name
        } else {
            gestureLabel.label.text = "Dodaj gest"
        }
        return gestureLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= unistrokes.count {
            performSegue(withIdentifier: Segues.goToAddGesture, sender: nil)
        }
    }
    
    
}
