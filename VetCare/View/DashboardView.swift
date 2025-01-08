//
//  DashboardView.swift
//  VetCare
//
//  Created by Tural Babayev on 7.01.2025.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: PetManagementView()) {
                    Text("Manage Pets")
                }
                NavigationLink(destination: AppointmentView()) {
                    Text("Manage Appointments")
                }
                NavigationLink(destination: TreatmentView()) {
                    Text("Manage Treatments")
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}


#Preview {
    DashboardView()
}
