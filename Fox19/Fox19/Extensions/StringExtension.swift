//
//  StringExtension.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 14.02.2021.
//

import Foundation

extension String {
  func withoutWhitespace() -> String {
    return self.replacingOccurrences(of: "\n", with: "")
      .replacingOccurrences(of: "\r", with: "")
        .replacingOccurrences(of: "\0", with: "")
  }
   
    func withoutSpaces() -> String {
      return self.replacingOccurrences(of: " ", with: "")
    }
}
