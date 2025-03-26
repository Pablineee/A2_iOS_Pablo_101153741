//
//  ContentView.swift
//  lab-test-2-app
//
//  Created by Pablo on 2025-03-26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.productName, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>

    var body: some View {
        NavigationView {
            List {
                ForEach(products) { product in
                    NavigationLink {
                        Text("Product at \(product.productName!)")
                    } label: {
                        Text(product.productName!)
                    }
                }
                // .onDelete(perform: deleteProduct)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addProduct) {
                        Label("Add Product", systemImage: "plus")
                    }
                }
            }
            Text("Select a Product")
        }
    }

    private func addProduct() {
        withAnimation {
            let newProduct = Product(context: viewContext)
            newProduct.productId = Int32.random(in: 100...999)
            newProduct.productName = "Product Name"
            newProduct.productDescription = "Product Description"
            newProduct.productPrice = 9.99
            newProduct.productProvider = "Product Provider"

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

//    private func deleteProduct(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}
