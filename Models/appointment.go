package Models

import "gorm.io/gorm"

type Appointment struct {
	gorm.Model
	DoctorID  uint    `json:"doctor_id"`
	PatientID uint    `json:"patient_id"`
	Treatment string  `json:"treatment"`
	Price     float64 `json:"price"`
	Paid      bool    `json:"paid"`
}
