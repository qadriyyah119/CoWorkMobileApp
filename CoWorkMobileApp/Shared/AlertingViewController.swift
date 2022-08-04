//
//  AlertingViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit

protocol AlertingViewController: UIViewController {

  func displayAlertViewController(withTitle title: String, message: String, alertActionTitle: String)
  func displayAlertViewController(withTitle title: String, message: String, actions: [UIAlertAction])

}

extension AlertingViewController {

  func displayAlertViewController(withTitle title: String, message: String, alertActionTitle: String = "OK") {
    let controller: UIAlertController = UIAlertController(title: title,
                                                          message: message,
                                                          preferredStyle: .alert)
    let ok = UIAlertAction(title: alertActionTitle, style: .default, handler: nil)
    controller.addAction(ok)

    if Thread.isMainThread {
      self.present(controller, animated: true, completion: nil)
    } else {
      DispatchQueue.main.async {
        self.present(controller, animated: true, completion: nil)
      }
    }
  }

  func displayAlertViewController(withTitle title: String, message: String, actions: [UIAlertAction]) {
    let controller: UIAlertController = UIAlertController(title: title,
                                                          message: message,
                                                          preferredStyle: .alert)
    actions.forEach { action in
      controller.addAction(action)
    }

    if Thread.isMainThread {
      self.present(controller, animated: true, completion: nil)
    } else {
      DispatchQueue.main.async {
        self.present(controller, animated: true, completion: nil)
      }
    }
  }

}
