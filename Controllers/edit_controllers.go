package Controllers

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/Shawket4/Dentex/Messaging"
	"github.com/Shawket4/Dentex/Models"
	"github.com/Shawket4/Dentex/Utils/Token"
	"github.com/gin-gonic/gin"
)

func EditTreatment(c *gin.Context) {
	var input Models.Treatment
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var treatment Models.Treatment
	if err := Models.DB.Model(&Models.Treatment{}).Where("id = ?", input.ID).Find(&treatment).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	input.DoctorID = treatment.DoctorID
	treatment = input
	var appointments []Models.Appointment
	if err := Models.DB.Model(&Models.Appointment{}).Where("condition_id = ?", treatment.ID).Find(&appointments).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	for _, appointment := range appointments {
		appointment.HexColor = treatment.HexColor
		if err := Models.DB.Save(&appointment).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
			return
		}
	}
	if err := Models.DB.Save(&treatment).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Updated Successfully"})
}

func EditAppointment(c *gin.Context) {
	var input Models.Appointment
	// var input struct {
	// 	ID uint `json:"id"`
	// }
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var appointment Models.Appointment

	if err := Models.DB.Model(&Models.Appointment{}).Where("id = ?", input.ID).Find(&appointment).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}

	if err := Models.DB.Delete(&Models.TimeBlock{}, appointment.TimeBlockID).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	appointment = input
	user_id, err := Token.ExtractTokenID(c)

	if err != nil {
		c.String(http.StatusBadRequest, "Unauthorized Token Extraction")
		c.Abort()
		return
	}

	user, err := Models.GetUserByID(user_id)
	if err != nil {
		c.String(http.StatusBadRequest, "Unauthorized User Extraction")
		c.Abort()
		return
	}

	var doctor Models.Doctor
	if err := Models.DB.Model(&Models.Doctor{}).Where("user_id = ?", user.ID).Preload("Schedule").Find(&doctor).Error; err != nil {
		c.String(http.StatusBadRequest, "Unauthorized User Extraction")
		c.Abort()
		return
	}

	var treatment Models.Treatment

	if err := Models.DB.Model(&Models.Treatment{}).Where("id = ?", appointment.ConditionID).Select("name", "price", "hex_color").Find(&treatment).Error; err != nil {
		c.String(http.StatusBadRequest, "Unauthorized User Extraction")
		c.Abort()
		return
	}
	appointment.DoctorID = doctor.ID
	appointment.Treatment = treatment.Name
	// appointment.Price = treatment.Price
	appointment.HexColor = treatment.HexColor
	if err := Models.DB.Model(&Models.Schedule{}).Where("doctor_id = ?", doctor.ID).Preload("TimeBlocks").Find(&doctor.Schedule).Error; err != nil {
		c.String(http.StatusBadRequest, "Unauthorized User Extraction")
		c.Abort()
		return
	}
	timeBlock, err := Models.CreateTimeBlock(doctor.Schedule, appointment)
	if err != nil {
		c.String(http.StatusBadRequest, "Unauthorized User Extraction")
		c.Abort()
		return
	}
	doctor.Schedule.TimeBlocks = append(doctor.Schedule.TimeBlocks, timeBlock)
	fmt.Println(doctor.Schedule.TimeBlocks)
	if err := Models.DB.Model(&doctor.Schedule).Association("TimeBlocks").Replace(&doctor.Schedule.TimeBlocks); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	if err := Models.DB.Model(&Models.TimeBlock{}).Find(&doctor.Schedule.TimeBlocks).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	if err := Models.DB.Model(&doctor.Schedule.TimeBlocks[len(doctor.Schedule.TimeBlocks)-1]).Association("Appointment").Replace(&appointment); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	var toothAppointments []Models.Appointment
	if err := Models.DB.Model(&Models.Appointment{}).Where("tooth_id = ?", appointment.ToothID).Find(&toothAppointments).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	var newestAppointment Models.Appointment
	for i, s := range toothAppointments {
		t, err := time.Parse("2006/01/02 & 3:04 PM", s.DateTime)
		if err != nil {
			log.Println(err)
			c.JSON(http.StatusBadRequest, err)
			return
		}
		var n time.Time
		if i != 0 {
			n, err = time.Parse("2006/01/02 & 3:04 PM", newestAppointment.DateTime)
			if err != nil {
				log.Println(err)
				c.JSON(http.StatusBadRequest, err)
				return
			}
			if t.After(n) {
				newestAppointment = s
			}
		}
		if i == 0 {
			newestAppointment = s
		}
	}
	if newestAppointment.DateTime == appointment.DateTime {
		var tooth Models.Tooth
		if err := Models.DB.Model(&Models.Tooth{}).Where("id = ?", appointment.ToothID).Find(&tooth).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusBadRequest, err)
			return
		}
		tooth.Condition = appointment.Treatment
		if err := Models.DB.Save(&tooth).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusBadRequest, err)
			return
		}
	}
	if err := Models.DB.Save(&appointment).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	if err := Models.DB.Model(&Models.Patient{}).Select("name").Where("id = ?", appointment.PatientID).Find(&appointment.PatientName).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	Messaging.SendMessage(user.Tokens, "Appointment Updated", fmt.Sprintf("%s's Appointment Has Been Updated", appointment.PatientName))
	c.JSON(http.StatusOK, gin.H{"message": "Updated Successfully"})
}

func EditPatient(c *gin.Context) {
	var input Models.Patient
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	var patient Models.Patient

	if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", input.ID).Preload("PatientTeethMap").Find(&patient).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}

	if err := Models.DB.Model(&Models.TeethMap{}).Where("id = ?", patient.PatientTeethMap.ID).Preload("Teeth").Find(&patient.PatientTeethMap).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	input.PatientTeethMap = patient.PatientTeethMap
	input.DoctorID = patient.DoctorID
	input.IsFavourite = patient.IsFavourite
	patient = input
	if err := Models.DB.Save(&patient).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Updated Successfully"})
}

func EditPrescription(c *gin.Context) {
	var input Models.Prescription
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	var prescription Models.Prescription
	if err := Models.DB.Model(&Models.Prescription{}).Preload("PrescriptionItems").Where("id = ?", input.ID).Find(&prescription).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	for _, item := range prescription.PrescriptionItems {
		if err := DeletePrescriptionItemByID(item.ID); err != nil {
			log.Println(err)
			c.JSON(http.StatusBadRequest, err)
			return
		}
	}
	input.PatientID = prescription.PatientID
	input.DoctorID = prescription.DoctorID
	prescription = input
	if err := Models.DB.Save(&prescription).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Updated Successfully"})
}
