//
//  ViewModel.swift
//  Unsplash
//
//  Created by mmxsound on 2020/08/10.
//  Copyright © 2020 mmxsound. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ViewModel {
    let relay = BehaviorRelay<[Unsplash]>(value: [])
}
