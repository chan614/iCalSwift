//
//  ICalTimeZone.swift
//  
//
//

import Foundation

/// Provide a grouping of component properties that defines a
/// time zone.
///
/// See https://tools.ietf.org/html/rfc5545#section-3.6.5
public struct ICalTimeZone: VComponent {
    public let component = Constant.Component.timeZone

    /// This property defines the time zone, that
    /// will be use in the event.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.6.5
    public var tzid: String
    
    /// This property defines the value of the object `StandardComponent`
    /// which is the standard time of the Time Zone.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.6.5
    public var standard: ICalSubTimeZone?
    
    /// This property defines the value of the object `DaylightComponent`
    /// which is the standard time of the Time Zone.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.6.5
    public var daylight: ICalSubTimeZone?

    public var properties: [VContentLine?] {
        [
            .line(Constant.Prop.tzid, tzid),
        ]
    }
    
    public var children: [VComponent] {
        var subComponent = [VComponent]()
        
        if let standard = standard {
            subComponent.append(standard)
        }
        
        if let daylight = daylight {
            subComponent.append(daylight)
        }
        
        return subComponent
    }
    
    public init(
        tzid: String,
        standard: ICalSubTimeZone? = nil,
        daylight: ICalSubTimeZone? = nil
    ) {
        assert(
            standard != nil || daylight != nil ,
            "One of 'standardc' or 'daylightc' MUST occur and each MAY occur more than once."
        )
        
        self.tzid = tzid
        self.standard = standard
        self.daylight = daylight
    }
}
