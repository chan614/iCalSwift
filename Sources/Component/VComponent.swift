//
//  VComponent.swift
//
//
//

/// A component enclosed by BEGIN: and END:.
public protocol VComponent: VEncodable {
    /// The component's 'type' that is used in the BEGIN/END
    /// declaration.
    var component: String { get }

    /// The component's properties.
    var properties: [VContentLine?] { get }

    /// The component's children.
    var children: [VComponent] { get }
}

public extension VComponent {
    var properties: [VContentLine?] { [] }
    var children: [VComponent] { [] }

    var contentLines: [VContentLine?] {
        [.line("BEGIN", component)]
        + properties
        + children.flatMap(\.contentLines)
        + [.line("END", component)]
    }

    var vEncoded: String {
        contentLines
            .compactMap { $0?.vEncoded }
            .joined()
    }
}
