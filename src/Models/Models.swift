import Foundation

// Модель врача
struct Doctor: Identifiable, Codable {
    let id = UUID()
    let name: String
    let specialty: String
    let photoURL: String
    let experience: String
    let schedule: String
    let education: String
    let certificates: [String]
}

// Модель услуги
struct Service: Identifiable, Codable {
    let id = UUID()
    let name: String
    let price: Double
    let category: String
    let priceCode: String
}

// Модель отделения
struct Department: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let equipment: [String]
    let specializations: [String]
    let contactInfo: String
    let schedule: String
}

// Вспомогательные модели
struct DoctorDetail {
    let schedule: String
    let education: String
    let certificates: [String]
}

struct DepartmentDetail {
    let equipment: [String]
    let specializations: [String]
    let contactInfo: String
    let schedule: String
}
