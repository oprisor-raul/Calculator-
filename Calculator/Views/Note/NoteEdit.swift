//
//  SwiftUIView.swift
//  Calculator-
//
//  Created by Oprișor Raul-Alexandru on 05.11.2022.
//

import SwiftUI

struct NoteEdit : View {
    var colorBackground: Color
    @State var title: String
    @State var content: String
    
    var body: some View {
        VStack(spacing: 15){
            // Title
            Text("Edit Note")
                .font(.system(size: 33, weight: .bold))
                .frame(maxWidth: .infinity,alignment: .leading)
            HStack {
                NavigationLink (destination: SecretMenuView(authorized: true)) {
                    Text ("Abort")
                        .foregroundColor(.white)
                        .fixedSize()
                        .padding(13)
                        .background(RoundedRectangle(cornerRadius: 10).fill(colorBackground.opacity(0.5)))
                }
                Spacer()
                NavigationLink (destination: SecretMenuView(authorized: true)) {
                    Text("Save")
                        .foregroundColor(.white)
                        .fixedSize()
                        .padding(13)
                        .background(RoundedRectangle(cornerRadius: 13).fill(colorBackground.opacity(0.5)))
                }
            }
            Form {
                VStack() {
                    if(!title.isEmpty) {
                        HStack{
                            Text("Title")
                                .font(.caption)
                                .foregroundColor(colorBackground)
                            Spacer()
                        }
                    }
                    TextField("Title", text: $title)
                }
                VStack() {
                    if(!content.isEmpty) {
                        HStack{
                            Text("Content")
                                .font(.caption)
                                .foregroundColor(colorBackground)
                            Spacer()
                        }
                    }
                    TextField("Content", text: $content, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(13, reservesSpace: true)
                }
            }
            .background(.black)
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .padding(.horizontal,15)
        .navigationBarBackButtonHidden(true)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NoteEdit(colorBackground: Color("SkyBlue"), title: "", content: "")
            .background(Color(.black))
    }
}
