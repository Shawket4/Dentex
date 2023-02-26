package Models

import "gorm.io/gorm"

type Doctor struct {
	gorm.Model
	Name           string `json:"name"`
	UserID         uint   `json:"user_id"`
	Phone          string `json:"phone"`
	Specialization string `json:"specialization"`
	ClinicName     string `json:"clinic_name"`
	ClinicAddress  string `json:"clinic_address"`
	PhotoUrl       string `json:"photo_url"`
}
