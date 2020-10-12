
import Foundation

struct MainModel: Codable {

	let status: Int?
	let message: String?
	let data: DoctorData?

	private enum CodingKeys: String, CodingKey {
		case status = "status"
		case message = "message"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decode(Int.self, forKey: .status)
		message = try values.decode(String.self, forKey: .message)
		data = try values.decode(DoctorData.self, forKey: .data)
	}

}
