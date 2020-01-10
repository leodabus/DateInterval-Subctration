
//
//  RangeReplaceableCollectionDateInterval.swift
//  
//
//  Created by Leo Dabus on 2/10/2019.
//
//  This is an implementation on top of the logic posted by Rob Ryan on StackOverflow
//  https://stackoverflow.com/a/54613327/2303865

extension RangeReplaceableCollection where Element == DateInterval {
    
    mutating func subtract(_ intervals: Self) {
        for dateInterval in intervals {
            var index = startIndex
            while index < endIndex {
                let interval = self[index]
                if let intersection = interval.intersection(with: dateInterval) {
                    var sequence: [DateInterval] = []
                    if intersection.start > interval.start {
                        sequence.append(.init(start: interval.start, end: intersection.start))
                    }
                    if intersection.end < interval.end {
                        sequence.append(.init(start: intersection.end, end: interval.end))
                    }
                    replaceSubrange(index...index, with: sequence)
                    index = self.index(index, offsetBy: sequence.count)
                } else {
                    index = self.index(after: index)
                }
            }
        }
    }
    
    mutating func subtract(_ interval: Element) {
        subtract(Self(CollectionOfOne(interval)))
    }
    
    func subtracting(_ intervals: Self) -> Self {
        var dateIntervals = self
        dateIntervals.subtract(intervals)
        return dateIntervals
    }
    func subtracting(_ interval: Element) -> Self {
        var dateIntervals = self
        dateIntervals.subtract(Self(CollectionOfOne(interval)))
        return dateIntervals
    }
    
    static public func -= (lhs: inout Self, rhs: Self) { lhs.subtract(rhs) }
    static public func -= (lhs: inout Self, rhs: Element) { lhs.subtract(rhs) }
    
    static public func - (lhs: Self, rhs: Self) -> Self { lhs.subtracting(rhs) }
    static public func - (lhs: Self, rhs: Element) -> Self { lhs.subtracting(rhs) }
}

extension DateInterval {
    func subtracting(_ interval: DateInterval) -> [DateInterval] { [self].subtracting([interval]) }
    func subtracting(_ intervals: [DateInterval]) -> [DateInterval] { [self].subtracting(intervals) }
    static public func - (lhs: DateInterval, rhs: DateInterval) -> [DateInterval] { lhs.subtracting(rhs) }
    static public func - (lhs: DateInterval, rhs: [DateInterval]) -> [DateInterval] { lhs.subtracting(rhs) }
}



// ***********************************************************************

extension Date {
    
    init?(calendar: Calendar? = nil, year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, nanosecond: Int? = nil, defaultDate: Date? = nil) {
        
        let calendar = calendar ?? .current
        var components = calendar.dateComponents([.calendar, .year, .month, .day, .hour, .minute, .second], from: defaultDate ?? calendar.startOfDay(for: Date()))
        
        components.year = year ?? components.year
        components.month = month ?? components.month
        components.day = day ?? components.day
        components.hour = hour ?? components.hour
        components.minute = minute ?? components.minute
        components.second = second ?? components.second
        components.nanosecond = nanosecond ?? components.nanosecond
        
        guard let date = components.date else { return nil }
        self.init(timeInterval: 0, since: date)
    }
}

// ***********************************************************************
// testing DateInterval 
// let di0 = DateInterval(start: Date(hour: 12)!, end: Date(hour: 18)!)
// let di1 = DateInterval(start: Date(hour: 13)!, end: Date(hour: 15)!)
// let di2 = DateInterval(start: Date(hour: 17)!, end: Date(hour: 18)!)
// let result = di0 - [di1,di2]
// result.map({ print($0.start.description(with: .current),
                 $0.end.description(with: .current))   })

// ***********************************************************************
// testing the mutating approach on a DateInterval collection
// var di0 = [DateInterval(start: Date(hour: 12)!, end: Date(hour: 18)!)]
//
// let di1 = DateInterval(start: Date(hour: 13)!, end: Date(hour: 15)!)
// let di2 = DateInterval(start: Date(hour: 17)!, end: Date(hour: 18)!)
//
// di0 -= [di1,di2]
// di0.map({ print($0.start.description(with: .current),
//                $0.end.description(with: .current))   })
