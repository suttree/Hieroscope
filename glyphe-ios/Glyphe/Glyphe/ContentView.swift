import WidgetKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                }
            }
            .navigationBarTitle("Hieroscope", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
