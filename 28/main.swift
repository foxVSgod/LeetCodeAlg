//
//  main.swift
//  LeetCodeSwift
//  28. Implement strStr()
//  Created by yourongrong on 2017/5/18.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//
/*
 Implement strStr().

 Returns the index of the first occurrence of needle in haystack, or -1 if needle is not part of haystack.
*/

import Foundation

class Solution {
    func  cal_newx(str:[Character] , nextlist:inout [Int] ,length :Int ) {
        var  j:Int
        nextlist[0] = -1
        for i  in 1 ..< str.count {
            j = nextlist[i - 1]
            while (str[j + 1] != str[i] && j >= 0) {
                j = nextlist[j]
            }
            if str[i] == str[j + 1] {
                nextlist[i] = j + 1
            }else{
                nextlist[i] = -1
            }
        }
    }

    func kmp(str:[Character] , ptr:[Character] , nextlist:[Int] ) -> Int {
        var  s_i = 0, p_i = 0
        while s_i < str.count && p_i < ptr.count {
            if str[s_i] == ptr[p_i] {
                s_i = s_i + 1
                p_i = p_i + 1
            }else{
                if p_i == 0 {
                    s_i = s_i + 1
                }else{
                    p_i = nextlist[p_i - 1 ] + 1
                }
            }
        }
        return  (p_i == ptr.count) ? (s_i - ptr.count) : -1
    }

    func strStr(_ haystack: String, _ needle: String) -> Int {
        var haylist = [Character](haystack.characters)
        var needlist = [Character](needle.characters)
        if needlist.count == 0 {
            return 0
        }
        var nextlist:[Int] = [Int].init(repeating: -1, count: needlist.count)
        cal_newx(str: needlist, nextlist: &nextlist, length: nextlist.count)
        return kmp(str: haylist, ptr: needlist, nextlist: nextlist)
    }
}

var solution = Solution.init()
var testlist = ""
var ptr = "a"
print(solution.strStr(testlist, ptr))

//print(solution.removeElement(&testlist,3))
