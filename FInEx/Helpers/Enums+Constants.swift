//
//  Formatters+Enums.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-14.
//

import SwiftUI

enum KeychainAccessKeys {
    static let AppleIDCredential = "userIdentifierAppleIDCredential"
    static let Passcode = "passcode"
    static let ServiceName = "zh.ayazbayeva.FInEx"
}

enum Coordinator {
  static func topViewController(_ viewController: UIViewController? = nil) -> UIViewController? {
    let vc = viewController ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
    if let navigationController = vc as? UINavigationController {
      return topViewController(navigationController.topViewController)
    } else if let tabBarController = vc as? UITabBarController {
      return tabBarController.presentedViewController != nil ? topViewController(tabBarController.presentedViewController) : topViewController(tabBarController.selectedViewController)
      
    } else if let presentedViewController = vc?.presentedViewController {
      return topViewController(presentedViewController)
    }
    return vc
  }
}

enum ActiveSheet: Identifiable {
    case add
    case edit
    
    var id: Int {
        hashValue
    }
}

// MARK: - Currencies
enum Currencies: String {
    case dollar
    case euro
    case lira
    case pound
    case ruble
    case tenge
    case yen
    case currency
}

// MARK: - ColorTheme
enum ColorTheme: String, CaseIterable {
    case purple = "purple"
    case orange = "orange"
    case blue = "blue"
    case pink = "pink"
}

// MARK: - Remainders

enum MonthlyRemainderDay: Int, CaseIterable {
    
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case eleven = 11
    case twelve = 12
    case thirteen = 13
    case fourteen = 14
    case fifteen = 15
    case sixteen = 16
    case seventeen = 17
    case eighteen = 18
    case nineteen = 19
    case twenty = 20
    case twentyOne = 21
    case twentyTwo = 22
    case twentyThree = 23
    case twentyFour = 24
    case twentyFive = 25
    case twentySix = 26
    case twentySeven = 27
    case twentyEight = 28
    case twentyNine = 29
    case thirty = 30
}

enum DailyRemainderTime: String, CaseIterable {

    case six = "06.00"
    case seven = "07.00"
    case eight = "08.00"
    case nine = "09.00"
    case ten = "10.00"
    case eleven = "11.00"
    case twelve = "12.00"
    case thirteen = "13.00"
    case fourteen = "14.00"
    case fifteen = "15.00"
    case sixteen = "16.00"
    case seventeen = "17.00"
    case eighteen = "18.00"
    case nineteen = "19.00"
    case twenty = "20.00"
    case twentyOne = "21.00"
    case twentyTwo = "22.00"

}

enum LocalNotificationTexts: String, CaseIterable {
    case dailyTitle = "local_key_notification_DailyTitle"
    case dailyBody = "local_key_notification_DailyBody"
    case monthlyTitle = "local_key_notification_MonthlyTitle"
    case monthlyBody = "local_key_notification_MonthlyBody"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum LocalNotificationIDs {
    static let dailyNotificationID = "dailyNotificationID"
    static let monthlyNotification = "monthlyNotification"
}

// MARK: - LabelTitles
enum LableTitles: String {
    case startDate = "local_key_labelTitle_StartDate"
    case passcodeFieldTitle_new = "local_key_labelTitle_passcodeFieldTitle_new"
    case passcodeFieldTitle_reset = "local_key_labelTitle_passcodeFieldTitle_reset"
    
    case saveButton = "local_key_labelTitle_SaveButton"
    case resetButton = "local_key_labelTitle_ResetButton"
    case withdrawButton = "local_key_labelTitle_WithdrawButton"
    
    case registerTab = "local_key_labelTitle_RegisterTab"
    case recurringTab = "local_key_labelTitle_RecurringTab"
    case categoriesTab = "local_key_labelTitle_CategoriesTab"
    case passcodeTab = "local_key_labelTitle_PasscodeTab"
    case remainderTab = "local_key_labelTitle_RemainderTab"
    case appearanceTab = "local_key_labelTitle_AppearanceTab"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

// MARK: - Currency Symbols
enum CurrencySymbols: String, CaseIterable {
    case dollar = "$"
    case euro = "€"
    case yen = "¥"
    case pound = "£"
    case ruble = "₽"
    case tenge = "₸"
    case lira = "₤"
}

// MARK: - Periodicity
enum Periodicity: String, CaseIterable {
   
    case TwoWeeks = "local_key_periodicity_TwoWeeks"
    case Month = "local_key_periodicity_EveryMonth"
    case Quarter = "local_key_periodicity_Quarter"
    case Year = "local_key_periodicity_EveryYear"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}


// MARK: - Placeholders

enum Placeholders: String {
    case Amount = "$"
    case Note = "local_key_placeholder_Note"
    case NewCategorySelector = "local_key_placeholder_Category"
    case PieSliceDescriptionExpense = "local_key_placeholder_ExpensesByCategory"
    case PieSliceDescriptionIncome = "local_key_placeholder_IncomeByCategory"
    case PieSliceDescriptionSaving = "local_key_placeholder_SavingsByCategory"
    case Required = "local_key_placeholder_Required"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}


// MARK: - Warning Messages
enum WarningMessages: String {
    case ValidationAmountFail = "local_key_warningMessage_ValidationAmountFail"
    case ValidationCategoryNotSelectedFail = "local_key_warningMessage_ValidationCategoryNotSelectedFail"
    case RequiredField = "local_key_warningMessage_RequiredField"
    case ExistingCategory = "local_key_warningMessage_ExistingCategory"
    case CheckBalance = "local_key_warningMessage_CheckBalance"
    case noDataPlaceholder = "local_key_warningMessage_noDataPlaceholder"
    case AvailableRecurringTransction = "local_key_warningMessage_AvailableRecurringTransction"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

// MARK: - SettingsContentDescription
enum SettingsContentDescription: String {
    case passcodeTab_field1 = "local_key_passcodeTab_field1"
    case passcodeTab_field2 = "local_key_passcodeTab_field2"
    case passcodeTab_field3 = "local_key_passcodeTab_field3"
    case passcodeTab_description1 = "local_key_passcodeTab_description1"
    case passcodeTab_mainDescription = "local_key_passcodeTab_mainDescription"
    
    case registerTab_title = "local_key_registerTab_title"
    case registerTab_description1 = "local_key_registerTab_description1"
    case registerTab_description1_signed = "local_key_registerTab_description1_signed"
    case registerTab_description2 = "local_key_registerTab_description2"
    case registerTab_description2_signed = "local_key_registerTab_description2_signed"
    case registerTab_description3 = "local_key_registerTab_description3"
    case registerTab_mainDescription = "local_key_registerTab_mainDescription"
    
    case recurringTab_mainDescription = "local_key_recurringTab_mainDescription"
    case recurringTab_field1 = "local_key_recurringTab_field1"
    
    case categoriesTab_mainDescription = "local_key_categoriesTab_mainDescription"
    
    case appearanceTab_mainDescription = "local_key_appearanceTab_mainDescription"
    case appearanceTab_field1_title = "local_key_appearanceTab_field1_title"
    case appearanceTab_field2_title = "local_key_appearanceTab_field2_title"
    case appearanceTab_field2 = "local_key_appearanceTab_field2"
    case appearanceTab_field3_title = "local_key_appearanceTab_field3_title"
    
    case reminderTab_mainDescription = "local_key_reminderTab_mainDescription"
    case reminderTab_field1_title = "local_key_reminderTab_field1_title"
    case reminderTab_field1 = "local_key_reminderTab_field1"
    case reminderTab_description1 = "local_key_reminderTab_description1"
    case reminderTab_field2_title = "local_key_reminderTab_field2_title"
    case reminderTab_description2 = "local_key_reminderTab_description2"
    case reminderTab_field2 = "local_key_reminderTab_field2"
    case reminderTab_field1_pickerDescription = "local_key_reminderTab_field1_pickerDescription"
    case reminderTab_field2_pickerDescription = "local_key_reminderTab_field2_pickerDescription"
    case reminderTab_field2_pickerLabel = "local_key_reminderTab_field2_pickerLabel"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

// MARK: - Months short name
enum MonthsShortName: String {
    case jan
    case feb
    case mar
    case apr
    case may
    case jun
    case jul
    case aug
    case sep
    case oct
    case nov
    case dec
}

// MARK: - AnalyticsContentDescription
enum AnalyticsContentDescription: String {
    case barChartTitle = "local_key_barChartTitle"
    case barChartDescription = "local_key_barChartDescription"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

// MARK: - Colors
enum CustomColors {
    static let CloudBlue = Color("CloudBlue")
    static let ExpensesColor = Color("ExpensesColor")
    static let ExpensesColor2 = Color("ExpensesColor2")
    static let HomeButtonGradient1 = Color("HomeButtonGradient1")
    static let HomeButtonGradient2 = Color("HomeButtonGradient2")
    static let IncomeGradient1 = Color("BalanceColor")
    static let IncomeGradient2 = Color("NewBalanceColor")
    static let SaveButtonGradient1 = Color("SaveButtonGradient1")
    static let SaveButtonGradient2 = Color("SaveButtonGradient2")
    static let SavingsGradient1 = Color("IncomeColor")
    static let SavingsGradient2 = Color("SavingsColor")
    static let TextDarkGray = Color("TextDarkGray")
    static let ToolsIconsGradient1 = Color("ToolsIconsGradient1")
    static let ToolsIconsGradient2 = Color("ToolsIconsGradient2")
    static let TopColorGradient1 = Color("TopColor")
    static let TopColorGradient2 = Color("TopGradient")
    
    static let TopBackgroundGradient1 = Color("TopBackgroundGradient1")
    static let TopBackgroundGradient2 = Color("TopBackgroundGradient2")
    static let TopBackgroundGradient3 = Color("TopBackgroundGradient3")
    
    static let CustomBlue = Color("CustomBlue")
    static let CustomGreen = Color("CustomGreen")
    static let CustomPink = Color("CustomPink")
    static let CustomPurple = Color("CustomPurple")
    static let CustomRed = Color("CustomRed")
    static let CustomYellow = Color("CustomYellow")
    
    static let Theme_purple = Color("Theme_purple")
    static let Theme_orange = Color("Theme_orange")
    static let Theme_blue = Color("Theme_blue")
    static let Theme_pink = Color("Theme_pink")
    
    static let White_Background = Color("WhiteBackground")
 }

enum GradientColors {
    typealias RawValue = LinearGradient
    
    static let TopBackground = LinearGradient(gradient: Gradient(colors: [Color.white, CustomColors.TopBackgroundGradient2, CustomColors.TopBackgroundGradient3, Color.white]), startPoint: .bottomTrailing, endPoint: .topLeading)
    
    static let Expense = LinearGradient(gradient: Gradient(colors: [Color("ExpensesColor"), Color("ExpensesColor2")]), startPoint: .bottomTrailing, endPoint: .topLeading)
    static let Income = LinearGradient(gradient: Gradient(colors: [Color("BalanceColor"), Color("NewBalanceColor")]), startPoint: .bottomTrailing, endPoint: .topLeading)
    static let Saving = LinearGradient(gradient: Gradient(colors: [Color("IncomeColor"), Color("SavingsColor")]), startPoint: .bottomTrailing, endPoint: .topLeading)
    
    static let Home = LinearGradient(gradient: Gradient(colors: [Color("HomeButtonGradient1"), Color("HomeButtonGradient2")]), startPoint: .bottomTrailing, endPoint: .topLeading)
    
    static let TransactionAmountTextField = LinearGradient(gradient: Gradient(colors: [Color("TextFieldBackgroundLight"), Color("TextFieldBackgroundDark"), Color("TextFieldBackgroundLight")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static let TabBarBackground = LinearGradient(gradient: Gradient(colors: [CustomColors.TopColorGradient2, Color.white]), startPoint: .bottomLeading, endPoint: .topLeading)
    
    static let SaveButton = LinearGradient(gradient: Gradient(colors: [CustomColors.SaveButtonGradient2, CustomColors.SaveButtonGradient1]), startPoint: .bottom, endPoint: .top)
    
    static let WithdrawButton = LinearGradient(gradient: Gradient(colors: [CustomColors.SavingsGradient1, CustomColors.SavingsGradient2]), startPoint: .bottom, endPoint: .top)
}

struct Theme {
    // LinearGradient(gradient: Gradient(colors: [CustomColors.TopColorGradient2, Color.white]), startPoint: .topLeading, endPoint: .bottomLeading)
    static let colors: [String : LinearGradient] = [
        ColorTheme.purple.rawValue : LinearGradient(gradient: Gradient(colors: [CustomColors.Theme_purple, Color.white]), startPoint: .topLeading, endPoint: .bottomLeading),
        ColorTheme.pink.rawValue : LinearGradient(gradient: Gradient(colors: [CustomColors.Theme_pink, Color("Theme_orange-1"), Color.white, Color("Theme_orange-1"), CustomColors.Theme_pink]), startPoint: .topLeading, endPoint: .bottomTrailing),
        ColorTheme.blue.rawValue : LinearGradient(gradient: Gradient(colors: [CustomColors.Theme_blue, Color.white]), startPoint: .topLeading, endPoint: .bottomLeading),
        ColorTheme.orange.rawValue : LinearGradient(gradient: Gradient(colors: [CustomColors.Theme_orange, Color.white]), startPoint: .topLeading, endPoint: .bottomLeading)
    ]
    
    static let tabbarColor: [String : LinearGradient] = [
        ColorTheme.purple.rawValue : LinearGradient(gradient: Gradient(colors: [CustomColors.Theme_purple, Color.white]), startPoint: .bottomLeading, endPoint: .topLeading),
        ColorTheme.pink.rawValue : LinearGradient(gradient: Gradient(colors: [CustomColors.Theme_pink, Color.white]), startPoint: .bottomLeading, endPoint: .topLeading),
        ColorTheme.blue.rawValue : LinearGradient(gradient: Gradient(colors: [CustomColors.Theme_blue, Color.white]), startPoint: .bottomLeading, endPoint: .topLeading),
        ColorTheme.orange.rawValue : LinearGradient(gradient: Gradient(colors: [CustomColors.Theme_orange, Color.white]), startPoint: .bottomLeading, endPoint: .topLeading)
    ]
}

// MARK: - Categories
enum Categories: CaseIterable {
    static let Income = "Income"
    static let Expense = "Expense"
    static let Saving = "Saving"
    
}
enum Categories2: String,  CaseIterable {
    case Income
    case Expense
    case Saving
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum IncomeTypeNames: String {
    case Salary
    case Bonus
    case Pension
    case Dividends
    case Interest
    case ChildBenefit
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum ExpenseTypeNames: String {
    case Rent
    case Loan
    case Maintenance
    case Furniture
    case Internet
    case Electricity
    case Heating
    case Water
    case Mobile
    case Cinema
    case Concert
    case Hobby
    case Bowling
    case Nightclub
    case Party
    case Restaurant
    case Groceries
    case Delivery
    case Clothing
    case Device
    case Accessories
    case Car
    case TV
    case Music
    case Gas
    case Parking
    case PublicTr
    case Repair
    case Dentist
    case CheckUp
    case Flight
    case Hotel 
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}


enum ExpenseSubCategories: String, CaseIterable {
    case Housing
    case Entertainment
    case FoodAndDrinks
    case Bills
    case Transportation
    case Health
    case Subscriptions
    case Insurance
    case Travel
    case Shopping
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum SavingTypeNames: String {
    case Cash
    case Investments
    case Shopping
    case Education
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum SvaingSubCategories: String, CaseIterable {
    case LongTerm
    case ShortTerm
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}



enum CategoryIcons {
    typealias RawValue = [String]
    
    static let first = ["person.3", "person.crop.square.fill.and.at.rectangle", "eyebrow", "mouth", "lungs", "face.dashed.fill", "person.fill.viewfinder", "figure.walk", "figure.wave", "figure.stand.line.dotted.figure.stand", "hands.sparkles.fill"]
    static let second = ["drop", "flame", "bolt", "hare", "tortoise", "ladybug", "leaf", "heart.text.square", "heart", "bandage.fill", "cross.case.fill", "bed.double", "pills"]
    static let third = ["waveform.path.ecg", "staroflife", "cross", "bag.fill", "cart", "creditcard.fill", "giftcard.fill", "dollarsign.circle.fill", "bitcoinsign.circle.fill"]
}

// MARK: - Fonts
enum Fonts {
    static var light45: Font {
        Font.system(size: 45, weight: .light, design: .default)
    }
    static var light40: Font {
        Font.system(size: 40, weight: .light, design: .default)
    }
    static var light35: Font {
        Font.system(size: 35, weight: .light, design: .default)
    }
    static var light30: Font {
        Font.system(size: 30, weight: .light, design: .default)
    }
    static var light25: Font {
        Font.system(size: 25, weight: .light, design: .default)
    }
    static var light20: Font {
        Font.system(size: 20, weight: .light, design: .default)
    }
    static var light15: Font {
        Font.system(size: 15, weight: .light, design: .default)
    }
    static var light12: Font {
        Font.system(size: 12, weight: .light, design: .default)
    }
    
    static var regular20: Font {
        Font.system(size: 20, weight: .regular, design: .default)
    }
    static var regular22: Font {
        Font.system(size: 22, weight: .regular, design: .default)
    }
    static var regular24: Font {
        Font.system(size: 24, weight: .regular, design: .default)
    }
    static var regular26: Font {
        Font.system(size: 26, weight: .regular, design: .default)
    }
}

// MARK: - Icons
enum Icons {
    static let ChevronLeft = "chevron.left"
    static let CevronRight = "chevron.right"
    static let ChevronCompactLeft = "chevron.compact.left"
    static let ChevronCompactRight = "chevron.compact.right"
    static let PencilAndSquare = "square.and.pencil"
    static let Pencil = "pencil"
    static let Trash = "trash"
    static let Doc = "doc"
    static let Doc_Fill = "doc.fill"
    static let Doc_Arrow_Up = "arrow.up.doc"
    static let Doc_Arrow_Down = "arrow.down.doc"
    static let Book = "book"
    static let Book_Fill = "book.fill"
    static let Book_Closed_Fill = "character.book.closed.fill"
    static let GraduationCap = "graduationcap"
    static let GraduationCat_Fill = "graduationcap.fill"
    static let TicketCinema = "ticket"
    static let Link = "link"
    static let PersonTwo = "person.2"
    static let PersonTwo_Fill = "person.2.fill"
    static let PersonThree = "person.3"
    static let PersonThree_Fill = "person.3.fill"
    static let PersonTwoInSquare_Fill = "person.2.square.stack.fill"
    static let Avatar = "person.crop.square.fill.and.at.rectangle"
    static let Globe = "globe"
    static let MoonStars = "moon.stars.fill"
    static let Sparkles = "sparkles"
    static let Cloud = "cloud"
    static let Cloud_Fill = "cloud.fill"
    static let Flame_Fill = "flame.fill"
    static let Timelapse = "timelapse"
    static let CheckmarkSeal_Fill = "checkmark.seal.fill"
    static let XmarkSeal_Fill = "xmark.seal.fill"
    static let Drop = "drop"
    static let Drop_Fill = "drop.fill"
    static let PlayRectangle_Fill = "play.rectangle.fill"
    static let MusicNote = "music.note"
    static let MusicNoteList = "music.note.list"
    static let MicMusic = "music.mic"
    static let Mic_Fill = "mic.fill"
    static let Triangle_Fill = "triangle.fill"
    static let Diamond_Fill = "diamond.fill"
    static let Octagon_Fill = "octagon.fill"
    static let Hexagon_Fill = "hexagon.fill"
    static let Heart_Fill = "heart.fill"
    static let SuitHeart_Fill = "suit.heart.fill"
    static let SuitClub_Fill = "suit.club.fill"
    static let SuitSpade_Fill = "suit.spade.fill"
    static let SuitDiamond_Fill = "suit.diamond.fill"
    static let Star_Fill = "star.fill"
    static let Flag_Fill = "flag.fill"
    static let Bell_Fill = "bell.fill"
    static let BellCircle = "bell.circle"
    static let Tag_Fill = "tag.fill"
    static let TagCircle = "tag.circle"
    static let Bolt = "bolt"
    static let Bolt_Fill = "bolt.fill"
    static let Eyes_Inverse = "eyes.inverse"
    static let Eyebrow = "eyebrow"
    static let Nose_Fill = "nose.fill"
    static let Mustache_Fill = "mustache.fill"
    static let Mouth_Fill = "mouth.fill"
    static let iCloud = "icloud"
    static let iCloud_Fill = "icloud.fill"
    static let iCloudCheckmark = "checkmark.icloud"
    static let iCloudCheckmark_Fill = "checkmark.icloud.fill"
    static let iCloudLink = "link.icloud"
    static let iCloudLink_Fill = "link.icloud.fill"
    static let iCloudLock = "lock.icloud"
    static let iCloudLock_Fill = "lock.icloud.fill"
    static let iCloudArrow = "arrow.clockwise.icloud"
    static let iCloudArrow_Fill = "arrow.clockwise.icloud.fill"
    static let iCloudArrowUp = "icloud.and.arrow.up"
    static let iCloudArrowUp_Fill = "icloud.and.arrow.up.fill"
    static let FlashLight = "flashlight.on.fill"
    static let Camera = "camera"
    static let Camera_Fill = "camera.fill"
    static let Phone_Fill = "phone.fill"
    static let PhoneConnection_Fill = "phone.fill.connection"
    static let Video_Fill = "video.fill"
    static let Envelope = "envelope"
    static let Envelope_Fill = "envelope.fill"
    static let Gear = "gear"
    static let Gearshape = "gearshape"
    static let Gearshape_Fill = "gearshape.fill"
    static let GearshapeTwo = "gearshape.2"
    static let GearshapeTwo_Fill = "gearshape.2.fill"
    static let Signature = "signature"
    static let CircleSwirlCrossed = "line.3.crossed.swirl.circle.fill"
    static let Scissors = "scissors"
    static let Bag_Fill = "bag.fill"
    static let BagPlusBadge_Fill = "bag.fill.badge.plus"
    static let Cart_Fill = "cart.fill"
    static let CartPlusBadge_Fill = "cart.fill.badge.plus"
    static let CreditCard_Fill = "creditcard.fill"
    static let GiftCard_Fill = "giftcard.fill"
    static let WalletPass_Fill = "wallet.pass.fill"
    static let WandRays_Inverse = "wand.and.rays.inverse"
    static let WandStars_Invers = "wand.and.stars.inverse"
    static let Gauge = "gauge"
    static let GaugePlusBadge = "gauge.badge.plus"
    static let Metronome_Fill = "metronome.fill"
    static let DiceFaceThree_Fill = "die.face.3.fill"
    static let PianoKeys_Inverse = "pianokeys.inverse"
    static let PaintBrush_Fill = "paintbrush.fill"
    static let PaintBrushPointed_Fill = "paintbrush.pointed.fill"
    static let Bandage_Fill = "bandage.fill"
    static let Ruler_Fill = "ruler.fill"
    static let Wrench = "wrench"
    static let Wrench_Fill = "wrench.fill"
    static let Hammer_Fill = "hammer.fill"
    static let WrenchAndScrewDriver_Fill = "wrench.and.screwdriver.fill"
    static let Scroll_Fill = "scroll.fill"
    static let Stethoscope = "stethoscope"
    static let Printer_Fill = "printer.fill"
    static let Scanner_Fill = "scanner.fill"
    static let Briefcase = "briefcase"
    static let Briefcase_Fill = "briefcase.fill"
    static let Case_Fill = "case.fill"
    static let CrossCase = "cross.case"
    static let CrossCase_Fill = "cross.case.fill"
    static let PuzzlePiece = "puzzlepiece"
    static let PuzzlePiece_Fill = "puzzlepiece.fill"
    static let House = "house"
    static let House_Fill = "house.fill"
    static let HouseCircle = "house.circle"
    static let HouseCircle_Fill = "house.circle.fill"
    static let HouseMusicNote = "music.note.house"
    static let HouseMusicNote_Fill = "music.note.house.fill"
    static let BuildingColumns = "building.columns"
    static let BuildingColumns_Fill = "building.columns.fill"
    static let Building = "building"
    static let Building_Fill = "building.fill"
    static let BuildingTwo = "building.2"
    static let BuildingTwo_Fill = "building.2.fill"
    static let BuildingTwoCircle = "building.2.crop.circle"
    static let BuildingtwoCircle_Fill = "building.2.crop.circle.fill"
    static let Lock = "lock"
    static let Lock_Fill = "lock.fill"
    static let LockCircle = "lock.circle"
    static let LockCircle_Fill = "lock.circle.fill"
    static let LockShield = "lock.shield"
    static let LockShield_Fill = "lock.shield.fill"
    static let LockOpen = "lock.open"
    static let LockOpen_Fill = "lock.open.fill"
    static let Key = "key"
    static let Key_Fill = "key.fill"
    static let Wifi = "wifi"
    static let Pin_Fill = "pin.fill"
    static let MappPin = "mappin"
    static let OpticalDisk = "opticaldisc"
    static let TV = "tv"
    static let TV_Fill = "tv.fill"
    static let TV4K_Fill = "4k.tv.fill"
    static let TVPlay_Fill = "play.tv.fill"
    static let iPhone = "iphone"
    static let iPhoneWaves = "iphone.radiowaves.left.and.right"
    static let iPad = "ipad.homebutton.landscape"
    static let AppleWatch = "applewatch"
    static let HomePod_Fill = "homepod.fill"
    static let HifiSpeaker = "hifispeaker.fill"
    static let Radio_Fill = "radio.fill"
    static let SignPost_Fill = "signpost.left.fill"
    static let Guitars = "guitars"
    static let Guitars_Fill = "guitars.fill"
    static let Car = "car"
    static let Car_Fill = "car.fill"
    static let CarBolt_Fill = "bolt.car.fill"
    static let Tram_Fill = "tram.fill"
    static let Bicycle = "bicycle"
    static let BedDouble = "bed.double"
    static let BedDouble_Fill = "bed.double.fill"
    static let Pills_Fill = "pills.fill"
    static let Cross_Fill = "cross.fill"
    static let Hare_Fill = "hare.fill"
    static let Tortois_Fill = "tortoise.fill"
    static let Ant_Fill = "ant.fill"
    static let Ladybug_Fill = "ladybug.fill"
    static let Leaf_Fill = "leaf.fill"
    static let Film = "film"
    static let SportsCourt = "sportscourt"
    static let FaceSmiling_Fill = "face.smiling.fill"
    static let FaceDashed_Fill = "face.dashed.fill"
    static let Crown_Fill = "crown.fill"
    static let Comb_Fill = "comb.fill"
    static let PersonViewFounder_Fill = "person.fill.viewfinder"
    static let Photo_Fill = "photo.fill"
    static let ChessBoard = "checkerboard.rectangle"
    static let CameraAperture = "camera.aperture"
    static let Questionmark = "questionmark"
    static let Checkmark = "checkmark"
    static let CheckmarkRectangle = "checkmark.rectangle"
}


