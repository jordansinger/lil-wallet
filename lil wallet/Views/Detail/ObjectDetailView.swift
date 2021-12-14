//
//  ObjectDetailView.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI
import WebKit

struct ObjectDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var object: OpenSeaAsset
    @EnvironmentObject var appearance: Appearance
    
    var body: some View {
        let appFont = appearance.getAppFont()
        
        List {
            Group {
                if object.isSVG() {
                    WebView(loadURL: object.image_url)
                        .aspectRatio(1, contentMode: .fit)
                } else {
                    AsyncImage(url: URL(string: object.image_url)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(Color(UIColor.secondarySystemBackground))
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            
            Section(content: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(object.name)
                        .font(.system(.headline, design: appFont))
                    
                    if let description = object.description {
                        Text(description)
                            .font(.system(.body, design: appFont))
                    }
                }
                .listRowSeparator(.hidden)
            }, header: {
                Text("About")
            })
            
            if object.traits.count > 0 {
                Section(content: {
                    ForEach(object.traits, id: \.trait_type) { trait in
                        HStack {
                            Text(trait.trait_type.capitalized)
                                .font(.system(.body, design: appFont))
                                .lineLimit(1)
                            Spacer()
                            Text(trait.value.capitalized)
                                .font(.system(.headline, design: appFont))
                                .lineLimit(1)
                        }
                    }
                    .listRowSeparator(.hidden)
                }, header: {
                    Text("Properties")
                })
            }
            
            Section(content: {
                Group {
                    Link(destination: URL(string: object.permalink)!, label: {
                        Text("View on OpenSea")
                            .font(.system(.body, design: appFont))
                    })
                }
                .font(.system(.body, design: appFont))
                .foregroundColor(appearance.getAppColor())
                .listRowSeparator(.hidden)
            }, header: {
                Text("Options")
            })
        }
        .listStyle(InsetListStyle())
        .navigationBarTitle(object.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebView: UIViewRepresentable {
    let loadURL: String
    
    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: loadURL) {
            do {
                let contents = try String(contentsOf: url)
                let html = contents + "<style>html, body { width: 100%; height: 100%; margin: 0; padding: 0 }</style><meta name=\"viewport\" content=\"width=device-width, shrink-to-fit=YES\">"
                uiView.loadHTMLString(html, baseURL: nil)
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad
        }
    }
}

struct ObjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectDetailView()
    }
}
