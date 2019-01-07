//
//  File.swift
//  UrbanEaterDriver
//
//  Created by Hexadots on 26/11/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

@objc public protocol SlideToOpenDelegate {
    func SlideToOpenDelegateDidFinish(_ slider:SlideToOpenView, switchStatus: Bool)
}

public class SlideToOpenView: UIView {
    // MARK: All Views
    public let textLabel: UILabel = {
        let label = UILabel.init()
        return label
    }()
    public let thumnailImageView: UIImageView = {
        let view = RoundImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = .center
        return view
    }()
    public let sliderHolderView: UIView = {
        let view = UIView()
        return view
    }()
    public let draggedView: UIView = {
        let view = UIView()
        return view
    }()
    public let view: UIView = {
        let view = UIView()
        return view
    }()
    // MARK: Public properties
    public weak var delegate: SlideToOpenDelegate?
    public var animationVelocity: Double = 0.2
    public var sliderViewTopDistance: CGFloat = 8.0 {
        didSet {
            topSliderConstraint?.constant = sliderViewTopDistance
            layoutIfNeeded()
        }
    }
    public var thumbnailViewLeadingDistance: CGFloat = 0.0 {
        didSet {
            updateThumbnailViewLeadingPosition(thumbnailViewLeadingDistance)
            layoutIfNeeded()
        }
    }
    public var textLabelLeadingDistance: CGFloat = 0 {
        didSet {
            leadingTextLabelConstraint?.constant = textLabelLeadingDistance
            layoutIfNeeded()
        }
    }
    public var isEnabled:Bool = true {
        didSet {
            animationChangedEnabledBlock?(isEnabled)
        }
    }
    public var animationChangedEnabledBlock:((Bool) -> Void)?
    // MARK: Default styles
    public var sliderCornerRadious: CGFloat = 30.0 {
        didSet {
            sliderHolderView.layer.cornerRadius = sliderCornerRadious
            draggedView.layer.cornerRadius = sliderCornerRadious
        }
    }
    public var defaultSliderBackgroundColor: UIColor = .restBGColor {
        didSet {
            sliderHolderView.backgroundColor = defaultSliderBackgroundColor
        }
    }
    
    public var defaultSlidingColor:UIColor = UIColor(red:25.0/255, green:155.0/255, blue:215.0/255, alpha:0.7) {
        didSet {
            draggedView.backgroundColor = defaultSlidingColor
        }
    }
    public var defaultThumbnailColor:UIColor = UIColor(red:25.0/255, green:155.0/255, blue:215.0/255, alpha:1) {
        didSet {
            thumnailImageView.backgroundColor = defaultSlidingColor
        }
    }
    public var defaultLabelText: String = "Swipe to open" {
        didSet {
            textLabel.text = defaultLabelText
        }
    }
    public var defaultLabelAttributeText: NSAttributedString = NSAttributedString(string: "Swipe to open") {
        didSet {
            textLabel.attributedText = defaultLabelAttributeText
        }
    }
    // MARK: Private Properties
    private var leadingThumbnailViewConstraint: NSLayoutConstraint?
    private var leadingTextLabelConstraint: NSLayoutConstraint?
    private var topSliderConstraint: NSLayoutConstraint?
    private var xPositionInThumbnailView: CGFloat = 0
    public var xEndingPoint: CGFloat = 0
    public var isFinished: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    private func setupView() {
        self.addSubview(view)
        view.addSubview(thumnailImageView)
        view.addSubview(sliderHolderView)
        view.addSubview(draggedView)
        sliderHolderView.addSubview(textLabel)
        view.bringSubview(toFront: self.thumnailImageView)
        setupConstraint()
        setStyle()
        // Add pan gesture
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        thumnailImageView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupConstraint() {
        view.translatesAutoresizingMaskIntoConstraints = false
        thumnailImageView.translatesAutoresizingMaskIntoConstraints = false
        sliderHolderView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        draggedView.translatesAutoresizingMaskIntoConstraints = false
        // Setup for view
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        // Setup for circle View
        leadingThumbnailViewConstraint = thumnailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        leadingThumbnailViewConstraint?.isActive = true
        thumnailImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        thumnailImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        thumnailImageView.heightAnchor.constraint(equalTo: thumnailImageView.widthAnchor).isActive = true
        // Setup for slider holder view
        topSliderConstraint = sliderHolderView.topAnchor.constraint(equalTo: view.topAnchor, constant: sliderViewTopDistance)
        topSliderConstraint?.isActive = true
        sliderHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sliderHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sliderHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Setup for textLabel
        textLabel.topAnchor.constraint(equalTo: sliderHolderView.topAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: sliderHolderView.centerYAnchor).isActive = true
        leadingTextLabelConstraint = textLabel.leadingAnchor.constraint(equalTo: sliderHolderView.leadingAnchor, constant: textLabelLeadingDistance)
        leadingTextLabelConstraint?.isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(-8)).isActive = true
        // Setup for Dragged View
        draggedView.leadingAnchor.constraint(equalTo: sliderHolderView.leadingAnchor).isActive = true
        draggedView.topAnchor.constraint(equalTo: sliderHolderView.topAnchor).isActive = true
        draggedView.bottomAnchor.constraint(equalTo: sliderHolderView.bottomAnchor).isActive = true
        draggedView.trailingAnchor.constraint(equalTo: thumnailImageView.trailingAnchor).isActive = true
    }
    
    private func setStyle() {
        thumnailImageView.backgroundColor = defaultThumbnailColor
        textLabel.text = defaultLabelText
        textLabel.font = UIFont.systemFont(ofSize: 15.0)
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        sliderHolderView.backgroundColor = defaultSliderBackgroundColor
        sliderHolderView.layer.cornerRadius = sliderCornerRadious
        draggedView.backgroundColor = defaultSlidingColor
        draggedView.layer.cornerRadius = sliderCornerRadious
        xEndingPoint = self.view.frame.maxX - thumnailImageView.bounds.height
    }
    
    private func isTapOnThumbnailViewWithPoint(_ point: CGPoint) -> Bool{
        return self.thumnailImageView.frame.contains(point)
    }
    
    public func updateThumbnailViewLeadingPosition(_ x: CGFloat) {
        leadingThumbnailViewConstraint?.constant = x
        layoutIfNeeded()
    }
    
    // MARK: Override methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        if thumnailImageView.bounds.height == 0 {
            xEndingPoint = self.view.frame.maxX - thumnailImageView.bounds.height
            return
        }
    }
    override public func updateConstraints() {
        super.updateConstraints()
        xEndingPoint = self.view.frame.maxX - thumnailImageView.bounds.height
    }
    
    // MARK: UIPanGestureRecognizer
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if isFinished || !isEnabled {
            self.swipeLeft(sender)
            return
        }
        self.swipeRight(sender)
    }
    
    public func swipeLeft(_ sender: UIPanGestureRecognizer){
        let translatedPoint = xEndingPoint + sender.translation(in: view).x
        switch sender.state {
        case .began:
            break
        case .changed:
            if translatedPoint >= xEndingPoint {
                updateThumbnailViewLeadingPosition(xEndingPoint)
                return
            }
            if translatedPoint <= thumbnailViewLeadingDistance {
                updateThumbnailViewLeadingPosition(thumbnailViewLeadingDistance)
                return
            }
            updateThumbnailViewLeadingPosition(translatedPoint)
            break
        case .ended:
            if translatedPoint >= xEndingPoint {
                updateThumbnailViewLeadingPosition(xEndingPoint)
                isFinished = false
                return
            }
            if translatedPoint <= thumbnailViewLeadingDistance {
                isFinished = false
                delegate?.SlideToOpenDelegateDidFinish(self, switchStatus: false)
                updateThumbnailViewLeadingPosition(thumbnailViewLeadingDistance)
                return
            }
            if translatedPoint > thumbnailViewLeadingDistance && translatedPoint < xEndingPoint{
                //textLabel.alpha = 0
                isFinished = true
                updateThumbnailViewLeadingPosition(xEndingPoint)
                return
            }
            UIView.animate(withDuration: animationVelocity) {
                self.leadingThumbnailViewConstraint?.constant = self.thumbnailViewLeadingDistance
                //self.textLabel.alpha = 1
                self.layoutIfNeeded()
            }
            break
        default:
            break
        }
    }
    
    public func swipeRight(_ sender: UIPanGestureRecognizer){
        let translatedPoint = sender.translation(in: view).x
        switch sender.state {
        case .began:
            break
        case .changed:
            if translatedPoint >= xEndingPoint {
                updateThumbnailViewLeadingPosition(xEndingPoint)
                return
            }
            if translatedPoint <= thumbnailViewLeadingDistance {
                //textLabel.alpha = 1
                updateThumbnailViewLeadingPosition(thumbnailViewLeadingDistance)
                return
            }
            updateThumbnailViewLeadingPosition(translatedPoint)
            //textLabel.alpha = (xEndingPoint - translatedPoint) / xEndingPoint
            break
        case .ended:
            if translatedPoint >= xEndingPoint {
                //textLabel.alpha = 0
                updateThumbnailViewLeadingPosition(xEndingPoint)
                // Finish action
                isFinished = true
                delegate?.SlideToOpenDelegateDidFinish(self, switchStatus: isEnabled)
                return
            }
            if translatedPoint <= thumbnailViewLeadingDistance {
                //textLabel.alpha = 1
                updateThumbnailViewLeadingPosition(thumbnailViewLeadingDistance)
                return
            }
            UIView.animate(withDuration: animationVelocity) {
                self.leadingThumbnailViewConstraint?.constant = self.thumbnailViewLeadingDistance
                //self.textLabel.alpha = 1
                self.layoutIfNeeded()
            }
            break
        default:
            break
        }
    }
    
    // Others
    public func resetStateWithAnimation(_ animated: Bool) {
        let action = {
            self.leadingThumbnailViewConstraint?.constant = 0
            self.textLabel.alpha = 1
            self.layoutIfNeeded()
            //
            self.isFinished = false
        }
        if animated {
            UIView.animate(withDuration: animationVelocity) {
                action()
            }
        } else {
            action()
        }
    }
}


class RoundImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
    }
}

