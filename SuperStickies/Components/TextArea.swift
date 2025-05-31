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
            
            textArea.backgroundColor = NSColor(noteColour)
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
            
            textView.allowsImageEditing = true

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
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pboard = sender.draggingPasteboard
        if let files = pboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            for fileURL in files {
                let fileType = fileURL.pathExtension.lowercased()
                if let image = NSImage(contentsOf: fileURL),
                   ["jpg", "jpeg", "png", "gif", "bmp", "tiff", "heic", "gif"].contains(fileType) {
                    let attachment = NSTextAttachment()
                    attachment.image = image
                    let attrString = NSAttributedString(attachment: attachment)
                    let location = self.selectedRange().location
                    self.textStorage?.insert(attrString, at: location)
                    self.textStorage?.insert(NSAttributedString(string: "\n"), at: location + 1)
                    self.typingAttributes[.font] = NSFont.systemFont(ofSize: 14)
                    self.typingAttributes[.foregroundColor] = NSColor.black
                } else {
                    self.textStorage?.insert(NSAttributedString(string: fileURL.path), at: self.selectedRange().location)
                }
            }
            self.didChangeText()
            return true
        }
        return super.performDragOperation(sender)
    }
    
    override func didChangeText() {
        super.didChangeText()
        (delegate as? TextArea.Coordinator)?.textDidChange(Notification(name: NSText.didChangeNotification, object: self))
    }
    
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
        case "=":
            adjustFontSize(by: 2)
        case "-":
            adjustFontSize(by: -2)
        default:
            super.keyDown(with: event)
        }
    }

    private func toggleFontTrait(trait: NSFontTraitMask) {
        let fontManager = NSFontManager.shared

        func toggledFont(from originalFont: NSFont) -> NSFont {
            let familyName = originalFont.familyName ?? "Helvetica"
            let baseFont = fontManager.font(
                withFamily: familyName,
                traits: [],
                weight: 5,
                size: originalFont.pointSize
            ) ?? NSFont.systemFont(ofSize: originalFont.pointSize)

            let existingTraits = fontManager.traits(of: originalFont)
            let newTraits = existingTraits.symmetricDifference(trait)

            return fontManager.font(
                withFamily: familyName,
                traits: newTraits,
                weight: 5,
                size: baseFont.pointSize
            ) ?? baseFont
        }

        if selectedRange.length > 0 {
            let range = selectedRange
            textStorage?.enumerateAttribute(.font, in: range) { value, subRange, _ in
                guard let originalFont = value as? NSFont else { return }
                let font = toggledFont(from: originalFont)
                textStorage?.addAttribute(.font, value: font, range: subRange)
            }
        } else {
            let rawFont = typingAttributes[.font] as? NSFont ?? NSFont.systemFont(ofSize: 14)
            let font = toggledFont(from: rawFont)
            typingAttributes[.font] = font
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
    
    private func adjustFontSize(by delta: CGFloat) {
        if selectedRange.length > 0 {
            let range = selectedRange
            textStorage?.enumerateAttribute(.font, in: range) { value, subRange, _ in
                guard let font = value as? NSFont else { return }
                let newSize = max(font.pointSize + delta, 1)
                let newFont = NSFontManager.shared.convert(font, toSize: newSize)
                textStorage?.addAttribute(.font, value: newFont, range: subRange)
            }
        } else {
            let rawFont = typingAttributes[.font] as? NSFont ?? NSFont.systemFont(ofSize: 14)
            let newSize = max(rawFont.pointSize + delta, 1)
            let newFont = NSFontManager.shared.convert(rawFont, toSize: newSize)
            typingAttributes[.font] = newFont
        }
    }
}
