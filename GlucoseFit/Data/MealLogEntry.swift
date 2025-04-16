import SwiftData
import Foundation

@Model
final class FoodItem: Codable {
    var name: String
    var carbs: Double
    var calories: Double
    var id = UUID()
    
    init(name: String, carbs: Double, calories: Double) {
        self.name = name
        self.carbs = carbs
        self.calories = calories
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case carbs
        case calories
    }
    
    public required convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let carbs = try container.decode(Double.self, forKey: .carbs)
        let cals = try container.decode(Double.self, forKey: .calories)
        self.init(name: name, carbs: carbs, calories: cals)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(carbs, forKey: .carbs)
        try container.encode(calories, forKey: .calories)
    }
}

@Model
final class SavedFoodItem: Codable {
    var name: String
    var carbs: Double
    var calories: Double
    var id = UUID()

    init(name: String, carbs: Double, calories: Double) {
        self.name = name
        self.carbs = carbs
        self.calories = calories
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case carbs
        case calories
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let carbs = try container.decode(Double.self, forKey: .carbs)
        let cals = try container.decode(Double.self, forKey: .calories)
        self.init(name: name, carbs: carbs, calories: cals)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(carbs, forKey: .carbs)
        try container.encode(calories, forKey: .calories)
    }
}

@Model
final class MealLogEntry: Codable {
    public final var mealName: String
    var foods: [FoodItem]
    var date: Date
    var id = UUID()
    
    init(mealName: String, foods: [FoodItem], date: Date) {
        self.mealName = mealName
        self.foods = foods
        self.date = date
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case foods
        case date
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let foods = try container.decode([FoodItem].self, forKey: .foods)
        let date = try container.decode(Date.self, forKey: .date)
        self.init(mealName: name, foods: foods, date: date)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mealName, forKey: .name)
        try container.encode(foods, forKey: .foods)
        try container.encode(date, forKey: .date)
    }
}

@Model
final class InsulinLogEntry: Codable {
    var id: UUID = UUID()
    var units: Double
    var date: Date

    init(units: Double, date: Date) {
        self.units = units
        self.date = date
    }
    
    enum CodingKeys: String, CodingKey {
        case units
        case date
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let units = try container.decode(Double.self, forKey: .units)
        let date = try container.decode(Date.self, forKey: .date)
        self.init(units: units, date: date)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(units, forKey: .units)
        try container.encode(date, forKey: .date)
    }
}
