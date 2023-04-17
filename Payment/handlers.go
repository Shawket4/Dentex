package Payment

import (
	"fmt"
	"log"
	"net/http"

	"github.com/Shawket4/Dentex/Models"
	"github.com/gin-gonic/gin"
)

func ReturnAllDoctors(c *gin.Context) {
	var doctors []Models.Doctor
	if err := Models.DB.Model(&Models.Doctor{}).Find(&doctors).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	for i, doctor := range doctors {
		var isFrozen bool
		if err := Models.DB.Model(&Models.User{}).Where("id = ?", doctor.UserID).Select("is_frozen").Find(&isFrozen).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, err)
			return
		}
		doctors[i].IsFrozen = isFrozen
	}
	c.JSON(http.StatusOK, doctors)
}

func ChangeDoctorState(c *gin.Context) {
	var input struct {
		ID uint `json:"doctor_id"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	var doctor Models.Doctor
	if err := Models.DB.Model(&Models.Doctor{}).Where("id = ?", input.ID).Find(&doctor).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	fmt.Println(doctor)
	var user Models.User
	if err := Models.DB.Model(&Models.User{}).Where("id = ?", doctor.UserID).Find(&user).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	fmt.Println(user)
	user.ChangeState()
	if err := Models.DB.Save(&user).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "User Changed Successfully"})
}
