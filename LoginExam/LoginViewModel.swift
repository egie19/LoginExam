//
//  LoginViewModel.swift
//  LoginExam
//
//  Created by Lowiegie Oblenida on 1/13/25.
//

import UIKit

class LoginViewModel {
    
    var model = UserModel()
    
    func login(username: String, password: String, completion: @escaping (Bool, UserModel?)->()) {
        // allowed any user input
        if password == "password" {
            model.username = username
            completion(true, model)
        } else {
            completion(false, nil)
        }
        
    }
    

}
