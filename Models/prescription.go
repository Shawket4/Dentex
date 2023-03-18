package Models

import "gorm.io/gorm"

type Prescription struct {
	gorm.Model
	PrescriptionItems []PrescriptionItem `json:"prescription_items"`
	PatientID         uint               `json:"patient_id"`
	Date              string             `json:"date"`
}

type PrescriptionItem struct {
	gorm.Model
	Name           string `json:"name"`
	Notes          string `json:"notes"`
	PrescriptionID uint
}
