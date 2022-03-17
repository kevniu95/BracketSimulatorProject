//
//  SceneDelegate.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/4/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let splashVC = storyBoard.instantiateViewController(withIdentifier: "splash")
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()


        let seconds = 0.5
        print("pausing before moving past splash screen...")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {

            let tabVC = storyBoard.instantiateViewController(withIdentifier: "tabbar")
            self.window?.rootViewController = tabVC
            self.window?.makeKeyAndVisible()
        }

        manageTimesOpened()
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
    
    
    // MARK: Manage times opened
    func manageTimesOpened(){
        print("I am managing times opened")
        let timesOpened = checkTimesOpened()
        if timesOpened == 0{
            print("I've never been opened!")
        }
        else if timesOpened == 3{
            print("I have been opened three whole times!")
        }
        DataManager.sharedInstance.updateTimesOpened(timesOpened: timesOpened)
    }

    func checkTimesOpened() -> Int{
        let defaults = UserDefaults.standard
        var timesOpened = defaults.integer(forKey: "timesOpened")
        print("Times opened: \(timesOpened)")
        if timesOpened == 0{
            print("I am doing something about this")
        }
        timesOpened += 1
        defaults.set(timesOpened, forKey: "timesOpened")
        defaults.register(defaults: ["timesOpened" : 0])
        return timesOpened - 1
    }
    



}

