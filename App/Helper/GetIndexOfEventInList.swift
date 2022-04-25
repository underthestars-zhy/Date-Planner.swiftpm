//
//  GetIndexOfEventInList.swift
//  
//
//  Created by 朱浩宇 on 2022/4/10.
//

import Foundation

func GetIndexOfEventInList(_ event: Event) -> Int {
    var index = 0
    for period in Period.allCases {
        for item in EventData.shared.sortedEvents(period: period) {
            if item.wrappedValue == event {
                return index
            }

            index += 1
        }
    }

    return 0
}
