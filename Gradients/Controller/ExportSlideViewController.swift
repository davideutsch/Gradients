//
//  ExportSlideViewController.swift
//  Gradients
//
//  Created by David Deutsch on 19.11.20.
//

import UIKit

class ExportSlideViewController: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var exportBtn: UIButton!
    @IBOutlet weak var sizePickerView: UIPickerView!
    @IBOutlet weak var sliderIdicatorView: UIView!
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var gradient: Gradient?
    
    //Formate siehe: https://de.wikipedia.org/wiki/Bildauflösung    
    var exportSizes: [Int] = [120, 144, 160, 180, 192, 200, 240, 265, 320, 360]
    
    let imageSaver = ImageSaver()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        
        self.sizePickerView.delegate = self
        self.sizePickerView.dataSource = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
    }
    
    func setStyle(){
        cancelBtn.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 20)
        exportBtn.titleLabel!.font = UIFont(name: "Montserrat-Bold", size: 25)
        exportBtn.layer.cornerRadius = 8
        sliderIdicatorView.layer.cornerRadius = 2
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        
        //Not allowing the user to drag the view updward
        guard translation.y >= 0 else {return}
        
        //setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else{
                //Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    @IBAction func exportBtnClicked(_ sender: UIButton) {
        if gradient != nil {
            let gradientView : UIView = createGradientViewFromSelectedSizes()
            
            imageSaver.writeToPhotoAlbum(image: gradientView.asImage())
        }
        
        //dismiss on completion
        self.dismiss(animated: true, completion: nil)
    }
    
    func createGradientViewFromSelectedSizes() -> UIView {
        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: exportSizes[sizePickerView.selectedRow(inComponent: 0)], height: exportSizes[sizePickerView.selectedRow(inComponent: 2)]))
        let gradientLayer = CAGradientLayer()
        gradientView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: gradientView.frame.width, height: gradientView.frame.height)
        
        if gradient!.colors.count == 1 {
            let singleColor = UIColor(hexString: gradient!.colors[0])!.cgColor
            gradientLayer.colors = [singleColor, singleColor]
        } else {
            gradientLayer.colors = gradient!.colors.map({UIColor(hexString: $0)!.cgColor})
        }
       
        gradientLayer.startPoint = gradient!.direction.startPoint()
        gradientLayer.endPoint = gradient!.direction.endPoint()
        
        return gradientView
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ExportSlideViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 || component == 2 {
            return exportSizes.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 || component == 2 {
            return "\(exportSizes[row]) px"
        } else {
            return "x"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let width = pickerView.frame.size.width
        
        switch component {
        case 0:
            return 3 / 7.0 * width
        case 1:
            return 0.5 / 7.0 * width
        case 2:
            return 3 / 7.0 * width
        default:
            return 0.0 * width
        }
           
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

