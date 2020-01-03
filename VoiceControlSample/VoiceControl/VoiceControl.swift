//
//  VoiceControl.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit

@IBDesignable
public final class VoiceControl: UIControl {
    internal var clovaAgentView: VoiceAgentView?
    
    private func startSpeechRecognizer() {
        speechRecognizer = Jarvis()
        speechRecognizer?.delegate = self
        speechRecognizer?.start()
    }
    
    private func stopSpeechRecognizer() {
        speechRecognizer = nil
    }
    
    override public var inputAccessoryView: UIView? {
        return clovaAgentView
    }
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        if isFirstResponder {
            return false
        }
        
        clovaAgentView = UIView.makeFromNib(class: VoiceAgentView.self, owner: nil)
        
        let didBecomeFirstResponder = super.becomeFirstResponder()
        if didBecomeFirstResponder {
            imageView.alpha = 0.3
            clovaAgentView?.transcription = nil
            startSpeechRecognizer()
        }
        
        return didBecomeFirstResponder
    }
    
    @discardableResult override public func resignFirstResponder() -> Bool {
        imageView.alpha = 1.0
        clovaAgentView = nil
        stopSpeechRecognizer()
        return super.resignFirstResponder()
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitTest = super.hitTest(point, with: event)
        
        if hitTest == nil, isFirstResponder {
            resignFirstResponder()
        }
        
        return hitTest
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    override public func prepareForInterfaceBuilder() {
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.0862745098, blue: 0.09019607843, alpha: 0.98)
        
        let designTimeBundle = Bundle(for: VoiceControl.self)
        imageView.image = UIImage(named: "ic-mic", in: designTimeBundle, compatibleWith: traitCollection)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        addTarget(self, action: #selector(triggerVoiceControl), for: .touchUpInside)
    }

    @objc func triggerVoiceControl() {
        if isFirstResponder {
            resignFirstResponder()
        } else {
            becomeFirstResponder()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        layer.mask = circleLayer
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 72, height: 72)
    }
    
    private var speechRecognizer: Jarvis?
    private let imageView = UIImageView()
    private let circleLayer = CAShapeLayer()
}