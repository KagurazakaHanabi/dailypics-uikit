import Moya
import SwiftyJSON

let TujianApiProvider = MoyaProvider<TujianApi>()

enum TujianApi {
    case text
    case types
    case today
    case random(count: Int = 1)

    /// 获取分页归档
    ///
    /// page 页数，不得超过 [Recents.maximum]
    /// size 每页容量，位于区间 [3, 20]
    /// type 分类 id
    /// option 排序方式，取值为'asc'或'desc'
    case recents(page: Int, size: Int, type: String, option: String)
    
    case details(pid: String)
    case search(keyword: String)
}

extension TujianApi: TargetType {
    var baseURL: URL {
        switch self {
        case .text:
            return URL.init(string: "https://v1.hitokoto.cn")!
        default:
            return URL.init(string: "https://v2.api.dailypics.cn")!
        }
    }

    var path: String {
        switch self {
        case .text:
            return "/"
        case .types:
            return "/sort"
        case .today:
            return "/today"
        case .random:
            return "/random"
        case .recents:
            return "/list"
        case .details:
            return "/member"
        case .search(let keyword):
            let encodedQuery = keyword.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            return "/search/s/\(encodedQuery!)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case .text:
            return .requestParameters(parameters: ["encode": "text"], encoding: URLEncoding.default)
        case .types:
            return .requestPlain
        case .today:
            return .requestPlain
        case .random(let count):
            return .requestParameters(parameters: ["count": count], encoding: URLEncoding.default)
        case .recents(let page, let size, let type, let option):
            let params: [String : Any] = ["page": page, "size": size, "sort": type, "opt": option]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .details(let pid):
            return .requestParameters(parameters: ["id": pid], encoding: URLEncoding.default)
        case .search:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return [
            "User-Agent": "Dailypics/2.0.3 Version/200129 StoryBoard"
        ]
    }
}

struct Photo {
    var id: String
    var tid: String
    var user: String
    var title: String
    var content: String
    var width: Int
    var height: Int
    var originUrl: String
    var cdnUrl: String
    var color: UIColor
    var date: String

    static func fromJson(source: Data) -> Photo {
        let decoded = try! JSON(data: source)
        return fromJson(source: decoded)
    }

    static func fromJson(source: JSON) -> Photo {
        return Photo(
            id: source["PID"].stringValue,
            tid: source["TID"].stringValue,
            user: source["username"].stringValue,
            title: source["p_title"].stringValue,
            content: source["p_content"].stringValue,
            width: source["width"].intValue,
            height: source["height"].intValue,
            originUrl: source["local_url"].stringValue,
            cdnUrl: "https://s1.images.dailypics.cn\(source["nativePath"])!w1080_jpg",
            color: UIColor(hexString: source["theme_color"].stringValue),
            date: source["p_date"].stringValue
        )
    }
}
