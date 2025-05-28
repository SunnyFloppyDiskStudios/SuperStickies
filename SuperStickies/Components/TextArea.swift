//
//  TextArea.swift
//  SuperStickies
//
//  Created by SunnyFlops on 27/05/2025.
//
//  Referenced from https://stackoverflow.com/a/63761738/18855905

import Foundation
import SwiftUI

struct TextArea: NSViewRepresentable {
    @Binding var text: String
    var noteColour: Color

    func makeNSView(context: Context) -> NSScrollView {
        context.coordinator.createTextViewStack(noteColour: noteColour)
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textArea = nsView.documentView as? NSTextView {
            if textArea.string != self.text {
                textArea.string = self.text
            }
            textArea.backgroundColor = NSColor(noteColour)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        fileprivate lazy var textStorage = NSTextStorage()
        fileprivate lazy var layoutManager = NSLayoutManager()
        fileprivate lazy var textContainer = NSTextContainer()
        fileprivate lazy var textView: NSTextView = NSTextView(frame: CGRect(), textContainer: textContainer)
        fileprivate lazy var scrollview = NSScrollView()

        func createTextViewStack(noteColour: Color) -> NSScrollView {
            let contentSize = scrollview.contentSize

            textContainer.containerSize = CGSize(width: contentSize.width, height: CGFloat.greatestFiniteMagnitude)
            textContainer.widthTracksTextView = true

            textView.minSize = CGSize(width: 0, height: 0)
            textView.maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            textView.isVerticallyResizable = true
            textView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
            textView.autoresizingMask = [.width]
            textView.delegate = self

            textView.backgroundColor = NSColor(noteColour)
            textView.textColor = .black
            textView.font = .systemFont(ofSize: 14)

            scrollview.borderType = .noBorder
            scrollview.hasVerticalScroller = false
            scrollview.documentView = textView

            textStorage.addLayoutManager(layoutManager)
            layoutManager.addTextContainer(textContainer)

            return scrollview
        }
    }
}

