package Controllers

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

// TODO: Test Function
func DeletePatient(c *gin.Context) {
	var input struct {
		ID uint `json:"id"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	fmt.Println(input.ID)
	if err := DeletePatientByID(input.ID); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Patient Deleted Successfully"})
}

// TODO: Test Function
func DeleteTreatment(c *gin.Context) {
	var input struct {
		ID uint `json:"id"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	if err := DeleteTreatmentByID(input.ID); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Treatment Deleted Successfully"})
}

func DeleteAppointment(c *gin.Context) {
	var input struct {
		ID uint `json:"id"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)

	}

	if err := DeleteAppointmentByID(input.ID); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
	}
	c.JSON(http.StatusOK, gin.H{"message": "Appointm	ent Deleted Successfully"})
}

// TODO: Test Function
func DeleteDoctor(c *gin.Context) {
	var input struct {
		ID uint `json:"id"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	if err := DeleteDoctorByID(input.ID); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Doctor Deleted Successfully"})
}

// TODO: Test Function
func DeletePrescription(c *gin.Context) {
	var input struct {
		ID uint `json:"id"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	if err := DeletePrescriptionByID(input.ID); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Prescription Deleted Successfully"})
}
