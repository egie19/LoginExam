//
//  WelcomeViewController.swift
//  LoginExam
//
//  Created by Lowiegie Oblenida on 1/13/25.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var viewModel: WelcomeViewModel?
    
    @IBOutlet weak var labelUsername: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel else { return }
        title = "Welcome"
        labelUsername.text = viewModel.userModel.username
    }

}
