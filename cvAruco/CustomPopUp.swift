//
//  CustomPopUp.swift
//  cvAruco
//
//  Created by Young Won Choi on 2022/10/12.
//  Copyright © 2022 Young Won Choi. All rights reserved.
//

import UIKit

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
    
    var vc: UIViewController!
    var view: UIView!
    var config = UIButton.Configuration.filled()
    var arucoId: Int!

    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    

    init(frame: CGRect, arucoId: Int){
        super.init(frame: frame)
        self.arucoId = arucoId
        
        print("Frame Height and Width: ", frame.width, ": ", frame.height)
        xibSetup(frame: CGRect(x:0,y:0,width: frame.width, height: frame.height))
        self.productID.text = "Aruco Id: " + String(arucoId)
        
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
    }

}
