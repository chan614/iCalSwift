//
//  PropertyBuilder.swift
//  
//
//

import Foundation

struct PropertyBuilder {
    
    /// Duration property
    static func buildDuration(value: String) -> ICalDuration {
        let weeksStr = matcheDuration(type: "W", duration: value)
        let daysStr = matcheDuration(type: "D", duration: value)
        let hoursStr = matcheDuration(type: "H", duration: value)
        let minutesStr = matcheDuration(type: "M", duration: value)
        let secondsStr = matcheDuration(type: "S", duration: value)
        
        let weeks = Int(weeksStr) ?? .zero
        let days = Int(daysStr) ?? .zero
        let hours = Int(hoursStr) ?? .zero
        let minutes = Int(minutesStr) ?? .zero
        let seconds = Int(secondsStr) ?? .zero
        
        return .init(weeks: weeks, days: days, hours: hours, minutes: minutes, seconds: seconds)
    }
    
    /// Recurrence Rule Property
    static func buildRRule(value: String) -> ICalRRule? {
        let params = paramsOfValue(value)
        let frequencyProperty = params
            .filter { $0.name == Constant.Prop.frequency }
            .first
        
        guard let frequencyProperty = frequencyProperty,
              let frequency = ICalRRule.Frequency(rawValue: frequencyProperty.value)
        else {
            return nil
        }
        
        var rule = ICalRRule(frequency: frequency)
        
        params.forEach { property in
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
        let params = paramsOfValue(propName)
        let valueType = dateValueType(params: params)
        let tzid = timeZoneID(params: params)
        
        guard let date = DateTimeUtil.dateFormatter(type: valueType, tzid: tzid).date(from: value) else {
            return nil
        }
        
        switch valueType {
        case .date:
            return .dateOnly(date)
        default:
            return .dateTime(date, tzid: tzid)
        }
    }
    
    static func buildAttachment(propName: String, value: String) -> ICalAttachment? {
        let params = paramsOfValue(propName)
            .map { ($0.name, [$0.value]) }
        
        return .init(parameters: params, value: value)
    }
    
    static func buildDateTimes(propName: String, value: String) -> ICalDateTimes? {
        let params = paramsOfValue(propName)
        let valueType = dateValueType(params: params)
        let tzid = timeZoneID(params: params)
        
        let periods = [ICalPeriod]()
        let dates = value
            .components(separatedBy: ",")
            .compactMap {
                DateTimeUtil.dateFormatter(type: valueType, tzid: tzid).date(from: $0)
            }
        
        if dates.isEmpty && periods.isEmpty {
            return nil
        }
        
        switch valueType {
        case .date:
            return .dateOnly(dates)
        case .dateTime:
            return .dateTime(dates, tzid: tzid)
        case .period:
            // TODO
            return .period([], tzid: tzid)
        }
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
    
    private static func paramsOfValue(_ value: String) -> [(name: String, value: String)] {
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
    
    private static func dateValueType(params: [(name: String, value: String)]) -> DateValueType {
        let valueType = params.first { $0.name == "VALUE" }?.value ?? ""
        
        switch valueType {
        case "DATE":
            return .date
        case "PERIOD":
            return .period
        default:
            return .dateTime
        }
    }
    
    private static func timeZoneID(params: [(name: String, value: String)]) -> String? {
        return params.first { $0.name == "TZID" }?.value
    }
}
