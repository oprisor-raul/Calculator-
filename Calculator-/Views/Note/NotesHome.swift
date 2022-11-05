import SwiftUI

struct Home: View {
    
    // Showing Card Colors on Button Click....
    @State var showColors: Bool = false
    
    // Button Animation...
    @State var animateButton: Bool = false
    
    var body: some View {
        bar()
        HStack(spacing: 0){
            MainContent()
        }
        .background(Color(.black).ignoresSafeArea())
        .overlay(SideBar())
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func bar()->some View {
        // A bar at the top of the screen so that the status bar does not appear over the notes
        HStack(){}
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.bottom,10)
        .overlay(
        
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(height: 1)
                .padding(.horizontal,-25)
            // Moving offset 6...
                .offset(y: 6)
                .opacity(1),
            
            alignment: .bottom
        )
    }
    
    @ViewBuilder
    func MainContent()->some View{
        VStack(spacing: 0){
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15){
                    // Title
                    Text("Notes")
                        .font(.system(size: 33, weight: .bold))
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    // Columns...
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 1)
                    
                    LazyVGrid(columns: columns,spacing: 25) {
                        // Notes
                        ForEach(notes){note in
                            // Card View....
                            CardView(note: note)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .padding(.horizontal,15)
    }
    
    @ViewBuilder
    func CardView(note: Note)->some View{
        
        VStack{
            
            Text(note.note)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            HStack{
                
                Text(note.date,style: .date)
                    .foregroundColor(.black)
                    .opacity(0.8)
                
                Spacer(minLength: 0)
                
                // Edit Button...
                Button {
                    
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 15, weight: .bold))
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .clipShape(Circle())
                }

            }
            .padding(.top,55)
        }
        .padding()
        .background(note.cardColor)
        .cornerRadius(18)
    }
    
    @ViewBuilder
    func SideBar()->some View{
        
        VStack{
            VStack(spacing: 15){
                
                // Colors...
                let colors = [Color("Skin"),Color("Orange"),Color("Purple"),Color("SkyBlue"),Color("Green")]
                
                ForEach(colors,id: \.self){color in
                    
                    NavigationLink(destination: NoteEdit(colorBackground: color, title: "Titlu 1 ", content: "Anastasia \n")) {
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .padding(.top,20)
            .frame(height: showColors ? nil : 0)
            .opacity(showColors ? 1 : 0)
            .zIndex(0)
            
            // Add Button
            AddButton()
                    .zIndex(1)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomTrailing)
        .padding()
        // Blur View...
        .background(
            BlurView(style: .systemUltraThinMaterialDark)
                .opacity(showColors ? 1 : 0)
                .ignoresSafeArea()
        )
    }
    
    @ViewBuilder
    func AddButton()->some View{
        Button {
            
            if animateButton{return}
            
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)){
                showColors.toggle()
                animateButton.toggle()
            }
            
            // Resetting the button...
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring()){
                    animateButton.toggle()
                }
            }
            
        } label: {
            
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.white)
                .scaleEffect(animateButton ? 1.1 : 1)
                .rotationEffect(.init(degrees: showColors ? 45 : 0))
                .padding(15)
                .background(Color.black)
                .clipShape(Circle())
        }
        .scaleEffect(animateButton ? 1.1 : 1)
        .padding(.top,30)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().body
    }
}

// Extending View to get Frame and getting device os Types...
extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
