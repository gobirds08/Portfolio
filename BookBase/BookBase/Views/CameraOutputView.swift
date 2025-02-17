//
//  CameraOutputView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/4/24.
//

import SwiftUI

struct CameraOutputView: View {
    var frame: CGImage?
    
    var body: some View {
        if let frame = frame{
            Image(decorative: frame, scale: 1.0, orientation: .up)
        }else{
            Color.black
        }
    }
}

#Preview {
    CameraOutputView()
}
