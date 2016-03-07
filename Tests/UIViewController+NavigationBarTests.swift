//
//  UIViewController+NavigationBarTests.swift
//  UIViewController+NavigationBar
//
//  Created by 전수열 on 1/27/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import XCTest
import UIViewController_NavigationBar

class Tests: XCTestCase {

    var navigationController: UINavigationController!
    var rootViewController: UIViewController! {
        return self.navigationController.viewControllers.first
    }
    var viewController: ViewController!


    // MARK: setUp

    override func setUp() {
        super.setUp()
        self.viewController = ViewController()
        self.navigationController = UINavigationController(rootViewController: UIViewController())
    }


    // MARK: testNavigationItemObserving

    func testNavigationItemObserving_title() {
        self.navigationController.viewControllers[0] = self.viewController
        self.viewController.navigationItem.title = "Hello!"
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.title, "Hello!")
    }

    func testNavigationItemObserving_titleView() {
        self.navigationController.viewControllers[0] = self.viewController
        self.viewController.navigationItem.titleView = {
            let view = UIView()
            view.backgroundColor = .redColor()
            return view
        }()
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.titleView?.backgroundColor, .redColor())
    }

    func testNavigationItemObserving_prompt() {
        self.navigationController.viewControllers[0] = self.viewController
        self.viewController.navigationItem.prompt = "Prompt"
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.prompt, "Prompt")
    }

    func testNavigationItemObserving_backBarButtonItem() {
        self.navigationController.viewControllers[0] = self.viewController
        self.viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back!",
            style: .Plain,
            target: nil,
            action: ""
        )
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.backBarButtonItem?.title, "Back!")
    }

    func testNavigationItemObserving_hidesBackButton() {
        self.navigationController.viewControllers[0] = self.viewController
        self.viewController.navigationItem.hidesBackButton = false
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.hidesBackButton, false)
        self.viewController.navigationItem.hidesBackButton = true
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.hidesBackButton, true)
    }

    func testNavigationItemObserving_rightBarButtonItem() {
        self.navigationController.viewControllers[0] = self.viewController
        self.viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Right!",
            style: .Plain,
            target: nil,
            action: ""
        )
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.rightBarButtonItem?.title, "Right!")
    }

    func testNavigationItemObserving_rightBarButtonItems() {
        self.navigationController.viewControllers[0] = self.viewController
        self.viewController.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                title: "Right1",
                style: .Plain,
                target: nil,
                action: ""
            ),
            UIBarButtonItem(
                title: "Right2",
                style: .Plain,
                target: nil,
                action: ""
            )
        ]
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.rightBarButtonItems?.count, 2)
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.rightBarButtonItems?[0].title, "Right1")
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.rightBarButtonItems?[1].title, "Right2")
    }

    func testNavigationItemObserving_leftBarButtonItem() {
        self.navigationController.viewControllers[0] = self.viewController
        self.viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Left!",
            style: .Plain,
            target: nil,
            action: ""
        )
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.leftBarButtonItem?.title, "Left!")
    }

    func testNavigationItemObserving_leftBarButtonItems() {
        self.navigationController.viewControllers[0] = self.viewController
        self.viewController.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(
                title: "Left1",
                style: .Plain,
                target: nil,
                action: ""
            ),
            UIBarButtonItem(
                title: "Left2",
                style: .Plain,
                target: nil,
                action: ""
            )
        ]
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.leftBarButtonItems?.count, 2)
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.leftBarButtonItems?[0].title, "Left1")
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.leftBarButtonItems?[1].title, "Left2")
    }

    func testNavigationItemObserving_leftItemsSupplementBackButton() {
        self.navigationController.viewControllers[0] = self.viewController
        self.viewController.navigationItem.leftItemsSupplementBackButton = false
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.leftItemsSupplementBackButton, false)
        self.viewController.navigationItem.leftItemsSupplementBackButton = true
        XCTAssertEqual(self.viewController.navigationBar.items?.first?.leftItemsSupplementBackButton, true)
    }


    // MARK: testNavigationBarHidden

    func testNavigationBarHidden_hasNavigationBarTrue() {
        self.viewController.hasNavigationBar = true

        self.navigationController.pushViewController(self.viewController, animated: false)
        self.viewController.viewWillAppear(false)

        let expectation = self.expectationWithDescription("testNavigationBarHidden_hasNavigationBarTrue")
        dispatch_async(dispatch_get_main_queue()) {
            if self.navigationController.navigationBarHidden == true {
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testNavigationBarHidden_hasNavigationBarFalse() {
        self.viewController.hasNavigationBar = false

        self.navigationController.pushViewController(self.viewController, animated: false)
        self.viewController.viewWillAppear(false)

        let expectation = self.expectationWithDescription("testNavigationBarHidden_hasNavigationBarFalse")
        dispatch_async(dispatch_get_main_queue()) {
            if self.navigationController.navigationBarHidden == false {
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }


    // MARK: testNavigationBarAdded

    func testNavigationBarAdded_hasNavigationBarTrue() {
        self.viewController.hasNavigationBar = true

        self.navigationController.pushViewController(self.viewController, animated: false)
        self.viewController.viewWillAppear(false)
        self.viewController.view.setNeedsLayout()
        self.viewController.view.layoutIfNeeded()

        let expectation = self.expectationWithDescription("testNavigationBarAdded_hasNavigationBarTrue")
        dispatch_async(dispatch_get_main_queue()) {
            if self.viewController.navigationBar.superview == self.viewController.view {
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testNavigationBarAdded_hasNavigationBarFalse() {
        self.viewController.hasNavigationBar = false

        self.navigationController.pushViewController(self.viewController, animated: false)
        self.viewController.viewWillAppear(false)
        self.viewController.view.setNeedsLayout()
        self.viewController.view.layoutIfNeeded()

        let expectation = self.expectationWithDescription("testNavigationBarAdded_hasNavigationBarFalse")
        dispatch_async(dispatch_get_main_queue()) {
            if self.viewController.navigationBar.superview == nil {
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }

}


final class ViewController: UIViewController {

    var hasNavigationBar: Bool = false

    override func hasCustomNavigationBar() -> Bool {
        return self.hasNavigationBar
    }

}
