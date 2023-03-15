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
	router.Run(":5505")
}
