import SwiftUI

struct MainView: View {
    @StateObject private var dataManager = DataManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Вкладка со специалистами
            DoctorsListView(doctors: dataManager.doctors)
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Специалисты")
                }
                .tag(0)
            
            // Вкладка с услугами
            ServicesView(services: dataManager.services)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Услуги")
                }
                .tag(1)
            
            // Вкладка с отделениями
            DepartmentsView(departments: dataManager.departments)
                .tabItem {
                    Image(systemName: "building.2.fill")
                    Text("Отделения")
                }
                .tag(2)
            
            // Вкладка с информацией
            InfoView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("Информация")
                }
                .tag(3)
        }
        .accentColor(Theme.primaryRed)
        .overlay(loadingOverlay)
        .alert("Ошибка", isPresented: .constant(dataManager.error != nil)) {
            Button("OK") {
                dataManager.error = nil
            }
        } message: {
            Text(dataManager.error?.localizedDescription ?? "")
        }
        .task {
            await dataManager.refreshData()
        }
    }
    
    // Оверлей загрузки
    private var loadingOverlay: some View {
        Group {
            if dataManager.isLoading {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: Theme.Spacing.medium) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        
                        Text("Загрузка данных...")
                            .font(Theme.bodyFont)
                            .foregroundColor(.white)
                    }
                    .padding(Theme.Spacing.large)
                    .background(Theme.cardBackground(for: .light))
                    .cornerRadius(Theme.CornerRadius.medium)
                }
            }
        }
    }
}

// Представление списка докторов
struct DoctorsListView: View {
    let doctors: [Doctor]
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(filteredDoctors) { doctor in
                NavigationLink(destination: DoctorDetailView(doctor: doctor)) {
                    DoctorRowView(doctor: doctor)
                }
            }
            .navigationTitle("Специалисты")
            .searchable(text: $searchText, prompt: "Поиск врача")
        }
    }
    
    private var filteredDoctors: [Doctor] {
        if searchText.isEmpty {
            return doctors
        }
        return doctors.filter { doctor in
            doctor.name.localizedCaseInsensitiveContains(searchText) ||
            doctor.specialty.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// Компонент строки доктора
struct DoctorRowView: View {
    let doctor: Doctor
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            AsyncImage(url: URL(string: doctor.photoURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text(doctor.name)
                    .font(Theme.subtitleFont)
                    .foregroundColor(Theme.textGray)
                
                Text(doctor.specialty)
                    .font(Theme.captionFont)
                    .foregroundColor(Theme.textGray.opacity(0.8))
            }
        }
        .padding(.vertical, Theme.Spacing.small)
    }
}

// Заглушка для InfoView
struct InfoView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("О клинике")) {
                    InfoRow(icon: "location.fill", title: "Адрес", detail: "ул. Примерная, 123")
                    InfoRow(icon: "phone.fill", title: "Телефон", detail: "+7 (123) 456-78-90")
                    InfoRow(icon: "clock.fill", title: "Режим работы", detail: "Пн-Пт: 8:00-20:00")
                }
                
                Section(header: Text("Контакты")) {
                    InfoRow(icon: "envelope.fill", title: "Email", detail: "info@rzd-med.ru")
                    InfoRow(icon: "globe", title: "Сайт", detail: "rzd-medicine.ru")
                }
            }
            .navigationTitle("Информация")
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let detail: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Theme.primaryRed)
                .frame(width: 30)
            
            Text(title)
            Spacer()
            Text(detail)
                .foregroundColor(.gray)
        }
    }
}

// Предварительный просмотр
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}