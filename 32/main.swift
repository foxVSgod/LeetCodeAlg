//
//  main.swift
//  32. Longest Valid Parentheses
//
//  Created by yourongrong on 17/05/2017.
//  Copyright © 2017 yourongrong. All rights reserved.
//

/*
  Merge k sorted linked lists and return it as one sorted list. Analyze and describe its complexity.
*/

/**
 Given a string containing just the characters '(' and ')', find the length of the longest valid (well-formed) parentheses substring.

 For "(()", the longest valid parentheses substring is "()", which has length = 2.

 Another example is ")()())", where the longest valid parentheses substring is "()()", which has length = 4.
 */
class Solution {

    func longestValidParentheses(_ s: String) -> Int {
        var newStr = NSString.init(string: s)
        var dp = [Int].init(repeating: 0, count: newStr.length)
        var maxLen = 0
        if newStr.length < 2 {
            return 0
        }
        for i in  (0 ..< newStr.length - 1).reversed(){
            if newStr.character(at: i) == 40 {
                var end = i + dp[i + 1] + 1;
                if end < newStr.length && newStr.character(at: end) == 41 {
                    dp[i] = dp[i + 1] + 2
                    if end + 1 < newStr.length {
                        dp[i] += dp[end + 1]
                    }
                }
            }
            maxLen = max(maxLen, dp[i])
        }
        return maxLen
    }
}
