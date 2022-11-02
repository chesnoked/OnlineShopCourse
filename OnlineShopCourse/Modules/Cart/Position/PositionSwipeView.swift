//
//  PositionView.swift
//  OnlineShopCourse
//
//  Created by Evgeniy Safin on 25.10.2022.
//

//struct PositionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PositionView()
//    }
//}

import SwiftUI

struct PositionSwipeView: View {
    @EnvironmentObject private var cartVM: CartViewModel
    @Binding var position: PositionModel
    @State private var offsetX: CGFloat = 0
    @State private var showMenu: Bool = false
    var body: some View {
        ZStack(alignment: .trailing) {
            // position view
            PositionView(position: $position)
                .offset(x: offsetX)
                .gesture(DragGesture()
                    .onEnded({ dragValue in
                        if dragValue.translation.width < -Settings.shared.positionWidth / 6 {
                            offsetX = -(UIScreen.main.bounds.width - Settings.shared.positionWidth) / 2
                            showMenu = true
                        } else if showMenu && dragValue.translation.width > 0 {
                            showMenu = false
                            offsetX = 0
                        }
                    })
                )
            // swipe menu
            if showMenu {
                swipeMenu
            }
        }
    }
    // swipe menu
    private var swipeMenu: some View {
        Button(action: {
            deletePosition()
        }, label: {
            Image(systemName: "xmark.app.fill")
                .font(.caption)
                .bold()
                .foregroundColor(Color.palette.child)
        })
        .frame(width: (UIScreen.main.bounds.width - Settings.shared.positionWidth) / 2)
        .frame(maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            deletePosition()
        }
    }
    // delete position
    private func deletePosition() {
        cartVM.positions.removeAll(where: { onePosition in position.id == onePosition.id })
    }
}

struct PositionView: View {
    @EnvironmentObject private var cartVM: CartViewModel
    @Binding var position: PositionModel
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // position image
            positionImage
            // product data
            VStack(alignment: .leading, spacing: 5) {
                // product category
                productCategory
                // product brand
                productBrand
                // product name
                productName
                // product cost
                productCost
            }
            .padding(.horizontal)
            Spacer()
            // position data
            VStack(alignment: .trailing, spacing: 5) {
                // product amount
                productAmount
                // position cost
                positionCost
                Spacer()
                // amount changer
                amountChanger
            }
        }
        .padding()
        .frame(width: Settings.shared.positionWidth, alignment: .leading)
        .background(Color.palette.child.cornerRadius(5))
    }
}

extension PositionView {
    // position image
    @ViewBuilder private var positionImage: some View {
        if let image = position.product.mainImage {
            Image(uiImage: image)
                .resizable()
                .frame(width: 50, height: 50)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke (
                            Color.palette.parent
                            ,
                            lineWidth: 0.55
                        )
                }
        }
    }
    // product category
    private var productCategory: some View {
        Text(position.product.category.rawValue)
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.parent)
    }
    // product brand
    private var productBrand: some View {
        Text(position.product.brand.rawValue)
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.parent)
    }
    // product name
    private var productName: some View {
        Text(position.product.name)
            .lineLimit(1)
            .font(.headline)
            .foregroundColor(Color.palette.parent)
    }
    // product cost
    private var productCost: some View {
        Text("\(position.product.cost.twoDecimalPlaces()) ₽")
            .font(.callout)
            .foregroundColor(Color.palette.parent)
    }
    // product amount
    private var productAmount: some View {
        Text("x\(position.amount)")
            .font(.caption)
            .bold()
            .foregroundColor(Color.palette.parent)
    }
    // position cost
    private var positionCost: some View {
        Text("\(position.cost.twoDecimalPlaces()) ₽")
            .font(.callout)
            .foregroundColor(Color.palette.parent)
    }
}

extension PositionView {
    // amount changer
    private var amountChanger: some View {
        HStack(spacing: 0) {
            // minus amount product
            minusAmount
            // plus amount product
            plusAmount
        }
        .frame(width: 60, height: 30)
        .background(Color.palette.parent.cornerRadius(5))
    }
    // minus product amount
    private var minusAmount: some View {
        Button(action: {
            changeProductAmount(changeMode: .minus)
        }, label: {
            Image(systemName: ChangeMode.minus.rawValue)
                .font(.caption)
                .bold()
                .foregroundColor(Color.palette.child)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            changeProductAmount(changeMode: .minus)
        }
    }
    // plus product amount
    private var plusAmount: some View {
        Button(action: {
            changeProductAmount(changeMode: .plus)
        }, label: {
            Image(systemName: ChangeMode.plus.rawValue)
                .font(.caption)
                .bold()
                .foregroundColor(Color.palette.child)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            changeProductAmount(changeMode: .plus)
        }
    }
    // change mode
    enum ChangeMode: String {
        case minus = "minus"
        case plus = "plus"
    }
    // change product amount
    private func changeProductAmount(changeMode: ChangeMode) {
        switch changeMode {
        case .minus:
            guard position.amount > 1 && position.amount <= 10 else { return }
            cartVM.positions[cartVM.getPositionIndex(position: position)].amount -= 1
        case .plus:
            guard position.amount >= 1 && position.amount < 10 else { return }
            cartVM.positions[cartVM.getPositionIndex(position: position)].amount += 1
        }
    }
}


