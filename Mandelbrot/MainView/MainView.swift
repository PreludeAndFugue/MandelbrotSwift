//
//  MainView.swift
//  Mandelbrot
//
//  Created by gary on 09/06/2021.
//  Copyright © 2021 Gary Kerr. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Picker("Colours", selection: $viewModel.colourSelection) {
                    ForEach(0..<viewModel.colourMaps.count) { i in
                        HStack {
                            viewModel.previewImage(for: viewModel.colourMaps[i])
                            Text(viewModel.colourMaps[i].title)
                        }
                        .tag(i)
                    }
                }
                .onChange(of: viewModel.colourSelection, perform: { _ in viewModel.draw() })
                .pickerStyle(MenuPickerStyle())
                .labelsHidden()

                Button(action: viewModel.reset) {
                    Text("Reset")
                }

                Button(action: viewModel.save) {
                    Text("Save")
                }

                Spacer()

                Text("dx: 1")

                Text("dy: 2")

                Text("iterations: 1000")
            }
            .frame(minWidth: 100)

            ZStack {
                Image(nsImage: viewModel.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: viewModel.viewWidth, height: viewModel.viewHeight)
                    .background(Color.black)
                    .cornerRadius(8)
                    .gesture(makeGesture())

                ProgressView(viewModel.progress)
                    .frame(width: 250, height: 5)
                    .padding()
                    .background(Color.init(.sRGB, white: 1, opacity: 0.25))
                    .cornerRadius(8)
                    .opacity(viewModel.isInProgress ? 1 : 0)
                    .progressViewStyle(MyProgressViewStyle())
            }
        }
        .padding()
        .onAppear() {
            viewModel.onAppear()
        }
        .fileExporter(
            isPresented: $viewModel.isSaving,
            document: viewModel.imageFile,
            contentType: .jpeg,
            defaultFilename: "mandelbrot.jpg",
            onCompletion: { _ in }
        )
    }


    func makeGesture() -> _EndedGesture<DragGesture> {
        let gesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
        let x = gesture.onEnded() { value in
            viewModel.select(location: value.location)
        }
        return x
    }
}


#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
//            .previewLayout(.fixed(width: 800.0, height: 800.0))
    }
}
#endif
