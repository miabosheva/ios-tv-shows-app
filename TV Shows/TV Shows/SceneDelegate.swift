//
//  SceneDelegate.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 7.7.23.
//

import UIKit
import KeychainAccess

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Create navigation controller in which we will embed our starting view controller
        
        let keychain = Keychain(service: "com.infinum.tv-shows")
        guard let savedAuthInfo = try? keychain.getData("authInfo") else { return }
        let decoder = JSONDecoder()
        if let authInfo = try? decoder.decode(AuthInfo.self, from: savedAuthInfo) {
            let tabBarController = UITabBarController()
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            
            let homeControllerShows = storyboard.instantiateViewController(withIdentifier: "homeController") as! HomeViewController
            setupHomeControllerShows(showsVC: homeControllerShows, authInfo: authInfo)
            let homeControllerTopRated = storyboard.instantiateViewController(withIdentifier: "homeController") as! HomeViewController
            setupHomeControllerTopRated(topRatedVC: homeControllerTopRated, authInfo: authInfo)

            let controllers = [homeControllerShows, homeControllerTopRated]
            tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
            tabBarController.tabBar.tintColor = UIColor(named: "primary-color")
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        } else {
            let navigationController = UINavigationController()
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "loginController") as! LoginViewController
            navigationController.setViewControllers([loginController], animated: true)
            window?.rootViewController = navigationController
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

private extension SceneDelegate {
    
    func setupHomeControllerShows(showsVC: HomeViewController, authInfo: AuthInfo) {
        showsVC.authInfo = authInfo
        showsVC.requestURL = "https://tv-shows.infinum.academy/shows"
        showsVC.tabBarItem.tag = 1
        showsVC.tabBarItem.image = UIImage(named: "ic-show-selected")
        showsVC.title = "Shows"
    }
    
    func setupHomeControllerTopRated(topRatedVC: HomeViewController, authInfo: AuthInfo){
        topRatedVC.authInfo = authInfo
        topRatedVC.requestURL = "https://tv-shows.infinum.academy/shows/top_rated"
        topRatedVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        topRatedVC.title = "Top Rated"
    }
}

