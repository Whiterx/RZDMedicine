import Foundation
import SwiftSoup

class RZDParser {
    private let baseURL = "https://khabarovsk.rzd-medicine.ru"
    
    enum ParsingError: Error {
        case networkError
        case parsingFailed
        case invalidURL
    }
    
    // Основной метод парсинга
    func parseMainData() async throws -> (doctors: [Doctor], departments: [Department], services: [Service]) {
        let doctors = try await parseDoctors()
        let departments = try await parseDepartments()
        let services = try await parseServices()
        return (doctors, departments, services)
    }
    
    // Парсинг докторов
    private func parseDoctors() async throws -> [Doctor] {
        let doctorsURL = "\(baseURL)/doctors/"
        let html = try await fetchHTML(from: doctorsURL)
        let doc = try SwiftSoup.parse(html)
        
        let doctorElements = try doc.select("div.doctor-item")
        
        return try doctorElements.compactMap { element -> Doctor? in
            let name = try element.select("div.doctor-name").text()
            let specialty = try element.select("div.doctor-specialty").text()
            let photoURL = try element.select("img").attr("src")
            let experience = try element.select("div.doctor-experience").text()
            
            // Получаем детальную информацию о враче
            let detailURL = try element.select("a").attr("href")
            let detailInfo = try await parseDoctorDetail(url: detailURL)
            
            return Doctor(
                name: name,
                specialty: specialty,
                photoURL: "\(baseURL)\(photoURL)",
                experience: experience,
                schedule: detailInfo.schedule,
                education: detailInfo.education,
                certificates: detailInfo.certificates
            )
        }
    }
    
    // Парсинг услуг
    private func parseServices() async throws -> [Service] {
        let servicesURL = "\(baseURL)/price/"
        let html = try await fetchHTML(from: servicesURL)
        let doc = try SwiftSoup.parse(html)
        
        let serviceElements = try doc.select("div.price-list table tr")
        
        return try serviceElements.compactMap { element -> Service? in
            let columns = try element.select("td")
            guard columns.size() >= 3 else { return nil }
            
            let name = try columns.get(0).text()
            let priceText = try columns.get(1).text()
                .replacingOccurrences(of: "руб.", with: "")
                .trimmingCharacters(in: .whitespaces)
            let price = Double(priceText) ?? 0.0
            let category = try element.parents().first()?
                .select("h2").text() ?? "Общие услуги"
            
            return Service(
                name: name,
                price: price,
                category: category,
                priceCode: try columns.get(2).text()
            )
        }
    }
    
    // Вспомогательные методы
    private func fetchHTML(from urlString: String) async throws -> String {
        guard let url = URL(string: urlString) else {
            throw ParsingError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let html = String(data: data, encoding: .utf8) else {
            throw ParsingError.parsingFailed
        }
        return html
    }
    
    private func parseDoctorDetail(url: String) async throws -> DoctorDetail {
        let html = try await fetchHTML(from: "\(baseURL)\(url)")
        let doc = try SwiftSoup.parse(html)
        
        return DoctorDetail(
            schedule: try doc.select("div.schedule").text(),
            education: try doc.select("div.education").text(),
            certificates: try doc.select("div.certificates").array().map { try $0.text() }
        )
    }
}