//
//  TKPieProgressView.swift
//  TKitDemoInSwift
//
//  Created by 王薰怡 on 16/8/1.
//  Copyright © 2016年 王薰怡. All rights reserved.
//

import UIKit

@IBDesignable
class TKPieProgressView: UIView, TKColorable, TKStrokable {
    //MARK: - Variables
    /**
     *  The line width of the border ouside pie progress.
     */
    var lineWidth: CGFloat = 1.0 {
        didSet {
            updatePieView()
        }
    }
    
    /**
     *  The radius of pie progress view.
     */
    @IBInspectable
    var pieRadius: CGFloat = 15.0 {
        didSet {
            self.bounds.size = CGSize(width: pieRadius * 2, height: pieRadius * 2)
            updatePieView()
        }
    }
    
    /**
     *  The inner pie view with dark color, will be smaller then the pie progress view. The inner pie view radius = pieRadius - pieInset.
     */
    @IBInspectable
    var pieInset: CGFloat = 3.0  {
        didSet {
            updatePieView()
        }
    }
    
    /**
     *  The prgress color, default is white color.
     */
    @IBInspectable
    var color: UIColor! = UIColor.white.withAlphaComponent(0.75) {
        didSet {
            updatePieView()
        }
    }
    
    /**
     *  The boolean value that determine the progress view with 1.0 progress will be hide or not.
     */
    @IBInspectable
    var hidesWhenFinished: Bool = true
    
    /**
     *  The border layer of the pie progress view
     */
    fileprivate lazy var borderLayer: CAShapeLayer = { [unowned self] in
        let lazyBorderLayer = CAShapeLayer()
        lazyBorderLayer.path = UIBezierPath.init(roundedRect: CGRect(x: self.lineWidth/2, y: self.lineWidth/2, width: self.bounds.width - self.lineWidth, height: self.bounds.height - self.lineWidth), cornerRadius: CGFloat(self.pieRadius) - self.lineWidth/2).cgPath
        lazyBorderLayer.lineWidth = self.lineWidth
        lazyBorderLayer.lineCap = CAShapeLayerLineCap.round
        lazyBorderLayer.lineJoin = CAShapeLayerLineJoin.round
        lazyBorderLayer.strokeColor = self.color.cgColor
        lazyBorderLayer.fillColor = UIColor.clear.cgColor
        lazyBorderLayer.strokeStart = 0
        lazyBorderLayer.strokeEnd = 1
        return lazyBorderLayer
    }()
    
    /**
     *  The pie layer of the pie progress view
     */
    fileprivate lazy var pieLayer: CAShapeLayer = { [unowned self] in
        let innerPieRadius: CGFloat = (self.pieRadius - self.lineWidth/2 - self.pieInset)/2
        let lazyPieLayer = CAShapeLayer()
        lazyPieLayer.path = UIBezierPath(roundedRect: CGRect(x: self.lineWidth/2 + self.pieInset + innerPieRadius, y: self.lineWidth/2 + self.pieInset + innerPieRadius, width: innerPieRadius * 2, height: innerPieRadius * 2), cornerRadius: innerPieRadius).cgPath
        lazyPieLayer.lineWidth = innerPieRadius * 2
        lazyPieLayer.lineCap = CAShapeLayerLineCap.butt
        lazyPieLayer.lineJoin = CAShapeLayerLineJoin.round
        lazyPieLayer.strokeColor = self.color.cgColor
        lazyPieLayer.fillColor = UIColor.clear.cgColor
        lazyPieLayer.strokeStart = 0
        lazyPieLayer.strokeEnd = 0
        return lazyPieLayer
    }()
    
    /**
     *  The float value of total progress, value is in [0.0, 1.0].
     */
    fileprivate(set) var progress: Double = 0.0;
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(borderLayer)
        layer.addSublayer(pieLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(borderLayer)
        layer.addSublayer(pieLayer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.addSublayer(borderLayer)
        layer.addSublayer(pieLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    deinit {
        print("TKPieProgressView is deinit")
    }
    
    //MARK: - Methods
    /**
     *  To set the progress view progress with animation, if progress is equal to 1.0, it will hide depends on the property 'hidesWhenFinished'.
     *  @param progress The destinate progress that will be setted with animation.
     */
    func setProgressWithAnimation(_ progress:Double) {
        self.isHidden = false
        self.pieLayer.strokeStart = 0
        self.pieLayer.strokeEnd = CGFloat(progress)
        self.progress = progress;
        
        if self.progress >= 1.0 {
            let time: TimeInterval = 0.3
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                if self.hidesWhenFinished {
                    self.isHidden = true
                }
                self.pieLayer.strokeEnd = 0
                self.progress = 0
            }
        }
    }
    
    fileprivate func updatePieView() {
        borderLayer.path = UIBezierPath(roundedRect: CGRect(x: lineWidth/2, y: lineWidth/2, width: self.bounds.width - lineWidth, height: self.bounds.height - lineWidth), cornerRadius: pieRadius - lineWidth/2).cgPath
        borderLayer.lineWidth = lineWidth
        borderLayer.strokeColor = color.cgColor
        
        let innerPieRadius: CGFloat = (pieRadius - lineWidth/2 - pieInset)/2
        self.pieLayer.path = UIBezierPath(roundedRect: CGRect(x: lineWidth/2 + pieInset + innerPieRadius, y: lineWidth/2 + pieInset + innerPieRadius, width: innerPieRadius * 2, height: innerPieRadius * 2), cornerRadius: innerPieRadius).cgPath
        self.pieLayer.lineWidth = innerPieRadius * 2
        self.pieLayer.strokeColor = self.color.cgColor
    }
}
