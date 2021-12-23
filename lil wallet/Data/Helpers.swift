//
//  Helpers.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/29/21.
//

import SwiftUI

class Appearance: ObservableObject {
    @AppStorage("appColor") private var appColor = AppColor.monochrome
    @AppStorage("appFont") private var appFont = AppFont.regular
    
    func getAppColor() -> Color {
        appColor.color
    }
    
    func getAppFont() -> Font.Design {
        appFont.font
    }
}

enum AppColor: String, Hashable, CaseIterable {
    case monochrome
    case red
    case orange
    case yellow
    case green
    case blue
    case indigo
    case purple
    
    var color: Color {
        switch self {
        case .monochrome:
            return Color.primary
        case .red:
            return Color.red
        case .orange:
            return Color.orange
        case .yellow:
            return Color.yellow
        case .green:
            return Color.green
        case .blue:
            return Color.blue
        case .indigo:
            return Color.indigo
        case .purple:
            return Color.purple
        }
    }
}

enum AppFont: String, Hashable, CaseIterable {
    case regular
    case rounded
    case monospaced
    case serif
    
    var font: Font.Design {
        switch self {
        case .regular:
            return Font.Design.default
        case .rounded:
            return Font.Design.rounded
        case .monospaced:
            return Font.Design.monospaced
        case .serif:
            return Font.Design.serif
        }
    }
}

struct ImageView: View {
    @ObservedObject var remoteImageURL: RemoteImageURL
    
    init(imageUrl: String) {
        remoteImageURL = RemoteImageURL(imageURL: imageUrl)
    }
    
    var body: some View {
        Image(uiImage: UIImage(data: self.remoteImageURL.data) ?? UIImage())
            .resizable()
            .aspectRatio(1, contentMode: .fill)
    }
}

class RemoteImageURL: ObservableObject {
    @Published var data = Data()
    
    // load our image URL
    init(imageURL: String) {
        guard let url = URL(string: imageURL) else {
            print("Invalid URL")
            return
        }
      
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let _ = response {
                DispatchQueue.main.async {
                    self.data = data
                }
            }
        }.resume()
    }
}
