import SwiftUI

struct ServicesView: View {
    let services: [Service]
    @State private var searchText = ""
    @State private var selectedCategory: String = "Все"
    
    private var categories: [String] {
        ["Все"] + Array(Set(services.map { $0.category })).sorted()
    }
    
    private var filteredServices: [Service] {
        services.filter { service in
            let matchesSearch = searchText.isEmpty || 
                service.name.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == "Все" || 
                service.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Picker категорий
                Picker("Категория", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                .background(Theme.backgroundGray)
                
                // Список услуг
                List {
                    ForEach(filteredServices) { service in
                        ServiceRowView(service: service)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Услуги")
            .searchable(text: $searchText, prompt: "Поиск услуги")
        }
    }
}

struct ServiceRowView: View {
    let service: Service
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text(service.name)
                .font(Theme.bodyFont)
                .foregroundColor(Theme.textGray)
            
            HStack {
                Text("\(Int(service.price)) ₽")
                    .font(Theme.subtitleFont)
                    .foregroundColor(Theme.primaryRed)
                
                Spacer()
                
                Text(service.priceCode)
                    .font(Theme.captionFont)
                    .foregroundColor(Theme.textGray.opacity(0.6))
            }
        }
        .padding(Theme.Spacing.medium)
        .background(Color.white)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Theme.shadowColor, radius: Theme.shadowRadius, y: Theme.shadowY)
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesView(services: [
            Service(name: "Консультация терапевта", price: 2000, category: "Терапия", priceCode: "A01"),
            Service(name: "УЗИ", price: 3000, category: "Диагностика", priceCode: "B01")
        ])
    }
}