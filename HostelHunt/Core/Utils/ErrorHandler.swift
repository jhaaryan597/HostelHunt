import Foundation

// MARK: - App Errors
enum AppError: LocalizedError, Equatable {
    case network(NetworkError)
    case authentication(AuthError)
    case validation(ValidationError)
    case database(DatabaseError)
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription
        case .authentication(let error):
            return error.localizedDescription
        case .validation(let error):
            return error.localizedDescription
        case .database(let error):
            return error.localizedDescription
        case .unknown(let message):
            return message
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .network(.noConnection):
            return "Please check your internet connection and try again."
        case .network(.timeout):
            return "The request timed out. Please try again."
        case .authentication(.invalidCredentials):
            return "Please check your email and password."
        case .authentication(.emailNotVerified):
            return "Please verify your email address before signing in."
        case .validation(.invalidEmail):
            return "Please enter a valid email address."
        case .validation(.weakPassword):
            return "Password must be at least 8 characters with uppercase, lowercase, and numbers."
        case .database(.recordNotFound):
            return "The requested information could not be found."
        default:
            return "Please try again or contact support if the problem persists."
        }
    }
}

// MARK: - Network Errors
enum NetworkError: LocalizedError, Equatable {
    case noConnection
    case timeout
    case serverError(Int)
    case invalidResponse
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .serverError(let code):
            return "Server error (\(code))"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingError:
            return "Failed to process server response"
        }
    }
}

// MARK: - Authentication Errors
enum AuthError: LocalizedError, Equatable {
    case invalidCredentials
    case emailNotVerified
    case accountLocked
    case sessionExpired
    case signUpFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .emailNotVerified:
            return "Email address not verified"
        case .accountLocked:
            return "Account temporarily locked"
        case .sessionExpired:
            return "Session expired. Please sign in again"
        case .signUpFailed(let reason):
            return "Sign up failed: \(reason)"
        }
    }
}

// MARK: - Validation Errors
enum ValidationError: LocalizedError, Equatable {
    case invalidEmail
    case weakPassword
    case passwordMismatch
    case requiredFieldEmpty(String)
    case invalidPhoneNumber
    case invalidAge
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email format"
        case .weakPassword:
            return "Password is too weak"
        case .passwordMismatch:
            return "Passwords do not match"
        case .requiredFieldEmpty(let field):
            return "\(field) is required"
        case .invalidPhoneNumber:
            return "Invalid phone number format"
        case .invalidAge:
            return "Invalid age. Must be 18 or older"
        }
    }
}

// MARK: - Database Errors
enum DatabaseError: LocalizedError, Equatable {
    case recordNotFound
    case insertFailed
    case updateFailed
    case deleteFailed
    case connectionFailed
    
    var errorDescription: String? {
        switch self {
        case .recordNotFound:
            return "Record not found"
        case .insertFailed:
            return "Failed to save data"
        case .updateFailed:
            return "Failed to update data"
        case .deleteFailed:
            return "Failed to delete data"
        case .connectionFailed:
            return "Database connection failed"
        }
    }
}

// MARK: - Error Handler
class ErrorHandler: ObservableObject {
    static let shared = ErrorHandler()
    
    @Published var currentError: AppError?
    @Published var showError = false
    
    private init() {}
    
    func handle(_ error: Error) {
        DispatchQueue.main.async {
            if let appError = error as? AppError {
                self.currentError = appError
            } else {
                self.currentError = AppError.unknown(error.localizedDescription)
            }
            self.showError = true
            
            // Log error for analytics/debugging
            self.logError(self.currentError!)
        }
    }
    
    func clearError() {
        currentError = nil
        showError = false
    }
    
    private func logError(_ error: AppError) {
        if EnvironmentConfig.shared.isDebugModeEnabled {
            print("🚨 Error: \(error.localizedDescription ?? "Unknown error")")
            if let suggestion = error.recoverySuggestion {
                print("💡 Suggestion: \(suggestion)")
            }
        }
        
        // TODO: Send to analytics service in production
        // AnalyticsService.shared.logError(error)
    }
}
