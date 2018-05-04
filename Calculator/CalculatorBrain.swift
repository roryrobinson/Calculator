//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Rory Robinson on 06/04/2018.
//  Copyright © 2018 Rory Robinson. All rights reserved.
//

import Foundation


class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    func addUnaryOperation(symbol: String, operation: (Double) -> Double){
        operations[symbol] = Operation.UnaryOperation(operation)
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" :   Operation.Constant(M_PI),
        "e" :   Operation.Constant(M_E),
        "ch":   Operation.UnaryOperation({ -$0 }),
        "sqr" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "x" :   Operation.BinaryOperation( { $0 * $1 }),
        "/" :   Operation.BinaryOperation({ $0 / $1 }),
        "+" :   Operation.BinaryOperation({ $0 + $1 }),
        "-" :   Operation.BinaryOperation({ $0 - $1 }),
        "=" :   Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation ((Double) -> Double)
        case BinaryOperation ((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let foo):
                accumulator = foo(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = pendingBinaryOperationInfo(binaryfunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryfunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: pendingBinaryOperationInfo?
    
    
    private struct pendingBinaryOperationInfo {
        var binaryfunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
}