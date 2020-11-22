//
//  CreateViewController.swift
//  Gradients
//
//  Created by David Deutsch on 10.11.20.
//

import UIKit
import SwipeCellKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exportButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var colorsTableView: UITableView!
    @IBOutlet weak var directionButton: UIButton!
    
    @IBOutlet weak var noColorExistsLabel: UILabel!
    
    var currentGradient = Gradient(
        direction: Direction.TOPTOBOTTOM,
        colors: ["#ff6f00","#ffdd00"].map({ColorHelper.hexStringToUIColor(hex: $0)}))
    
    var gradientLayer = CAGradientLayer()
    
    var currentColorListItemSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        updateGradientView()
        setUpColorsTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colorsTableView.setShade()
    }
    
    func setUpColorsTableView(){
        colorsTableView.register(UINib(nibName: "ColorCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        colorsTableView.register(UINib(nibName: "AddNewColorCell", bundle: nil), forCellReuseIdentifier: "AddNewColorReusableCell")
        
        let topInset: CGFloat = 10.0 //change this value as needed
        colorsTableView.contentInset =  UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        colorsTableView.dataSource = self
        colorsTableView.delegate = self
    }
    
    func setStyle(){
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 35)
        exportButton.titleLabel!.font = UIFont(name: "Montserrat-Bold", size: 25)
        exportButton.layer.cornerRadius = 8
        
        colorsTableView.backgroundColor = UIColor.clear
        
        noColorExistsLabel.font = UIFont(name: "Montserrat-Bold", size: 15)
        
        directionButton.titleLabel!.font = UIFont(name: "Montserrat-Bold", size: 20)
        directionButton.layer.cornerRadius = 8
        directionButton.setImage(currentGradient.direction.arrowImage(), for: .normal)
    }
    
    // Rotate the gradientView to the next direction
    func updateDirection(){
        //        1. Check current Direction and go forward to the next one
        switch currentGradient.direction {
        case .TOPTOBOTTOM:
            currentGradient.direction = .TOPLEFTTOBOTTOMRIGHT
        case .TOPLEFTTOBOTTOMRIGHT:
            currentGradient.direction = .LEFTTORIGHT
        case .LEFTTORIGHT:
            currentGradient.direction = .BOTTOMLEFTTOTOPRIGHT
        case .BOTTOMLEFTTOTOPRIGHT:
            currentGradient.direction = .TOPTOBOTTOM
        }
        
        //        2. Update button icon
        directionButton.setImage(currentGradient.direction.arrowImage(), for: .normal)
        
        //        3. Update the gradientView with the new direction
        updateGradientView()
    }
    
    override func viewDidLayoutSubviews() {
        //Set the size of gradientView after the autolayout has been performed
        gradientLayer.frame = gradientView.bounds
    }
    
    // Open the export-Popup Menu to export the current gradientView
    @IBAction func exportBtnClicked(_ sender: UIButton) {
        showExportView()
    }
    
    let exportSlideVC = ExportSlideViewController()
    
    func showExportView(){
        exportSlideVC.modalPresentationStyle = .custom
        exportSlideVC.transitioningDelegate = self
        
        exportSlideVC.gradient = currentGradient
        self.present(exportSlideVC, animated: true, completion: nil)
    }
    
    @IBAction func directionBtnClicked(_ sender: UIButton) {
        updateDirection()
    }
    
    func updateGradientView(){
        self.colorsTableView.reloadData()
        
        if gradientLayer.cornerRadius != 8 {
            gradientView.layer.addSublayer(gradientLayer)
        }
        
        noColorExistsLabel.isHidden = (currentGradient.colors.count == 0) ? false : true
        directionButton.isHidden = (currentGradient.colors.count == 0) ? true : false
        
        gradientLayer.frame = CGRect(x: gradientView.frame.origin.x, y: gradientView.frame.origin.y, width: gradientView.frame.width, height: gradientView.frame.width)
        
        if currentGradient.colors.count == 1 {
            let singleColor = currentGradient.colors[0].cgColor
            gradientLayer.colors = [singleColor, singleColor]
        } else {
            gradientLayer.colors = currentGradient.colors.map({$0.cgColor})
        }
        
        gradientLayer.startPoint = currentGradient.direction.startPoint()
        gradientLayer.endPoint = currentGradient.direction.endPoint()
        gradientLayer.cornerRadius = 8
    }
}

extension CreateViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentGradient.colors.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
//
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//            return index
//        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section <= (currentGradient.colors.count - 1){
            let cell = colorsTableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ColorCell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeCell") as! SwipeTableViewCell
            
            cell.numberLabel.text = "\(indexPath.section + 1)"
            cell.tapToEditView.backgroundColor = currentGradient.colors[indexPath.section]
            cell.delegate = self
            return cell
            
        } else {
            return colorsTableView.dequeueReusableCell(withIdentifier: "AddNewColorReusableCell", for: indexPath) as! AddNewColorCell
        }
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return (indexPath.section < currentGradient.colors.count) ? true : false
//    }
    
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //        return UITableViewCell.EditingStyle.delete
    //    }
    //
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            currentGradient.colors.remove(at: indexPath.section)
    //            updateGradientView()
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .reveal
        return options
    }
    
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    ////        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
    ////                //TODO: Delete the row at indexPath here
    ////            self.currentGradient.colors.remove(at: indexPath.section)
    ////            self.updateGradientView()
    ////        }
    //
    //        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
    //                self.currentGradient.colors.remove(at: indexPath.section)
    //                self.updateGradientView()
    //                completion(true)
    //          }
    //
    //        deleteAction.backgroundColor = .clear
    //        deleteAction.image = UIImage(systemName: "trash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .medium))!.withTintColor(.white, renderingMode: .alwaysOriginal)
    //
    //        return UISwipeActionsConfiguration(actions: [deleteAction])
    //    }
}

//MARK: - SwipeTableViewCellDelegate
extension CreateViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.currentGradient.colors.remove(at: indexPath.section)
            self.updateGradientView()
        }
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.title = .none
        
        // customize the action appearance
        deleteAction.backgroundColor = .clear
        
        deleteAction.image = UIImage(systemName: "trash.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .medium))!.withTintColor(.red, renderingMode: .alwaysOriginal)
//        deleteAction.image = UIImage(systemName: "trash.circle.fill")!.withTintColor(.red, renderingMode: .alwaysOriginal)
        
        
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        
        return [deleteAction]
    }
}

extension CreateViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentColorListItemSelected = indexPath.section
        let colorCount = currentGradient.colors.count
        
        if currentColorListItemSelected < colorCount {
            // Edit only color -> Send current color to colorpicker
            let currentColor = currentGradient.colors[indexPath.section]
            openColorPicker(color: currentColor)
            
        } else if currentColorListItemSelected == colorCount {
            // new color -> Dont use to send a color to colorpicker
            openColorPicker(color: nil)
        }
    }
    
    
    func openColorPicker(color: UIColor?){
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        picker.delegate = self
        picker.view.backgroundColor = UIColor(named: "Background")
        
        if let color = color {
            picker.title = "Select New Color"
            picker.selectedColor = color
        } else {
            picker.title = "Add Color"
        }
        
        self.present(picker, animated: true, completion: nil)
    }
}

extension CreateViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension CreateViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let colorCount = currentGradient.colors.count
        let color = viewController.selectedColor
        
        // edit one color
        if currentColorListItemSelected < colorCount {
            currentGradient.colors[currentColorListItemSelected] = color
        }
        // add new color
        else if currentColorListItemSelected == colorCount {
            currentGradient.colors.append(color)
        }
        
        updateGradientView()
    }
}

extension UIImageView {

   func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
   }
}

extension UITableView {
    func setShade(){
        let gradient = CAGradientLayer()

        if let superview = superview {
            gradient.frame = superview.bounds
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
            gradient.locations = [0.0, 0.1, 0.9, 1.0]
            
            superview.layer.mask = gradient
        }
        backgroundColor = UIColor.clear
    }
}

extension UIColor {
        func toHexString() -> String {
            var r:CGFloat = 0
            var g:CGFloat = 0
            var b:CGFloat = 0
            var a:CGFloat = 0

            getRed(&r, green: &g, blue: &b, alpha: &a)

            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

            return String(format:"#%06x", rgb)
        }
    }
