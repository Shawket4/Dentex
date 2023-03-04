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
	if err := c.ShouldBindBodyWith(&patient, binding.JSON); err != nil {
		log.Println(err.Error())
		c.JSON(http.StatusBadRequest, err)
		return
	}
	patient.DoctorID = user.ID
	patient.PatientTeethMap = Models.CreatePatientTeethMap(patient)
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

func ChangeAppointmentPaymentStatus(c *gin.Context) {
	var input struct {
		AppointmentID uint `json:"appointment_id"`
		PaymentStatus bool `json:"payment_status"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.String(http.StatusBadRequest, "Couldn't Parse Input")
		c.Abort()
		return
	}
	var appointment Models.Appointment
	if err := Models.DB.Model(&Models.Appointment{}).Where("id = ?", input.AppointmentID).Find(&appointment).Error; err != nil {
		c.String(http.StatusBadRequest, "Couldn't Find Appointment")
		c.Abort()
		return
	}
	appointment.IsPaid = input.PaymentStatus
	if err := Models.DB.Save(&appointment).Error; err != nil {
		c.String(http.StatusBadRequest, "Couldn't Update Appointment Payment Status")
		c.Abort()
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Payment Status Updated Successfully"})
}

func ChangeAppointmentCompletionStatus(c *gin.Context) {
	var input struct {
		AppointmentID    uint `json:"appointment_id"`
		CompletionStatus bool `json:"completion_status"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.String(http.StatusBadRequest, "Couldn't Parse Input")
		c.Abort()
		return
	}
	var appointment Models.Appointment
	if err := Models.DB.Model(&Models.Appointment{}).Where("id = ?", input.AppointmentID).Find(&appointment).Error; err != nil {
		c.String(http.StatusBadRequest, "Couldn't Find Appointment")
		c.Abort()
		return
	}
	appointment.IsPaid = input.CompletionStatus
	appointment.IsCompleted = input.CompletionStatus
	if err := Models.DB.Save(&appointment).Error; err != nil {
		c.String(http.StatusBadRequest, "Couldn't Update Appointment Payment Status")
		c.Abort()
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Payment Status Updated Successfully"})
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
		return
	}
	c.JSON(http.StatusOK, patients)
}

func EditTeethMap(c *gin.Context) {
	var input struct {
		PatientID       uint            `json:"patient_id"`
		PatientTeethMap Models.TeethMap `json:"patient_teeth_map"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var patient Models.Patient
	if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", input.PatientID).Preload("PatientTeethMap").Find(&patient).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	if err := Models.DB.Model(&Models.TeethMap{}).Where("id = ?", patient.PatientTeethMap.ID).Preload("Teeth").Find(&patient.PatientTeethMap).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
	}

	// patient.PatientTeethMap = input.PatientTeethMap
	for index := range patient.PatientTeethMap.Teeth {
		patient.PatientTeethMap.Teeth[index].Condition = input.PatientTeethMap.Teeth[index].Condition
		patient.PatientTeethMap.Teeth[index].IsTreated = input.PatientTeethMap.Teeth[index].IsTreated
	}
	// var teethMap Models.TeethMap
	var teeth []Models.Tooth
	for _, tooth := range patient.PatientTeethMap.Teeth {
		teeth = append(teeth, Models.Tooth{Condition: tooth.Condition, ToothCode: tooth.ToothCode, IsTreated: tooth.IsTreated})
	}
	fmt.Println(teeth)
	if err := Models.DB.Model(&patient.PatientTeethMap).Association("Teeth").Replace(&teeth); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Patient Updated Successfully"})
}

func GetDoctorPatients(c *gin.Context) {
	var patients []Models.Patient
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
	if err := Models.DB.Model(&Models.Patient{}).Where("doctor_id = ?", user.ID).Preload("PatientTeethMap").Find(&patients).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
	}
	c.JSON(http.StatusOK, patients)
}

func RegisterCondition(c *gin.Context) {
	var input struct {
		ConditionName  string  `json:"condition_name"`
		ConditionPrice float64 `json:"condition_price"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var condition Models.Condition

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

	condition.Name = input.ConditionName
	condition.Price = input.ConditionPrice
	condition.DoctorID = user.ID

	if err := Models.DB.Save(&condition).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Condition Created Successfully"})
}

func EditCondition(c *gin.Context) {
	var input struct {
		ConditionID    uint    `json:"condition_id"`
		ConditionName  string  `json:"condition_name"`
		ConditionPrice float64 `json:"condition_price"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var condition Models.Condition
	if err := Models.DB.Model(&Models.Condition{}).Where("id = ?", input.ConditionID).Find(&condition).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	condition.Name = input.ConditionName
	condition.Price = input.ConditionPrice
	if err := Models.DB.Model(&Models.Condition{}).Save(&condition).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Condition Updated Successfully"})
}

func GetDoctorConditions(c *gin.Context) {
	var conditions []Models.Condition
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
	if err := Models.DB.Model(&Models.Condition{}).Where("doctor_id = ?", user.ID).Find(&conditions).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
	}
	c.JSON(http.StatusOK, conditions)
}

func GetPatientTeethMap(c *gin.Context) {
	var input struct {
		PatientID uint `json:"patient_id"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var patient Models.Patient
	if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", input.PatientID).Preload("PatientTeethMap").Find(&patient).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
	}
	if err := Models.DB.Model(&Models.TeethMap{}).Where("id = ?", patient.PatientTeethMap.ID).Preload("Teeth").Find(&patient.PatientTeethMap).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
	}
	c.JSON(http.StatusOK, patient.PatientTeethMap)
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
