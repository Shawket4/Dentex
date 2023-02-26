package Routes

import (
	"github.com/Shawket4/ClinicManagement/Controllers"
	"github.com/Shawket4/ClinicManagement/Middleware"
	"github.com/gin-gonic/gin"
)

func ConfigRoutes(router *gin.Engine) {
	public := router.Group("/api")
	public.POST("/login", Controllers.Login)
	authorized := router.Group("/api/protected")
	authorized.Use(Middleware.JwtAuthMiddleware())
	authorized.GET("/user", Controllers.CurrentUser)
	authorized.POST("/RegisterPatient", Controllers.RegisterPatient)
	authorized.POST("/RegisterAppointment", Controllers.RegisterAppointment)
	authorized.GET("/GetAllPatients", Controllers.GetAllPatients)
	authorized.GET("/GetDoctorAppointments", Controllers.GetDoctorAppointments)
	adminRoutes := router.Group("/api/admin")
	adminRoutes.Use(Middleware.JwtAuthMiddleware())
	adminRoutes.Use(Middleware.PermissionCheckAdmin())
	adminRoutes.POST("/register", Controllers.Register)
	adminRoutes.POST("/RegisterDoctor", Controllers.RegisterDoctor)
	adminRoutes.GET("/GetAllDoctors", Controllers.GetAllDoctors)
}
