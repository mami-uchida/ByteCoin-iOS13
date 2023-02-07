//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet weak var bitCoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        
        //ViewControllerクラスをデータソースとしてcurrencyPickerオブジェクトとして設定
        currencyPicker.dataSource = self
        
        //いつ操作されたかを検出するためにViewControllerクラスをcurrencyPickerのデリゲートとして設定
        currencyPicker.delegate = self
    }
}


//CoinManagerDelegateプロトコルでViewControllerクラスにAPIで取得したビットコインの最終価格を渡しデータをbitCoinLabelとcurrencyLabelに表示
extension ViewController: CoinManagerDalegate {
    func didUpdataPrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitCoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}


//CoinManagerDelegateプロトコルでViewControllerクラスにAPIで取得したビットコインの最終価格を渡し、データをユーザーインターフェースに表示
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    //numberOfComponentsメソッドで実際にデータを提供しピッカーに必要な列を決定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //umberOfRowsInComponent componentメソッドで、ピッカーに必要な行数を要求
    //CoinManagerのcurrencyArrayでcountメソッドを使用してその情報を取得
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    
    //titleForRow rowメソッドで、pickerViewが読み込まれるとデリゲートに行のタイトルを要求
    //メソッド内で行Intを使用してcurrencyArrayからタイトルを取得し、行の値0とコンポーネント(列)の値0が渡される
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    
    //ユーザーがピッカーをスクロールするたびにpickerView(didSelectRow:)メソッドを更新
    //選択された行番号を記録して、選択した通貨をgetCoin()メソッドを介してCoinManagerに渡す
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

