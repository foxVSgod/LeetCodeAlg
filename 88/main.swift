//
//  main.swift
//  LeetCodeSwift
// 88. Merge Sorted Array
//  Created by yourongrong on 2017/5/18.
//  Copyright © 2017年 益盟技术部. All rights reserved.
/*
 Given two sorted integer arrays nums1 and nums2, merge nums2 into nums1 as one sorted array.

 Note:
 You may assume that nums1 has enough space (size that is greater or equal to m + n) to hold additional elements from nums2. The number of elements initialized in nums1 and nums2 are m and n respectively.
 */

import Foundation

class Solution {
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        var firstIndex = m - 1 , secondIndex = n - 1 , currentIndex = m + n - 1
        while firstIndex >= 0 && secondIndex >= 0 && currentIndex >= 0{
            if nums1[firstIndex] >= nums2[secondIndex] {
                nums1[currentIndex] = nums1[firstIndex]
                firstIndex = firstIndex - 1
            }else{
                nums1[currentIndex] = nums2[secondIndex]
                secondIndex = secondIndex - 1
            }
            currentIndex = currentIndex - 1
        }
        while firstIndex >= 0 && currentIndex >= 0{
            nums1[currentIndex] = nums1[firstIndex]
            firstIndex = firstIndex - 1
            currentIndex = currentIndex - 1
        }

        while secondIndex >= 0 && currentIndex >= 0{
            nums1[currentIndex] = nums2[secondIndex]
            secondIndex = secondIndex - 1
            currentIndex = currentIndex - 1
        }
    }
}
//var solution = Solution.init()
//var testlist = "abb"
//print(solution.shortestPalindrome(testlist))
