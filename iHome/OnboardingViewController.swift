//
//  OnboardingViewController.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-14.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var controlView: UIView!
    internal var pageViewController: UIPageViewController!
    
    internal var currentControllerIndex: Int {
        get {
            return onBoardViewControllers.index(of: pageViewController.viewControllers!.last!)!
        }
    }
    
    private(set) lazy var onBoardViewControllers: [UIViewController] = {
        return [self.newOnboardingViewControllerScreen(count: "First"),
                self.newOnboardingViewControllerScreen(count: "Second")]
    }()
    
    /**
     References a storyboard to instantiate, and return a view controller
     - parameters:
     - color: The name of the color to reference the storyboard identifier
     */
    private func newOnboardingViewControllerScreen(count: String) -> UIViewController {
        return UIStoryboard(name: "OnboardingViewController", bundle: nil) .
            instantiateViewController(withIdentifier: "\(count)OnBoardingViewController")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        generatePageController()
        self.view.addSubview(self.pageViewController.view)
        setupControllerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func generatePageController(){
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        if let firstViewController = onBoardViewControllers.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setupControllerView(){
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.numberOfPages = onBoardViewControllers.count
        view.bringSubview(toFront: controlView)
    }
    
    private func swipeToNextController(){
        let nextIndex = currentControllerIndex + 1
        let totalNumberOfPages = onBoardViewControllers.count
        // User is on the last view controller and swiped right to loop to the first view controller.
        if totalNumberOfPages == nextIndex {
            pageViewController.setViewControllers([onBoardViewControllers.first!],
                                                  direction: .forward,
                                                  animated: true,
                                                  completion: nil)
            pageControl.currentPage = currentControllerIndex
        }
        else {
            pageViewController.setViewControllers([onBoardViewControllers[nextIndex]],
                                                  direction: .forward,
                                                  animated: true,
                                                  completion: nil)
            pageControl.currentPage = currentControllerIndex
        }
    }
}

// MARK: - Protocol Conformance | UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(completed) {
            pageControl.currentPage = currentControllerIndex
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    }
}

// MARK: - Protocol Conformance | UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = currentControllerIndex
        let previousIndex = index - 1
        // Check bounds
        guard previousIndex >= 0 else {
            return nil
        }
        guard onBoardViewControllers.count > previousIndex else {
            return nil
        }
        let returnController = onBoardViewControllers[previousIndex]
        returnController.view.bringSubview(toFront: pageControl)
        return returnController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = currentControllerIndex
        let nextIndex = index + 1
        // Check bounds
        guard onBoardViewControllers.count != nextIndex else {
            return nil
        }
        guard onBoardViewControllers.count > nextIndex else {
            return nil
        }
        return onBoardViewControllers[nextIndex]
    }
    
}
