//
//  WatchManager.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/15/25.
//
import WatchConnectivity
import SwiftData
import SwiftUI

class WatchManager: NSObject, WCSessionDelegate, ObservableObject {
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("📴 iOS session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("♻️ iOS session deactivated, reactivating")
        WCSession.default.activate()
    }
    
    func activateSession() {
        guard WCSession.isSupported() else {
            print("❌ WCSession not supported")
            return
        }
        print("Paired: \(WCSession.default.isPaired)")
        print("Installed: \(WCSession.default.isWatchAppInstalled)")
        print("Reachable: \(WCSession.default.isReachable)")

        WCSession.default.delegate = self
        WCSession.default.activate()
        print("Activation: \(WCSession.default.activationState.rawValue)")
        
        print("🔌 Activating WCSession")
    }
    
    static let shared = WatchManager()
    
    private var modelContext: ModelContext?
    
    @Query private var meals: [MealLogEntry]
    
    private var mealsForToday: [MealLogEntry] {
        meals.filter {
            $0.date == Date.now
        }
    }
    
    private override init() {
        super.init()
    }
    
    func checkState() {
        print("Paired: \(WCSession.default.isPaired)")
        print("Installed: \(WCSession.default.isWatchAppInstalled)")
        print("Reachable: \(WCSession.default.isReachable)")
        print("Activation: \(WCSession.default.activationState.rawValue)")
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let context = self.modelContext {
                try? self.handleMessage(message: message, context: context)
                try? context.save()
            } else {
                print("ModelContext is not set yet!")
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print("Paired: \(WCSession.default.isPaired)")
        print("Installed: \(WCSession.default.isWatchAppInstalled)")
        print("Reachable: \(WCSession.default.isReachable)")
        print("Activation: \(WCSession.default.activationState)")
    }
    
    func handleMessage(message: [String : Any], context: ModelContext) throws {
        guard let messageName = message["name"] as? String, let payload = message["data"] as? Data else { return }
        
        
        switch messageName {
        case "add":
            let mealName = message["extMealName"] as? String ?? ""
            let food = try JSONDecoder().decode(FoodItem.self, from: payload)
            addFoodToMealLog(food, mealName: mealName, context: context)
        case "import":
            let savedFood = try JSONDecoder().decode(SavedFoodItem.self, from: payload)
            context.insert(savedFood)
        case "log":
            let log = try JSONDecoder().decode(InsulinLogEntry.self, from: payload)
            context.insert(log)
        default:
            throw NSError(domain: "Invalid message name \(messageName)", code: 0, userInfo: nil)
        }
        
    }
    
    private func addFoodToMealLog(_ food: FoodItem, mealName: String, context: ModelContext) {
        let foodCopy = FoodItem(name: food.name, carbs: food.carbs, calories: food.calories)

        if let existingMealLog = mealsForToday.first(where: { $0.mealName == mealName }) {
            existingMealLog.foods.append(foodCopy)
        } else {
            let mealLog = MealLogEntry(mealName: mealName, foods: [foodCopy], date: Date.now)
            context.insert(mealLog)
        }
    }
}
