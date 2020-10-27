//: ## Лабораторная №1. Основы Swift
import Foundation
//: 1. Дана строка: "студент1 группа1; студент2 группа2; ..."
let studentsStr = "Хаустова Екатерина 4.1; Кириллова Елена 4.1; Марков Иван 4.1; Пашков Данил 4.1; Бакуменко Олег 4.1; Кириченко Анастасия 4.1; Гусев Евгений 4.1; Белоконь Александр 4.2; Архипов Антон 4.1; Кравцов Роман 4.1; Нинидзе Давид 4.2; Кашилов Иван 4.2; Кравцов Максим 4.2; Коваленко Алексей 4.2; Бочкарёва Дария 4.2; Ульянов Михаил 4.2; Сенчукова Ангелина 4.1; Лебедев Евгений 4.1; Галайчук Виталий 4.2"
//: Сформировать массив студентов в алфавитном поряке.
//:
//: _Для разделения строки можно использовать `String.components(separatedBy: String) -> [String]`._
//:
//: _Для сортировки подойдёт стандартный метод `Sequence.sort()`._
let studentsArr: [String] = studentsStr.components(separatedBy: "; ").sorted()
//studentsArr.forEach({print($0)})

//:
//: _Перед использованием массив нужно инициализировать_
//: ```
//: if studentsGroups["1.1"] == nil {
//:     studentsGroups["1.1"] = []
//: }
//:```
var groupStudents: [String: [String]] = [:]

for studGroup in studentsArr {
    let parts: [String] = studGroup.components(separatedBy: " ")
    
    if groupStudents[parts[2]] == nil {
        groupStudents[parts[2]] = []
    }
    groupStudents[parts[2]]?.append(studGroup)
}
//print(groupStudents)
//: 2. Дан словарь баллов по лабораторным.
//:
//: _Получить доступ к последовательности ключей или значений словаря можно,
//: используя поля `Dictionary.keys` и `Dictionary.values`._
let points: [String: Int] = ["Основы Swift" : 5,
                             "Классы Swift" : 5,
                             "Делегирование" : 10,
                             "Интерфейс" : 10,
                             "Хранение данных" : 10,
                             "Core Data" : 10,
                             "Лаб 7" : 10,
                             "Лаб 8" : 15,
                             "Лаб 9" : 15,
                             "Лаб 10" : 10]

let labCount: Int = points.count
//: Сформировать словарь студент : мaссив баллов по лабораторным.
//:
//: _Баллы заполнить случайными значениями (с учетом максимальных баллов)._
//: ```
//: let randomUInt = arc4random()
//: let randomUpTo5 = arc4random_uniform(5)
//: let randomDouble = drand48()
//: ```
var studentPoints: [String: [Int]] = [:]
for student in studentsArr {
    studentPoints[student] = points.values.map{ maxPoint in Int(arc4random_uniform(UInt32(maxPoint))) }
}
//print(studentPoints)
//: 3. Посчитать суммарный балл для каждого студента.
//:
//: _Для накопления суммы можно использовать метод аггрегации данных: `reduce()`._
//: ```
//: points.values.reduce(0) { sum, point in
//:     return sum + point
//: }
//: ```
//: _Преобразование коллекций можно делать с помощью `map()` или `flatMap()`._
//: ```
//: points.map { (name, point) in
//:     return name
//: }
//: points.flatMap { (name, point) in
//:    if point == 10 {
//:        return name
//:    }
//:    return nil
//: }
//: ```
//: _Отсеивание значений удобно делать методом `filter()`._
//: ```
//: points.filter { (name,point) in
//:     return point > 5
//: }
//: ```
var sumPoints: [String: Int] = [:]

for (student, points) in studentPoints {
    sumPoints[student] = points.reduce(0, +)
}
//print(sumPoints)
//: Для каждой группы посчитать средний балл, массив студентов сдавших и не сдавших курс.
var groupAvg: [String: Float] = [:]
var passedPerGroup: [String: [String]] = [:]
var restOfStudentsPerGroup: [String: [String]] = [:]

for (group, students) in groupStudents {
    groupAvg[group] = students.map({ Float(sumPoints[$0]!) / Float(labCount) }).reduce(0, +)
}
//print(groupAvg)

let minPoint: Float = 60
for (group, students) in groupStudents {
    passedPerGroup[group] = students.filter({ Float(sumPoints[$0]!) >= minPoint })
    restOfStudentsPerGroup[group] = students.filter({ Float(sumPoints[$0]!) < minPoint })
}
//print(passedPerGroup)
//print(restOfStudentsPerGroup)



enum TimeExceptions: Error {
    case wrongHours
    case wrongMinutes
    case wrongSeconds
}

class TimeTG {
    private var hours: UInt
    private var minutes: UInt
    private var seconds: UInt
    
    init() {
        self.hours = 0
        self.minutes = 0
        self.seconds = 0
    }
    
    init(hours: UInt, minutes: UInt, seconds: UInt) throws {
        if (hours < 0 || hours > 23) {
            throw TimeExceptions.wrongHours
        }
        if (minutes < 0 || minutes > 59) {
            throw TimeExceptions.wrongMinutes
        }
        if (seconds < 0 || seconds > 59) {
            throw TimeExceptions.wrongSeconds
        }
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
    
    init(date: Date) {
        let calendar = Calendar.current
    
        self.hours = UInt(calendar.component(.hour, from: date))
        self.minutes = UInt(calendar.component(.minute, from: date))
        self.seconds = UInt(calendar.component(.second, from: date))
    }
    
    func format() -> String {
        if (hours == 0) {
            return ("12:\(minutes):\(seconds) AM")
            
        } else if (hours == 12) {
            return ("12:\(minutes):\(seconds) PM")
            
        } else if (hours < 12) {
            return ("\(hours):\(minutes):\(seconds) AM")
            
        } else {
            return ("\(hours - 12):\(minutes):\(seconds) PM")
        }
    }
    
    func sum(time: TimeTG) -> TimeTG {
        return TimeTG.sum(time1: self, time2: time)
    }
    
    func sub(time: TimeTG) -> TimeTG {
         return TimeTG.sub(time1: self, time2: time)
    }
    
    class func sum(time1: TimeTG, time2: TimeTG) -> TimeTG {
        var overflow: UInt;
        var sum: UInt;

        sum = time1.seconds + time2.seconds;
        let seconds = sum % 60;
        overflow = sum / 60;

        sum = time1.minutes + time2.minutes + overflow;
        let minutes = sum % 60;
        overflow = sum / 60;

        sum = time1.hours + time2.hours + overflow;
        let hours = sum % 24;

        return try! TimeTG(hours: hours, minutes: minutes, seconds: seconds)
    }

    class func sub(time1: TimeTG, time2: TimeTG) -> TimeTG {
        var overflow: UInt;
        var diff: UInt;

        if (time2.seconds > time1.seconds) {
            diff = 60 + time1.seconds - time2.seconds;
            overflow = 1;
        } else {
            diff = time1.seconds - time2.seconds;
            overflow = 0;
        }
        let seconds = diff;

        if (time2.minutes + overflow > time1.minutes) {
            diff = 60 + time1.minutes - time2.minutes - overflow;
            overflow = 1;
        } else {
            diff = time1.minutes - time2.minutes - overflow;
            overflow = 0;
        }
        let minutes = diff;

        if (time2.hours + overflow > time1.hours) {
            diff = 24 + time1.hours - time2.hours - overflow;
            overflow = 1;
        } else {
            diff = time1.hours - time2.hours - overflow;
        }
        let hours = diff;

        return try! TimeTG(hours: hours, minutes: minutes, seconds: seconds)
    }
    
}


var time = TimeTG()
var time1 = try TimeTG(hours: 16, minutes: 45, seconds: 23)
var time2 = try TimeTG(hours: 3, minutes: 54, seconds: 48)

print("intitial")
print(time.format())
print(time1.format())
print(time2.format())

print("sum")
print(time.sum(time: time1).format())
print(time1.sum(time: time2).format())
print(time2.sum(time: time1).format())

print("sub")
print(time.sub(time: time1).format())
print(time1.sub(time: time2).format())
print(time2.sub(time: time1).format())

