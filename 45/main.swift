//
//  main.swift
//  45. Jump Game II
//
//  Created by yourongrong on 17/05/2017.
//  Copyright © 2017 yourongrong. All rights reserved.
//

/*
 Given an array of non-negative integers, you are initially positioned at the first index of the array.

 Each element in the array represents your maximum jump length at that position.

 Your goal is to reach the last index in the minimum number of jumps.

 For example:
 Given array A = [2,3,1,1,4]

 The minimum number of jumps to reach the last index is 2. (Jump 1 step from index 0 to 1, then 3 steps to the last index.)
*/


class Solution {
    func jump(_ nums: [Int]) -> Int {
        var count = 0
        var curMax = 0
        var curRth = 0
        for i in 0 ..< nums.count {
            if curRth < i {
                count += 1
                curRth = curMax
            }
            curMax = max(curMax, nums[i] + i)
        }
        return count
    }}

