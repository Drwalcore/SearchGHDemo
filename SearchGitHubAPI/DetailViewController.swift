//
//  DetailViewController.swift
//  SearchGitHubAPI
//
//  Created by Michał Czerniakowski on 07.11.2016.
//  Copyright © 2016 Michał Czerniakowski. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var OwnerName: UILabel!
    @IBOutlet weak var StarsNumber: UILabel!
    @IBOutlet weak var StarImage: UIImageView!
    @IBOutlet weak var RepoName: UILabel!
    @IBOutlet weak var RepoDescription: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    private var user: User? = nil
    private var repo: GitHubAPI? = nil

    func update(withUser user: User) {
        self.user = user
    }
    
    func update(withRepository repo: GitHubAPI) {
        self.repo = repo
    }
    
    func downloadImage(link: String?) {
        guard let linkVal = link else {
            return
        }
        let url = URL(string: linkVal)
        Avatar.setImageWith(url!)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
