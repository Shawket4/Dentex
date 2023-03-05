package Models

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDataBase() {

	err := godotenv.Load(".env")

	if err != nil {
		log.Fatalf("Error loading .env file")
	}

	DbHost := os.Getenv("DB_HOST")
	DbUser := os.Getenv("DB_USER")
	DbPassword := os.Getenv("DB_PASSWORD")
	DbName := os.Getenv("DB_NAME")
	DbPort := os.Getenv("DB_PORT")

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", DbHost, DbUser, DbPassword, DbName, DbPort)
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		fmt.Println("Cannot connect to database ")
		log.Fatal("connection error:", err)
	} else {
		fmt.Println("We are connected to the database ")
	}

	DB.AutoMigrate(&User{})
	DB.AutoMigrate(&Doctor{})
	DB.AutoMigrate(&Tooth{})
	DB.AutoMigrate(&TeethMap{})
	DB.AutoMigrate(&Patient{})
	DB.AutoMigrate(&Appointment{})
	DB.AutoMigrate(&Treatment{})
	DB.AutoMigrate(&Schedule{})
	DB.AutoMigrate(&TimeBlock{})
	// DB.AutoMigrate(&DoctorWorkingHour{})
	DB.Session(&gorm.Session{FullSaveAssociations: true})
}
