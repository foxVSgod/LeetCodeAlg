//
//  main.swift
//  LeetCodeSwift
//  55. Jump Game
//  Created by yourongrong on 2017/5/18.
//  Copyright © 2017年 益盟技术部. All rights reserved.
/*
 Given an array of non-negative integers, you are initially positioned at the first index of the array.

 Each element in the array represents your maximum jump length at that position.

 Determine if you are able to reach the last index.

 For example:
 A = [2,3,1,1,4], return true.

 A = [3,2,1,0,4], return false.
 */

import Foundation

class Solution {
    func canJump(_ nums: [Int]) -> Bool {
        if nums.count <= 1 {
            return true
        }
        var maxvalue = 0
        for i in 0 ..< nums.count - 1 {
            var currentMax = i + nums[i]
            if currentMax  >= nums.count - 1   {
                return true
            }
            if currentMax > maxvalue {
                maxvalue = currentMax
            }
            if nums[i] == 0 && maxvalue < i + 1 {
                break;
            }
        }
        return false
    }
}

var tempSoluction = Solution.init()
print(tempSoluction.canJump([3,0,8,2,0,0,1]))
