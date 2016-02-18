import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let venueStore = VenueStore()
        let tabBar = window!.rootViewController as! UITabBarController
        if let mapViewController = tabBar.viewControllers![0] as? MapViewController {
            mapViewController.store = venueStore
        } else {
            print("Failed to pass VenueStore")
        }
        return true
    }
}
