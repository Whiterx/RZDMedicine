import SwiftUI

struct DoctorDetailView: View {
    let doctor: Doctor
    @State private var isShowingAppointment = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.large) {
                // Фото и основная информация
                doctorHeader
                
                // Опыт и специализация
                experienceSection
                
                // Образование
                educationSection
                
                // Сертификаты
                certificatesSection
                
                // Расписание
                scheduleSection
                
                // Кнопка записи
                appointmentButton
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingAppointment) {
            AppointmentView(doctor: doctor)
        }
    }
    
    private var doctorHeader: some View {
        VStack(spacing: Theme.Spacing.medium) {
            AsyncImage(url: URL(string: doctor.photoURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .overlay(Circle().stroke(Theme.primaryRed, lineWidth: 2))
            
            VStack(spacing: Theme.Spacing.small) {
                Text(doctor.name)
                    .font(Theme.titleFont)
                    .foregroundColor(Theme.textGray)
                    .multilineTextAlignment(.center)
                
                Text(doctor.specialty)
                    .font(Theme.subtitleFont)
                    .foregroundColor(Theme.primaryRed)
            }
        }
    }
    
    private var experienceSection: some View {
        InfoSection(title: "Опыт работы") {
            Text(doctor.experience)
                .font(Theme.bodyFont)
                .foregroundColor(Theme.textGray)
        }
    }
    
    private var educationSection: some View {
        InfoSection(title: "Образование") {
            Text(doctor.education)
                .font(Theme.bodyFont)
                .foregroundColor(Theme.textGray)
        }
    }
    
    private var certificatesSection: some View {
        InfoSection(title: "Сертификаты") {
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                ForEach(doctor.certificates, id: \.self) { certificate in
                    HStack(spacing: Theme.Spacing.small) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Theme.primaryRed)
                        
                        Text(certificate)
                            .font(Theme.bodyFont)
                            .foregroundColor(Theme.textGray)
                    }
                }
            }
        }
    }
    
    private var scheduleSection: some View {
        InfoSection(title: "Расписание приёма") {
            Text(doctor.schedule)
                .font(Theme.bodyFont)
                .foregroundColor(Theme.primaryRed)
        }
    }
    
    private var appointmentButton: some View {
        Button(action: {
            isShowingAppointment = true
        }) {
            Text("Записаться на приём")
                .font(Theme.subtitleFont)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.primaryRed)
                .cornerRadius(Theme.CornerRadius.medium)
        }
        .padding(.top, Theme.Spacing.large)
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text(title)
                .font(Theme.subtitleFont)
                .foregroundColor(Theme.textGray)
            
            content()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Theme.shadowColor, radius: Theme.shadowRadius, y: Theme.shadowY)
    }
}

// Заглушка для AppointmentView
struct AppointmentView: View {
    let doctor: Doctor
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @State private var selectedTime = "09:00"
    
    private let timeSlots = [
        "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
        "14:00", "14:30", "15:00", "15:30", "16:00", "16:30"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Выберите дату")) {
                    DatePicker(
                        "Дата приёма",
                        selection: $selectedDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                }
                
                Section(header: Text("Выберите время")) {
                    Picker("Время приёма", selection: $selectedTime) {
                        ForEach(timeSlots, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        // Здесь будет логика записи на приём
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Подтвердить запись")
                            .foregroundColor(Theme.primaryRed)
                    }
                }
            }
            .navigationTitle("Запись на приём")
            .navigationBarItems(trailing: Button("Закрыть") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}