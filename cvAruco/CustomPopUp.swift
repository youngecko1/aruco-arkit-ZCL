//
//  CustomPopUp.swift
//  cvAruco
//
//  Created by Young Won Choi on 2022/10/12.
//  Copyright © 2022 Young Won Choi. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class CustomPopUp: UIView {


    @IBOutlet weak var productID: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var fullCount: UILabel!
    @IBOutlet weak var lastTakein: UILabel!
    @IBOutlet weak var lastTakeout: UILabel!
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var predTakein: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var remainder: UILabel!
    @IBOutlet weak var image: UIImageView!

    
    var vc: ViewController!
    var view: UIView!
    var config = UIButton.Configuration.filled()
    var arucoId: Int!
    
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    

    init(frame: CGRect, arucoId: Int, vc:ViewController){
        super.init(frame: frame)
        self.arucoId = arucoId
        self.vc = vc
        
        print("Frame Height and Width: ", frame.width, ": ", frame.height)
        xibSetup(frame: CGRect(x:0,y:0,width: frame.width, height: frame.height))
        self.layer.cornerRadius = 5
//        self.productID.text = "Aruco Id: " + String(arucoId)
//        getDocument(arucoId: arucoId)
        
        
        let docRef = vc.db.collection("ZCL").document(String(arucoId)).addSnapshotListener
        {DocumentSnapshot, error in guard let document = DocumentSnapshot else {
            print("Error fetching document: \(error!)")
            return
        }
            guard let data = document.data() else{
                print("document data was empty")
                return
            }
            
            //Get Date Formatter to display FIRTimestamp as String
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "KST")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyy-MM-dd HH:mm"
            
            //Image URL converted to image
            let imageData = document.data()!["img"] as! String
            let imageURL = URL(string: imageData)
            self.image.load(url: imageURL!)

           
            
            //Product ID
            let pID = document.data()!["prod_id"] as! String
            
            //Full Count
            let fc = document.data()!["full_count"] as! Int
            
            //Last Takein Date
            let ltiDate = document.data()!["last_takein"] as! Timestamp
            let ltiStringDate = dateFormatter.string(from: ltiDate.dateValue())
            
            //Last Takeout Date
            let ltoDate = document.data()!["last_takeout"] as! Timestamp
            let ltoStringDate = dateFormatter.string(from: ltoDate.dateValue())
            
            //Last Update Date
            let luDate = document.data()!["last_update"] as! Timestamp
            let luStringDate = dateFormatter.string(from: luDate.dateValue())
            
            //Last Prediction Takein Date
            let ptiDate = document.data()!["pred_takein"] as! Timestamp
            let ptiStringDate = dateFormatter.string(from: ptiDate.dateValue())
            
            //Product Name
            let prodName = document.data()!["prod_name"] as! String
            
            //Remainder Amount (Percentage)
            let remain = document.data()!["remainder"] as! String
            
            
//                self.fullCount.text = "Full Count: " + String(fc)
            self.lastTakein.text = "최종 반입일: " + ltiStringDate
            self.lastTakeout.text = "최종 반출일: " + ltoStringDate
//                self.lastUpdate.text = "Last Update: " + luStringDate
            self.predTakein.text = "예상 발주일: " + ptiStringDate
            self.productName.text = "품목명: " + prodName
            self.remainder.text = "잔량: " + remain
            self.productID.text = pID
            
        }
        
        
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//
//
//
//
//
//            } else {
//                print("Document does not exist")
//            }
        
    }
    
    func xibSetup(frame: CGRect){
        self.view = loadNibView()
        view.frame = frame
        addSubview(view)
        
    }
    
    func loadNibView() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomPopUp", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.layer.zPosition = 1
        return view
    }
    
    

    @IBAction func closePopUp(_ sender: Any) {
        self.removeFromSuperview()
        self.vc.buttonIsPressed = false
    }
}

extension UIImageView {
    func load(url: URL){
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
