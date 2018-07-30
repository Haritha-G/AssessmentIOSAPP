//
//  AboutCanadaTableViewController.swift
//  IOSAssessmentApp
//
//  Created by HarithaReddy on 23/07/18.
//  Copyright © 2018 administrator. All rights reserved.
//

import UIKit

class AboutCanadaTableViewController: UITableViewController {
  
    var canadaPlacesArray = [Place]()
    let reuseIdentifier = "placeCellIdentifier"
    var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loading an activity indicator
        addActivityIndicator()
        initializeTheDataSource()
        
        navigationController?.navigationBar.barTintColor = UIColor.themeBlueColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(AboutCanadaTableViewController.refreshData))
        refreshButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = refreshButton
       
        
        // registering for the custom cell
        tableView.register(CustomCanadaPlaceTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }

    private func initializeTheDataSource()
    {
        //Adding network check before call , web service calls
        if ReachabilityManager.sharedInstance.isNetworkAvailable()
        {
            //showing an activity indicator
            activityIndicator?.startAnimating()
            // calling the getData in Dispatch queue to reduce the burden on mainqueue , to have a smooth ui
            DispatchQueue.global(qos: .background).async {
                ParserHelper.getData(completionHandler: { (canada, error) in
                    if error == nil
                    {
                        // using weakself inside the blocks..
                        DispatchQueue.main.async { [weak self]() in
                            // on success , updating the view title and tableview in mainQueue .
                            // hiding the activity indicator on result..
                            self?.activityIndicator.stopAnimating()
                            self?.title = canada?.title
                            self?.canadaPlacesArray = (canada?.rows)!
                            self?.tableView.reloadData()
                        }
                    }
                })
            }
        }else
        {
            // show alert on no connection ...
            showAlert()
        }
    }
    
    func addActivityIndicator()
    {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = (self.view?.center)!
        activityIndicator.hidesWhenStopped = true
        self.view?.addSubview(activityIndicator)
    }
    // calling refresh dataa on refresh click ...
    @objc func refreshData()
    {
       
        initializeTheDataSource()
        
    }
    
    func showAlert()
    {
       
        let alert = UIAlertController(title: "Ooops..!!", message: "No Inernet Connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return canadaPlacesArray.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CustomCanadaPlaceTableViewCell
        cell.place = canadaPlacesArray[indexPath.row]
        return cell

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    

}

