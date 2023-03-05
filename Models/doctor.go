package Models

import "gorm.io/gorm"

type Doctor struct {
	gorm.Model
	Name           string   `json:"name"`
	UserID         uint     `json:"user_id"`
	Phone          string   `json:"phone"`
	Specialization string   `json:"specialization"`
	ClinicName     string   `json:"clinic_name"`
	ClinicAddress  string   `json:"clinic_address"`
	Schedule       Schedule `json:"schedule"`
	// DoctorWorkingHours []DoctorWorkingHour `json:"doctor_working_hours"`
	PhotoUrl string `json:"photo_url"`
}

type Schedule struct {
	gorm.Model
	DoctorID   uint
	TimeBlocks []TimeBlock `json:"time_blocks"`
}

// type DoctorWorkingHour struct {
// 	gorm.Model
// 	DoctorID uint
// 	Time     string `json:"time"`

// }

type TimeBlock struct {
	gorm.Model
	ScheduleID  uint
	DateTime    string      `json:"date"`
	IsAvailable bool        `json:"is_available"`
	Appointment Appointment `json:"appointment"`
}

// func CreateDoctorWorkingHours(doctor *Doctor) {
// 	var workingHours []DoctorWorkingHour = []DoctorWorkingHour{{DoctorID: doctor.ID, Time: "07:00 AM"}, {DoctorID: doctor.ID, Time: "07:30 AM"}, {DoctorID: doctor.ID, Time: "08:00 AM"}, {DoctorID: doctor.ID, Time: "08:30 AM"}, {DoctorID: doctor.ID, Time: "09:00 AM"}, {DoctorID: doctor.ID, Time: "09:30 AM"}}
// 	doctor.DoctorWorkingHours = workingHours
// }

func CreateTimeBlock(schedule Schedule, appointment Appointment) (TimeBlock, error) {
	return TimeBlock{ScheduleID: schedule.ID, IsAvailable: false, DateTime: appointment.DateTime, Appointment: appointment}, nil
}
