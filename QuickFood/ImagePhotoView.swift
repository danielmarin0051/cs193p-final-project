//
//  ImagePhotoView.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/8/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardifyImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 6)
    }
}

extension View {
    func cardify() -> some View {
        self.modifier(CardifyImage())
    }
}

struct ImagePhotoView: View {
    let widthFactor: CGFloat?
    let heightFactor: CGFloat?
    let aspectRatio: CGFloat
    let size: CGSize
    let imageURL: String?
    
    init(imageURL: String?, size: CGSize, widthFactor: CGFloat = 1.0, aspectRatio: CGFloat = 3/2) {
        self.imageURL = imageURL
        self.size = size
        self.aspectRatio = aspectRatio
        self.widthFactor = widthFactor
        self.heightFactor = nil
    }
    
    init(imageURL: String?, size: CGSize, heightFactor: CGFloat = 1.0, aspectRatio: CGFloat = 3/2) {
        self.imageURL = imageURL
        self.size = size
        self.aspectRatio = aspectRatio
        self.heightFactor = heightFactor
        self.widthFactor = nil
    }
    
    var body: some View {
        if self.widthFactor != nil {
            // The ViewModifiers and View below are from the SDWebImageSwiftUI library, credit goes to its creators.
            return WebImage(url: URL(string: imageURL ?? ""))
                .resizable()
                .placeholder {
                    Image(systemName: "clock")
                        .imageScale(.large)
                        .spinning(period: 2.0)
                        .frame(width: size.width * self.widthFactor!,
                               height: size.width * (self.widthFactor!) / self.aspectRatio)
                        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.1))
            }
                .animation(.easeInOut(duration: 0.5))
                .transition(.fade)
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width * self.widthFactor!,
                       height: size.width * (self.widthFactor!) / self.aspectRatio)
                .cardify()
        } else {
            return WebImage(url: URL(string: imageURL ?? ""))
                .resizable()
                .placeholder {
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .frame(width: size.height * self.heightFactor! * self.aspectRatio,
                               height: size.height * self.heightFactor!)
                        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.1))
            }
                .animation(.easeInOut(duration: 0.5))
                .transition(.fade)
                .aspectRatio(contentMode: .fill)
                .frame(width: size.height * self.heightFactor! * self.aspectRatio,
                       height: size.height * self.heightFactor!)
                .cardify()
        }
    }
}

struct ImagePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ZStack {
                ImagePhotoView(imageURL: "https://live.staticflickr.com/65535/49983403076_efbef3f54f_c.jpgl",
                           size: geo.size, widthFactor: 0.8)
            }
        }
    }
}
