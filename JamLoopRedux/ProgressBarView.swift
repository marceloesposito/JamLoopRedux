//
//  ProgressBarView.swift
//  JamLoopRedux
//
//  Created by Marcelo Esposito on 15/12/21.
//

import Foundation
import SwiftUI

struct ProgressBarView: View {
    var body: some View{
        
        RoundedRectangle(cornerRadius: 40).frame(width: 100, height: 20).foregroundColor(.white).padding(.horizontal, 15)
        
        
        
        RoundedRectangle(cornerRadius: 40).frame(width: 100, height: 20).foregroundColor(.white.opacity(0.5)).padding(.horizontal, 15)
        
        
        
        RoundedRectangle(cornerRadius: 40).frame(width: 100, height: 20).foregroundColor(.white.opacity(0.5)).padding(.horizontal, 15)
        
        
        
        RoundedRectangle(cornerRadius: 40).frame(width: 100, height: 20).foregroundColor(.white.opacity(0.5)).padding(.horizontal, 15)
        
    }
    
}

