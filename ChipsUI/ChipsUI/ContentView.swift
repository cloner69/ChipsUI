//
//  ContentView.swift
//  ChipsUI
//
//  Created by Adrian Suryo Abiyoga on 06/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack{
                ChipsView{
                    ForEach(mockChips) { chip in
                        let viewWidth = chip.name.size(.preferredFont(forTextStyle: .body)).width + 20
                        Text(chip.name)
                            .font(.body)
                            .foregroundStyle(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(.red.gradient, in: .capsule)
                            .containerValue(\.viewWidth, viewWidth)
                    }
                }
                .frame(width: 300)
                .padding(15)
                .background(.primary.opacity(0.06), in: .rect(cornerRadius: 10))
            }
            .padding(15)
            .navigationTitle("Chip's")
        }
    }
}

extension String {
    func size(_ font: UIFont) -> CGSize {
        let attrributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: attrributes)
    }
}

extension ContainerValues {
    @Entry var viewWidth: CGFloat = 0
}

#Preview {
    ContentView()
}

struct ChipsView<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        Group(subviews: content) { collection in
            
            ///chunk by container width
            let chunkedCollection = collection.chunkByWidth(300)
            ///chunk by capsule count
            //let chunkedCollection = collection.chunked(3)
            
            VStack(alignment: .center, spacing: 10) {
                ForEach(chunkedCollection.indices, id: \.self) { index in
                    HStack(spacing: 10) {
                        ForEach(chunkedCollection[index]) { subview in
                            subview
                        }
                    }
                }
            }
        }
    }
}

extension SubviewsCollection {
    func chunkByWidth(_ containerWidth: CGFloat) -> [[Subview]] {
        var row: [Subview] = []
        var rowWidth: CGFloat = 0
        var rows: [[Subview]] = []
        let spacing: CGFloat = 10
        
        for subview in self {
            let viewWidth = subview.containerValues.viewWidth + spacing
            
            rowWidth += viewWidth
            
            if rowWidth < containerWidth {
                row.append(subview)
            }else {
                rows.append(row)
                row = [subview]
                rowWidth = viewWidth
            }
        }
        
        if !row.isEmpty {
            rows.append(row)
        }
        
        return rows
    }
    
    func chunked(_ size: Int) -> [[Subview]] {
        return stride(from: 0, to: count, by: size).map { index in
            Array(self[index..<Swift.min(index + size, count)])
        }
    }
}

struct Chip: Identifiable {
    var id: String = UUID().uuidString
    var name: String
}

var mockChips: [Chip] = [
    .init(name: "Apple"),
    .init(name: "Microsoft"),
    .init(name: "Google"),
    .init(name: "Facebook"),
    .init(name: "Huawei"),
    .init(name: "Twitter"),
    .init(name: "Reddit"),
    .init(name: "Youtube"),
    .init(name: "Uber"),
    .init(name: "TikTok"),
    .init(name: "Spotify"),
    .init(name: "Instagram"),
    .init(name: "Netflix"),
    .init(name: "Amazon"),
    .init(name: "Pinterest")
]
