//
//  main.swift
//  LeetCodeSwift
//  57 Insert Interval
//  Created by yourongrong on 2017/5/18.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//
/*
 Given a set of non-overlapping intervals, insert a new interval into the intervals (merge if necessary).

 You may assume that the intervals were initially sorted according to their start times.

 Example 1:
 Given intervals [1,3],[6,9], insert and merge [2,5] in as [1,5],[6,9].

 Example 2:
 Given [1,2],[3,5],[6,7],[8,10],[12,16], insert and merge [4,9] in as [1,2],[3,10],[12,16].

 This is because the new interval [4,9] overlaps with [3,5],[6,7],[8,10].
*/

import Foundation
public class Interval {
    public var start: Int
    public var end: Int
    public init(_ start: Int, _ end: Int) {
        self.start = start
        self.end = end
    }
}
class Solution {
    func insert(_ intervals: [Interval], _ newInterval: Interval) -> [Interval] {
//        if intervals.count == 0 {
//            return [newInterval]
//        }
        var i = 0, overlap = 0
        var tempinterVal = intervals
        while i < tempinterVal.count {
            if newInterval.end < tempinterVal[i].start {
                break
            }else if (newInterval.start > tempinterVal[i].end){

            }else{
                newInterval.start = min(newInterval.start, tempinterVal[i].start)
                newInterval.end = max(newInterval.end, tempinterVal[i].end)
                overlap =  overlap + 1
            }
            i = i + 1
        }
        if (overlap > 0) {
            tempinterVal.removeSubrange(ClosedRange.init(uncheckedBounds: (lower: i - overlap, upper: i - 1)))
        }
        tempinterVal.insert(newInterval, at: i - overlap)
        return tempinterVal
    }

}

var solution = Solution.init()
print(solution.insert([Interval.init(1, 5)], Interval.init(4, 9)))
