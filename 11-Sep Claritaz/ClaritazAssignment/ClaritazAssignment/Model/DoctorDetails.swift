
import Foundation

struct DoctorDetails: Codable {

	let firstName: String?
	let lastName: String?
	let userProfile: String?
	let overallRating: String?
	let degreeDetails: String?
	let specialist: String?
	let milesAway: String?

	private enum CodingKeys: String, CodingKey {
		case firstName = "first_name"
		case lastName = "last_name"
		case userProfile = "user_profile"
		case overallRating = "overall_rating"
		case degreeDetails = "degree_details"
		case specialist = "specialist"
		case milesAway = "miles_away"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		firstName = try values.decode(String.self, forKey: .firstName)
		lastName = try values.decode(String.self, forKey: .lastName)
		userProfile = try values.decode(String.self, forKey: .userProfile)
		overallRating = try values.decode(String.self, forKey: .overallRating)
		degreeDetails = try values.decode(String.self, forKey: .degreeDetails)
		specialist = try values.decode(String.self, forKey: .specialist)
		milesAway = try values.decode(String.self, forKey: .milesAway)
	}

}
