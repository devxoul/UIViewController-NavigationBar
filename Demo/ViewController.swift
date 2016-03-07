// The MIT License (MIT)
//
// Copyright (c) 2016 Suyeol Jeon (xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import UIViewController_NavigationBar

class ViewController: UIViewController {

    let button = UIButton(type: .System)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back",
            style: .Plain,
            target: nil,
            action: ""
        )

        if self.navigationItem.title == nil {
            self.navigationItem.title = "ViewController 0"
        }

        self.button.titleLabel?.font = UIFont.boldSystemFontOfSize(24)
        self.button.setTitle("Push", forState: .Normal)
        self.button.sizeToFit()
        self.button.center.x = self.view.frame.size.width / 2
        self.button.center.y = self.view.frame.size.height / 2
        self.button.addTarget(self, action: "buttonDidSelect", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.button)
    }

    dynamic func buttonDidSelect() {
        typealias Configuration = (
            hasNavigationBackground: Bool,
            barTintColor: UIColor?,
            backgroundColor: UIColor?
        )
        let configurations: [Configuration] = [
            (true, color(0x33CCCC), .whiteColor()),
            (true, color(0xA0C85F), .whiteColor()),
            (true, color(0x42A5F5), .whiteColor()),
            (false, nil, color(0xDCBE4B)),
            (true, color(0xB487D7), .whiteColor()),
            (false, nil, color(0xFF5F5F)),
            (true, color(0xFF82B4), .whiteColor()),
            (false, nil, color(0x222222)),
        ]
        let index = self.navigationController?.viewControllers.count ?? 1
        let configuration = configurations[index % configurations.count]

        let viewController = BarViewController()
        viewController.navigationItem.title = "ViewController \(index)"
        if configuration.hasNavigationBackground {
            viewController.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        } else {
            viewController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        }
        viewController.navigationBar.shadowImage = UIImage()
        viewController.navigationBar.barTintColor = configuration.barTintColor
        viewController.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        viewController.view.backgroundColor = configuration.backgroundColor

        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func color(hex: Int) -> UIColor {
        let red = CGFloat(hex >> 16 & 0xff) / 255
        let green = CGFloat(hex >> 8 & 0xff) / 255
        let blue  = CGFloat(hex & 0xff) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    override func prefersNavigationBarHidden() -> Bool {
        return true
    }

}

class BarViewController: ViewController {

    override func hasCustomNavigationBar() -> Bool {
        return true
    }

}
