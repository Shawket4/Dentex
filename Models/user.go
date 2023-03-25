package Models

import (
	"errors"
	"html"
	"strings"

	"github.com/Shawket4/Dentex/Utils/Token"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	Username   string `gorm:"size:255;not null;unique" json:"username"`
	Password   string `gorm:"size:255;not null;" json:"password"`
	Permission int    `json:"permission"`
	IsDemo     bool   `json:"is_demo"`
}

func GetUserByID(uid uint) (User, error) {

	var user User

	if err := DB.First(&user, uid).Error; err != nil {
		return user, errors.New("User not found")
	}

	user.PrepareGive()

	return user, nil

}

func (user *User) PrepareGive() {
	user.Password = ""
}

func VerifyPassword(password, hashedPassword string) error {
	return bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(password))
}

func LoginCheck(username string, password string) (string, error) {

	var err error

	user := User{}

	err = DB.Model(User{}).Where("username = ?", username).Take(&user).Error

	if err != nil {
		return "", err
	}

	err = VerifyPassword(password, user.Password)

	if err != nil && err == bcrypt.ErrMismatchedHashAndPassword {
		return "", err
	}

	token, err := Token.GenerateToken(user.ID)

	if err != nil {
		return "", err
	}

	return token, nil

}

func (user *User) SaveUser() (*User, error) {

	if err := user.BeforeSave(); err != nil {
		return &User{}, err
	}

	if err := DB.Create(&user).Error; err != nil {
		return &User{}, err
	}

	return user, nil
}

func (user *User) BeforeSave() error {

	//turn password into hash
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	user.Password = string(hashedPassword)

	//remove spaces in username
	user.Username = html.EscapeString(strings.TrimSpace(user.Username))

	return nil

}
