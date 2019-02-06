//
//  ViewController.swift
//  ScrollingFormProgrammatically
//
//  Created by Mark Meretzky on 2/3/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit;

class ViewController: UIViewController {
    let scrollView: UIScrollView = UIScrollView();

    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        
        //Create an array of eight Strings.
        
        let strings: [String] = [
            "First Name",
            "Last Name",
            "Address Line 1",
            "Address Line 2",
            "City",
            "State",
            "Zip Code",
            "Phone Number"
        ];
        
        //Create an array of eight UIViews, one for each String.
        
        let arrangedSubviews: [UIView] = strings.map {
            let view: UIView = UIView();   //Will contain one UILabel and one UITextField.
            
            let label: UILabel = UILabel();
            label.text = $0;
            label.frame.origin = CGPoint(x: view.layoutMargins.left, y: view.layoutMargins.top);
            label.translatesAutoresizingMaskIntoConstraints = false;
            view.addSubview(label);
            
            let textField: UITextField = UITextField();
            textField.borderStyle = .roundedRect;
            textField.placeholder = $0;
            textField.frame.origin = CGPoint(x: view.layoutMargins.left, y: 2 * view.layoutMargins.top + label.frame.height);
            textField.addTarget(self, action: #selector(returnKeyTapped(_:)), for: .primaryActionTriggered);
            textField.translatesAutoresizingMaskIntoConstraints = false;
            view.addSubview(textField);
            
            //The first seven anchors on page 586.
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.layoutMargins.left).isActive = true;
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.layoutMargins.right).isActive = true;
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: view.layoutMargins.top).isActive = true;
            label.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -view.layoutMargins.top).isActive = true;
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.layoutMargins.left).isActive = true;
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.layoutMargins.right).isActive = true;
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.layoutMargins.bottom).isActive = true;
            
            return view;
        }
        
        //Put the stack view into the scroll view.
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: arrangedSubviews);
        stackView.axis = .vertical;   //defaults to .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.addSubview(stackView);
        
        //Page 584: pin the edges of the stack view to the edges of the scroll view.

        let stackViewConstraints: [NSLayoutConstraint] = [
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ];
        scrollView.addConstraints(stackViewConstraints);
        
        //Put the scroll view into the big white view.
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(scrollView);
        
        //Page 583: pin the edges of the scroll view to the edges of the big white view's safe area.
        
        let scrollViewConstraints: [NSLayoutConstraint] = [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ];
        view.addConstraints(scrollViewConstraints);

        //last anchor on page 586.
        stackView.arrangedSubviews[0].widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true;
        
        registerForKeyboardNotifications();   //p. 590
    }
    
    //Called when the return key of any UITextField is tapped.
    
    @objc func returnKeyTapped(_ sender: UITextField) {
        sender.resignFirstResponder();
    }
    
    //MARK: Keyboard Notifications
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShown(_:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil);
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil);
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {   //p. 589
        guard let info: [AnyHashable: Any] = notification.userInfo,
            let keyboardFrameValue: NSValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
                return;
        }
        
        let height: CGFloat = keyboardFrameValue.cgRectValue.size.height;
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {   //p. 590
        scrollView.contentInset = .zero;
        scrollView.scrollIndicatorInsets = .zero;
    }

}
