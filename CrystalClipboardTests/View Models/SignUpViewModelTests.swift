//
//  SignUpViewModelTests.swift
//  CrystalClipboard
//
//  Created by Justin Mazzocchi on 8/21/17.
//  Copyright © 2017 Justin Mazzocchi. All rights reserved.
//

import XCTest
import ReactiveSwift
import Result
import Moya
@testable import CrystalClipboard

class SignUpViewModelTests: XCTestCase {
    static let provider = CrystalClipboardAPI.testingProvider()
    let viewModel = SignUpViewModel(provider: provider)
    let alertMessage = TestObserver<String, NoError>()
    
    override func setUp() {
        super.setUp()
        viewModel.alertMessage.observe(alertMessage.observer)
    }
    
    func testSignUpEnabled() {
        XCTAssertFalse(viewModel.signUp.isEnabled.value)
        viewModel.email.value = "user@domain.com"
        XCTAssertFalse(viewModel.signUp.isEnabled.value)
        viewModel.password.value = "password"
        XCTAssertTrue(viewModel.signUp.isEnabled.value)
    }
    
    func testSignUp() {
        // TODO
    }
    
    func testAlertsRemoteErrors() {
        viewModel.email.value = "satan@hell.org"
        viewModel.password.value = "p"
        viewModel.signUp.apply().start()
        alertMessage.assertValues(["Email has already been taken\n\nPassword is too short (minimum is 6 characters)"])
        viewModel.email.value = "satan+2@hell.org"
        viewModel.signUp.apply().start()
        alertMessage.assertValues([
            "Email has already been taken\n\nPassword is too short (minimum is 6 characters)",
            "Password is too short (minimum is 6 characters)"
        ])
        viewModel.password.value = "password"
        viewModel.signUp.apply().start()
        alertMessage.assertValues([
            "Email has already been taken\n\nPassword is too short (minimum is 6 characters)",
            "Password is too short (minimum is 6 characters)"
        ])
    }
    
    func testAlertsNetworkError() {
        let offlineProvider = CrystalClipboardAPI.testingProvider(online: false)
        let offlineViewModel = SignUpViewModel(provider: offlineProvider)
        let offlineAlertMessage = TestObserver<String, NoError>()
        offlineViewModel.alertMessage.observe(offlineAlertMessage.observer)
        offlineViewModel.email.value = "user@domain.com"
        offlineViewModel.password.value = "password"
        offlineViewModel.signUp.apply().start()
        offlineAlertMessage.assertValues(["sign-up.could-not".localized])
    }
}
