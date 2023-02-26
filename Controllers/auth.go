package Controllers

import (
	"net/http"

	"github.com/Shawket4/ClinicManagement/Models"
	"github.com/Shawket4/ClinicManagement/Utils/Token"
	"github.com/gin-gonic/gin"
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

	c.JSON(http.StatusOK, gin.H{"message": "success", "data": user})
}

type LoginInput struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
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

	token, err := Models.LoginCheck(user.Username, user.Password)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "username or password is incorrect."})
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
