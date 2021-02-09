//
//  RealmHelper.swift
//  Gradients
//
//  Created by David Deutsch on 08.12.20.
//

import RealmSwift

class RealmHelper {
    static func saveGradient(_ gradient: Gradient){
        //create equivalent database model object
        let savedGradient = SavedGradient(gradient: gradient)
               
        do {
            let realm = try Realm()
            
            //check if gradient with id exists
            let results = realm.objects(SavedGradient.self).filter("gradientID == %@", gradient.id)
            
            if let existingGradient = results.first {
                // TODO: Open an alert action asking the user whether the current gradient should be overwritten or a new gradient created.
               
                //updateExistingGradient
                try realm.write {
                    existingGradient.colors.removeAll()
                    savedGradient.colors.forEach { existingGradient.colors.append($0) }
                    existingGradient.direction = savedGradient.direction
                }
            } else {
                //addNewGradient
                let savedGradient = SavedGradient(gradient: gradient)
                
                try realm.write{
                    realm.add(savedGradient)
                }
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    static func deleteGradientById(id: String){
            do{
                let realm = try Realm()
                let results = realm.objects(SavedGradient.self).filter("gradientID == %@", id)
                if let existingGradient = results.first {
                        try realm.write {
                            realm.delete(existingGradient)
                        }
                }
            } catch {
                print("Error saving category \(error)")
            }
    }
    
    //return the saved gradients as an Array of Gradient Objects
    static func getAllSavedGradients() -> [Gradient]{
        let realm = try! Realm()
        let savedGradients: Results<SavedGradient> = realm.objects(SavedGradient.self)
        
        var gradients: [Gradient] = []
        for gradient in savedGradients {
            gradients.append(Gradient(direction: gradient.direction, colors: Array(gradient.colors), id: gradient.gradientID))
        }
        return gradients
    }
    
    static func checkIfGradientExists(_ id: String) -> Bool {
        let realm = try! Realm()
        let results = realm.objects(SavedGradient.self).filter("gradientID == %@", id)
        
        if results.count != 0 {
            return results.first != nil
        } else {
            return false
        }
    }
}
