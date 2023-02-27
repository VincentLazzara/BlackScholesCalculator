//
//  UIAnimateable.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/26/23.
//

import UIKit
import MBProgressHUD


protocol UIAnimateable where Self: UIViewController{
    func showLoadingAnimation()
    func hideLoadingAnimation()
    
}

extension UIAnimateable{
    
    
    func showLoadingAnimation(){
        
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hideLoadingAnimation(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
