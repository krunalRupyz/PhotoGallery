//
//  ToastView.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .background(.black.opacity(0.8))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
