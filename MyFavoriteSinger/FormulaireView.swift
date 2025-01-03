import SwiftUI
import SwiftData

struct FormulaireView: View {
    @State var NameArtist: String
    @State var NameSong: String
    
    
    var itemToEdit: Item?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private func saveItem() {
        guard !NameArtist.isEmpty, !NameSong.isEmpty else {
            print("Les champs ne peuvent pas être vides")
            return
        }
        
        withAnimation {
            if let item = itemToEdit {
                item.NameArtist = NameArtist
                item.NameSong = NameSong
            } else {
                let newItem = Item(NameArtist: NameArtist, NameSong: NameSong)
                modelContext.insert(newItem)
            }
            
            do {
                try modelContext.save()
                dismiss()
            } catch {
                print("Error saving item: \(error.localizedDescription)")
            }
        }
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails de l'artiste")) {
                    TextField("Nom de l'artiste", text: $NameArtist)
                    TextField("Nom de la chanson", text: $NameSong)
                    
                }
                
                Section(header: Text("Ajout url")) {
                    TextField("url", text: $NameArtist)
                    
                }
                
                    
                    
                    Button(action: saveItem, label: {
                        Text("Sauvegarder")
                            .foregroundColor(.blue)
                    })
                }
                .onAppear {
                    if let item = itemToEdit {
                        NameArtist = item.NameArtist
                        NameSong = item.NameSong
                    }
                }
                .navigationTitle("Ajouter une chanson")
            } //fin navigation stack
        } // fin body
    } // fin strucut

#Preview {
    FormulaireView(NameArtist: "", NameSong: "")
}

