//
//  main.swift
//  LeetCodeSwift
//   51 N queens
//  Created by yourongrong on 2017/5/18.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//
/*
Given an integer n, return all distinct solutions to the n-queens puzzle.

Each solution contains a distinct board configuration of the n-queens' placement, where 'Q' and '.' both indicate a queen and an empty space respectively.

For example,
There exist two distinct solutions to the 4-queens puzzle:

[
[".Q..",  // Solution 1
"...Q",
"Q...",
"..Q."],

["..Q.",  // Solution 2
"Q...",
"...Q",
".Q.."]
]
*/

import Foundation
class Solution {
    func solveNQueens(_ n: Int) -> [[String]] {
        var row:[Int] = [Int].init(repeating: 0, count: n)
        var col:[Int] = [Int].init(repeating: 0, count: n);
        var resultmap:[[Character]] = [[Character]].init(repeating:[Character].init(repeating: ".", count: n), count: n)
        var resultstr:[[String]] = [[String]].init()
        func queuesDfs(r:Int,n:Int){
            if r == n {
                var strlist = [String].init()
                for i in 0 ..< n{
                    var tempstr = String.init()
                    for j in 0 ..< n {
                        if j == row[i] {
                          tempstr.append("Q")
                        }else{
                            tempstr.append(".")
                        }
                    }
                    strlist.append(tempstr)
                }
               resultstr.append(strlist)
            }else{
                for i in 0  ..< n{
                    if col[i] == 0 {
                        var isavalible = true
                        for j in 0 ..< r{
                            if abs(j - r) == abs(i - row[j]) {
                                isavalible = false
                                break
                            }
                        }
                        if isavalible {
                            row[r] = i
                            col[i] = 1
                            queuesDfs(r: r+1, n: n)
                            col[i] = 0
                            row[r] = 0
                        }
                    }
                }
            }
        }
        queuesDfs(r: 0, n: n)
        return resultstr
    }
}

var solution = Solution.init()
   print(solution.solveNQueens(5))
