//
//  AvatarView.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/29/21.
//

import SwiftUI

struct AvatarView: View {
    @EnvironmentObject var appearance: Appearance
    @State var text: String
    @State var iconURL: String?
    
    var body: some View {
        if let iconURL = iconURL {
            ImageView(imageUrl: iconURL)
                .frame(width: 40, height: 40)
                .cornerRadius(40)
                .background(
                    Ellipse()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                )
        } else {
            placeholder
        }
    }
    
    var placeholder: some View {
        ZStack {
            Text(text.prefix(1).uppercased())
                .font(.system(.headline, design: appearance.getAppFont()))
                .foregroundColor(Color(UIColor.systemBackground))
        }
            .frame(width: 40, height: 40)
            .background(appearance.getAppColor())
            .cornerRadius(40)
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(text: "abc")
    }
}
