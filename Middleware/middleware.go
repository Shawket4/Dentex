package Middleware

import (
	"net/http"

	"github.com/Shawket4/ClinicManagement/Models"
	"github.com/Shawket4/ClinicManagement/Utils/Token"
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

type RegisterInput struct {
	Username   string `json:"name" binding:"required"`
	Password   string `json:"password" binding:"required"`
	Permission int    `json:"permission"`
}

// func RegisterDoctorMiddleware() gin.HandlerFunc {
// 	return func(c *gin.Context) {

// 		c.Next()
// 	}

// }
