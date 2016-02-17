import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let venueStore = VenueStore()
        let navContoller = window!.rootViewController as! UINavigationController
        let mapViewController = navContoller.topViewController as! MapViewController
        mapViewController.store = venueStore
        return true
    }
}

