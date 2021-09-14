//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Leo Moon on 2021-09-03.
//

import UIKit

class WelcomeViewController: UIViewController {

    var playlists = [Playlist]()

    public var selectionHandler: ((Playlist) -> Void)?

    private let noPlaylistsView = ActionLabelView()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identfier)
        tableView.isHidden = true
        return tableView
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Spotify"
//        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        view.backgroundColor = .systemGreen
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoPlaylistsView()
        fetchData()
        print("Playlists1: \(playlists)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if AuthManager.shared.isSignedIn {
            signInButton.isHidden = true
            tableView.isHidden = false
        } else {
            signInButton.isHidden = false
            tableView.isHidden = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50)
        
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistsView.center = view.center
        tableView.frame = view.bounds
        
    }
    
    private func setUpNoPlaylistsView() {
        view.addSubview(noPlaylistsView)
        noPlaylistsView.delegate = self
        noPlaylistsView.configure(
            with: ActionLabelViewViewModel(
                text: "You don't have any playlists yet.",
                actionTitle: "Create"
            )
        )
    }

    private func fetchData() {
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                    print("Playlists2: \(playlists)")

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func updateUI() {
        if playlists.isEmpty {
            // Show label
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        }
        else {
            // Show table
            tableView.reloadData()
            noPlaylistsView.isHidden = true
            tableView.isHidden = false
        }
    }

    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(
            title: "New Playlists",
            message: "Enter playlist name.",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }

            APICaller.shared.createPlaylist(with: text) { [weak self] success in
                if success {
//                    HapticsManager.shared.vibrate(for: .success)
                    // Refresh list of playlists
                    self?.fetchData()
                }
                else {
//                    HapticsManager.shared.vibrate(for: .error)
                    print("Failed to create playlist")
                }
            }
        }))

        present(alert, animated: true)
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    private func handleSignIn(success: Bool) {
        // Log user in or yell at them for error
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        print("SUCCCESS:: \(success)")
//        let mainAppTabBarVC = TabBarViewController()
//        mainAppTabBarVC.modalPresentationStyle = .fullScreen
//        present(mainAppTabBarVC, animated: true)
    }
}

extension WelcomeViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()
    }
}



extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identfier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(
            with: SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(string: playlist.images.first?.url ?? "")
            )
        )
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        HapticsManager.shared.vibrateForSelection()
        let playlist = playlists[indexPath.row]
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }

        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
