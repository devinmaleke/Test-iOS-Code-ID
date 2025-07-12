//
//  HomeListTVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 10/07/25.
//

import UIKit

class HomeListTVC: UITableViewCell {

    @IBOutlet weak var pokemonName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(pokemon: String?) {
        pokemonName.text = pokemon
    }
    
}
