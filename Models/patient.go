package Models

import "gorm.io/gorm"

type Patient struct {
	gorm.Model
	Name    string `json:"name"`
	Address string `json:"address"`
	Phone   string `json:"phone"`
}
