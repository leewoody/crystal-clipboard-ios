//
//  SignUpViewModel.swift
//  CrystalClipboard
//
//  Created by Justin Mazzocchi on 8/21/17.
//  Copyright © 2017 Justin Mazzocchi. All rights reserved.
//

import ReactiveSwift
import Result
import Moya

class SignUpViewModel {
    enum SignUpFormError: Error {
        case invalidEmail
        case invalidPassword
    }
    
    private let provider: MoyaProvider<CrystalClipboardAPI>
    
    // MARK: Inputs
    
    let email = ValidatingProperty<String, SignUpFormError>("") {
        $0.characters.count > 0 ? .valid : .invalid(.invalidEmail)
    }
    
    let password = ValidatingProperty<String, SignUpFormError>("") {
        $0.characters.count > 0 ? .valid : .invalid(.invalidPassword)
    }
    
    lazy var signUp: Action<Void, String, MoyaError> = Action(enabledIf: self.signUpEnabled) { [unowned self] _ in
        return self.provider.reactive.request(.createUser(email: self.email.value, password: self.password.value))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .map { json in
                // TODO
                return ""
//                fatalError("coming soon")
        }
    }
    
    // MARK: Outputs

    lazy var alertMessage: Signal<String, NoError> = self.signUp.errors.map {
        $0.response?.combinedErrorDescription ?? "sign-up.could-not".localized
    }
    
    // MARK: Initialization
    
    init(provider: MoyaProvider<CrystalClipboardAPI>) {
        self.provider = provider
    }
    
    // MARK: Private
    
    private lazy var signUpEnabled: Property<Bool> = Property
        .combineLatest(self.email.result, self.password.result)
        .map { email, password in !email.isInvalid && !password.isInvalid }
}
