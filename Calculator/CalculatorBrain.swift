//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by YGuan on 5/18/16.
//  Copyright © 2016 YGuan. All rights reserved.
//

import Foundation


class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0 }),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
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
                excutePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, fistOperand: accumulator)
            case .Equals:
                excutePendingBinaryOperation()
            }
        }
    }
    
    private func excutePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.fistOperand,accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var fistOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}