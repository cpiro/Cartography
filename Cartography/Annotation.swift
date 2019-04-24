//
//  Annotation.swift
//  Cartography
//
//  Created by Chris Piro on 5/13/18.
//  Copyright © 2018 Robert Böhnke. All rights reserved.
//

import Foundation

infix operator ~?~: CartographyAnnotationPrecedence

public class CartographyAnnotationContextualizulator {
  public init() {
  }

  public func m(
    _ message: String = "",
    fileName: String = #file,
    line: Int = #line,
    column: Int = #column,
    funcName: String = #function) -> String
  {
    if message != "" {
      return "\(message) (line \(line))"
    } else {
      return "line \(line)"
    }
  }
}

precedencegroup CartographyAnnotationPrecedence {
  lowerThan: ComparisonPrecedence
}

@discardableResult public func ~?~ (left: NSLayoutConstraint, right: String) -> NSLayoutConstraint {
  left.identifier = right
  return left
}

@discardableResult public func ~?~ (left: [NSLayoutConstraint], right: String) -> [NSLayoutConstraint] {
  left.forEach { $0.identifier = right }
  return left
}
