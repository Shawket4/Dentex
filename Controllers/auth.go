package Controllers

import (
	"log"
	"net/http"
	"time"

	"github.com/Shawket4/Dentex/Models"
	"github.com/Shawket4/Dentex/Utils/Token"
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	jwt "github.com/golang-jwt/jwt/v5"
)

func CurrentUser(c *gin.Context) {
	user_id, err := Token.ExtractTokenID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := Models.GetUserByID(user_id)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	var output struct {
		Username   string `json:"username"`
		ClinicName string `json:"clinic_name"`
		Permission int    `json:"permission"`
	}
	if user.Permission == 1 {
		var doctor Models.Doctor
		if err := Models.DB.Model(&Models.Doctor{}).Where("user_id = ?", user.ID).Find(&doctor).Error; err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		output.ClinicName = doctor.ClinicName
	}
	output.Username = user.Username
	output.Permission = user.Permission
	c.JSON(http.StatusOK, gin.H{"message": "success", "data": output})
}

type LoginInput struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

func Logout(c *gin.Context) {
	token, err := Token.ExtractJWT(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	claims := jwt.MapClaims{}
	claims["authorized"] = false
	claims["exp"] = time.Now()
	token2 := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	token.Claims = token2.Claims
}

func Login(c *gin.Context) {
	var input LoginInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user := Models.User{}

	user.Username = input.Username
	user.Password = input.Password

	uid, token, err := Models.LoginCheck(user.Username, user.Password)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "username or password is incorrect."})
		return
	}

	user, _ = Models.GetUserByID(uid)

	if user.IsFrozen {
		c.JSON(http.StatusUnauthorized, gin.H{"message": "User Frozen"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Login Successful", "jwt": token})

}

type RegisterInput struct {
	Username   string `json:"name" binding:"required"`
	Password   string `json:"password" binding:"required"`
	Permission int    `json:"permission"`
}

func Register(c *gin.Context) {
	var input RegisterInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	user := Models.User{}

	user.Username = input.Username
	user.Password = input.Password
	user.Permission = input.Permission
	_, err := user.SaveUser()

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": "validated"})
}

func RegisterDemo(c *gin.Context) {
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
	doctor.IsDemo = true
	// Models.CreateDoctorWorkingHours(&doctor)
	if err := Models.DB.Model(&Models.Doctor{}).Create(&doctor).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Registered Successfully"})
}

func DeleteUser(c *gin.Context) {
	user_id, err := Token.ExtractTokenID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := Models.GetUserByID(user_id)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := Models.DB.Unscoped().Delete(&Models.DeviceToken{}, "user_id = ?", user.ID).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := Models.DB.Unscoped().Delete(&Models.User{}, user.ID).Error; err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Account Deleted Successfully"})
}
