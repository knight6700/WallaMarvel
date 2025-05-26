import UIKit
import netfox
import SwiftUI
import ComposableArchitecture
import Heros

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        startMentoring()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let view = HeroListRowsView(
            store: Store(
                initialState: HeroListRowsFeature.State(
                    hero: []
                ),
                reducer: { HeroListRowsFeature()
                }
            )
        )
        let listHeroesViewController = UIHostingController(rootView: view)        
        let navigationController = UINavigationController(rootViewController: listHeroesViewController)
        window.rootViewController = navigationController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    func startMentoring() {
        NFX.sharedInstance().start()
    }
}
