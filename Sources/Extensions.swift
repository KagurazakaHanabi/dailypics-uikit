import UIKit

extension UIColor {
    convenience init(hexString: String) {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }

        var val = UInt64()
        Scanner(string: hex).scanHexInt64(&val)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (val >> 8) * 17, (val >> 4 & 0xF) * 17, (val & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, val >> 16, val >> 8 & 0xFF, val & 0xFF)
        case 8:
            (a, r, g, b) = (val >> 24, val >> 16 & 0xFF, val >> 8 & 0xFF, val & 0xFF)
        default:
            (a, r, g, b) = (0, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255,
                  blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    func isDark() -> Bool {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r * 255 * 299 + g * 255 * 587 + b * 255 * 114) / 1000 < 128;
    }

    func invert() -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: 1.0 - r , green: 1.0 - g, blue: 1.0 - b, alpha: a)
    }
}
