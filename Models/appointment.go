package Models

import (
	"gorm.io/gorm"
)

type Appointment struct {
	gorm.Model
	DateTime    string  `json:"date"`
	DoctorID    uint    `json:"doctor_id"`
	PatientID   uint    `json:"patient_id"`
	PatientName string  `json:"patient_name" gorm:"-"`
	Treatment   string  `json:"treatment"`
	Price       float64 `json:"price"`
	IsCompleted bool    `json:"is_completed"`
	IsPaid      bool    `json:"is_paid"`
}
