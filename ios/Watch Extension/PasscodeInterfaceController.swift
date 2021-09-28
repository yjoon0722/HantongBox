//
//  PasscodeInterfaceController.swift
//  Watch Extension
//
//  Created by SONGKIWON on 2020/08/24.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import WatchKit
import UIKit

class PasscodeInterfaceController: WKInterfaceController {
    
    let dataStore = DataStore()
    let api: API = API.sharedInstance
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var passcodeTextField: WKInterfaceTextField!
    @IBOutlet weak var backButton: WKInterfaceButton!
    
    var passCode: String? = nil
    var passWord: String? = nil
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didAppear() {
        super.didAppear()
        
        titleLabel.setText("암호 입력")
        titleLabel.setHidden(false)
        
        passcodeTextField.setText("")
        passcodeTextField.setHidden(true)
        
        backButton.setHidden(true)
        
        self.api.serverPassword {
            debugPrint("serverPassword: \(String(describing: self.dataStore.serverPassword))")
            self.passWord = self.dataStore.serverPassword ?? ""
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // MARK: Actions
        
    @IBAction func actionOneButton()    {  buttonEvent(code: 1) }
    @IBAction func actionTwoButton()    {  buttonEvent(code: 2) }
    @IBAction func actionThreeButton()  {  buttonEvent(code: 3) }
    
    @IBAction func actionFourButton()   {  buttonEvent(code: 4) }
    @IBAction func actionFiveButton()   {  buttonEvent(code: 5) }
    @IBAction func actionSixButton()    {  buttonEvent(code: 6) }
    
    @IBAction func actionSevenButton()  {  buttonEvent(code: 7) }
    @IBAction func actionEightButton()  {  buttonEvent(code: 8) }
    @IBAction func actionNineButton()   {  buttonEvent(code: 9) }
    
    @IBAction func actionZeroButton()   {  buttonEvent(code: 0) }
    
    @IBAction func actionBackButton() {
        guard let passCode: String = passCode else { return }
        if passCode.isEmpty { return }
        setPassCode(text: String(passCode.dropLast()))
    }
    
    // MARK: Class methods
    
    func buttonEvent(code: Int)  {
        var newPassCode = passCode ?? ""
        newPassCode += String(code)
        setPassCode(text: newPassCode)
    }
    
    func setPassCode(text: String?) {
        passCode = text
        
        if passWord == nil || passWord?.count == 0 {
            self.api.serverPassword {
                debugPrint("serverPassword: \(String(describing: self.dataStore.serverPassword))")
                self.passWord = self.dataStore.serverPassword ?? ""
            }
        }
        
        if passCode == nil || passCode?.count == 0 {
            titleLabel.setText("암호 입력")
            titleLabel.setHidden(false)
            
            passcodeTextField.setText("")
            passcodeTextField.setHidden(true)
            
            backButton.setHidden(true)
            return
        }
        
        titleLabel.setText("암호 입력")
        titleLabel.setHidden(true)
        
        passcodeTextField.setText(passCode)
        passcodeTextField.setHidden(false)
        
        backButton.setHidden(false)
                
        // 서버에 저장된 패스워드와 비교
        if passWord?.count == passCode?.count {
            if passWord == passCode {
                dataStore.unlockDate = Date()
                WKInterfaceController.reloadRootControllers(withNamesAndContexts:
                    [(name: "InterfaceController", context: InterfaceController.self)])
            } else {
                titleLabel.setText("패스워드가 틀렸습니다.")
                setPassCode(text: nil)
            }
        }
        
    }
}
