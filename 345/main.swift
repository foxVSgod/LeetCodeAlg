//
//  main.swift
//  345. Reverse Vowels of a String
//
//  Created by yourongrong on 17/05/2017.
//  Copyright © 2017 yourongrong. All rights reserved.
//

/*
Write a function that takes a string as input and reverse only the vowels of a string.

Example 1:
Given s = "hello", return "holle".

Example 2:
Given s = "leetcode", return "leotcede".

Note:
The vowels does not include the letter "y".
*/


class Solution {
    class Solution {
        func reverseVowels(_ s: String) -> String {
            var temArray = s.utf8CString
            var low = 0
            var high = temArray.count - 1

            while (low < high) {
                while !isVowel(c:temArray[low]) && low < high {
                    low += 1
                }
                while !isVowel(c: temArray[high]) && low < high {
                    high -= 1
                }
                if low < high {
                    var tempchar = temArray[low]
                    temArray[low] = temArray[high]
                    temArray[high] = tempchar
                }
                low += 1
                high -= 1
            }
            var newstr = String.init()
            for var tempchar:CChar in temArray {
                var tempchar:UnicodeScalar = UnicodeScalar.init(UInt8.init(tempchar))
                newstr.append(Character.init(tempchar))
            }
            return newstr
        }
        func isVowel(c: CChar) -> Bool {
            return (c == 97 /*UnicodeScalar("a")!.value*/ ||
                c == 101 /*UnicodeScalar("e")!.value*/ ||
                c == 117 /*UnicodeScalar("u")!.value*/  ||
                c == 105 /*UnicodeScalar("i")!.value*/ ||
                c == 111 /*UnicodeScalar("o")!.value)*/ ||

                c == 65 /*UnicodeScalar("A")!.value*/ ||
                c == 69 /*UnicodeScalar("E")!.value*/ ||
                c == 85 /*UnicodeScalar("U")!.value*/ ||
                c == 73 /*UnicodeScalar("I")!.value*/ ||
                c == 79 /*UnicodeScalar("O")!.value*/)
        }
    }
}
let solution = Solution()
print(solution.reverseVowels("A man\na plan\na cameo\nZena\nBird\nMochaArgo"))
