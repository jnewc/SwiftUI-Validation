//
//  ValidationPublishers.swift
//  SwiftUI-Validation
//
//  Created by Jack Newcombe on 01/03/2020.
//  Copyright © 2020 Jack Newcombe. All rights reserved.
//

import Foundation
import Combine
import Regex

typealias ValidationErrorClosure = () -> String

typealias ValidationPublisher = AnyPublisher<Validation, Never>

class ValidationPublishers {

    // Validates whether a string property is non-empty.
    static func nonEmptyValidation(for publisher: Published<String>.Publisher,
                                   errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return publisher.map { value in
            guard value.count > 0 else {
                return .failure(message: errorMessage())
            }
            return .success
        }
        .dropFirst()
        .eraseToAnyPublisher()
    }
    
    // Validates whether a string matches a regular expression.
    static func matcherValidation(for publisher: Published<String>.Publisher,
                                  withPattern pattern: Regex,
                                  errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return publisher.map { value in
            guard pattern.matches(value) else {
                return .failure(message: errorMessage())
            }
            return .success
        }
        .dropFirst()
        .eraseToAnyPublisher()
    }
    
    // Validates whether a date falls between two other dates. If one of
    // the bounds isn't provided, a suitable distant detail is used.
    static func dateValidation(for publisher: Published<Date>.Publisher,
                               afterDate after: Date = .distantPast,
                               beforeDate before: Date = .distantFuture,
                               errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return publisher.map { date in
            return date > after && date < before ? .success : .failure(message: errorMessage())
        }.eraseToAnyPublisher()
    }

}
