//
//  File.swift
//  
//
//  Created by Shyngys Kuandyk on 10.08.2023.
//

import Foundation

public extension DispatchQueue {
    func debounce(delay: Int, action: @escaping (() -> Void)) -> () -> Void {
        var lastFireTime = DispatchTime.now()
        let dispatchDelay = DispatchTimeInterval.milliseconds(delay)
        
        return {
            let dispatchTime: DispatchTime = lastFireTime + dispatchDelay
            self.asyncAfter(deadline: dispatchTime, execute: {
                let when: DispatchTime = lastFireTime + dispatchDelay
                let now = DispatchTime.now()
                if now.rawValue >= when.rawValue {
                    lastFireTime = DispatchTime.now()
                    action()
                }
            })
        }
    }
    
    static func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    static func background(_ closure: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            closure()
        }
    }
    
    static func main(_ closure: @escaping () -> Void) {
        DispatchQueue.main.async(execute: { () -> Void in
            closure()
        })
    }
    
}
