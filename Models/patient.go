package Models

import (
	"fmt"

	"gorm.io/gorm"
)

type Patient struct {
	gorm.Model
	Name            string   `json:"name"`
	DoctorID        uint     `json:"doctor_id"`
	Address         string   `json:"address"`
	Phone           string   `json:"phone"`
	Gender          string   `json:"gender"`
	Age             int      `json:"age"`
	IsFavourite     bool     `json:"is_favourite"`
	PatientTeethMap TeethMap `json:"patient_teeth_map"`
}

type TeethMap struct {
	gorm.Model
	PatientID uint
	Teeth     []Tooth `json:"teeth" gorm:"foreignKey:TeethMapID"`
}

type Tooth struct {
	gorm.Model
	ToothCode    string `json:"tooth_code"`
	TeethMapID   uint
	Condition    string `json:"condition"`
	IsTreated    bool   `json:"is_treated"`
	ToothHistory []Appointment
}

func CreatePatientTeethMap(patient Patient) TeethMap {
	var teethMap = patient.PatientTeethMap
	for i := 1; i <= 8; i++ {
		teethMap.Teeth = append(teethMap.Teeth, Tooth{gorm.Model{}, fmt.Sprintf("LB%v", i), teethMap.ID, "None", false, nil})
	}
	for i := 1; i <= 8; i++ {
		teethMap.Teeth = append(teethMap.Teeth, Tooth{gorm.Model{}, fmt.Sprintf("LT%v", i), teethMap.ID, "None", false, nil})
	}
	for i := 1; i <= 8; i++ {
		teethMap.Teeth = append(teethMap.Teeth, Tooth{gorm.Model{}, fmt.Sprintf("RB%v", i), teethMap.ID, "None", false, nil})
	}
	for i := 1; i <= 8; i++ {
		teethMap.Teeth = append(teethMap.Teeth, Tooth{gorm.Model{}, fmt.Sprintf("RT%v", i), teethMap.ID, "None", false, nil})
	}
	return teethMap
}
