//
//  String+Utilities.swift
//
//
//

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
}
