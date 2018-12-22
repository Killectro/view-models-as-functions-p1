//
//  LoginViewController.swift
//  ViewModelsAsFunctions
//
//  Created by DJ Mitchell on 12/22/18.
//  Copyright © 2018 Killectro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: UIButton!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        let (
            loginButtonEnabled,
            showSuccessMessage
        ) = loginViewModel(
            usernameChanged: usernameTextField.rx.text.orEmpty.asObservable(),
            passwordChanged: passwordTextField.rx.text.orEmpty.asObservable(),
            loginTapped: loginButton.rx.tap.asObservable()
        )

        disposeBag.insert(
            loginButtonEnabled
                .bind(to: loginButton.rx.isEnabled),

            showSuccessMessage
                .subscribe(onNext: { [weak self] message in
                    self?.showSuccessMessage(message)
                })
        )
    }

    private func setupViews() {
        loginButton.setBackgroundImage(
            .from(color: .black),
            for: .normal
        )

        loginButton.setBackgroundImage(
            .from(color: .lightGray),
            for: .disabled
        )
    }

    private func showSuccessMessage(_ message: String) {
        let alert = UIAlertController(
            title: "Success!",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            .init(
                title: "OK",
                style: .default,
                handler: nil
            )
        )

        present(alert, animated: true, completion: nil)
    }
}

private extension UIImage {
    static func from(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

        UIGraphicsBeginImageContext(rect.size)
        defer { UIGraphicsEndImageContext() }

        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
