//
//  ExportView.swift
//  Gradients
//
//  Created by David Deutsch on 16.11.20.
//

import UIKit

class ExportView: UIView {
    let cancelBtn = UIButton()
    let arrowDownBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    let exportBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    var typePickerView: UIPickerView = SizePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "Background")
        layer.cornerRadius = 20
        self.addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView() {
        cancelBtn.setTitleColor(UIColor(named: "TitleColor"), for: .normal)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 20)
        
        let arrowDownImage = UIImage(systemName: "chevron.compact.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium))?.withTintColor(UIColor(named: "TitleColor")!, renderingMode: .alwaysOriginal)
        arrowDownBtn.setImage(arrowDownImage, for: .normal)
        
        exportBtn.setTitle("EXPORT", for: .normal)
        exportBtn.titleLabel!.font = UIFont(name: "Montserrat-Bold", size: 25)
        exportBtn.setTitleColor(UIColor(named: "BigBtnFontColor"), for: .normal)
        exportBtn.backgroundColor  = UIColor(named: "BigBtnBackgroundColor")
        exportBtn.layer.cornerRadius = 8
        
        
        //        typePickerView.frame = (100, 100, 100, 162)
        typePickerView.backgroundColor = .clear
//        typePickerView.layer.borderColor = UIColor.white.cgColor
        
        [cancelBtn, arrowDownBtn, exportBtn, typePickerView].forEach { addSubview($0) }
        
        cancelBtn.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 5, left: 15, bottom: 0, right: 0))
        
        arrowDownBtn.translatesAutoresizingMaskIntoConstraints = false
        arrowDownBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        arrowDownBtn.centerView(to: self, x: true, y: false)
        arrowDownBtn.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        
        exportBtn.anchor(top: nil, leading: nil, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 25, right: 0), size: CGSize(width: (frame.size.width*2/3), height: 45))
        exportBtn.centerView(to: self, x: true, y: false)
        
        typePickerView.anchor(top: cancelBtn.bottomAnchor, leading: leadingAnchor, bottom: exportBtn.topAnchor, trailing: trailingAnchor, padding: .init(top: 15, left: 15, bottom: 15, right: 15))
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
    }
}

extension UIView {
    
    // call with:
    //1.    view. addSubview(redView)
    //    view.addSubview(blueView)
    //        or
    //    [redView, blueView].forEach { view.addSubview($0) }
    
    //2.    view.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 100, height: 100))
    
    //view.safeAreaLayoutGuide.bottomAnchor / topAnchor /...
    func anchor(top:NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero)  {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.width != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    //set the same size as the defined one
    //blueView.anchorSize(to: redView)
    func anchorSize(to view: UIView?, height: CGFloat?, width: CGFloat?){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let view = view {
            widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        } else {
            if let height = height {
                heightAnchor.constraint(equalToConstant: height).isActive = true
            }
            
            if let width = width {
                widthAnchor.constraint(equalToConstant: width).isActive = true
            }
        }
    }
    
    func fillSuperView() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func centerView(to view: UIView, x: Bool, y: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if x {
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        
        if y {
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
}

class SizePicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Formate siehe: https://de.wikipedia.org/wiki/Bildauflösung
//    var exportFormats: [ExportFormat] = [
//        ExportFormat(height: 160, width: 120),
//        ExportFormat(height: 160, width: 144),
//        ExportFormat(height: 160, width: 160),
//        ExportFormat(height: 240, width: 160),
//        ExportFormat(height: 240, width: 180),
//        ExportFormat(height: 265, width: 192),
//        ExportFormat(height: 400, width: 240),
//        ExportFormat(height: 320, width: 200),
//        ExportFormat(height: 320, width: 240),
//        ExportFormat(height: 360, width: 240)
//    ]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return exportFormats.count
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return "\(exportFormats[row].height) x \(exportFormats[row].width)"
        return "Test \(row)"
    }
    
    
}
