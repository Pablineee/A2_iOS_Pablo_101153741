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
            LinearGradient(
                gradient: Gradient(colors: [.white, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            List {
                ForEach(filteredProducts) { product in
                    NavigationLink {
                        LinearGradient(
                            gradient: Gradient(colors: [.white, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        VStack(alignment: .leading, spacing: 4) {
                            Image("productDefault")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .frame(maxWidth: .infinity)
                                .clipped()
                            Text(product.productName ?? "Unnamed Product")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .padding(.top, 150)
                                .foregroundColor(.color2)
                            Text(product.productDescription ?? "")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                            Text("SKU: " + String(product.productId))
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                            Text(product.productProvider ?? "")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.gray)
                            Text(formatPrice(product.productPrice))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.color2)
                        }
                        .padding(40)

                    } label: {
                        Text(product.productName!)
                    }
                    .navigationBarBackButtonHidden(true) // Hide 'Back' button in navigation bar
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
        .background(.color1)
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
