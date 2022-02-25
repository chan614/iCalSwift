//
//  ICalTimeZone.swift
//  
//
//

import Foundation

public struct ICalTimeZone: VComponent {
    public let component = ICalComponent.timeZone

    /// This property defines the time zone, that
    /// will be use in the event.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.6.5
    public var tzid: String
    
    /// This property defines the value of the object `DaylightComponent`
    /// which is the standard time of the Time Zone.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.6.5
    public var daylight: DaylightComponet

    /// This property defines the value of the object `StandardComponent`
    /// which is the standard time of the Time Zone.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.6.5
    public var standard: StandardComponet

    public var properties: [VContentLine?] {
        [
            .line("TZID", tzid),
        ]
    }
    
    public var children: [VComponent] {
        [
            daylight,
            standard
        ]
    }
    
    public init(
        tzid: String,
        daylight: DaylightComponet,
        standard: StandardComponet
    ) {
        self.tzid = tzid
        self.daylight = daylight
        self.standard = standard
    }
}
