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
        NavigationView {
            Form {
                TextField("Product Name", text: $productName)
                TextField("Description", text: $productDescription)
                TextField("Provider", text: $productProvider)
                TextField("Price", text: $productPrice)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Product")
            .toolbar {
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
