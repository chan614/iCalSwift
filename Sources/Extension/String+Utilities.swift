//
//  String+Utilities.swift
//
//
//

import Foundation

extension String {
    func chunks(ofLength length: Int) -> [String] {
        assert(length > 0, "Can only chunk string into non-empty slices.")

        guard !isEmpty else { return [""] }

        var chunks = [String]()
        var currentIndex = startIndex
        var remaining = count

        while currentIndex < endIndex {
            let nextIndex = index(currentIndex, offsetBy: min(length, remaining))
            chunks.append(String(self[currentIndex..<nextIndex]))
            currentIndex = nextIndex
            remaining -= length
        }

        return chunks
    }
    
    func replacing(pattern: String, with template: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return self
        }
        let range = NSRange(0..<self.utf16.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: template)
    }
}
