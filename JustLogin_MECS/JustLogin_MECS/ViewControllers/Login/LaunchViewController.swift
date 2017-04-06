//
//  ViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 5/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import UIKit

class LaunchViewController: BaseViewController {
    /***********************************/
    // MARK: - Properties
    /***********************************/
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let manager = LaunchManager()
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension LaunchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Hide the navigation bar
        navigationController?.isNavigationBarHidden = true
        
        automaticallyAdjustsScrollViewInsets = false;
        
        setCustomLayoutForCollectionView()
    }
}
/***********************************/
// MARK: - Navigation
/***********************************/
extension LaunchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIds.signIn {
            let navigationController = segue.destination as! UINavigationController
            let signInController = navigationController.viewControllers.first as! SignInViewController
            signInController.delegate = self
        } else if segue.identifier == Constants.SegueIds.signUp {
            let navigationController = segue.destination as! UINavigationController
            let signUpController = navigationController.viewControllers.first as! SignUpViewController
            signUpController.delegate = self
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension LaunchViewController {
    /**
     Method to set custom layout to the collection view. Removes the spaces between the cells, which was not possible to remove in the default flow layout.
     */
    func setCustomLayoutForCollectionView() {
        let customFlow = UICollectionViewFlowLayout()
        customFlow.itemSize = CGSize(width:collectionView.frame.width, height:collectionView.frame.height)
        customFlow.scrollDirection = UICollectionViewScrollDirection.horizontal
        customFlow.minimumInteritemSpacing = 0
        customFlow.minimumLineSpacing = 0
        collectionView.collectionViewLayout = customFlow
    }
    
    /**
     Method to navigate to the dashboard after the user has logged in.
     */
    func navigateToDashboard() {
        manager.navigateToApprovalFlow { (response) in
            switch(response) {
            case .success(let isApprover):
                isApprover ? navigateToAdminAndApproverDashboard() : navigateToSubmitterDashboard()
            case .failure(_ , let message):
                Utilities.showErrorAlert(withMessage: message, onController: self)
            }
        }
    }
    
    /**
     Method to navigate to the submitter's dashboard.
     */
    func navigateToSubmitterDashboard() {
        
        let submitterDashboard = UIStoryboard(name: Constants.StoryboardIds.dashboardStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Dashboard.submitterDashboard) as! UITabBarController
        
        navigationController?.pushViewController(submitterDashboard, animated: true)
    }
    
    /**
     Method to navigate to the admin/approver's dashboard.
     */
    func navigateToAdminAndApproverDashboard() {
        
        let approverAndAdminDashboard = UIStoryboard(name: Constants.StoryboardIds.dashboardStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Dashboard.approverAndAdminDashboard) as! UITabBarController
        
        navigationController?.pushViewController(approverAndAdminDashboard, animated: true)
    }
}
/***********************************/
// MARK: - SignInDelegate
/***********************************/
extension LaunchViewController: SignInDelegate {
    func loginSuccessful() {
        navigateToDashboard()
    }
}
/***********************************/
// MARK: - SignUpDelegate
/***********************************/
extension LaunchViewController: SignUpDelegate {
    func signUpSuccessful() {
        navigateToDashboard()
    }
}
/***********************************/
// MARK: - UICollectionViewDataSource
/***********************************/
extension LaunchViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.getLaunchContent().count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.launchCollectionViewCellIdentifier, for: indexPath) as! LaunchCollectionViewCell
        // TODO: - Uncomment once you have the images.
        //let imageName = getLaunchContent()[indexPath.row].imageName
        //cell.imgView.image = UIImage.init(named: imageName!)
        cell.lblDescription.text = manager.getLaunchContent()[indexPath.row].description
        return cell
    }
}
/***********************************/
// MARK: - UICollectionViewDelegate
/***********************************/
extension LaunchViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = self.collectionView.frame.size.width
        pageControl.currentPage = Int(self.collectionView.contentOffset.x / pageWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
