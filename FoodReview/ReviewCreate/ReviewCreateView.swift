//
//  ReviewCreateView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/14/26.
//

import SwiftUI

struct ReviewCreateView: View {
    let image: UIImage
    @Bindable var session: ReviewCreationSession
    
    @State private var isSheetPresented: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    var scrollProxy: ScrollViewProxy
    
    
    var body: some View {
        Spacer()
        
        Button(action: {
            isSheetPresented = true
        }) {
            HStack {
                if let menu = session.selectedMenu,
                   let restaurant = session.selectedRestaurant {
                    HStack{
                        if let data = Data(base64Encoded: restaurant.imageData), let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.secondary.opacity(0.2))
                                .frame(width: 36, height: 36)
                                .overlay {
                                    Image(systemName: "fork.knife")
                                        .foregroundColor(.secondary)
                                }
                        }
                        Text(restaurant.name).font(.system(size: 18))
                    }
                    .foregroundStyle(Color(.label))
                    Spacer()
                    Text(menu.name)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color(.label))
                } else {
                    Text(session.selectedMenu?.name ?? "메뉴 선택")
                        .foregroundColor(session.selectedMenu == nil ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(.systemBackground))
            )
        }
        .sheet(isPresented: $isSheetPresented) {
            RestaurantPickerView(
                selectedMenu: $session.selectedMenu,
                selectedRestaurant: $session.selectedRestaurant
            )
        }
        
        Spacer()
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
            )
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        VStack {
            StarRatingView(label: "맛", rating: $session.tasteRating)
            Divider()
            StarRatingView(label: "양", rating:  $session.amountRating)
            Divider()
            StarRatingView(label: "가격", rating:  $session.priceRating )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemBackground))
        )
        Spacer()
        TextField("자세한 내용을 적어주세요", text: $session.reviewText)
            .focused($isTextFieldFocused)
            .onChange(of: isTextFieldFocused) { newValue, _ in
                DispatchQueue.main.async {
                    withAnimation {
                        scrollProxy.scrollTo("bottomID", anchor: .bottom)
                    }
                }
            }
            .onChange(of: session.reviewText) { _, newValue in
                if newValue.count > 200 {
                    session.reviewText = String(newValue.prefix(200))
                }
            }
            .fontWeight(.regular)
            .padding()
            .frame(minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(.tertiarySystemBackground))
            )
        
        Spacer()
    }
}

struct StarRatingView: View {
    let label: String
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .foregroundColor(index <= rating ? .yellow : .gray)
                        .font(.system(size: 18))
                        .onTapGesture {
                            rating = index
                        }
                }
            }
        }
    }
}


#Preview {
    if let image = UIImage(systemName: "star") {
        ScrollViewReader { proxy in
            ReviewCreateView(image: image, session: ReviewCreationSession(), scrollProxy: proxy)
        }
    }
}
