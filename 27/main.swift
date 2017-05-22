//
//  main.swift
//  LeetCodeSwift
//  27. Remove Element
//  Created by yourongrong on 2017/5/18.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//
/*
 Total Accepted: 191627
 Total Submissions: 501460
 Difficulty: Easy
 Contributor: LeetCode
 Given an array and a value, remove all instances of that value in place and return the new length.

 Do not allocate extra space for another array, you must do this in place with constant memory.

 The order of elements can be changed. It doesn't matter what you leave beyond the new length.

 Example:
 Given input array nums = [3,2,2,3], val = 3

 Your function should return length = 2, with the first two elements of nums being 2.
*/

import Foundation

class Solution {
    func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
        var length = nums.count
        var newindex = 0
        for  i  in 0..<length {
            if nums[i] != val {
                nums[newindex] = nums[i]
                newindex = newindex + 1
            }
        }
        return newindex
    }
}

var solution = Solution.init()
var testlist = [3,3,2,2]

print(solution.removeElement(&testlist,3))
