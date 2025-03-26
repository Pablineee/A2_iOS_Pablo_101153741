//
//  AddProductView.swift
//  lab-test-2-app
//
//  Created by Pablo on 2025-03-26.
//

import SwiftUI

struct AddProductView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var productName = ""
    @State private var productDescription = ""
    @State private var productProvider = ""
    @State private var productPrice = ""
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Form {
                        Text("Product Name")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        TextField("e.g., 55\" 4K Television" , text: $productName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 5)
                            .padding(.bottom, 8)
                        Text("Description")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        TextField("Detailed product description", text: $productDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 5)
                            .padding(.bottom, 8)
                        Text("Provider")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        TextField("Manufacturer", text: $productProvider)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 5)
                            .padding(.bottom, 8)
                        Text("Price")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        TextField("$", text: $productPrice)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 5)
                            .padding(.bottom, 8)
                    }
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Add New Product")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(Color("Color1"))
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                addProduct()
                            }
                            .disabled(productName.isEmpty || productPrice.isEmpty)
                        }
                    }
                }
            }
        }
    }

    private func addProduct() {
        let product = Product(context: viewContext)
        product.productId = Int32.random(in: 1000000...9999999)
        product.productName = productName
        product.productDescription = productDescription
        product.productProvider = productProvider
        product.productPrice = Double(productPrice) ?? 0.0

        try? viewContext.save()
        dismiss()
    }
}
