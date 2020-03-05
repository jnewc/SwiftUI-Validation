//
//  Validation.swift
//  SwiftUI-Validation
//
//  Created by Jack Newcombe on 01/03/2020.
//  Copyright © 2020 Jack Newcombe. All rights reserved.
//

import Foundation

enum Validation {
    case success
    case failure(message: String)
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}
