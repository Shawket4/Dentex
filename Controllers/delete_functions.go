package Controllers

import (
	"errors"
	"fmt"

	"github.com/Shawket4/Dentex/Models"
)

func DeleteTimeBlockByID(timeBlockID uint) error {
	if err := Models.DB.Delete(&Models.TimeBlock{}, timeBlockID).Error; err != nil {
		return fmt.Errorf("couldn't delete time block: %v", timeBlockID)
	}
	return nil
}

func DeleteAppointmentByID(appointmentID uint) error {
	var appointment Models.Appointment
	if err := Models.DB.Model(&Models.Appointment{}).Where("id = ?", appointmentID).Find(&appointment).Error; err != nil {
		return errors.New("couldn't find appointment")
	}

	if err := DeleteTimeBlockByID(appointment.TimeBlockID); err != nil {
		return err
	}
	if err := Models.DB.Delete(&Models.Appointment{}, appointmentID).Error; err != nil {
		return errors.New("couldn't delete appointment")
	}
	return nil
}

func DeleteScheduleByID(scheduleID uint) error {
	var schedule Models.Schedule
	if err := Models.DB.Model(&Models.Schedule{}).Where("id = ?", scheduleID).Preload("TimeBlocks").Find(&schedule).Error; err != nil {
		return errors.New("couldn't find doctor schedule")
	}
	for _, timeBlock := range schedule.TimeBlocks {
		if err := DeleteTimeBlockByID(timeBlock.ID); err != nil {
			return err
		}
	}
	if err := Models.DB.Delete(&Models.Schedule{}, scheduleID).Error; err != nil {
		return fmt.Errorf("couldn't delete schedule: %v", scheduleID)
	}
	return nil
}

func DeleteTreatmentByID(treatmentID uint) error {
	if err := Models.DB.Delete(&Models.Treatment{}, treatmentID).Error; err != nil {
		return fmt.Errorf("couldn't delete treatment: %v", treatmentID)
	}
	return nil
}

func DeleteDoctorByID(doctorID uint) error {
	var doctor Models.Doctor

	if err := Models.DB.Model(&Models.Doctor{}).Where("id = ?", doctorID).Preload("Schedule").Find(&doctor).Error; err != nil {
		return errors.New("couldn't find doctor")
	}
	if err := DeleteScheduleByID(doctor.Schedule.ID); err != nil {
		return err
	}

	var doctorPatients []Models.Patient
	if err := Models.DB.Model(&Models.Patient{}).Where("doctor_id = ?", doctorID).Find(&doctorPatients).Error; err != nil {
		return errors.New("couldn't find the doctor's patients")
	}
	for _, patient := range doctorPatients {
		if err := DeletePatientByID(patient.ID); err != nil {
			return err
		}
	}

	var doctorTreatments []Models.Treatment
	if err := Models.DB.Model(&Models.Treatment{}).Where("doctor_id = ?", doctorID).Find(&doctorTreatments).Error; err != nil {
		return errors.New("couldn't find the doctor's treatments")
	}
	for _, treatment := range doctorTreatments {
		if err := DeleteTreatmentByID(treatment.ID); err != nil {
			return err
		}
	}
	// var doctorPrescriptions []Models.Prescription
	// if err := Models.DB.Model(&Models.Prescription{}).Where("doctor_id = ?", doctorID).Find(&doctorPrescriptions).Error; err != nil {
	// 	return errors.New("couldn't find the doctor's prescriptions")
	// }

	// var doctorAppointments []Models.Appointment
	// if err := Models.DB.Model(&Models.Appointment{}).Where("doctor_id = ?", doctorID).Find(&doctorAppointments).Error; err != nil {
	// 	return errors.New("couldn't find the doctor's appointments")
	// }

	if err := Models.DB.Delete(&Models.Doctor{}, doctorID).Error; err != nil {
		return err
	}
	return nil
}

func DeleteToothByID(toothID uint) error {
	var tooth Models.Tooth
	if err := Models.DB.Model(&Models.Tooth{}).Where("id = ?", toothID).Preload("ToothHistory").Find(&tooth).Error; err != nil {
		return fmt.Errorf("couldn't find tooth: %v", toothID)
	}
	for _, appointment := range tooth.ToothHistory {
		if err := DeleteAppointmentByID(appointment.ID); err != nil {
			return err
		}
	}
	if err := Models.DB.Delete(&Models.Tooth{}, toothID).Error; err != nil {
		return fmt.Errorf("couldn't delete tooth: %v", toothID)
	}
	return nil
}

func DeleteTeethMapByID(teethMapID uint) error {
	var teethMap Models.TeethMap
	if err := Models.DB.Model(&Models.TeethMap{}).Where("id = ?", teethMapID).Preload("Teeth").Find(&teethMap).Error; err != nil {
		return fmt.Errorf("couldn't find teeth map: %v", teethMapID)
	}
	for _, tooth := range teethMap.Teeth {
		if err := DeleteToothByID(tooth.ID); err != nil {
			return err
		}
	}
	if err := Models.DB.Delete(&Models.TeethMap{}, teethMapID).Error; err != nil {
		return fmt.Errorf("couldn't delete patient: %v", teethMapID)
	}
	return nil
}

// TODO: Test Function
func DeletePatientByID(patientID uint) error {
	var patient Models.Patient
	if err := Models.DB.Model(&Models.Patient{}).Where("id = ?", patientID).Preload("PatientTeethMap").Find(&patient).Error; err != nil {
		return fmt.Errorf("couldn't find patient: %v", patientID)
	}
	if err := DeleteTeethMapByID(patient.PatientTeethMap.ID); err != nil {
		return err
	}

	var patientPresciptions []Models.Prescription
	if err := Models.DB.Model(&Models.Prescription{}).Where("patient_id = ?", patientID).Find(&patientPresciptions).Error; err != nil {
		return errors.New("couldn't find the patient's prescriptions")
	}
	for _, prescription := range patientPresciptions {
		if err := DeletePrescriptionByID(prescription.ID); err != nil {
			return err
		}
	}

	var patientAppointments []Models.Appointment
	if err := Models.DB.Model(&Models.Appointment{}).Where("patient_id = ?", patientID).Find(&patientAppointments).Error; err != nil {
		return errors.New("couldn't find the patient's appointments")
	}
	for _, appointment := range patientAppointments {
		if err := DeleteAppointmentByID(appointment.ID); err != nil {
			return err
		}
	}
	if err := Models.DB.Delete(&Models.Patient{}, patientID).Error; err != nil {
		return fmt.Errorf("couldn't delete patient: %v", patientID)
	}
	return nil
}

func DeletePrescriptionItemByID(prescriptionItemID uint) error {
	if err := Models.DB.Delete(&Models.PrescriptionItem{}, prescriptionItemID).Error; err != nil {
		return fmt.Errorf("couldn't delete prescription item: %v", prescriptionItemID)
	}
	return nil
}

func DeletePrescriptionByID(prescriptionID uint) error {
	var prescription Models.Prescription
	if err := Models.DB.Model(&Models.Prescription{}).Where("id = ?", prescriptionID).Preload("PrescriptionItems").Find(&prescription).Error; err != nil {
		return fmt.Errorf("couldn't find prescription: %v", prescriptionID)
	}
	for _, item := range prescription.PrescriptionItems {
		if err := DeletePrescriptionItemByID(item.ID); err != nil {
			return err
		}
	}
	if err := Models.DB.Delete(&Models.Prescription{}, prescriptionID).Error; err != nil {
		return fmt.Errorf("couldn't delete prescription: %v", prescriptionID)
	}
	return nil
}
