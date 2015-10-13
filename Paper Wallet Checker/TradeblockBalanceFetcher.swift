//
//  TradeblockBalanceFetcher.swift
//  Paper Wallet Checker
//
//  Created by Fabian Lachman on 25/04/15.
//  Copyright (c) 2015 Fabian Lachman. All rights reserved.
//

import Foundation
import SwiftyJSON

class TradeblockBalanceFetcher : BalanceFetcher
{
    
    override func fetch(address: String) {
        
        let urlPath = "https://tradeblock.com/api/blockchain/address/\(address)"
        let url = NSURL(string: urlPath)
        if (url == nil) { return }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error in
            
            if (error != nil) {
                print("Error: \(error)");
                return;
            }
            
            let json = JSON(data: data!)
            if let balance = json["data"]["balance"]["confirmed"].double {
//            if let balance = json["data"]["balance"]["unconfirmed"].double {
                let balanceBtc = balance / 100000000
                
                self.delegate?.didReceiveBalance("\(balanceBtc)", scanCounter:self.scanCounter, sender: self)
            }
        })
        
        task.resume()
    }
    
    
}