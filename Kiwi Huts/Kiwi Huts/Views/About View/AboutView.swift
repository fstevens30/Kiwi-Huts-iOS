//
//  AboutView.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 7/03/24.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject var viewModel: HutsViewModel
    @EnvironmentObject var user: User
    
    func getAppVersion() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return "Unknown"
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack {
                    AppVersionInformationView(
                        versionString: AppVersionProvider.appVersion(),
                        appIcon: AppIconProvider.appIcon()
                    )
                }
                
                VStack {
                    Text("Kiwi Huts")
                        .font(.headline)
                }
                Divider()
                    .padding()
                
                VStack(alignment: .leading) {
                    
                    Text("Remember, please refer to the DOC website and local weather before heading out on adventures. Data is updated twice a day. For more information on this app please see below.")
                        .padding()
                    
                    Text("All data on this app is pulled from the Department of Conservation API. Please refer to the timestamp below to see when the data was last updated.")
                        .padding()
                }
                .padding()
                
                HStack {
                    Link("GitHub Link", destination: URL(string:"https://github.com/fstevens30/Kiwi-Huts")!)
                        .buttonStyle(.bordered)
                    Link("DOC API", destination: URL(string: "https://api.doc.govt.nz/")!)
                        .buttonStyle(.bordered)
                }
                .padding()
                
                Spacer()
                
            }
            .statusBarHidden(false)
            .navigationTitle("About")
        }
      
    }
    
}

#Preview {
    AboutView()
        .environmentObject(HutsViewModel())
}
