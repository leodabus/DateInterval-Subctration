
//
//  RangeReplaceableCollectionDateInterval.swift
//  
//
//  Created by Leo Dabus on 11/18/2018.
//
//  This is an implementation on top of the logic posted by Rob Ryan post on StackOverflow
//  https://stackoverflow.com/a/54613327/2303865



extension RangeReplaceableCollection where Element == DateInterval {
    
    mutating func subtract(_ intervals: Self) {
        for dateInterval in intervals {
            var index = startIndex
            while index < endIndex {
                let interval = self[index]
                if let intersection = interval.intersection(with: dateInterval) {
                    var replacements: [DateInterval] = []
                    if intersection.start > interval.start {
                        replacements.append(DateInterval(start: interval.start, end: intersection.start))
                    }
                    if intersection.end < interval.end {
                        replacements.append(DateInterval(start: intersection.end, end: interval.end))
                    }
                    replaceSubrange(index...index, with: replacements)
                    index = self.index(index, offsetBy: replacements.count)
                } else {
                    index = self.index(after: index)
                }
            }
        }
    }
    
    func subtracting(_ intervals: Self) -> Self {
        var dateIntervals = self
        dateIntervals.subtract(intervals)
        return dateIntervals
    }
}

extension DateInterval {
    func subtracting(_ intervals: [DateInterval]) -> [DateInterval] {
        return [self].subtracting(intervals)
    }
}

public func -= (lhs: inout [DateInterval], rhs: [DateInterval]) {
    lhs.subtract(rhs)
}

public func - (lhs: [DateInterval], rhs: [DateInterval]) -> [DateInterval] {
    return lhs.subtracting(rhs)
}

public func - (lhs: DateInterval, rhs: [DateInterval]) -> [DateInterval] {
    return lhs.subtracting(rhs)
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
