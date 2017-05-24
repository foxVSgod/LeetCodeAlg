//
//  main.swift
//  LeetCodeSwift
//  21.  Merge Two Sorted Lists
//  Created by yourongrong on 2017/5/18.
//  Copyright © 2017年 益盟技术部. All rights reserved.
/*
 Merge two sorted linked lists and return it as a new list. The new list should be made by splicing together the nodes of the first two lists.

 Subscribe to see which companies asked this question.
 */

import Foundation

 public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}
class Solution {
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var tempListNode = ListNode.init(-1)
        var result = tempListNode
        var firstNode = l1, secondNode = l2
        while firstNode != nil && secondNode != nil {
            if (firstNode?.val)! > (secondNode?.val)! {
                 tempListNode.next = secondNode!
                tempListNode = tempListNode.next!
                secondNode = secondNode?.next
            }else{
                 tempListNode.next = firstNode!
                 tempListNode = tempListNode.next!
                firstNode = firstNode?.next
            }
        }
        while firstNode != nil {
            tempListNode.next = firstNode
            tempListNode = tempListNode.next!
            firstNode = firstNode?.next
        }

        while secondNode != nil {
            tempListNode.next = secondNode
            tempListNode = tempListNode.next!
            secondNode = secondNode?.next
        }
        return result.next
    }

}
//var solution = Solution.init()
//var testlist = "abb"
//print(solution.shortestPalindrome(testlist))
