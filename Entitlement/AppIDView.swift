//
//  AppIDView.swift
//  Entitlement
//
//  Created by s s on 2025/3/15.
//
import SwiftUI

struct AppIDEditView : View {
    @StateObject var viewModel: AppIDModel
    @State private var selectedEntitlement = Entitlement.increasedMemory
    
    @State private var errorShow = false
    @State private var errorInfo = ""
    
    var body: some View {
        Form {
            Section {
                Picker("Entitlement", selection: $selectedEntitlement) {
                    ForEach(Entitlement.allCases, id: \.self) { entitlement in
                        Text(entitlement.displayName).tag(entitlement)
                    }
                }
                
                Button {
                    Task { await addEntitlement() }
                } label: {
                    Text("Add Entitlement")
                }
            }
            
            Section {
                Text(viewModel.result)
                    .font(.system(.subheadline, design: .monospaced))
            } header: {
                Text("Server Response")
            }
        }
        .alert("Error", isPresented: $errorShow){
            Button("OK".loc, action: {
            })
        } message: {
            Text(errorInfo)
        }
        .navigationTitle(viewModel.bundleID)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addEntitlement() async {
        do {
            try await viewModel.addEntitlement(selectedEntitlement)
        } catch {
            errorInfo = error.localizedDescription
            errorShow = true
        }
    }
}


struct AppIDView : View {
    @StateObject var viewModel : AppIDViewModel
    
    @State private var errorShow = false
    @State private var errorInfo = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ForEach(viewModel.appIDs, id: \.self) { appID in
                        NavigationLink {
                            AppIDEditView(viewModel: appID)
                        } label: {
                            Text(appID.bundleID)
                        }
                    }
                } header: {
                    Text("App IDs")
                }
                
                Section {
                    Button("Refresh") {
                        Task { await refreshButtonClicked() }
                    }
                }
            }
            .alert("Error", isPresented: $errorShow){
                Button("OK".loc, action: {
                })
            } message: {
                Text(errorInfo)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func refreshButtonClicked() async {
        do {
            try await viewModel.fetchAppIDs()
        } catch {
            errorInfo = error.localizedDescription
            errorShow = true
        }
    }
}
