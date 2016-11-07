//
//  ViewController.swift
//  SearchGitHubAPI
//
//  Created by Michał Czerniakowski on 04.11.2016.
//  Copyright © 2016 Michał Czerniakowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    var searchPreRequisities = GitHubAPIConditions()
    var gitRepositories: [GitHubAPI]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarSetUp()
        tableViewPreSetup()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableViewPreSetup() {
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var reusableCell = tableView.dequeueReusableCell(withIdentifier: "CustomGITCell", for: indexPath) as! CustomGITCell
        
        let gitRepository = gitRepositories![indexPath.row]
        
        reusableCell.nameLabel.text = gitRepository.name!
        reusableCell.descriptionLabel.text = gitRepository.description!
        
        return reusableCell
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let gitRepositories = gitRepositories {
            
            return gitRepositories.count
        } else {
            
            return 0
        }

    }
    
    
    func searchBarSetUp() {
    
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    internal func searchInit(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        GitHubAPI.startRepoFetch(settings: searchPreRequisities, successCallback: { (repositories) -> Void in
            self.gitRepositories = repositories
            for repository in repositories {
                
                print("[Name: \(repository.name!)]" +
                    "\n\t[Description: \(repository.description!)]" +
                    "\n\t[Stars: \(repository.stars!)]" +
                    "\n\t[Owner: \(repository.ownerLogin!)]" +
                    "\n\t[Avatar: \(repository.ownerAvatarURL!)]")
                //var singleRepo = ["name" : repo.name, "description" : repo.description]  as? NSDictionary
                //self.repositories = singleRepo as? [NSDictionary]
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.reloadData()
        }, error: { (error) -> Void in
            
            print(error!)
            
        })
    }
}


extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchPreRequisities.searchString = searchBar.text
        searchBar.resignFirstResponder()
        searchInit()
    }

    
}
