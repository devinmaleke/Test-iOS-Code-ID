//
//  Extensions.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 11/07/25.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showSuccessToast(message: String, duration: Double = 2.0) {
        UIWindow.showToast(
            message: message,
            backgroundColor: UIColor.green.withAlphaComponent(0.1),
            textColor: .black,
            borderColor: .green,
            duration: duration
        )
    }

    func showErrorToast(message: String, duration: Double = 2.0) {
        UIWindow.showToast(
            message: message,
            backgroundColor: UIColor.systemPink.withAlphaComponent(0.1),
            textColor: .black,
            borderColor: .red,
            duration: duration
        )
    }
    
    func showLoading(_ message: String? = nil) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message ?? "Loading..."
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
}

extension UITextField {
    func showErrorBorder() {
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.cornerRadius = 6
    }

    func removeErrorBorder() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
}

extension UIWindow {
    static func showToast(
        message: String,
        backgroundColor: UIColor,
        textColor: UIColor,
        borderColor: UIColor,
        duration: Double
    ) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }

        let toastContainer = UIView()
        toastContainer.backgroundColor = backgroundColor
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 12
        toastContainer.layer.borderWidth = 2
        toastContainer.layer.borderColor = borderColor.cgColor
        toastContainer.clipsToBounds = true

        let toastLabel = UILabel()
        toastLabel.textColor = textColor
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toastLabel.text = message
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        window.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 16),
            toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -16),
            toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 12),
            toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -12),

            toastContainer.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 32),
            toastContainer.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -32),
            toastContainer.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -48)
        ])

        UIView.animate(withDuration: 0.3, animations: {
            toastContainer.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }) { _ in
                toastContainer.removeFromSuperview()
            }
        }
    }
}
