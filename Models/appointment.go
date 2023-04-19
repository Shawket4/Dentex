package Models

import (
	"gorm.io/gorm"
)

type Appointment struct {
	gorm.Model
	DateTime    string `json:"date"`
	TimeBlockID uint
	DoctorID    uint    `json:"doctor_id"`
	PatientID   uint    `json:"patient_id"`
	Patient     Patient `gorm:"-" json:"patient"`
	ConditionID uint    `json:"condition_id"`
	// IsBraces    bool    `json:"is_braces"`
	// BracesID    uint    `json:"braces_id"`
	PatientName string  `json:"patient_name" gorm:"-"`
	Treatment   string  `json:"treatment"`
	Price       float64 `json:"price"`
	HexColor    string  `json:"hex_color"`
	IsCompleted bool    `json:"is_completed"`
	IsPaid      bool    `json:"is_paid"`
	ToothID     uint    `json:"tooth_id"`
	ToothCode   string  `json:"tooth_code" gorm:"-"`
	Notes       string  `json:"notes"`
}

// type BracesAppointment struct {
// 	gorm.Model
// 	DateTime    string `json:"date"`
// 	TimeBlockID uint
// 	DoctorID    uint    `json:"doctor_id"`
// 	PatientID   uint    `json:"patient_id"`
// 	ConditionID uint    `json:"condition_id"`
// 	IsBraces    bool    `json:"is_braces"`
// 	BracesID    uint    `json:"braces_id"`
// 	PatientName string  `json:"patient_name" gorm:"-"`
// 	Treatment   string  `json:"treatment"`
// 	Price       float64 `json:"price"`
// 	HexColor    string  `json:"hex_color"`
// 	IsCompleted bool    `json:"is_completed"`
// 	IsPaid      bool    `json:"is_paid"`
// 	ToothID     uint    `json:"tooth_id"`
// 	ToothCode   string  `json:"tooth_code" gorm:"-"`
// 	Notes       string  `json:"notes"`
// }
