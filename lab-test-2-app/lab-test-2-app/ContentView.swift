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
    @State private var showingAddProduct = false
    @State private var searchText = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.productName, ascending: true)],
        animation: .default
    ) private var products: FetchedResults<Product>


    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return Array(products)
        } else {
            return products.filter {
                ($0.productName ?? "").localizedCaseInsensitiveContains(searchText) ||
                ($0.productDescription ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProducts) { product in
                    NavigationLink {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.productName ?? "Unnamed Product")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            Text(product.productDescription ?? "")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Text("SKU: " + String(product.productId))
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Text(product.productProvider ?? "")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Text(formatPrice(product.productPrice))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color("Color2"))
                        }

                    } label: {
                        Text(product.productName!)
                    }
                }
                .onDelete(perform: deleteProduct)
            }
            .searchable(text: $searchText, prompt: "Search products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { showingAddProduct = true }) {
                        Label("Add Product", systemImage: "plus")
                    }
                }
            }
            Text("Select a Product")
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView()
                .environment(\.managedObjectContext, viewContext)
        }

    }

    private func deleteProduct(offsets: IndexSet) {
        withAnimation {
            offsets.map { products[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func formatPrice(_ price: Double) -> String {
        String(format: "$%.2f", price)
    }
}
