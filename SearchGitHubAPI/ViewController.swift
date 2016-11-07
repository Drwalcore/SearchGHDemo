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
        
    }
    
    
//MARK: TableView Set Up and Options
    
    func tableViewPreSetup() {
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var reusableCell = self.tableView.dequeueReusableCell(withIdentifier: "CustomGITCell", for: indexPath) as! CustomGITCell
        
        let gitRepository = gitRepositories![indexPath.row]
        
        reusableCell.nameLabel?.text = gitRepository.name!
        reusableCell.descriptionLabel?.text = gitRepository.description!
        
        return reusableCell
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let gitRepositories = gitRepositories {
            
            return gitRepositories.count
        } else {
            
            return 0
        }

    }
    
//MARK: Search Bar Setup and Options
    
    func searchBarSetUp() {
    
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Type to search GitHub repositories!"
        
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.spellCheckingType = .no
        
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    
    internal func searchInit(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        GitHubAPI.startRepoFetch(settings: searchPreRequisities, successCallback: { (repositories) -> Void in
            self.gitRepositories = repositories
            for repository in repositories {
                
                print("[Name: \(repository.name!)]" +
                    "\n\t[Description: \(repository.description)]" +
                    "\n\t[Stars: \(repository.stars!)]" +
                    "\n\t[Owner: \(repository.ownerLogin!)]" +
                    "\n\t[Avatar: \(repository.ownerAvatarURL!)]")
                
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
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // to limit network activity, reload half a second after last key press.
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ViewController.searchInit), object: nil)
//        self.perform(#selector(ViewController.searchInit), with: nil, afterDelay: 1.0)
////        self.tableView.reloadData()
//    }

    
}
