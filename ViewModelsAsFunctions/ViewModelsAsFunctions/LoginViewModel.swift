//
//  LoginViewModel.swift
//  ViewModelsAsFunctions
//
//  Created by DJ Mitchell on 12/22/18.
//  Copyright © 2018 Killectro. All rights reserved.
//

import Foundation
import RxSwift

func loginViewModel(
    usernameChanged: Observable<String>,
    passwordChanged: Observable<String>,
    loginTapped: Observable<Void>
) -> (
    loginButtonEnabled: Observable<Bool>,
    showSuccessMessage: Observable<String>
) {
    let loginButtonEnabled = Observable
        .combineLatest(
            usernameChanged,
            passwordChanged
        ) { username, password in
            !username.isEmpty && !password.isEmpty
        }
        .distinctUntilChanged()

    let showSuccessMessage = loginTapped
        // Later examples will show how we do real networking here,
        // for now we will just hard-code it
        .map { "Login Successful!" }

    return (
        loginButtonEnabled,
        showSuccessMessage
    )
}
