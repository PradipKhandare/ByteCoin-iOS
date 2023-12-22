//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    var delegate: CurrencyManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "57662446-A7FF-42C4-ACA1-6BBD8C3F14B2"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
              if let safeData = data {
                  if let currencyData = parseJSON(safeData){
                      let currencyString = String(format: "%.2f", currencyData)
                      self.delegate?.currencyUpdate(price: currencyString, currency: currency)
                  }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ currencyData: Data) -> Double?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: currencyData)
            let lastPrice = decodedData.rate
            return lastPrice
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
       
    }
   
}
