//
//  main.swift
//  23. Merge k Sorted Lists
//
//  Created by yourongrong on 17/05/2017.
//  Copyright © 2017 yourongrong. All rights reserved.
//

/*
  Merge k sorted linked lists and return it as one sorted list. Analyze and describe its complexity.
*/

/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.next = nil
 *     }
 * }
 */
class Solution {

    func mergeKLists(_ lists: [ListNode?]) -> ListNode?{
        var listCount = lists.count
        var newlists = lists
        if  listCount == 0  {
            return nil
        }
        while listCount > 1 {
            var k = ( listCount + 1) / 2
            for i  in 0 ..< listCount / 2 {
                newlists[i] = mergeTwoList(listleft: newlists[i], listRight: newlists[i + k])
            }
            listCount = k
        }
        return newlists[0]
    }
    func mergeTwoList( listleft: ListNode?, listRight:ListNode?) ->ListNode?{
        if listleft == nil {
            return listRight
        }
        if listRight == nil {
            return listleft
        }
        var dummy = ListNode.init(-1)
        var p = dummy
        var list1 = listleft
        var list2 = listRight
        while (list1 != nil && list2 != nil) {
            if (list1?.val)! > (list2?.val)! {
                p.next = list2
                list2 = list2?.next
            }else{
                p.next = list1
                list1 = list1?.next
            }
            p = p.next!
        }
        if  list1 == nil {
            p.next = list2
        }else if(list2 == nil){
            p.next = list1
        }
        return dummy.next
    }
}
