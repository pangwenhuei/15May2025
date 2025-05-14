//
//  CircularTimerViewModel.swift
//  iosApp
//
//  Created by Mohamed Alwakil on 2022-10-18.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import Combine

typealias ProgressTimer = Publishers.Autoconnect<Timer.TimerPublisher>

class CircularTimerViewModel: ObservableObject {

    struct Time {

        let hours: Int
        let minutes: Int
        let seconds: Int

        var interval: TimeInterval {
            TimeInterval((hours * 60 * 60) + (minutes * 60) + seconds)
        }
    }

    @Published var progress: CGFloat = 0
    @Published var timerInterval: TimeInterval

    let timer: ProgressTimer
    private let timeStep = 0.25
    private let stepProgress: CGFloat

    var cancellable: Cancellable?

    init(interval: TimeInterval, progress: CGFloat) {

        self.progress = progress
        self.stepProgress = timeStep / CGFloat(interval)

        self.timerInterval = interval * (1 - progress)

        timer = Timer.publish(every: timeStep, on: .main, in: .common).autoconnect()

        cancellable = timer
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] _ in

                guard let self = self
                else { return 0 }

                if self.progress >= 1.0 || self.timerInterval <= 0 {

                    self.cancellable?.cancel()
                    return 1.0
                } else {

                    self.timerInterval -= self.timeStep
                    print("progress \(self.progress)")
                    self.progress += self.stepProgress
                    return self.progress
                }
            }
            .removeDuplicates()
            .sink(receiveValue: { [weak self] value in
                self?.progress = value
            })

    }

    func textFromTimeInterval() -> String {

        let time = Int(timerInterval)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3_600)

        return timeStringFrom(hours: hours, minutes: minutes, seconds: seconds)
    }

    private func timeStringFrom(hours: Int = 0, minutes: Int = 0, seconds: Int) -> String {

        if hours != 0 {
            var text = hoursString(hours: hours)
            if minutes != 0 {
                text = " ";
                text.append(minutesString(minutes: minutes))

            }
            return text
        } else if minutes != 0 {
            return shortMinutesString(minutes: minutes)
        } else {
            return shortSecondsString(seconds: seconds)
        }
    }

    private func hoursString(hours: Int) -> String {
//        languageService.getResourceString(resourceKey: StringKey().timerHours, params: [hours.toString].toKotlin())
        "\(hours) \(hours == 1 ? "hour" : "hours")"
    }

    private func minutesString(minutes: Int) -> String {
        //        languageService.getResourceString(resourceKey: StringKey().timerMinutes, params: [minutes.toString].toKotlin())
        "\(minutes) \(minutes == 1 ? "minute" : "minutes")"

    }

    private func shortMinutesString(minutes: Int) -> String {
//        languageService.getResourceString(resourceKey: StringKey().timeMinutesShort, params: [minutes.toString].toKotlin())
        "\(minutes) m"
    }

    private func shortSecondsString(seconds: Int) -> String {
//        languageService.getResourceString(resourceKey: StringKey().timeSecondsShort, params: [seconds.toString].toKotlin()).trimmingCharacters(in: .whitespaces)
        "\(seconds) s"
    }
}
