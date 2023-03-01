package Controllers

import (
	"fmt"
	"log"
	"net/http"

	"github.com/Shawket4/ClinicManagement/Models"
	"github.com/Shawket4/ClinicManagement/Utils/Token"
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
)

func RegisterDoctor(c *gin.Context) {
	var input RegisterInput
	if err := c.ShouldBindBodyWith(&input, binding.JSON); err != nil {
		c.String(http.StatusBadRequest, "Bad Request")
		c.Abort()
		return
	}
	user := Models.User{}

	user.Username = input.Username
	user.Password = input.Password
	user.Permission = 1
	_, err := user.SaveUser()

	if err != nil {
		c.String(http.StatusBadRequest, "Failed To Register User")
		c.Abort()
		return
	}
	var doctor Models.Doctor

	fmt.Println(doctor)
	if err := c.ShouldBindBodyWith(&doctor, binding.JSON); err != nil {
		log.Println(err.Error())
		c.JSON(http.StatusBadRequest, err)
		return
	}
	doctor.UserID = user.ID
	if err := Models.DB.Model(&Models.Doctor{}).Create(&doctor).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Registered Successfully"})
}

func RegisterPatient(c *gin.Context) {
	var patient Models.Patient
	if err := c.ShouldBindBodyWith(&patient, binding.JSON); err != nil {
		log.Println(err.Error())
		c.JSON(http.StatusBadRequest, err)
		return
	}
	if err := Models.DB.Model(&Models.Patient{}).Create(&patient).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Registered Successfully"})
}

func RegisterAppointment(c *gin.Context) {
	var appointment Models.Appointment
	if err := c.ShouldBindBodyWith(&appointment, binding.JSON); err != nil {
		log.Println(err.Error())
		c.JSON(http.StatusBadRequest, err)
		return
	}
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
	if user.Permission != 2 {
		appointment.DoctorID = user.ID
	}
	if err := Models.DB.Model(&Models.Appointment{}).Create(&appointment).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Registered Successfully"})
}

func GetAllDoctors(c *gin.Context) {
	var doctors []Models.Doctor
	if err := Models.DB.Model(&Models.Doctor{}).Find(&doctors).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
	}
	c.JSON(http.StatusOK, doctors)
}

func GetAllPatients(c *gin.Context) {
	var patients []Models.Patient
	if err := Models.DB.Model(&Models.Patient{}).Find(&patients).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
	}
	c.JSON(http.StatusOK, patients)
}

func GetDoctorAppointments(c *gin.Context) {
	var appointments []Models.Appointment
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
	fmt.Println(user.ID)
	if err := Models.DB.Model(&Models.Appointment{}).Where("doctor_id = ?", user.ID).Find(&appointments).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
	}
	for i, s := range appointments {
		var patientName string
		if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", s.PatientID).Select("name").Find(&patientName); err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
		}
		appointments[i].PatientName = patientName
	}
	c.JSON(http.StatusOK, appointments)
}
