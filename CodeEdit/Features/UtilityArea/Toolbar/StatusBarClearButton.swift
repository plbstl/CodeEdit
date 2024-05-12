//
//  StatusBarClearButton.swift
//  CodeEdit
//
//  Created by Stef Kors on 12/04/2022.
//

import SwiftUI

struct StatusBarClearButton: View {
    var body: some View {
        Button {
            // Clear terminal
        } label: {
            Image(systemName: "trash")
                .foregroundColor(.secondary)
        }
        .buttonStyle(.plain)
    }
}
