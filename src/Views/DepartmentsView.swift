import SwiftUI

struct DepartmentsView: View {
    let departments: [Department]
    @State private var searchText = ""
    
    private var filteredDepartments: [Department] {
        if searchText.isEmpty {
            return departments
        }
        return departments.filter { department in
            department.name.localizedCaseInsensitiveContains(searchText) ||
            department.description.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredDepartments) { department in
                NavigationLink(destination: DepartmentDetailView(department: department)) {
                    DepartmentRowView(department: department)
                }
            }
            .navigationTitle("Отделения")
            .searchable(text: $searchText, prompt: "Поиск отделения")
        }
    }
}

struct DepartmentRowView: View {
    let department: Department
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text(department.name)
                .font(Theme.subtitleFont)
                .foregroundColor(Theme.textGray)
            
            Text(department.description)
                .font(Theme.captionFont)
                .foregroundColor(Theme.textGray.opacity(0.8))
                .lineLimit(2)
            
            Text(department.schedule)
                .font(Theme.captionFont)
                .foregroundColor(Theme.primaryRed)
        }
        .padding(Theme.Spacing.medium)
    }
}

struct DepartmentDetailView: View {
    let department: Department
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                // Основная информация
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text(department.name)
                        .font(Theme.titleFont)
                        .foregroundColor(Theme.textGray)
                    
                    Text(department.description)
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textGray.opacity(0.8))
                }
                
                // Оборудование
                if !department.equipment.isEmpty {
                    SectionView(title: "Оборудование", items: department.equipment)
                }
                
                // Специализации
                if !department.specializations.isEmpty {
                    SectionView(title: "Специализации", items: department.specializations)
                }
                
                // Контактная информация
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("Контакты")
                        .font(Theme.subtitleFont)
                    
                    Text(department.contactInfo)
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textGray)
                }
                
                // Расписание
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("Режим работы")
                        .font(Theme.subtitleFont)
                    
                    Text(department.schedule)
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.primaryRed)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SectionView: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text(title)
                .font(Theme.subtitleFont)
            
            ForEach(items, id: \.self) { item in
                HStack(spacing: Theme.Spacing.small) {
                    Circle()
                        .fill(Theme.primaryRed)
                        .frame(width: 6, height: 6)
                    
                    Text(item)
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textGray)
                }
            }
        }
    }
}