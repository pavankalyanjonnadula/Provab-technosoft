
import Foundation

struct ScheduleTimings: Codable {

	let time: String?
	let id: Int?
	let eventId: Int?
	let status: Int?
	let duration: String?
	let startDate: String?
	let procedureId: Int?
	let isPastDate: Int?
	let endDate: String?

	private enum CodingKeys: String, CodingKey {
		case time = "time"
		case id = "id"
		case eventId = "event_id"
		case status = "status"
		case duration = "duration"
		case startDate = "start_date"
		case procedureId = "procedure_id"
		case isPastDate = "is_past_date"
		case endDate = "end_date"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		time = try values.decode(String.self, forKey: .time)
		id = try values.decode(Int.self, forKey: .id)
		eventId = try values.decode(Int.self, forKey: .eventId)
		status = try values.decode(Int.self, forKey: .status)
		duration = try values.decode(String.self, forKey: .duration)
		startDate = try values.decode(String.self, forKey: .startDate)
		procedureId = try values.decode(Int.self, forKey: .procedureId)
		isPastDate = try values.decode(Int.self, forKey: .isPastDate)
		endDate = try values.decode(String.self, forKey: .endDate)
	}

}
