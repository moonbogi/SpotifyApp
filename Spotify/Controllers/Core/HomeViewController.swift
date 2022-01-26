//
//  ViewController.swift
//  Spotify
//
//  Created by Leo Moon on 2021-09-03.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        view.backgroundColor = UIColor(red: 237/255.0, green: 236/255.0, blue: 232/255.0, alpha: 1.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings))
    }

    @objc func didTapSettings() {
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

