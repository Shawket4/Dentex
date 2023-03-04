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
	authorized.POST("/RegisterCondition", Controllers.RegisterCondition)
	authorized.POST("/UpdateCondition", Controllers.EditCondition)
	authorized.POST("/ChangeAppointmentPaymentStatus", Controllers.ChangeAppointmentPaymentStatus)
	authorized.POST("/ChangeAppointmentCompletionStatus", Controllers.ChangeAppointmentCompletionStatus)
	authorized.GET("/GetDoctorPatients", Controllers.GetDoctorPatients)
	authorized.GET("/GetDoctorAppointments", Controllers.GetDoctorAppointments)
	authorized.GET("/GetDoctorConditions", Controllers.GetDoctorConditions)
	authorized.POST("/GetPatientTeethMap", Controllers.GetPatientTeethMap)
	authorized.POST("/EditTeethMap", Controllers.EditTeethMap)
	adminRoutes := router.Group("/api/admin")
	adminRoutes.Use(Middleware.JwtAuthMiddleware())
	adminRoutes.Use(Middleware.PermissionCheckAdmin())
	adminRoutes.POST("/register", Controllers.Register)
	adminRoutes.POST("/RegisterDoctor", Controllers.RegisterDoctor)
	adminRoutes.GET("/GetAllPatients", Controllers.GetAllPatients)
	adminRoutes.GET("/GetAllDoctors", Controllers.GetAllDoctors)
}
