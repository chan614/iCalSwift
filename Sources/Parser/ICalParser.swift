//
//  ICalParser.swift
//  
//
//

import Foundation

public class ICalParser {
    public struct ComponentElement {
        let properties: [(name: String, value: String)]
        
        func findProperty(name: String) -> (name: String, value: String)? {
            return properties
                .filter { $0.name == name }
                .first
        }
    }
    
    // MARK: - Parse
    
    public func parseCalendar(ics: String) -> ICalendar {
        let elements = icsToElements(ics: ics)
        
        let vEvents = findElement(component: ICalComponent.event, elements: elements)
        let vAlarams = findElement(component: ICalComponent.alarm, elements: elements)
        let vTimeZones = findElement(component: ICalComponent.timeZone, elements: elements)
        
        let events = buildEvents(elements: vEvents)
        let alarms = buildAlarms(elements: vAlarams)
        let timeZones = buildTimeZones(elements: vTimeZones)
        
        return ICalendar(
            prodid: .init(),
            calscale: nil,
            method: nil,
            events: events,
            timeZones: timeZones,
            alarms: alarms)
    }
    
    public func parseEvent(ics: String) -> [ICalEvent] {
        let elements = icsToElements(ics: ics)
        
        let vEvents = findElement(component: ICalComponent.event, elements: elements)
        
        return buildEvents(elements: vEvents)
    }
    
    public func parseAlarm(ics: String) -> [ICalAlarm] {
        let elements = icsToElements(ics: ics)
        let vAlarams = findElement(component: ICalComponent.alarm, elements: elements)
        
        return buildAlarms(elements: vAlarams)
    }
    
    public func parseTimeZone(ics: String) -> [ICalTimeZone] {
        let elements = icsToElements(ics: ics)
        let vTimeZones = findElement(component: ICalComponent.timeZone, elements: elements)
        
        return buildTimeZones(elements: vTimeZones)
    }
    
    // MARK: - Build component
    
    /// VEvent
    public func buildEvents(elements: [ComponentElement]) -> [ICalEvent] {
        return elements.map { element -> ICalEvent in
            var event = ICalEvent()
            var rdates = [Date]()
            var exdates = [Date]()
            var extendProperties = [String: VPropertyEncodable]()
            
            element.properties.forEach { property in
                switch property.name {
                case ICalProperty.dtstamp:
                    event.dtstamp = buildDateTime(propName: property.name, value: property.value)?.date ?? Date()
                case ICalProperty.uid:
                    event.uid = property.value
                case ICalProperty.classification:
                    event.classification = property.value
                case ICalProperty.created:
                    event.created = buildDateTime(propName: property.name, value: property.value)?.date
                case ICalProperty.description:
                    event.description = property.value
                case ICalProperty.dtstart:
                    event.dtstart = buildDateTime(propName: property.name, value: property.value)
                case ICalProperty.lastModified:
                    event.lastModified = buildDateTime(propName: property.name, value: property.value)?.date
                case ICalProperty.location:
                    event.location = property.value
                case ICalProperty.organizer:
                    event.organizer = property.value
                case ICalProperty.priority:
                    event.priority = Int(property.value)
                case ICalProperty.seq:
                    event.seq = Int(property.value)
                case ICalProperty.status:
                    event.status = property.value
                case ICalProperty.summary:
                    event.summary = property.value
                case ICalProperty.transp:
                    event.transp = property.value
                case ICalProperty.url:
                    event.url = URL(string: property.value)
                case ICalProperty.dtend:
                    event.dtend = buildDateTime(propName: property.name, value: property.value)
                case ICalProperty.duration:
                    event.duration = buildDuration(value: property.value)
                case ICalProperty.recurrenceID:
                    event.recurrenceID = buildDateTime(propName: property.name, value: property.value)?.date
                case ICalProperty.rrule:
                    event.rrule = buildRule(value: property.value)
                case ICalProperty.exrule:
                    event.exrule = buildRule(value: property.value)
                case ICalProperty.rdates:
                    if let date = buildDateTime(propName: property.name, value: property.value)?.date {
                        rdates.append(date)
                    }
                case ICalProperty.exdates:
                    if let date = buildDateTime(propName: property.name, value: property.value)?.date {
                        exdates.append(date)
                    }
                default:
                    extendProperties[property.name] = property.value
                }
            }
            
            if !rdates.isEmpty {
                event.rdates = rdates
            }
            
            if !exdates.isEmpty {
                event.exdates = exdates
            }
            
            if !extendProperties.isEmpty {
                event.extendProperties = extendProperties
            }
            
            return event
        }
    }
    
    /// VAlarm
    public func buildAlarms(elements: [ComponentElement]) -> [ICalAlarm] {
        return elements.compactMap { element -> ICalAlarm? in
            guard let action = element.findProperty(name: ICalProperty.action)?.value,
                  let triggerProp = element.findProperty(name: ICalProperty.trigger)
            else {
                return nil
            }
            
            guard let trigger = buildDateTime(propName: triggerProp.name, value: triggerProp.value) else {
                return nil
            }
            
            var alarm = ICalAlarm(action: action, trigger: trigger.date)
            
            element.properties.forEach { property in
                switch property.name {
                case ICalProperty.description:
                    alarm.description = property.value
                case ICalProperty.summary:
                    alarm.summary = property.value
                case ICalProperty.duration:
                    alarm.duration = buildDuration(value: property.value)
                case ICalProperty.repetition:
                    alarm.repetition = Int(property.value)
                case ICalProperty.attach:
                    alarm.attach = property.value
                default:
                    break
                }
            }
            
            return alarm
        }
    }
    
    /// VTimeZone
    public func buildTimeZones(elements: [ComponentElement]) -> [ICalTimeZone] {
        return elements.compactMap { element -> ICalTimeZone? in
            guard let tzid = element.findProperty(name: ICalProperty.tzid)?.value else {
                return nil
            }
            
            let standardElement = findElement(
                component: ICalComponent.standard,
                elements: element.properties
            ).first
            
            let daylightElement = findElement(
                component: ICalComponent.daylight,
                elements: element.properties
            ).first
            
            let standard = buildSubTimeZone(element: standardElement)
            let daylight = buildSubTimeZone(element: daylightElement)
            
            // One of 'standardc' or 'daylightc' MUST occur and each MAY occur more than once.
            if standard == nil && daylight == nil {
                return nil
            }
            
            return ICalTimeZone(tzid: tzid, standard: standard, daylight: daylight)
        }
    }
    
    /// TimeZone sub component
    public func buildSubTimeZone(element: ComponentElement?) -> ICalSubTimeZone? {
        guard let element = element else { return nil }
        
        guard let dtStartValue = element.findProperty(name: ICalProperty.dtstart)?.value,
              let tzOffsetTo = element.findProperty(name: ICalProperty.tzOffsetTo)?.value,
              let tzOffsetFrom = element.findProperty(name: ICalProperty.tzOffsetFrom)?.value
        else {
            return nil
        }
        
        guard let dtStart = buildDateTime(propName: ICalProperty.dtstart, value: dtStartValue)?.date else {
            return nil
        }
        
        let subTimeZone = ICalSubTimeZone(
            dtstart: dtStart,
            tzOffsetTo: tzOffsetTo,
            tzOffsetFrom: tzOffsetFrom)
        
        element.properties.forEach { property in
            switch property.name {
            case ICalProperty.tzName:
                subTimeZone.tzName = property.value
            case ICalProperty.rrule:
                subTimeZone.rrule = buildRule(value: property.value)
            default:
                break
            }
        }
        
        return subTimeZone
    }
    
    // MARK: - Build property
    
    /// Duration property
    public func buildDuration(value: String) -> ICalDuration {
        let weeksStr = matcheDuration(type: "W", duration: value)
        let daysStr = matcheDuration(type: "D", duration: value)
        let hoursStr = matcheDuration(type: "H", duration: value)
        let minutesStr = matcheDuration(type: "M", duration: value)
        let secondsStr = matcheDuration(type: "S", duration: value)
        
        let weeks = Int64(weeksStr) ?? .zero
        let days = Int64(daysStr) ?? .zero
        let hours = Int64(hoursStr) ?? .zero
        let minutes = Int64(minutesStr) ?? .zero
        let seconds = Int64(secondsStr) ?? .zero
        
        return .init(weeks: weeks, days: days, hours: hours, minutes: minutes, seconds: seconds)
    }
    
    /// Recurrence Rule Property
    public func buildRule(value: String) -> ICalRule? {
        let properties = propertiesOfElement(value: value)
        let frequencyProperty = properties
            .filter { $0.name == ICalProperty.frequency }
            .first
        
        guard let frequencyProperty = frequencyProperty,
              let frequency = ICalRule.Frequency(rawValue: frequencyProperty.value)
        else {
            return nil
        }
        
        var rule = ICalRule(frequency: frequency)
        
        properties.forEach { property in
            switch property.name {
            case ICalProperty.interval:
                rule.interval = Int(property.value)
            case ICalProperty.until:
                rule.until = buildDateTime(propName: property.name, value: property.value)
            case ICalProperty.count:
                rule.count = Int(property.value)
            case ICalProperty.bySecond:
                rule.bySecond = seperateCommaProperty(value: property.value).compactMap { Int($0) }
            case ICalProperty.byMinute:
                rule.byMinute = seperateCommaProperty(value: property.value).compactMap { Int($0) }
            case ICalProperty.byHour:
                rule.byHour = seperateCommaProperty(value: property.value).compactMap { Int($0) }
            case ICalProperty.byDay:
                rule.byDay = seperateCommaProperty(value: property.value).compactMap { .from($0) }
            case ICalProperty.byDayOfMonth:
                rule.byDayOfMonth = seperateCommaProperty(value: property.value).compactMap { Int($0) }
            case ICalProperty.byDayOfYear:
                rule.byDayOfYear = seperateCommaProperty(value: property.value).compactMap { Int($0) }
            case ICalProperty.byWeekOfYear:
                rule.byWeekOfYear = seperateCommaProperty(value: property.value).compactMap { Int($0) }
            case ICalProperty.byMonth:
                rule.byMonth = seperateCommaProperty(value: property.value).compactMap { Int($0) }
            case ICalProperty.bySetPos:
                rule.bySetPos = seperateCommaProperty(value: property.value).compactMap { Int($0) }
            case ICalProperty.startOfWorkweek:
                rule.startOfWorkweek = .init(rawValue: property.value)
            default:
                break
            }
        }
        
        return rule
    }
    
    /// DateTime / Date property
    public func buildDateTime(propName: String, value: String) -> ICalDateTime? {
        let seperatedPropName = propName.components(separatedBy: ";")
        let isUTC = value.last == "Z"
        
        let timeZoneID: String = {
            if seperatedPropName.count > 1 {
                return seperatedPropName[1]
            } else if isUTC {
                return "UTC"
            } else {
                return ""
            }
        }()
        
        if let date = ICalDateTime.dateFormatter(timeZoneID: timeZoneID).date(from: value) {
            return .init(date: date, timeZoneID: timeZoneID)
        } else if let dateOnly = ICalDateTime.dateFormatter(timeZoneID: ICalDateTime.dateOnlyTZID).date(from: value) {
            return .dateOnly(dateOnly)
        }
        
        return nil
    }
    
    // MARK: - Supporting function
    
    public func icsToElements(ics: String) -> [(name: String, value: String)] {
        return ics
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: ":") }
            .filter { $0.count > 1 }
            .map { ($0[0], $0[1]) }
    }
    
    public func findElement(
        component: String,
        elements: [(name: String, value: String)]
    ) -> [ComponentElement] {
        var founds = [ComponentElement]()
        var currentComponent: [(String, String)]?
        
        for element in elements {
            if element.name == ICalProperty.begin, element.value == component {
                if currentComponent == nil {
                    currentComponent = []
                }
            }
            
            if element.name == ICalProperty.end, element.value == component {
                if let currentComponent = currentComponent {
                    let componentElement = ComponentElement(properties: currentComponent)
                    founds.append(componentElement)
                }
                currentComponent = nil
            }
            
            if currentComponent != nil {
                currentComponent?.append(element)
            }
        }
        
        return founds
    }
    
    public func propertiesOfElement(value: String) -> [(name: String, value: String)] {
        return value.components(separatedBy: ";")
            .map { $0.components(separatedBy: "=") }
            .filter { $0.count > 1 }
            .map { ($0[0], $0[1]) }
    }
    
    public func seperateCommaProperty(value: String) -> [String] {
        return value.components(separatedBy: ",")
    }
    
    public func matcheDuration(type: String, duration: String) -> String {
        do {
            let pattern = "[0-9]+\(type)"
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = NSString(string: duration)
            let results = regex.matches(
                in: duration,
                options: [],
                range: NSRange(location: 0, length: nsString.length))
            
            return results
                .map { nsString.substring(with: $0.range) }
                .map { String($0.prefix($0.count - 1)) }
                .first ?? ""
        } catch {
            return ""
        }
    }
}
