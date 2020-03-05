//
//  Model.swift
//  SwiftUI-Validation
//
//  Created by Jack Newcombe on 04/03/2020.
//  Copyright © 2020 Jack Newcombe. All rights reserved.
//

import Foundation
import Combine

let postcodeRegex = "[A-Z]{1,2}[0-9]{1,2}[A-Z]?\\s?[0-9][A-Z]{2}"

class Model: ObservableObject {
    
    // MARK: Published Properties
    
    // Names
    
    @Published var firstName: String = ""

    @Published var middleNames: String = ""

    @Published var lastNames: String = ""
    
    // Personal Information

    @Published var birthday: Date = Date()
    
    // Address
        
    @Published var addressHouseNumberOrName: String = ""
    
    @Published var addressFirstLine: String = ""

    @Published var addressSecondLine: String = ""

    @Published var addressPostcode: String = ""
    
    @Published var addressCountry: String = ""
    
    // MARK: Validation Publishers
    
    // Names
    
    lazy var firstNameValidation: ValidationPublisher = {
        $firstName.nonEmptyValidator("First name must be provided")
    }()
    
    lazy var lastNamesValidation: ValidationPublisher = {
        $lastNames.nonEmptyValidator("Last name(s) must be provided")
    }()
    
    // Personal Information
    
    lazy var birthdayValidation: ValidationPublisher = {
        $birthday.dateValidation(beforeDate: Date(), errorMessage: "Date must be before today")
    }()
    
    // Address
    
    lazy var addressHouseNumberOrNameValidation: ValidationPublisher = {
        $addressHouseNumberOrName.nonEmptyValidator("House number or name must not be empty")
    }()

    lazy var addressFirstLineValidation: ValidationPublisher = {
        $addressFirstLine.nonEmptyValidator("House number or name must not be empty")
    }()

    lazy var postcodeValidation: ValidationPublisher = {
        $addressPostcode.matcherValidation(postcodeRegex, "Postcode is not valid")
    }()
    
    // MARK: Combined Publishers
    
    // These are split up by section as CombineLatest only supports
    // a maximum of 4 input publishers maximum.
    
    lazy var allNamesValidation: ValidationPublisher = {
        Publishers.CombineLatest3(
            firstNameValidation,
            lastNamesValidation,
            birthdayValidation
        ).map { v1, v2, v3 in
            print("firstNameValidation: \(v1)")
            print("lastNamesValidation: \(v2)")
            print("birthdayValidation: \(v3)")
            return [v1, v2, v3].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
        }.eraseToAnyPublisher()
    }()
        
    lazy var allAddressValidation: ValidationPublisher = {
        Publishers.CombineLatest3(
            addressHouseNumberOrNameValidation,
            addressFirstLineValidation,
            postcodeValidation
        ).map { v1, v2, v3 in
            print("addressHouseNumberOrNameValidation: \(v1)")
            print("addressFirstLineValidation: \(v2)")
            print("postcodeValidation: \(v3)")
            return [v1, v2, v3].allSatisfy {
                $0.isSuccess } ? .success : .failure(message: "")
        }.eraseToAnyPublisher()
    }()
    
    lazy var allValidation: ValidationPublisher = {
        Publishers.CombineLatest(
            allNamesValidation,
            allAddressValidation
        ).map { v1, v2 in
            return [v1, v2].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
        }.eraseToAnyPublisher()
    }()

}

