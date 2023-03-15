package Models

import "gorm.io/gorm"

type Treatment struct {
	gorm.Model
	Name     string  `json:"name"`
	Price    float64 `json:"price"`
	HexColor string  `json:"hex_color"`
	DoctorID uint    `json:"doctor_id"`
}
