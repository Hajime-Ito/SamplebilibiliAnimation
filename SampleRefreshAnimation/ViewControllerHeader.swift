//
//  ViewControllerHeader.swift
//  SampleRefreshAnimation
//
//  Created by hajime ito on 2020/02/10.
//  Copyright © 2020 hajime_poi. All rights reserved.
//

import UIKit

extension ViewController {
    
    enum headerViewStatus {
        case start(_ headerViewFrame: CGRect, _ initHeaderFrameMinY: CGFloat)
        case move_up(_ sub: CGFloat, _ scrollViewY: CGFloat, _ headerViewFrame: CGRect)
        case stop_up(_ scrollViewY: CGFloat, _ headerViewFrame: CGRect, _ initHeaderFrameMaxY: CGFloat)
        case move_down(_ sub: CGFloat, _ scrollViewY: CGFloat, _ headerViewFrame: CGRect)
        case stop_down(_ scrollViewY: CGFloat, _ headerViewFrame: CGRect, _ initHeaderFrameMinY: CGFloat)
    }
    
    private func getHeaderViewStatus(_ sub: inout[String:CGFloat], _ scrollViewY: CGFloat, _ headerViewFrame: CGRect, _ lastScrollViewY: CGFloat, _ initHeaderFrame: [String:CGFloat]) -> headerViewStatus {
        if (scrollViewY <= (0 - initHeaderFrame["height"]!)) {
            return headerViewStatus.start(headerViewFrame, initHeaderFrame["minY"]!)
        } else if (lastScrollViewY > scrollViewY) {
            sub["down"] = 0
            if(headerViewFrame.origin.y >= scrollViewY + initHeaderFrame["maxY"]!) {
                return headerViewStatus.stop_up(scrollViewY, headerViewFrame, initHeaderFrame["maxY"]!)}
            else { return headerViewStatus.move_up(sub["up"]!, scrollViewY, headerViewFrame)}
        } else {
            sub["up"] = 0
            if(headerViewFrame.origin.y <= scrollViewY + initHeaderFrame["minY"]!) { return headerViewStatus.stop_down(scrollViewY, headerViewFrame, initHeaderFrame["minY"]!)}
            else { return headerViewStatus.move_down(sub["down"]!, scrollViewY, headerViewFrame)}
        }
    }
    
    
    private func scrolling(status: headerViewStatus) {
        
        func start(_ headerViewFrame: CGRect, _ initHeaderFrameMaxY: CGFloat) {
            print("Start")
            myHeaderView.frame = CGRect(x: headerViewFrame.origin.x, y: initHeaderFrameMaxY, width: headerViewFrame.width, height:  headerViewFrame.height)
        }
        
        func move_up(_ sub: CGFloat, _ scrollViewY: CGFloat, _ headerViewFrame: CGRect) {
            print("Move_up")
            myHeaderView.frame = CGRect(x: headerViewFrame.origin.x, y: headerViewFrame.origin.y + sub, width: headerViewFrame.width, height: headerViewFrame.height)
        }
        
        func stop_up(_ scrollViewY: CGFloat, _ headerViewFrame: CGRect, _ initHeaderFrameMaxY: CGFloat) {
            print("Stop_up")
            myHeaderView.frame = CGRect(x: headerViewFrame.origin.x, y: (scrollViewY + initHeaderFrameMaxY), width:  headerViewFrame.width, height:  headerViewFrame.height)
        }
        
        func move_down(_ sub: CGFloat, _ scrollViewY: CGFloat, _ headerViewFrame: CGRect) {
            print("Move_down")
            myHeaderView.frame = CGRect(x: headerViewFrame.origin.x, y: headerViewFrame.origin.y + sub, width: headerViewFrame.width, height: headerViewFrame.height)
        }
        
        func stop_down(_ scrollViewY: CGFloat, _ headerViewFrame: CGRect, _ initHeaderFrameMinY: CGFloat) {
            print("Stop_down")
            myHeaderView.frame = CGRect(x: headerViewFrame.origin.x, y: (scrollViewY + initHeaderFrameMinY), width: headerViewFrame.width, height: headerViewFrame.height)
        }
        
        switch status {
        case let .start(headerViewFrame, initHeaderFrameMinY): start(headerViewFrame, initHeaderFrameMinY)
        case let .move_up(sub, scrollViewY, headerViewFrame): move_up(sub, scrollViewY, headerViewFrame)
        case let .stop_up(scrollViewY, headerViewFrame, initHeaderFrameMaxY): stop_up(scrollViewY, headerViewFrame, initHeaderFrameMaxY)
        case let .move_down(sub, scrollViewY, headerViewFrame): move_down(sub, scrollViewY, headerViewFrame)
        case let .stop_down(scrollViewY, headerViewFrame, initHeaderFrameMinY): stop_down(scrollViewY, headerViewFrame, initHeaderFrameMinY)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var subSet: [String:CGFloat] = ["up": 0, "down": 0]
        // MARK: -- 以下のinitialHeaderFrameに適切な値を入力するだけで、このプログラムは動作します。
        let initialHeaderFrame: [String:CGFloat] = ["Y": -230, "height": 30]
        let headerFrame: [String:CGFloat] = ["minY": initialHeaderFrame["Y"]! , "maxY": initialHeaderFrame["Y"]! + initialHeaderFrame["height"]!, "height": initialHeaderFrame["height"]!]
        
        subSet["up"]! += (lastContentOffset - scrollView.contentOffset.y)*0.1
        subSet["down"]! += (lastContentOffset - scrollView.contentOffset.y)*0.1
        
        let status = self.getHeaderViewStatus(&subSet, scrollView.contentOffset.y, myHeaderView.frame, lastContentOffset, headerFrame)
        self.scrolling(status: status)
        lastContentOffset = scrollView.contentOffset.y
        
    }
}


