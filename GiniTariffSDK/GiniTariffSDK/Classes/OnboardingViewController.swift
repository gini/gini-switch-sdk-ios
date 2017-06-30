//
//  OnboardingViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 28.06.17.
//
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    var onboarding = TariffOnboarding()
    var completion:(() -> Void)? = nil
    
    var currentPage:OnboardingPage? = nil
    
    convenience init(onboarding:TariffOnboarding, completion: (() -> Void)? = nil) {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.onboarding = onboarding
        // add a default empty page at the end used to let the use to scroll past the onboarding
        // and dismiss it
        var pages = self.onboarding.pages
        pages.append(OnboardingPage(image: UIImage(), text: ""))
        self.onboarding = TariffOnboarding(pages: pages)
        self.completion = completion
        dataSource = self
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstPage = onboardingPageController(with: self.onboarding.pages.first)
        self.setViewControllers([firstPage!], direction: .forward, animated: false, completion: nil)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let page = (viewController as? OnboardingPageViewController)?.page
        guard let currentPage = page else {
            return nil
        }
        let currentIndex = onboarding.pages.index(of: currentPage)
        guard let index = currentIndex else {
            return nil
        }
        let beforeIndex = onboarding.pages.index(before: index)
        guard beforeIndex >= 0 && beforeIndex < onboarding.pages.count else {
            return nil
        }
        return onboardingPageController(with: onboarding.pages[beforeIndex])
        
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let page = (viewController as? OnboardingPageViewController)?.page
        guard let currentPage = page else {
            return nil
        }
        let currentIndex = onboarding.pages.index(of: currentPage)
        guard let index = currentIndex,
            (index >= 0 && index < onboarding.pages.count) else {
            return nil
        }
        let afterIndex = onboarding.pages.index(after: index)
        guard afterIndex >= 0 && afterIndex < onboarding.pages.count else {
            return nil
        }
        return onboardingPageController(with: onboarding.pages[afterIndex])
    }
    
    func onboardingPageController(with page:OnboardingPage?) -> OnboardingPageViewController? {
        guard let page = page,
            let pageController = UIStoryboard.tariffStoryboard()?.instantiateViewController(withIdentifier: "OnboardingPageViewController") as? OnboardingPageViewController else {
                return nil
        }
        pageController.page = page
        return pageController
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        // keep track of the currently displayed page
        // For a UIPageViewController it is possible to show several pages at the same time, hence pendingViewControllers is an array
        // OnboardingViewController only shows one and that probably wont change but just to be sure, take the last page -
        // it should be the right-most one
        currentPage = (pendingViewControllers.last as? OnboardingPageViewController)?.page
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if currentPage == onboarding.pages.last {
            completion?()
        }
    }
    
}
