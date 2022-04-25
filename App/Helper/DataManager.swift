//
//  DataManager.swift
//  
//
//  Created by 朱浩宇 on 2022/4/10.
//

import SwiftUI

class DataManager: ObservableObject {
    static let shared = DataManager()

    @Published var activeList: Event?

    @Published var edited = [UUID]()
}
