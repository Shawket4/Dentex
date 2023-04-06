package Messaging

import (
	"context"
	"fmt"
	"log"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"github.com/Shawket4/Dentex/Models"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/option"
)

func SendApi(c *gin.Context) {
	var input struct {
		Message string `json:"message"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println(err)
		c.JSON(400, err.Error())
		return
	}
	if err := SendMessage([]Models.DeviceToken{{Value: "fHcrya4hf05gs-qGfaMCmK:APA91bGSoHYVPXyzleeQxUUuN9PlP1rTrWhc1irfLVkLzhEGtlkaJs9dU-HSb6N29GUNAGstRQR2HGL1NIYBvgPZedkW9O0UjF268ozXSBgTUANKetLOv1Xrgjgb2rypHoLtI2_1lxZh"}, {Value: "etPcSHauSqyWKGKcyD_NtC:APA91bEbVzc9yC8fD94LRcfTkZQYPvNpqcTHKmYA3IqggHLNlXmHKHh9-MAvsp6CwWeGzgEYduBqd_UJpEqqQRW6KO60wuL_262CpZwEMVXRoB2bZ9vy3Q3bfqFFtVtkmlg-qymCupHe"}, {Value: "d2i2aXgmwkidkV0edvE5QT:APA91bGvko4XaKFYzPXAHYOGoGAK771WCotZHzWra2q-8NdKF1g73Q4GxYbl-urBq8uF4z4LagPCMMzpz8XpiZX2273AzUWRCA8Xeo1AEyVpXLckIpyX-UcjicGZdu22_hwR-TfLwyIq"}, {Value: "fDNeJTpKRQCZZj1fAlAL7N:APA91bF7SAACuB_hwyGaD_H8ni8wPRE1KQhlNTs1W8grqT0mpKBxNJT6pFQbvvZ8MT9ltd8_zt8QGA-HgSAOlGENTb8DlFUaKyZLouGAW8SmD8bXLvYgCQgk8vHyTqdo_BGjGax8Itqg"}}, "Message", input.Message); err != nil {

	}
}

func SendMessage(tokens []Models.DeviceToken, title, messageString string) error {
	opt := option.WithCredentialsFile("./key-store.json")
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		return err
	}
	ctx := context.Background()
	client, err := app.Messaging(ctx)
	if err != nil {
		log.Fatalf("error getting Messaging client: %v\n", err)
		return err
	}

	// This registration token comes from the client FCM SDKs.
	var registrationTokens []string
	for _, token := range tokens {
		registrationTokens = append(registrationTokens, token.Value)
	}
	message := &messaging.MulticastMessage{
		Notification: &messaging.Notification{
			Title:    title,
			Body:     messageString,
			ImageURL: "http://144.126.234.206:5505/Web/Android.png",
		},
		Tokens: registrationTokens,
	}

	br, err := client.SendMulticast(context.Background(), message)
	if err != nil {
		log.Fatalln(err)
		return err
	}

	// See the BatchResponse reference documentation
	// for the contents of response.
	fmt.Printf("%d messages were sent successfully\n", br.SuccessCount)
	return nil
}
