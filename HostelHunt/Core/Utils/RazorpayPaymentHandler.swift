import Foundation
import Razorpay
import SwiftUI

class RazorpayPaymentHandler: NSObject, RazorpayPaymentCompletionProtocol, ObservableObject {
    
    var onPaymentSuccess: ((String) -> Void)?
    var onPaymentError: ((String) -> Void)?
    
    private var razorpay: RazorpayCheckout?
    
    override init() {
        super.init()
    }
    
    func openCheckout(amount: Double, name: String, description: String, email: String, phone: String) {
        let options: [String: Any] = [
            "amount": amount * 100, // Amount in paise
            "currency": "INR",
            "description": description,
            "name": name,
            "prefill": [
                "email": email,
                "contact": phone
            ],
            "theme": [
                "color": "#3399cc"
            ]
        ]
        
        razorpay = RazorpayCheckout.initWithKey("rzp_test_1DP5mmOlF5G5ag", andDelegate: self)
        razorpay?.open(options)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        onPaymentSuccess?(payment_id)
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        onPaymentError?(str)
    }
}
