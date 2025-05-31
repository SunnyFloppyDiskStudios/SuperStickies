//
//  TextArea.swift
//  SuperStickies
//
//  Created by SunnyFlops on 27/05/2025.
//

import Foundation
import SwiftUI

struct TextArea: NSViewRepresentable {
    @Binding var attributedText: NSAttributedString
    var noteColour: Color

    func makeCoordinator() -> Coordinator {
        Coordinator(attributedText: $attributedText, noteColour: noteColour)
    }

    func makeNSView(context: Context) -> NSScrollView {
        context.coordinator.createTextViewStack()
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textArea = nsView.documentView as? NSTextView {
            if textArea.attributedString() != self.attributedText {
                textArea.textStorage?.setAttributedString(self.attributedText)
            }
        }
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var attributedText: Binding<NSAttributedString>
        var noteColour: Color

        init(attributedText: Binding<NSAttributedString>, noteColour: Color) {
            self.attributedText = attributedText
            self.noteColour = noteColour
        }

        fileprivate lazy var textStorage = NSTextStorage()
        fileprivate lazy var layoutManager = NSLayoutManager()
        fileprivate lazy var textContainer = NSTextContainer()
        fileprivate lazy var textView: RichTextView = RichTextView(frame: .zero, textContainer: textContainer)
        fileprivate lazy var scrollview = NSScrollView()

        func createTextViewStack() -> NSScrollView {
            let contentSize = scrollview.contentSize

            textContainer.containerSize = CGSize(width: contentSize.width, height: .greatestFiniteMagnitude)
            textContainer.widthTracksTextView = true

            textView.minSize = CGSize(width: 0, height: 0)
            textView.maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
            textView.isVerticallyResizable = true
            textView.autoresizingMask = [.width]
            textView.delegate = self
            textView.font = .systemFont(ofSize: 14)
            textView.textColor = .black
            textView.backgroundColor = NSColor(noteColour)
            textView.isRichText = true
            textView.usesRuler = false

            scrollview.borderType = .noBorder
            scrollview.hasVerticalScroller = false
            scrollview.documentView = textView

            textStorage.addLayoutManager(layoutManager)
            layoutManager.addTextContainer(textContainer)

            DispatchQueue.main.async {
                self.textView.window?.makeFirstResponder(self.textView)
            }

            return scrollview
        }

        func textDidChange(_ notification: Notification) {
            self.attributedText.wrappedValue = textView.attributedString()
        }
    }
}

class RichTextView: NSTextView {
    override func keyDown(with event: NSEvent) {
        guard event.modifierFlags.contains(.command),
              let key = event.charactersIgnoringModifiers?.lowercased()
        else {
            super.keyDown(with: event)
            return
        }

        switch key {
        case "b":
            toggleFontTrait(trait: .boldFontMask)
        case "i":
            toggleFontTrait(trait: .italicFontMask)
        case "u":
            toggleUnderline()
        case "s":
            toggleStrikethrough()
        default:
            super.keyDown(with: event)
        }
    }

    private func toggleFontTrait(trait: NSFontTraitMask) {
        let fontManager = NSFontManager.shared

        if selectedRange.length > 0 {
            let range = selectedRange
            textStorage?.enumerateAttribute(.font, in: range) { value, subRange, _ in
                guard let font = value as? NSFont else { return }

                let hasTrait = fontManager.traits(of: font).contains(trait)
                let newFont = hasTrait
                    ? fontManager.convert(font, toNotHaveTrait: trait)
                    : fontManager.convert(font, toHaveTrait: trait)

                textStorage?.addAttribute(.font, value: newFont, range: subRange)
            }
        } else {
            let currentFont = typingAttributes[.font] as? NSFont ?? NSFont.systemFont(ofSize: 14)
            let hasTrait = fontManager.traits(of: currentFont).contains(trait)
            let newFont = hasTrait
                ? fontManager.convert(currentFont, toNotHaveTrait: trait)
                : fontManager.convert(currentFont, toHaveTrait: trait)

            typingAttributes[.font] = newFont
        }
    }


    private func toggleUnderline() {
        let key: NSAttributedString.Key = .underlineStyle
        if selectedRange.length > 0 {
            let range = selectedRange
            let current = textStorage?.attribute(key, at: range.location, effectiveRange: nil) as? Int ?? 0
            let newStyle = current == 0 ? NSUnderlineStyle.single.rawValue : 0
            textStorage?.addAttribute(key, value: newStyle, range: range)
        } else {
            let current = typingAttributes[key] as? Int ?? 0
            let newStyle = current == 0 ? NSUnderlineStyle.single.rawValue : 0
            typingAttributes[key] = newStyle
        }
    }

    private func toggleStrikethrough() {
        let key: NSAttributedString.Key = .strikethroughStyle
        if selectedRange.length > 0 {
            let range = selectedRange
            let current = textStorage?.attribute(key, at: range.location, effectiveRange: nil) as? Int ?? 0
            let newStyle = current == 0 ? NSUnderlineStyle.single.rawValue : 0
            textStorage?.addAttribute(key, value: newStyle, range: range)
        } else {
            let current = typingAttributes[key] as? Int ?? 0
            let newStyle = current == 0 ? NSUnderlineStyle.single.rawValue : 0
            typingAttributes[key] = newStyle
        }
    }
}
