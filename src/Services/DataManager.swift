import Foundation

class DataManager: ObservableObject {
    private let parser = RZDParser()
    
    @Published var doctors: [Doctor] = []
    @Published var departments: [Department] = []
    @Published var services: [Service] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func refreshData() async {
        do {
            await MainActor.run {
                self.isLoading = true
                self.error = nil
            }
            
            let data = try await parser.parseMainData()
            
            await MainActor.run {
                self.doctors = data.doctors
                self.departments = data.departments
                self.services = data.services
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
        }
    }
}