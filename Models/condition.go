package Models

import "gorm.io/gorm"

type Condition struct {
	gorm.Model
	Name     string  `json:"name"`
	Price    float64 `json:"price"`
	DoctorID uint    `json:"doctor_id"`
}
