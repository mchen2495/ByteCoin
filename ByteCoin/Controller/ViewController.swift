//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

/*By adding data source protocol it is saying this view Controller is
  capable of providing data to any UIPickerViews
 */
class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var bitCoinLabel: UILabel!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        coinManager.delegate = self
    }


}


//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    //----------------------UIPickerDataSource Methods
    
    //number of columns we want
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    //number of rows we want
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    
    
    //-----------------------UIPickerViewDelegate methods
    
    //this method will be called once for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    
    //when the user scrolls the picker this gets triggered
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        print(selectedCurrency)
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
}





//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didUpdateProce(_ coinManager: CoinManager, price: Double, currency: String) {
        
        DispatchQueue.main.async {
            
            let priceString = String(format: "%.2f", price)
            self.bitCoinLabel.text = priceString
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
}

