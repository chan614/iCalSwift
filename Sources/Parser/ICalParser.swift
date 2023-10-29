//
//  ICalParser.swift
//  
//
//

import Foundation

public struct ICalParser {
    
    public init() {}
    
    // MARK: - Parse
    
    public func parseCalendar(ics: String) -> ICalendar? {
        let elements = icsToElements(ics)
        
        guard let prodIDValue = findProperty(name: Constant.Prop.prodid, elements: elements)?.value else {
            return nil
        }
        
        let prodSegments = segmentsOfProdID(prodIDValue)
        
        guard !prodSegments.isEmpty else { return nil }
        
        let method = findProperty(name: Constant.Prop.method, elements: elements)?.value
        let calscale = findProperty(name: Constant.Prop.calscale, elements: elements)?.value
        
        let vEvents = findComponent(name: Constant.Component.event, elements: elements)
        let vAlarams = findComponent(name: Constant.Component.alarm, elements: elements)
        let vTimeZones = findComponent(name: Constant.Component.timeZone, elements: elements)
        
        let events = buildEvents(components: vEvents)
        let alarms = buildAlarms(components: vAlarams)
        let timeZones = buildTimeZones(components: vTimeZones)
        
        return ICalendar(
            prodid: .init(segments: prodSegments),
            calscale: method,
            method: calscale,
            events: events,
            timeZones: timeZones,
            alarms: alarms)
    }
    
    public func parseEvents(ics: String) -> [ICalEvent] {
        let elements = icsToElements(ics)
        
        let vEvents = findComponent(name: Constant.Component.event, elements: elements)
        
        return buildEvents(components: vEvents)
    }
    
    public func parseAlarms(ics: String) -> [ICalAlarm] {
        let elements = icsToElements(ics)
        let vAlarams = findComponent(name: Constant.Component.alarm, elements: elements)
        
        return buildAlarms(components: vAlarams)
    }
    
    public func parseTimeZones(ics: String) -> [ICalTimeZone] {
        let elements = icsToElements(ics)
        let vTimeZones = findComponent(name: Constant.Component.timeZone, elements: elements)
        
        return buildTimeZones(components: vTimeZones)
    }
    
    public func parseDuration(value: String) -> ICalDuration {
        return PropertyBuilder.buildDuration(value: value)
    }
    
    public func parseRRule(value: String) -> ICalRRule? {
        return PropertyBuilder.buildRRule(value: value)
    }
    
    // MARK: - Build component
    
    /// VEvent
    private func buildEvents(components: [ICalComponent]) -> [ICalEvent] {
        
        return components.map { component -> ICalEvent in
            var event = ICalEvent()
            
            let vAlarams = findComponent(name: Constant.Component.alarm, elements: component.children)
            event.alarms = buildAlarms(components: vAlarams)
            
            event.dtstamp = component.buildProperty(of: Constant.Prop.dtstamp)?.date ?? Date()
            event.uid = component.buildProperty(of: Constant.Prop.uid) ?? String()
            event.classification = component.buildProperty(of: Constant.Prop.classification)
            event.created = component.buildProperty(of: Constant.Prop.created)?.date ?? Date()
            event.description = component.buildProperty(of: Constant.Prop.description)
            event.dtstart = component.buildProperty(of: Constant.Prop.dtstart)
            event.lastModified = component.buildProperty(of: Constant.Prop.lastModified)?.date ?? Date()
            event.location = component.buildProperty(of: Constant.Prop.location)
            event.organizer = component.buildProperty(of: Constant.Prop.organizer)
            event.priority = component.buildProperty(of: Constant.Prop.priority)
            event.seq = component.buildProperty(of: Constant.Prop.seq)
            event.status = component.buildProperty(of: Constant.Prop.status)
            event.summary = component.buildProperty(of: Constant.Prop.summary)
            event.transp = component.buildProperty(of: Constant.Prop.transp)
            event.url = component.buildProperty(of: Constant.Prop.url)
            event.dtend = component.buildProperty(of: Constant.Prop.dtend)
            event.duration = component.buildProperty(of: Constant.Prop.duration)
            event.recurrenceID = component.buildProperty(of: Constant.Prop.recurrenceID)
            event.rrule = component.buildProperty(of: Constant.Prop.rrule)
            event.rdate = component.buildProperty(of: Constant.Prop.rdate)
            event.exdate = component.buildProperty(of: Constant.Prop.exdate)
            event.attachments = component.buildProperty(of: Constant.Prop.attach)
            
            event.extendProperties = component.findExtendProperties()
            
            return event
        }
    }
    
    /// VAlarm
    private func buildAlarms(components: [ICalComponent]) -> [ICalAlarm] {
        return components.compactMap { component -> ICalAlarm? in
            guard let action = component.findProperty(name: Constant.Prop.action)?.value,
                  let triggerProp = component.findProperty(name: Constant.Prop.trigger)
            else {
                return nil
            }
            
            guard let trigger = PropertyBuilder.buildDateTime(propName: triggerProp.name, value: triggerProp.value) else {
                return nil
            }
            
            var alarm = ICalAlarm(action: action, trigger: trigger.date)
            alarm.description = component.buildProperty(of: Constant.Prop.description)
            alarm.summary = component.buildProperty(of: Constant.Prop.summary)
            alarm.duration = component.buildProperty(of: Constant.Prop.duration)
            alarm.repetition = component.buildProperty(of: Constant.Prop.repetition)
            alarm.attach = component.buildProperty(of: Constant.Prop.attach)
            
            return alarm
        }
    }
    
    /// VTimeZone
    private func buildTimeZones(components: [ICalComponent]) -> [ICalTimeZone] {
        return components.compactMap { component -> ICalTimeZone? in
            guard let tzid = component.findProperty(name: Constant.Prop.tzid)?.value else {
                return nil
            }
            
            let standardElement = findComponent(
                name: Constant.Component.standard,
                elements: component.properties
            ).first
            
            let daylightElement = findComponent(
                name: Constant.Component.daylight,
                elements: component.properties
            ).first
            
            let standard = buildSubTimeZone(component: standardElement)
            let daylight = buildSubTimeZone(component: daylightElement)
            
            // One of 'standardc' or 'daylightc' MUST occur and each MAY occur more than once.
            if standard == nil && daylight == nil {
                return nil
            }
            
            return ICalTimeZone(tzid: tzid, standard: standard, daylight: daylight)
        }
    }
    
    /// TimeZone sub component
    private func buildSubTimeZone(component: ICalComponent?) -> ICalSubTimeZone? {
        guard let component = component else { return nil }
        
        guard let dtStartValue = component.findProperty(name: Constant.Prop.dtstart)?.value,
              let tzOffsetTo = component.findProperty(name: Constant.Prop.tzOffsetTo)?.value,
              let tzOffsetFrom = component.findProperty(name: Constant.Prop.tzOffsetFrom)?.value
        else {
            return nil
        }
        
        guard let dtStart = PropertyBuilder.buildDateTime(propName: Constant.Prop.dtstart, value: dtStartValue)?.date else {
            return nil
        }
        
        let subTimeZone = ICalSubTimeZone(
            dtstart: dtStart,
            tzOffsetTo: tzOffsetTo,
            tzOffsetFrom: tzOffsetFrom)
        
        subTimeZone.rrule = component.buildProperty(of: Constant.Prop.rrule)
        subTimeZone.tzName = component.buildProperty(of: Constant.Prop.tzName)
        
        return subTimeZone
    }
    
    // MARK: - Supporting function

    private func icsToElements(_ ics: String) -> [(name: String, value: String)] {
        let icsReplaced = ics.replacing(pattern: "(\r?\n)+[ \t]", with: "")
        let icsComponents = icsReplaced.components(separatedBy: "\n")
        let icsComponentsMapped = icsComponents.map { $0.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true) }
        let icsComponentsFiltered = icsComponentsMapped.filter { $0.count > 1 }
        return icsComponentsFiltered.map { (String($0[0]), String($0[1])) }
    }
    
    private func findComponent(
        name: String,
        elements: [(name: String, value: String)]
    ) -> [ICalComponent] {
        var founds = [ICalComponent]()
        var currentComponent: [(String, String)]?
        var childComponent: [(String, String)]?
        
        for element in elements {
            if element.name == Constant.Prop.begin, element.value == name {
                if currentComponent == nil {
                    currentComponent = []
                }
            }
            
            if currentComponent != nil {
                if element.name == Constant.Prop.begin, element.value != name {
                    childComponent = []
                }
                
                if childComponent != nil {
                    childComponent?.append(element)
                } else {
                    currentComponent?.append(element)
                }
            }
            
            if element.name == Constant.Prop.end, element.value == name {
                if let currentComponent = currentComponent {
                    let componentElement = ICalComponent(
                        properties: currentComponent,
                        children: childComponent ?? [])
                    founds.append(componentElement)
                }
                currentComponent = nil
                childComponent = nil
            }
        }
        
        return founds
    }
    
    private func findProperty(
        name: String,
        elements: [(name: String, value: String)]
    ) -> (name: String, value: String)? {
        return elements
            .filter { $0.name.hasPrefix(name) }
            .first
    }
    
    private func segmentsOfProdID(_ value: String) -> [String] {
        return value
            .components(separatedBy: "//")
            .filter { !$0.isEmpty && $0 != "-" }
    }
}
