//
//  ExportViewController.swift
//  Gradients
//
//  Created by David Deutsch on 12.11.20.
//

import UIKit

class ExportViewController: UIViewController {
    
    @IBOutlet var exportView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        // self.view is now a transparent view, so now I add newView to it and can size it however, I like.
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let heightOfSafeArea = window!.safeAreaInsets.bottom + window!.safeAreaInsets.top
        let halfHeightOfScreen = (UIScreen.main.bounds.height-heightOfSafeArea)/2
        
        let emptyView = UIView (frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: halfHeightOfScreen + heightOfSafeArea))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        emptyView.addGestureRecognizer(tap)
        view.addSubview(emptyView)
        
        //        view.addSubview(newView)
        
        //        let label: UILabel = UILabel()
        //        label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //        label.textColor = .white
        //        label.text = "test label"
        //        view.addSubview(label)
       
        let exportView = ExportView(frame:  CGRect(x: 0, y: halfHeightOfScreen + heightOfSafeArea/2, width: self.view.bounds.width, height: halfHeightOfScreen))
        exportView.cancelBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        exportView.arrowDownBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        
        view.addSubview(exportView)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
    }
}

