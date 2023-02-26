package main

import (
	"github.com/Shawket4/ClinicManagement/Models"
	"github.com/Shawket4/ClinicManagement/Routes"
	"github.com/gin-gonic/gin"
)

func main() {
	Models.ConnectDataBase()
	router := gin.Default()
	Routes.ConfigRoutes(router)
	router.Run(":5505")
}
