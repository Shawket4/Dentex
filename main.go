package main

import (
	"github.com/Shawket4/Dentex/Models"
	"github.com/Shawket4/Dentex/Routes"
	"github.com/gin-gonic/gin"
)

func main() {
	Models.ConnectDataBase()
	router := gin.Default()
	Routes.ConfigRoutes(router)
	router.RunTLS(":5505", "dentex.crt", "dentex_priv.key")
	// router.Run(":5505")
}
