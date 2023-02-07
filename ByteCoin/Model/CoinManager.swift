//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

//CoinManagerDelegateプロトコルを作成しAPI要求から取得したビットコインの最終価格をViewControllerクラスに渡す
protocol CoinManagerDalegate {
    func didUpdataPrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDalegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "4190BFC2-7022-4EF3-9B22-4B1ABB237193"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    
    func getCoinPrice(for currency: String) {
        //ビットコイン(BTC)の最新価格を米ドル(USD)で表示する。
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, error) in
                //errorの強制アンラップを避ける
                if let error = error {
                    delegate?.didFailWithError(error: error)
                    return
                }
                //guard else文には複数の条件を記載
                guard let safeData = data, let bitcoinPrice = parseJSON(safeData) else { return }
                let priceString = String(format: "%.2f", bitcoinPrice)
                self.delegate?.didUpdataPrice(price: priceString, currency: currency)
                
            }
            task.resume()
        }
    }
        
        
        
        
        //取得したJSONデータをswiftオブジェクトに変換（CoinData構造体も合わせて作成）
        func parseJSON(_ data: Data) -> Double? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(CoinData.self, from: data)
                let lastPrice = decodedData.rate
                return lastPrice
            } catch {
                delegate?.didFailWithError(error:error)
                return nil
            }
        }
        
    }
