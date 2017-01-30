//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Stephen Lin on 6/27/16.
//  Copyright © 2016 Stephen Lin. All rights reserved.
//

import Foundation

func factorial(num: Double) -> Double {
    if num <= 1 {
        return 1
    }
    return num * factorial(num - 1)
}

// This class contains the underlying calculations behind the screen
class CalculatorBrain {
    
    // This is a Double that contains the accumulated value so far from an expression
    private var accumulator = 0.0
    
    // This function takes a parameter, operand, which is set to the accumulator
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    // This is a Dictionary of key-value pairs whose key give access to the proper operations to perform
    var operations: Dictionary<String,Operation> = [
        "π"     : Operation.Constant(M_PI),
        "e"     : Operation.Constant(M_E),
        "√"     : Operation.UnaryOperation(sqrt),
        "sin"   : Operation.UnaryOperation(sin),
        "cos"   : Operation.UnaryOperation(cos),
        "tan"   : Operation.UnaryOperation(tan),
        "sinh"  : Operation.UnaryOperation(sinh),
        "cosh"  : Operation.UnaryOperation(cos),
        "tanh"  : Operation.UnaryOperation(tanh),
        "±"     : Operation.UnaryOperation({ -$0 }),
        "x²"    : Operation.UnaryOperation({ pow($0, 2) }),
        "x³"    : Operation.UnaryOperation({ pow($0, 3) }),
        "x⁻¹"   : Operation.UnaryOperation({ 1 / $0 }),
        "ln"    : Operation.UnaryOperation(log),
        "log"   : Operation.UnaryOperation(log10),
        "eˣ"    : Operation.UnaryOperation(exp),
        "10ˣ"   : Operation.UnaryOperation({ pow(10, $0) }),
        "x!"    : Operation.UnaryOperation(factorial),
        "×"     : Operation.BinaryOperation({ $0 * $1 }),
        "÷"     : Operation.BinaryOperation({ $0 / $1 }),
        "+"     : Operation.BinaryOperation({ $0 + $1 }),
        "−"     : Operation.BinaryOperation({ $0 - $1 }),
        "="     : Operation.Equals
    ]
    
    // This contains seperate categories for each case an operation can be assigned to
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}