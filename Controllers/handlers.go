package Controllers

import (
	"fmt"
	"log"
	"math"
	"net/http"
	"time"

	"strings"

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

	if err := c.ShouldBindBodyWith(&doctor, binding.JSON); err != nil {
		log.Println(err.Error())
		c.JSON(http.StatusBadRequest, err)
		return
	}
	doctor.UserID = user.ID
	doctor.Schedule = Models.Schedule{DoctorID: doctor.UserID}
	// Models.CreateDoctorWorkingHours(&doctor)
	if err := Models.DB.Model(&Models.Doctor{}).Create(&doctor).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Registered Successfully"})
}

// func GetDoctorWorkingHours(c *gin.Context) {
// 	user_id, err := Token.ExtractTokenID(c)

// 	if err != nil {
// 		c.String(http.StatusBadRequest, "Unauthorized Token Extraction")
// 		c.Abort()
// 		return
// 	}

// 	user, err := Models.GetUserByID(user_id)
// 	if err != nil {
// 		c.String(http.StatusBadRequest, "Unauthorized User Extraction")
// 		c.Abort()
// 		return
// 	}
// 	var doctorID uint
// 	if err := Models.DB.Model(&Models.Doctor{}).Where("user_id = ?", user.ID).Select("id").Find(&doctorID).Error; err != nil {
// 		c.String(http.StatusBadRequest, "Unauthorized User Extraction")
// 		c.Abort()
// 		return
// 	}
// 	var doctorWorkingHours []Models.DoctorWorkingHour
// 	if err := Models.DB.Model(&Models.DoctorWorkingHour{}).Where("doctor_id = ?", doctorID).Find(&doctorWorkingHours).Error; err != nil {
// 		c.String(http.StatusBadRequest, "Unauthorized User Extraction")
// 		c.Abort()
// 		return
// 	}
// 	c.JSON(http.StatusOK, doctorWorkingHours)
// }

func GetPatientDetails(c *gin.Context) {
	var patient Models.Patient
	var input struct {
		PatientID uint `json:"patient_id"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.String(http.StatusBadRequest, "Unauthorized Token Extraction")
		c.Abort()
		return
	}
	if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", input.PatientID).Find(&patient).Error; err != nil {
		c.String(http.StatusBadRequest, "Unauthorized Token Extraction")
		c.Abort()
		return
	}
	c.JSON(http.StatusOK, patient)
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
	var doctor Models.Doctor
	if err := Models.DB.Model(&Models.Doctor{}).Where("user_id = ?", user.ID).Find(&doctor).Error; err != nil {
		log.Println(err.Error())
		c.JSON(http.StatusBadRequest, err)
		return
	}
	patient.DoctorID = doctor.ID
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

	var doctor Models.Doctor
	if err := Models.DB.Model(&Models.Doctor{}).Where("user_id = ?", user.ID).Preload("Schedule").Find(&doctor).Error; err != nil {
		c.String(http.StatusBadRequest, "Unauthorized User Extraction")
		c.Abort()
		return
	}
	if user.Permission != 2 {
		appointment.DoctorID = doctor.ID

	}
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

	if appointment.IsCompleted {
		var tooth Models.Tooth

		if err := Models.DB.Model(&Models.Tooth{}).Where("id = ?", appointment.ToothID).Error; err != nil {
			c.String(http.StatusBadRequest, "Couldn't Find Tooth")
			c.Abort()
			return
		}
		tooth.Condition = "None"
		var teethMap Models.TeethMap
		if err := Models.DB.Model(&Models.TeethMap{}).Where("id = ?", tooth.TeethMapID).Preload("Teeth").Find(&teethMap).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
		}
		for index, s := range teethMap.Teeth {
			fmt.Println(tooth.ID)
			if s.ID == tooth.ID {
				teethMap.Teeth[index] = tooth
			}
		}

		// if err := Models.DB.Model(&Models.Tooth{}).Where("id = ?", appointment.ToothID).Update("condition", "None").Error; err != nil {

		var patient Models.Patient
		if err := Models.DB.Model(&Models.Patient{}).Preload("TeethMap").Where("id = ?", teethMap.PatientID).Find(&patient).Error; err != nil {
			c.String(http.StatusBadRequest, "Couldn't Update Teeth Map")
			c.Abort()
			return
		}

		if err := Models.DB.Model(&patient.PatientTeethMap).Association("Teeth").Replace(&teethMap.Teeth); err != nil {
			c.String(http.StatusBadRequest, "Couldn't Update Patient Teeth Map")
			c.Abort()
			return
		}
	} else {
		var tooth Models.Tooth

		if err := Models.DB.Model(&Models.Tooth{}).Where("id = ?", appointment.ToothID).Error; err != nil {
			c.String(http.StatusBadRequest, "Couldn't Find Tooth")
			c.Abort()
			return
		}
		tooth.Condition = appointment.Treatment
		var teethMap Models.TeethMap
		if err := Models.DB.Model(&Models.TeethMap{}).Where("id = ?", tooth.TeethMapID).Preload("Teeth").Find(&teethMap).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
		}
		for index, s := range teethMap.Teeth {
			if s.ID == tooth.ID {
				teethMap.Teeth[index] = tooth
			}
		}

		// if err := Models.DB.Model(&Models.Tooth{}).Where("id = ?", appointment.ToothID).Update("condition", "None").Error; err != nil {

		var patient Models.Patient
		if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", teethMap.PatientID).Find(&patient).Error; err != nil {
			c.String(http.StatusBadRequest, "Couldn't Update Teeth Map")
			c.Abort()
			return
		}
		patient.PatientTeethMap = teethMap
		if err := Models.DB.Save(&patient).Error; err != nil {
			c.String(http.StatusBadRequest, "Couldn't Update Patient Teeth Map")
			c.Abort()
			return
		}
	}

	if err := Models.DB.Save(&appointment).Error; err != nil {
		c.String(http.StatusBadRequest, "Couldn't Update Appointment Completion Status")
		c.Abort()
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Completion Status Updated Successfully"})
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
	var doctor Models.Doctor
	if err := Models.DB.Model(&Models.Doctor{}).Where("user_id = ?", user.ID).Find(&doctor).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	if err := Models.DB.Model(&Models.Patient{}).Where("doctor_id = ?", doctor.ID).Preload("PatientTeethMap").Find(&patients).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, patients)
}

func GetDoctorEarnings(c *gin.Context) {
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
	if err := Models.DB.Model(&Models.Doctor{}).Where("user_id = ?", user.ID).Find(&doctor).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var allAppointments []Models.Appointment
	var completedAppointments []Models.Appointment
	if err := Models.DB.Model(&Models.Appointment{}).Where("doctor_id = ?", doctor.ID).Find(&allAppointments).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	for _, appointment := range allAppointments {
		if appointment.IsCompleted {
			completedAppointments = append(completedAppointments, appointment)
		}
	}
	var earningsLast7Days float64
	var earningsThisMonth float64
	var allEarnings float64
	// print(completedAppointments)
	for _, appointment := range completedAppointments {
		fmt.Println(appointment.DateTime[:10])
		var appointmentTime time.Time
		appointmentTime, err = time.Parse("2006/01/02", appointment.DateTime[:10])
		if err != nil {
			log.Println(err)
			continue
		}
		currentTime, err := time.Parse("2006/01/02", time.Now().Format("2006/01/02"))
		if err != nil {
			log.Println(err)
			continue
		}
		year, month, day := appointmentTime.Date()
		currentYear, currentMonth, currentDay := currentTime.Date()
		fmt.Println(int(currentMonth))
		fmt.Println(int(month))
		if year == currentYear && int(month) == int(currentMonth) {
			if math.Abs(float64(currentDay-day)) <= 7 {
				fmt.Println(float64(currentDay - day))
				earningsLast7Days += appointment.Price
			}
			earningsThisMonth += appointment.Price
		}
		allEarnings += appointment.Price
	}
	c.JSON(http.StatusOK, gin.H{"earnings_last_7_days": earningsLast7Days, "earnings_this_month": earningsThisMonth, "all_earnings": allEarnings})
}

func GetFavouritePatients(c *gin.Context) {
	var patients []Models.Patient
	var favouritePatients []Models.Patient
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
	if err := Models.DB.Model(&Models.Doctor{}).Where("user_id = ?", user.ID).Find(&doctor).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	if err := Models.DB.Model(&Models.Patient{}).Where("doctor_id = ?", doctor.ID).Preload("PatientTeethMap").Find(&patients).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	for _, patient := range patients {
		if patient.IsFavourite {
			favouritePatients = append(favouritePatients, patient)
		}
	}
	c.JSON(http.StatusOK, favouritePatients)
}

func EditPatientFavouriteStatus(c *gin.Context) {
	var input struct {
		PatientID uint `json:"patient_id"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var patient Models.Patient
	if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", input.PatientID).Find(&patient).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	patient.IsFavourite = !patient.IsFavourite
	if err := Models.DB.Save(&patient).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Added Successfully"})
}

func GetDoctorSchedule(c *gin.Context) {
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
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	if err := Models.DB.Model(&Models.Schedule{}).Where("id = ?", doctor.Schedule.ID).Preload("TimeBlocks").Find(&doctor.Schedule).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	for index, timeBlock := range doctor.Schedule.TimeBlocks {
		var appointment Models.Appointment
		if err := Models.DB.Model(&Models.Appointment{}).Where("time_block_id = ?", timeBlock.ID).Find(&appointment).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
			return
		}

		if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", appointment.PatientID).Select("name").Find(&appointment.PatientName).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
			return
		}

		if err := Models.DB.Model(&Models.Tooth{}).Where("id = ?", appointment.ToothID).Select("tooth_code").Find(&appointment.ToothCode).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
			return
		}

		doctor.Schedule.TimeBlocks[index].Appointment = appointment
	}

	c.JSON(http.StatusOK, doctor)
}

func Search(c *gin.Context) {
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
	var doctorID uint
	if err := Models.DB.Model(&Models.Doctor{}).Select("id").Where("user_id = ?", user.ID).Find(&doctorID).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var input struct {
		Query string `json:"query"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var allPatients []Models.Patient
	input.Query = strings.ToLower(input.Query)
	// db.Where(
	// 	db.Where("pizza = ?", "pepperoni").Where(db.Where("size = ?", "small").Or("size = ?", "medium")),
	//   ).Or(
	// 	db.Where("pizza = ?", "hawaiian").Where("size = ?", "xlarge"),
	//   ).Find(&Pizza{}).Statement
	if err := Models.DB.Model(&Models.Patient{}).Where("LOWER(name) LIKE ?", "%"+input.Query+"%").Or("LOWER(address) LIKE ?", "%"+input.Query+"%").Or("LOWER(phone) LIKE ?", "%"+input.Query+"%").Find(&allPatients).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var patients []Models.Patient = []Models.Patient{}
	for _, patient := range allPatients {
		if patient.DoctorID == doctorID {
			patients = append(patients, patient)
		}
	}
	c.JSON(http.StatusOK, patients)
}

func RegisterTreatment(c *gin.Context) {
	var input struct {
		TreatmentName  string  `json:"treatment_name"`
		TreatmentPrice float64 `json:"treatment_price"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var treatment Models.Treatment

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

	treatment.Name = input.TreatmentName
	treatment.Price = input.TreatmentPrice
	treatment.DoctorID = user.ID

	if err := Models.DB.Save(&treatment).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Registered Successfully"})
}

func EditTreatment(c *gin.Context) {
	var input struct {
		TreatmentID    uint    `json:"treatment_id"`
		TreatmentName  string  `json:"treatment_name"`
		TreatmentPrice float64 `json:"treatment_price"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var treatment Models.Treatment
	if err := Models.DB.Model(&Models.Treatment{}).Where("id = ?", input.TreatmentID).Find(&treatment).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	treatment.Name = input.TreatmentName
	treatment.Price = input.TreatmentPrice
	if err := Models.DB.Model(&Models.Treatment{}).Save(&treatment).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Condition Updated Successfully"})
}

func GetDoctorTreatments(c *gin.Context) {
	var treatments []Models.Treatment
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
	if err := Models.DB.Model(&Models.Treatment{}).Where("doctor_id = ?", user.ID).Find(&treatments).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
	}
	c.JSON(http.StatusOK, treatments)
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
		return
	}
	for i, s := range appointments {
		var patientName string
		if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", s.PatientID).Select("name").Find(&patientName).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
			return
		}
		var toothCode string
		if err := Models.DB.Model(&Models.Tooth{}).Where("id = ?", s.ToothID).Select("tooth_code").Find(&toothCode).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
			return
		}
		appointments[i].PatientName = patientName
		appointments[i].ToothCode = toothCode
	}
	c.JSON(http.StatusOK, appointments)
}

func GetToothHistory(c *gin.Context) {
	var input struct {
		ToothID uint `json:"tooth_id"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var tooth Models.Tooth
	if err := Models.DB.Model(&Models.Tooth{}).Where("id = ?", input.ToothID).Preload("ToothHistory").Find(&tooth).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	for i, s := range tooth.ToothHistory {
		fmt.Println(s)
		var patientName string
		if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", s.PatientID).Select("name").Find(&patientName).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
			return
		}
		var toothCode string
		if err := Models.DB.Model(&Models.Tooth{}).Where("id = ?", s.ToothID).Select("tooth_code").Find(&toothCode).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
			return
		}
		tooth.ToothHistory[i].PatientName = patientName
		tooth.ToothHistory[i].ToothCode = toothCode
	}
	c.JSON(http.StatusOK, tooth)
	// var appointments []Models.Appointment
	// for _, appointment := range tooth.ToothHistory {

	// }

}
