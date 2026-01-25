import SwiftUI
import Observation

// Demo model class using @Observable
@Observable
class UserSettings {
    var username: String = "Guest"
    var isNotificationsEnabled: Bool = true
    var volume: Double = 50.0
    var selectedTheme: String = "Light"
    
    var description: String {
        "User: \(username), Notifications: \(isNotificationsEnabled ? "ON" : "OFF"), Volume: \(Int(volume))%, Theme: \(selectedTheme)"
    }
}

struct BindablePlayground: View {
    // Using @State with an @Observable class
    @State var settings = UserSettings()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Display current settings
                    GroupBox("Current Settings") {
                        Text(settings.description)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Direct editing with @Bindable in the same view
                    GroupBox("Direct Editing") {
                        VStack(alignment: .leading, spacing: 15) {
                            // Create @Bindable for binding support
                            @Bindable var bindableSettings = settings
                            
                            HStack {
                                Text("Username:")
                                TextField("Enter username", text: $bindableSettings.username)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            Toggle("Enable Notifications", isOn: $bindableSettings.isNotificationsEnabled)
                            
                            VStack(alignment: .leading) {
                                Text("Volume: \(Int(bindableSettings.volume))%")
                                Slider(value: $bindableSettings.volume, in: 0...100, step: 5)
                            }
                            
                            Picker("Theme", selection: $bindableSettings.selectedTheme) {
                                Text("Light").tag("Light")
                                Text("Dark").tag("Dark")
                                Text("Auto").tag("Auto")
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    
                    // Child view that receives the model
                    GroupBox("Child View Editing") {
                        SettingsEditView(settings: settings)
                    }
                    
                    // Another child view showing read-only data
                    GroupBox("Read-Only Display") {
                        SettingsDisplayView(settings: settings)
                    }
                    
                    // Reset button
                    Button(action: {
                        settings.username = "Guest"
                        settings.isNotificationsEnabled = true
                        settings.volume = 50.0
                        settings.selectedTheme = "Light"
                    }) {
                        Label("Reset to Defaults", systemImage: "arrow.counterclockwise")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle("@Bindable Demo")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

// Child view that can edit the settings using @Bindable
struct SettingsEditView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Edit from Child View")
                .font(.headline)
            
            HStack {
                Text("Quick Name:")
                TextField("Name", text: $settings.username)
                    .textFieldStyle(.roundedBorder)
            }
            
            Toggle("Notifications", isOn: $settings.isNotificationsEnabled)
        }
    }
}

// Child view that only displays settings (no @Bindable needed)
struct SettingsDisplayView: View {
    let settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Display Only")
                .font(.headline)
            
            Label(settings.username, systemImage: "person.circle")
            Label("\(Int(settings.volume))%", systemImage: "speaker.wave.2")
            Label(settings.selectedTheme, systemImage: "sun.max")
            
            if settings.isNotificationsEnabled {
                Label("Notifications ON", systemImage: "bell.fill")
                    .foregroundColor(.green)
            } else {
                Label("Notifications OFF", systemImage: "bell.slash")
                    .foregroundColor(.red)
            }
        }
    }
}

#if !SKIP
struct BindablePlayground_Previews: PreviewProvider {
    static var previews: some View {
        BindablePlayground()
    }
}
#endif