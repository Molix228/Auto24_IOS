//
//  CustomTabView.swift
//  Auto24_iOS
//
//  Created by Александр Меслюк on 27.10.2024.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabBarItems: [(image: String, title: String)] = [
        ("house.fill", "Home"),
        ("magnifyingglass", "Search"),
        ("heart.fill", "Favourites"),
        ("person.fill", "Account"),
        ("bell.fill", "Notifications"),
    ]
    
    var body: some View {
        ZStack{
            Capsule()
                .frame(height: 80)
                .foregroundStyle(Color(.secondarySystemBackground))
                .shadow(radius: 2)
            
            HStack {
                ForEach(0..<5) { index in
                    Button {
                        tabSelection = index + 1
                    } label: {
                        VStack(spacing: 8){
                            Spacer()
                            
                            
                            
                            if index + 1 == tabSelection {
                                Image(systemName: tabBarItems[index].image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                Text(tabBarItems[index].title)
                                Capsule()
                                    .frame(height: 8)
                                    .foregroundStyle(.blue)
                                    .matchedGeometryEffect(id: "SelectedTabId", in: animationNamespace)
                                    .offset(y: 1)
                            } else {
                                Image(systemName: tabBarItems[index].image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .padding(.bottom)
                                Capsule()
                                    .frame(height: 8)
                                    .foregroundStyle(Color.clear)
                                    .offset(y: 3)
                            }
                        }
                        .foregroundStyle(index + 1 == tabSelection ? .blue : .gray)
                    }
                }
            }
            .frame(height: 80)
            .clipShape(.capsule)
        }
        .padding(.horizontal)
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(tabSelection: .constant(1))
            .previewLayout(.sizeThatFits)
            .padding(.vertical)
    }
}
