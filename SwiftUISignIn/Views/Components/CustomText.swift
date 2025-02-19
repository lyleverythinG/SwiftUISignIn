//
//  CustomText.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/19/25.
//

import SwiftUI

struct CustomText {
    static func defaultText(_ text: String) -> some View {
        Text(text)
    }
    
    static func largeTitle(_ text: String) -> some View {
        Text(text)
            .font(.largeTitle)
    }
    
    static func title(_ text: String) -> some View {
        Text(text)
            .font(.title)
    }
    
    static func title2(_ text: String) -> some View {
        Text(text)
            .font(.title2)
    }
    
    static func title3(_ text: String) -> some View {
        Text(text)
            .font(.title3)
    }
    
    static func body(_ text: String) -> some View {
        Text(text)
            .font(.body)
    }
    
    static func headLine(_ text: String) -> some View {
        Text(text)
            .font(.headline)
    }
    
    static func subHeadline(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
    }
    
    static func caption(_ text: String) -> some View {
        Text(text)
            .font(.caption)
    }
    
    static func footNote(_ text: String) -> some View {
        Text(text)
            .font(.footnote)
    }
}
