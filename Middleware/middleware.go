package Middleware

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"

	"github.com/Shawket4/Dentex/Controllers"
	"github.com/Shawket4/Dentex/Models"
	"github.com/Shawket4/Dentex/Utils/Token"
	"github.com/gin-gonic/gin"
)

func JwtAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		err := Token.TokenValid(c)
		if err != nil {
			c.String(http.StatusUnauthorized, "Unauthorized Token Invalid")
			c.Abort()
			return
		}
		c.Next()
	}
}

func PermissionCheckAdmin() gin.HandlerFunc {
	return func(c *gin.Context) {
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

		if user.Permission == 2 {
			c.Next()
		} else {
			c.String(http.StatusBadRequest, "Unauthorized Not Enough Permission")
			c.Abort()
		}
	}
}

func CheckObjectOwnerShip(object string) gin.HandlerFunc {
	return func(c *gin.Context) {
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
			c.String(http.StatusBadRequest, "Couldn't Load Doctor By ID")
			c.Abort()
			return
		}
		var input struct {
			ID uint `json:"id"`
		}

		body, err := io.ReadAll(c.Request.Body)
		if err != nil {
			c.String(http.StatusBadRequest, "Couldn't Load ID In Middleware")
			c.Abort()
			return
		}
		buf := bytes.NewBuffer(body)

		// Replace the request body with the buffer
		c.Request.Body = io.NopCloser(buf)
		if err := json.Unmarshal(body, &input); err != nil {
			c.String(http.StatusBadRequest, "Couldn't Load ID In Middleware")
			c.Abort()
			return
		}

		isOwned, err := CompareObjectID(object, doctor.ID, input.ID)
		if err != nil {
			log.Println(err)
			c.String(http.StatusBadRequest, err.Error())
			c.Abort()
			return
		}
		if isOwned {
			c.Next()
		} else {

			c.String(http.StatusBadRequest, err.Error())
			c.Abort()
			return
		}
	}
}

func CompareObjectID(object string, doctorID uint, objectID uint) (bool, error) {
	switch object {
	case "Patient":
		var patient Models.Patient
		if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", objectID).Find(&patient).Error; err != nil {
			return false, err
		}
		if patient.DoctorID == doctorID {
			return true, nil
		}
	case "Treatment":
		var treatment Models.Treatment
		if err := Models.DB.Model(&Models.Treatment{}).Where("id = ?", objectID).Find(&treatment).Error; err != nil {
			return false, err
		}
		fmt.Println(doctorID)
		if treatment.DoctorID == doctorID {
			return true, nil
		}
	case "Appointment":
		var appointment Models.Appointment
		if err := Models.DB.Model(&Models.Appointment{}).Where("id = ?", objectID).Find(&appointment).Error; err != nil {
			return false, err
		}
		if appointment.DoctorID == doctorID {
			return true, nil
		}
	case "Prescription":
		var prescription Models.Prescription
		if err := Models.DB.Model(&Models.Prescription{}).Where("id = ?", objectID).Find(&prescription).Error; err != nil {
			return false, err
		}
		if prescription.DoctorID == doctorID {
			return true, nil
		}
	}
	return false, errors.New("couldn't identify object")
}

type RegisterInput struct {
	Username   string `json:"name" binding:"required"`
	Password   string `json:"password" binding:"required"`
	Permission int    `json:"permission"`
}

func CheckDoctorState() gin.HandlerFunc {
	return func(c *gin.Context) {
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
		if user.IsFrozen {
			Controllers.Logout(c)
			c.String(http.StatusUnauthorized, "Account Frozen")
			c.Abort()
			return
		} else {
			c.Next()
		}
	}
}

// func RegisterDoctorMiddleware() gin.HandlerFunc {
// 	return func(c *gin.Context) {

// 		c.Next()
// 	}

// }
