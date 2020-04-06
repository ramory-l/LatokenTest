//
//  ViewController.swift
//  LatokenTest
//
//  Created by Mikhail Strizhenov on 06.04.2020.
//  Copyright © 2020 Mikhail Strizhenov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Write currency tag first bellow"
        return label
    }()
    
    let currencyTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter currency"
        textField.font = .systemFont(ofSize: 18)
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        return textField
    }()
    
    let checkButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Check current exchange rate to USD", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        currencyTextField.delegate = self
        view.addSubview(exchangeRateLabel)
        view.addSubview(currencyTextField)
        view.addSubview(checkButton)
        checkButton.addTarget(self, action: #selector(createRequest), for: .touchUpInside)
        setupLayout()
    }

    @objc func createRequest() {
        guard let tag = currencyTextField.text else { return }
        let url = URL(string: "https://api.latoken.com/api/v2/rate/\(tag)/USD")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let res = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async {
                    self.exchangeRateLabel.text = "Exchange rate value: \(String(res.value))"
                }
            } catch let error {
//                let alert = UIAlertController(title: "Error", message: "SOME ERROR", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
                print(error)
            }
        }
        task.resume()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    private func setupLayout() {
        currencyTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currencyTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        currencyTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        currencyTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        checkButton.topAnchor.constraint(equalTo: currencyTextField.bottomAnchor, constant: 10).isActive = true
        checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        checkButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        exchangeRateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        exchangeRateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        exchangeRateLabel.bottomAnchor.constraint(equalTo: currencyTextField.topAnchor).isActive = true
    }
}

