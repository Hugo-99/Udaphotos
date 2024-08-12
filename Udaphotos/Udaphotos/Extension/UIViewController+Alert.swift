//
//  UIViewController+Alert.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 14/07/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func showCustomAlert(
        title: String,
        message: String,
        handlerName: String? = nil,
        handler: (() -> Void)? = nil
    ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if handler != nil {
            alertVC.addAction(UIAlertAction(title: handlerName ?? "", style: .default, handler: { _ in
                (handler ?? {})()
            }))
        }
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertVC, animated: false, completion: nil)
    }
}
