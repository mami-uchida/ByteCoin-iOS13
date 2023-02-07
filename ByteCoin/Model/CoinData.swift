//
//  CoinData.swift
//  ByteCoin
//
//  Created by 内田麻美 on 2022/12/15.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

//ビットコインデータをデコードするためにCoinData構造体を作る
struct CoinData: Decodable {
    let rate: Double
}
