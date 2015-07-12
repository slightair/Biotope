import Foundation
import RxSwift

class GameScenePaceMaker {
    static let defaultPaceMaker = GameScenePaceMaker()

    let interval = 0.3
    var previousTime: CFTimeInterval = kCFAbsoluteTimeIntervalSince1970
    let paceSubject = PublishSubject<CFTimeInterval>()

    func knock(currentTime: CFTimeInterval) {
        let firstKnock = (previousTime == kCFAbsoluteTimeIntervalSince1970)
        if firstKnock {
            previousTime = currentTime / interval * interval
            return
        }

        while currentTime > previousTime + interval {
            previousTime += interval

            sendNext(paceSubject, previousTime)
        }
    }
}