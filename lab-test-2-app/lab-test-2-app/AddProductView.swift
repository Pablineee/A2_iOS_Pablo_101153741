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
                            .foregroundColor(.color2)
                                .fontWeight(.semibold)
                        TextField("e.g., 55\" 4K Television" , text: $productName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 2)
                            .padding(.bottom, 5)
                        Text("Description")
                                .foregroundColor(.color2)
                                .fontWeight(.semibold)
                        TextField("Detailed product description", text: $productDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 2)
                            .padding(.bottom, 5)
                        Text("Provider")
                                .foregroundColor(.color2)
                                .fontWeight(.semibold)
                        TextField("Manufacturer", text: $productProvider)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 2)
                            .padding(.bottom, 5)
                        Text("Price")
                                .foregroundColor(.color2)
                                .fontWeight(.semibold)
                        TextField("$", text: $productPrice)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 2)
                            .padding(.bottom, 5)
                        Image("productDefault")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    }
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Add Product")
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
                    }.padding(.top, -40)
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
