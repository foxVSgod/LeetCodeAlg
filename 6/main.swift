//
//  main.swift
//  LeetCodeSwift
//  6. ZigZag Conversion
//  Created by yourongrong on 2017/5/18.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//
/*
 The string "PAYPALISHIRING" is written in a zigzag pattern on a given number of rows like this: (you may want to display this pattern in a fixed font for better legibility)

 P   A   H   N
 A P L S I I G
 Y   I   R
 And then read line by line: "PAHNAPLSIIGYIR"
 Write the code that will take a string and make this conversion given a number of rows:

 string convert(string text, int nRows);
 convert("PAYPALISHIRING", 3) should return "PAHNAPLSIIGYIR".
*/

import Foundation

class Solution {
    func convert(_ s: String, _ numRows: Int) -> String {
       var characters = [Character](s.characters)
        if numRows <= 1 || characters.count == 0{
            return s
        }
        var res:String = String.init()
        var maxlength = min(characters.count, numRows)
        for i  in 0 ..< maxlength{
            var index = i
            res.append(characters[index])
            for k  in 1 ..< characters.count {
                if i == 0  || i == numRows - 1 {
                    index  = index + 2*numRows - 2
                }else{
                    if k%2 == 1  {
                        index = index + 2*(numRows - i - 1)
                    }else{
                        index = index + 2 * i
                    }
                }

                if index < characters.count {
                    res.append(characters[index])
                }
            }
        }
        return res
    }
}

var solution = Solution.init()
print(solution.convert("PAYPALISHIRING", 3))
