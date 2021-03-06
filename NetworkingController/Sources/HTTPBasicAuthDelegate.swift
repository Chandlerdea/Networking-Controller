//
//  HTTPBasicAuthDelegate.swift
//  NetworkingController
//
//  Created by Chandler De Angelis on 9/26/17.
//  Copyright © 2017 Chandler De Angelis. All rights reserved.
//

import Foundation

final class HTTPBasicAuthDelegate: NSObject, URLSessionTaskDelegate {
    
    weak var authDelegate: NetworkingControllerAuthenticationDelegate?
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let request: URLRequest = task.originalRequest, let authDelegate: NetworkingControllerAuthenticationDelegate = self.authDelegate else {
            self.performDefaultHandling(challenge, completionHandler: completionHandler)
            return
        }
        var usernamePassword: (String, String)? = .none
        DispatchQueue.main.sync {
            usernamePassword = authDelegate.requestDidReceiveAuthenticationChallenge(request)
        }
        if let unwrappedUsernamePassword: (String, String) = usernamePassword {
            let credential: URLCredential = URLCredential(user: unwrappedUsernamePassword.0, password: unwrappedUsernamePassword.1, persistence: .permanent)
            self.useCredential(credential, challenge: challenge, completionHandler: completionHandler)
        } else {
            self.cancel(challenge, completionHandler: completionHandler)
        }
    }
    
}
