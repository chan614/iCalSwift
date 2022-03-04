//
//  ICalAlarm.swift
//  
//
//

import Foundation

public struct ICalAlarm: VComponent {
    public let component = ICalComponent.alarm
    
    var action: String
    var trigger: Date
    var summary: String?
    var description: String?
    var duration: ICalendarDuration?
    var repetition: Int?
    var attach: String?
    
    public var properties: [VContentLine?] {
        [
            .line(ICalProperty.action, action),
            .line(ICalProperty.trigger, trigger),
            .line(ICalProperty.description, description),
            .line(ICalProperty.summary, summary),
            .line(ICalProperty.duration, duration),
            .line(ICalProperty.repetition, repetition),
            .line(ICalProperty.attach, attach)
        ]
    }
    
    public static func audioProp(
        trigger: Date,
        duration: ICalDuration? = nil,
        repetition: Int? = nil,
        attach: String? = nil
    ) -> ICalAlarm {
        return .init(
            action: "AUDIO",
            trigger: trigger,
            summary: nil,
            description: nil,
            duration: duration,
            repetition: repetition,
            attach: attach)
    }
    
    public static func displayProp(
        trigger: Date,
        description: String,
        duration: ICalDuration? = nil,
        repetition: Int? = nil
    ) -> ICalAlarm {
        return .init(
            action: "DISPLAY",
            trigger: trigger,
            summary: nil,
            description: description,
            duration: duration,
            repetition: repetition,
            attach: nil)
    }
    
    public static func emailProp(
        trigger: Date,
        description: String,
        summary: String,
        duration: ICalDuration? = nil,
        repetition: Int? = nil,
        attach: String? = nil
    ) -> ICalAlarm {
        return .init(
            action: "EMAIL",
            trigger: trigger,
            summary: summary,
            description: description,
            duration: duration,
            repetition: repetition,
            attach: attach)
    }
}
