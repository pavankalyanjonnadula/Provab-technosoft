
import Foundation

struct DoctorData: Codable {

	let doctorDetails: DoctorDetails?
	let slotTimings: [SlotTimings]?

	private enum CodingKeys: String, CodingKey {
		case doctorDetails = "doctor_details"
		case slotTimings = "slot_timings"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		doctorDetails = try values.decode(DoctorDetails.self, forKey: .doctorDetails)
		slotTimings = try values.decode([SlotTimings].self, forKey: .slotTimings)
	}

}
