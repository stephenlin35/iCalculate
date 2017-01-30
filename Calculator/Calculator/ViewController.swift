//
//  ViewController.swift
//  Calculator
//
//  Created by Stephen Lin on 6/27/16.
//  Copyright © 2016 Stephen Lin. All rights reserved.
//

import UIKit

// This class contains the data and logic of what should happen when the user interacts with the interface
class ViewController: UIViewController {
    
    // I am a property of the ViewController, 
    // this allows you to edit and modify its contents
    @IBOutlet weak var display: UILabel!
    
    // I am a Boolean that is FALSE when I first press a button,
    // and TRUE when I'm in the middle of a multi-digit number
    var userIsInTheMiddleOfTyping = false {
        didSet {
            if !userIsInTheMiddleOfTyping {
                userIsInTheMiddleOfFloatingPointNumber = false
            }
        }
    }
    
    // This is TRUE when user entering a decimal number
    private var userIsInTheMiddleOfFloatingPointNumber = false
    
    // I am a function that takes a Button with a digit as a parameter, the number on that button will be stored in @digit.
    // If I am in the middle of typing, get the current display into textCurr.. and set the display to whatever is in textCurr.. and add the digit pressed onto the display string.
    // Otherwise, this means you pressed your first digit and replace the default 0 value in the display with the digit pressed. Finally, set userIn.. to true because in either case afterwards you would still have to type additional info to form an expression.
    @IBAction func touchDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        
        if digit == "." {
            if userIsInTheMiddleOfFloatingPointNumber {
                return
            }
            if !userIsInTheMiddleOfTyping {
                digit = "0."
            }
            userIsInTheMiddleOfFloatingPointNumber = true
        }
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    // I am a computed variable, this means I am calculated each time I am used.
    // I am not like a stored var, they store only a value.
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)     // newValue: contains the modified content of displayValue
        }
    }
    
    // I am an object of class CalculatorBrain, I can then use the properies and methods of that class.
    private var brain = CalculatorBrain()
    
    // I am a function that takes a Button with an operation as a parameter. If I am in the middle of typing,
    // call the object brain's setOperand() method and have it take the current value in the display as a parameter and set userIn.. to false, this means you finished typing the integer-value and proceed to perform an operation on that.
    // If the text on the Button can be retrieved, store it in a constant called mathem.. and call brain's 
    // performOperation method with mathem.. as a parameter.
    // Get back the result property from brain and set displayValue to contain that result.
    @IBAction func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
    private func adjustButtonLayout(view: UIView, portrait: Bool) {
        for subview in view.subviews {
            if subview.tag == 1 {
                subview.hidden = portrait
            } else if subview.tag == 2 {
                subview.hidden = !portrait
            }
            if let button = subview as? UIButton {
                button.setBackgroundColor(UIColor.blackColor(), forState: .Highlighted)
            } else if let stack = subview as? UIStackView {
                adjustButtonLayout(stack, portrait: portrait);
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustButtonLayout(view, portrait: traitCollection.horizontalSizeClass == .Compact && traitCollection.verticalSizeClass == .Regular)
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        adjustButtonLayout(view, portrait: newCollection.horizontalSizeClass == .Compact && newCollection.verticalSizeClass == .Regular)
    }
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState state: UIControlState) {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext();
        color.setFill()
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(image, forState: state);
    }
}
