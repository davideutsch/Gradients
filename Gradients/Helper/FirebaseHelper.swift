//
//  FirebaseHelper.swift
//  Gradients
//
//  Created by David Deutsch on 10.12.20.
//
import Firebase

class FirebaseHelper {
    let tableIdentifier = "gradients"
    
    var lastLowestLikes = 0
    let limitOfNewLoadedGradients = 20
    
    static func addGradient(gradient: Gradient){
        let collection = Firestore.firestore().collection("gradients")
        
        collection.addDocument(data: [
            "id": gradient.id,
            "direction": gradient.direction.rawValue,
            "colors": Array(gradient.colors),
            "likes": 0
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to firestore, \(e)")
            }
        }
    }
    
    func getGradients(completion: @escaping ([Gradient]) -> ()) {
        let collection = getCollection()
        var gradients: [Gradient] = []
        
        
        collection.order(by: "likes", descending: true).limit(to: limitOfNewLoadedGradients).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                return
            }
            for doc in snapshot.documents {
                let gradient = Gradient(snapshot: doc)
                gradients.append(gradient)
                
            }
            
            if snapshot.documents.count >= 1 {
                self.lastLowestLikes =  snapshot.documents.last?.get("likes") as! Int
            }
            completion(gradients)
        }
    }
    
    func getMoreDocuments(completion: @escaping ([Gradient]) -> ()) {
        let collection = getCollection()
        var gradients: [Gradient] = []
        
        collection.order(by: "likes", descending: true).limit(to: limitOfNewLoadedGradients).whereField("likes", isLessThan: lastLowestLikes).getDocuments { (snapshot, error) in
            // iterate through the documents and create Cat objects
            guard let snapshot = snapshot else {
                return
            }
            for doc in snapshot.documents {
                let gradient = Gradient(snapshot: doc)
                gradients.append(gradient)
            }
            if snapshot.documents.count >= 1 {
                self.lastLowestLikes =  snapshot.documents.last?.get("likes") as! Int
            }
            completion(gradients)
        }
    }
    
    //increment likes count of specific gradient
    func likeGradient(uuid: String){
        getCollection().whereField("id", isEqualTo: uuid).getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
            } else if snapshot!.documents.count != 1 {
                return
            } else {
                if let document = snapshot!.documents.first {
                    let likesCountBefore = document.get("likes") as! Int
                    document.reference.updateData([
                        "likes": likesCountBefore + 1
                    ])
                }
            }
        }
        
    }
    
    func getCollection() -> CollectionReference {
        return Firestore.firestore().collection(tableIdentifier)
    }
}
