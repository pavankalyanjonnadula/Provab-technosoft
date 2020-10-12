
import Foundation

struct SlotTimings: Codable {

	let date: String?
	let availableSlots: Int?
	let scheduleTimings: [ScheduleTimings]?

	private enum CodingKeys: String, CodingKey {
		case date = "date"
		case availableSlots = "available_slots"
		case scheduleTimings = "schedule_timings"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		date = try values.decode(String.self, forKey: .date)
		availableSlots = try values.decode(Int.self, forKey: .availableSlots)
		scheduleTimings = try values.decode([ScheduleTimings].self, forKey: .scheduleTimings)
	}

}
