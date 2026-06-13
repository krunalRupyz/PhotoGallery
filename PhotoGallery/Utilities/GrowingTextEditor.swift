//
//  GrowingTextEditor.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//
import SwiftUI

struct GrowingTextEditor: View {
    @Binding var text: String
    @State private var dynamicHeight: CGFloat = 50

    var body: some View {

        ZStack(alignment: .topLeading) {

            Text(text.isEmpty ? "Enter Title" : text)
                .font(.body)
                .padding(8)
                .opacity(0)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                dynamicHeight = max(
                                    50,
                                    geometry.size.height + 20
                                )
                            }
                            .onChange(of: text) { _ in
                                dynamicHeight = max(
                                    50,
                                    geometry.size.height + 20
                                )
                            }
                    }
                )

            TextEditor(text: $text)
                .frame(height: dynamicHeight)
                .padding(4)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray.opacity(0.4))
        )
    }
}
