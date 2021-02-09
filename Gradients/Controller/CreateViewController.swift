//
//  CreateViewController.swift
//  Gradients
//
//  Created by David Deutsch on 10.11.20.
//

import UIKit
import SwipeCellKit
import StatusAlert

class CreateViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exportButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var colorsTableView: UITableView!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var saveGradientButton: UIButton!
    
    @IBOutlet weak var noColorExistsLabel: UILabel!
    
    var currentGradient = Gradient(
        direction: Direction.TOPTOBOTTOM,
        colors: ["#ff6f00","#ffdd00"])
    
    var gradientLayer = CAGradientLayer()
    
    var currentColorListItemSelected: Int = 0
    
    let vibrationGenerator = UIImpactFeedbackGenerator(style: .medium)
    
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
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized(_:)))
        colorsTableView.addGestureRecognizer(longpress)
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
        
        saveGradientButton.titleLabel!.font = UIFont(name: "Montserrat-Bold", size: 20)
        saveGradientButton.layer.cornerRadius = 8
        saveGradientButton.setImage(UIImage(systemName: "tray.and.arrow.down.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .medium))!.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: colorsTableView)
        let indexPath = colorsTableView.indexPathForRow(at: locationInView)
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = colorsTableView.cellForRow(at: indexPath!) as UITableViewCell?
                My.cellSnapshot  = snapshotOfCell(cell!)
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                colorsTableView.addSubview(My.cellSnapshot!)
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25) {
                                cell?.alpha = 1
                            }
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
        case UIGestureRecognizerState.changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                if let indexPath = indexPath {
                    if indexPath != Path.initialIndexPath {
                        if indexPath.section < currentGradient.colors.count{
                            self.currentGradient.colors.swapAt(Path.initialIndexPath!.section, indexPath.section)
                            Path.initialIndexPath = indexPath
                            
                            vibrationGenerator.impactOccurred()
                            
                            updateGradientView()
                        }
                    }
                }
            }
        default:
            if Path.initialIndexPath != nil {
                if let cell = colorsTableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell? {
                    if My.cellIsAnimating {
                        My.cellNeedToShow = true
                    } else {
                        cell.isHidden = false
                        cell.alpha = 0.0
                    }
                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
                        My.cellSnapshot!.center = (cell.center)
                        My.cellSnapshot!.transform = CGAffineTransform.identity
                        My.cellSnapshot!.alpha = 0.0
                        cell.alpha = 1.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            Path.initialIndexPath = nil
                            My.cellSnapshot!.removeFromSuperview()
                            My.cellSnapshot = nil
                        }
                    })
                }
            }
        }
        colorsTableView.reloadData()
    }
    
    func renewCurrentGradientID(){
        currentGradient = Gradient(direction: currentGradient.direction, colors: currentGradient.colors)
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        
        return cellSnapshot
    }
    
    // Rotate the gradientView to the next direction
    func updateDirection(){
        //renew the currentGradient object to seperate it from the databases
        renewCurrentGradientID()
        
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
        
        //        4. Let the device vibrate
        vibrationGenerator.impactOccurred()
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
    
    @IBAction func saveGradientBtnClicked(_ sender: UIButton) {
        //save gradient in database
        
        //check if gradient was already saved
        if !RealmHelper.checkIfGradientExists(currentGradient.id) {
            RealmHelper.saveGradient(currentGradient)
            
            //save gradient in global database
            FirebaseHelper.addGradient(gradient: currentGradient)
            
            // Creating StatusAlert instance
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(systemName: "checkmark")
            statusAlert.title = "Saved"
            statusAlert.message = "Current Gradient was saved!"
            statusAlert.canBePickedOrDismissed = false
            
            // Presenting created instance
            statusAlert.showInKeyWindow()
        } else {
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(systemName: "checkmark")
            statusAlert.title = "Already saved"
            statusAlert.message = "Current Gradient was already saved!"
            statusAlert.canBePickedOrDismissed = false
            
            // Presenting created instance
            statusAlert.showInKeyWindow()
        }
    }
    
    func updateGradientView(){
        self.colorsTableView.reloadData()
        
        if gradientLayer.cornerRadius != 8 {
            gradientView.layer.addSublayer(gradientLayer)
        }
        
        noColorExistsLabel.isHidden = (currentGradient.colors.count == 0) ? false : true
        directionButton.isHidden = (currentGradient.colors.count == 0) ? true : false
        saveGradientButton.isHidden = (currentGradient.colors.count == 0) ? true : false
        
        gradientLayer.frame = CGRect(x: gradientView.frame.origin.x, y: gradientView.frame.origin.y, width: gradientView.frame.width, height: gradientView.frame.width)
        
        if currentGradient.colors.count == 1 {
            let singleColor = UIColor(hexString: currentGradient.colors[0])!.cgColor
            gradientLayer.colors = [singleColor, singleColor]
        } else {
            gradientLayer.colors = currentGradient.colors.map({UIColor(hexString: $0)!.cgColor})
        }
        
        gradientLayer.startPoint = currentGradient.direction.startPoint()
        gradientLayer.endPoint = currentGradient.direction.endPoint()
        gradientLayer.cornerRadius = 8
    }
}

//MARK: - UITableViewDataSource

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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section <= (currentGradient.colors.count - 1){
            let cell = colorsTableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ColorCell
            //            let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeCell") as! SwipeTableViewCell
            
            cell.numberLabel.text = "\(indexPath.section + 1)"
            cell.tapToEditView.backgroundColor = UIColor(hexString: currentGradient.colors[indexPath.section])
            cell.delegate = self
            return cell
            
        } else {
            return colorsTableView.dequeueReusableCell(withIdentifier: "AddNewColorReusableCell", for: indexPath) as! AddNewColorCell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .reveal
        return options
    }
}

//MARK: - SwipeTableViewCellDelegate

extension CreateViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.currentGradient.colors.remove(at: indexPath.section)
            self.vibrationGenerator.impactOccurred()
            self.updateGradientView()
        }
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.title = .none
        
        // customize the action appearance
        deleteAction.backgroundColor = .clear
        deleteAction.image = UIImage(systemName: "trash.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .medium))!.withTintColor(.red, renderingMode: .alwaysOriginal)
        
        return [deleteAction]
    }
}

//MARK: - UITableViewDelegate

extension CreateViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentColorListItemSelected = indexPath.section
        let colorCount = currentGradient.colors.count
        
        if currentColorListItemSelected < colorCount {
            // Edit only color -> Send current color to colorpicker
            let currentColor = UIColor(hexString: currentGradient.colors[indexPath.section])
            openColorPicker(color: currentColor)
            
        } else if currentColorListItemSelected == colorCount {
            // new color -> Dont use to send a color to colorpicker
            openColorPicker(color: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.section < currentGradient.colors.count {
            currentGradient.colors.swapAt(sourceIndexPath.section, destinationIndexPath.section)
            updateGradientView()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section < currentGradient.colors.count) ? true : false
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.section == currentGradient.colors.count {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
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
        vibrationGenerator.impactOccurred()
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
        
        //renew the currentGradient object to seperate it from the databases
        renewCurrentGradientID()
        
        // edit one color
        if currentColorListItemSelected < colorCount {
            currentGradient.colors[currentColorListItemSelected] = color.toHexString()
        }
        // add new color
        else if currentColorListItemSelected == colorCount {
            currentGradient.colors.append(color.toHexString())
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
