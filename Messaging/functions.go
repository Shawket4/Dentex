package Messaging

import (
	"log"
	"net/http"

	"github.com/Shawket4/Dentex/Models"
	"github.com/Shawket4/Dentex/Utils/Token"
	"github.com/gin-gonic/gin"
)

func SendAlerts() {
	var doctors []Models.Doctor
	if err := Models.DB.Model(&Models.Doctor{}).Find(&doctors).Error; err != nil {
		return
	}

}

func LinkDeviceToken(c *gin.Context) {
	var input struct {
		Token string `json:"token"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	user_id, err := Token.ExtractTokenID(c)

	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := Models.GetUserByID(user_id)

	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	var isRegistered bool
	for _, token := range user.Tokens {
		if token.Value == input.Token {
			isRegistered = true
		}
	}
	if !isRegistered {
		user.Tokens = append(user.Tokens, Models.DeviceToken{UserID: user.ID, Value: input.Token})
		if err := Models.DB.Save(&user.Tokens[len(user.Tokens)-1]).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
	}
	c.JSON(http.StatusOK, gin.H{"message": "Token Registerd Successfully"})
}

func UnlinkDeviceToken(c *gin.Context) {
	var input struct {
		Token string `json:"token"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	user_id, err := Token.ExtractTokenID(c)

	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := Models.GetUserByID(user_id)

	if err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	var currentTokens []Models.DeviceToken
	for _, token := range user.Tokens {
		if token.Value == input.Token {
			currentTokens = append(currentTokens, token)
		}
	}
	for _, token := range currentTokens {
		if err := Models.DB.Delete(&token).Error; err != nil {
			log.Println(err)
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
	}

}
