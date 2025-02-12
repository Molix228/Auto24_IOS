import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    var placeholder: String
    var isSecuredField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text(title)
                .foregroundStyle(.blue)
                .fontWeight(.medium)
                .font(.title3)
            
            if isSecuredField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 18))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 18))
            }
            
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email", placeholder: "example@mail.com")
}
