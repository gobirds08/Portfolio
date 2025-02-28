//
//  SheetCapsule.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/28/24.
//

import SwiftUI

struct SheetCapsule: View {
    var body: some View {
        Capsule()
            .foregroundStyle(.placeholder)
            .frame(width: 25, height: 5)
    }
}

#Preview {
    SheetCapsule()
}
