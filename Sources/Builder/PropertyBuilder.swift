//
//  PropertyBuilder.swift
//  
//
//

import Foundation

class PropertyBuilder {
    
    /// Duration property
    static func buildDuration(value: String) -> ICalDuration {
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
    static func buildRRule(value: String) -> ICalRRule? {
        let properties = propertiesOfValue(value)
        let frequencyProperty = properties
            .filter { $0.name == Constant.Prop.frequency }
            .first
        
        guard let frequencyProperty = frequencyProperty,
              let frequency = ICalRRule.Frequency(rawValue: frequencyProperty.value)
        else {
            return nil
        }
        
        var rule = ICalRRule(frequency: frequency)
        
        properties.forEach { property in
            switch property.name {
            case Constant.Prop.interval:
                rule.interval = Int(property.value)
            case Constant.Prop.until:
                rule.until = buildDateTime(propName: property.name, value: property.value)
            case Constant.Prop.count:
                rule.count = Int(property.value)
            case Constant.Prop.bySecond:
                rule.bySecond = separateCommaProperty(value: property.value).compactMap { Int($0) }
            case Constant.Prop.byMinute:
                rule.byMinute = separateCommaProperty(value: property.value).compactMap { Int($0) }
            case Constant.Prop.byHour:
                rule.byHour = separateCommaProperty(value: property.value).compactMap { Int($0) }
            case Constant.Prop.byDay:
                rule.byDay = separateCommaProperty(value: property.value).compactMap { .from($0) }
            case Constant.Prop.byDayOfMonth:
                rule.byDayOfMonth = separateCommaProperty(value: property.value).compactMap { Int($0) }
            case Constant.Prop.byDayOfYear:
                rule.byDayOfYear = separateCommaProperty(value: property.value).compactMap { Int($0) }
            case Constant.Prop.byWeekOfYear:
                rule.byWeekOfYear = separateCommaProperty(value: property.value).compactMap { Int($0) }
            case Constant.Prop.byMonth:
                rule.byMonth = separateCommaProperty(value: property.value).compactMap { Int($0) }
            case Constant.Prop.bySetPos:
                rule.bySetPos = separateCommaProperty(value: property.value).compactMap { Int($0) }
            case Constant.Prop.startOfWorkweek:
                rule.startOfWorkweek = .init(rawValue: property.value)
            default:
                break
            }
        }
        
        return rule
    }
    
    /// DateTime / Date property
    static func buildDateTime(propName: String, value: String) -> ICalDateTime? {
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
    
    private static func findProperty(
        name: String,
        elements: [(name: String, value: String)]
    ) -> (name: String, value: String)? {
        return elements
            .filter { $0.name.hasPrefix(name) }
            .first
    }
    
    private static func propertiesOfValue(_ value: String) -> [(name: String, value: String)] {
        return value.components(separatedBy: ";")
            .map { $0.components(separatedBy: "=") }
            .filter { $0.count > 1 }
            .map { ($0[0], $0[1]) }
    }
    
    private static func separateCommaProperty(value: String) -> [String] {
        return value.components(separatedBy: ",")
    }
    
    private static func matcheDuration(type: String, duration: String) -> String {
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
