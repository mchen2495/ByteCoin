//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateProce(_ coinManager: CoinManager, price: Double, currency: String)
    
    func didFailWithError(error: Error)
}


struct CoinManager {
    
    //only something that have conformed to CoinManagerDelegate can be assign to this
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    //https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=B50D8B8D-5A1E-4CBE-81E5-16F67AB0B2B4#
    func getCoinPrice(for currency: String){
        print("price for \(currency)")
        let urlString = "\(baseURL)/\(currency)/?apikey=\(K_API_KEY)"
        //performRequest(with: urlString)
        
        /*
         1.create url
         2.make a session
         3.set up the task
         4.start the task
         */
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    print("This was a error making the request")
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString)
                    
                    if let price = parseJSON(bitCoinData: safeData){
                        print(String(format: "%.2f", Double(price)))
                        
                        delegate?.didUpdateProce(self, price: price, currency: currency)
                    }
                }
            }
            task.resume()
        }
        
        
        
    }
    
    func parseJSON(bitCoinData: Data) -> Double? {
        
        let decoder = JSONDecoder()
        
        do {
            //what type we want the data to be decoded into
            let decodedData = try decoder.decode(BitCoinData.self, from: bitCoinData)
            let price = decodedData.rate
            return price
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    
//    func performRequest(with urlString: String){
//        if let url = URL(string: urlString){
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) { (data, response, error) in
//
//                if error != nil{
//                    print("This was a error making the request")
//                    return
//                }
//                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString)
//
//                    if let price = parseJSON(bitCoinData: safeData){
//                        print(String(format: "%.2f", Double(price)))
//
//                        delegate?.didUpdateProce(self, price: price)
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
    
    
    
    
    
    
}
