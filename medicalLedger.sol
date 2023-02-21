// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

contract MedicalLedger {

    struct Patient {
        uint ID;
        uint age;
        string name;
        string disease;
    }

    struct Doctor{
        uint ID;
        string name;
        string qual;
        string location;
    }

    struct Medicine{
        string name;
        string expiryDate;
        string dose;
        uint price;
    }

    uint DoctorID = 1;
    uint patientID = 1;
    mapping(uint => Doctor) doctors;
    mapping(address => uint) doctorsID;
    mapping(address => uint) patientsID;
    mapping(uint => Patient) patients;
    mapping(uint => Medicine) medicines;
    mapping(address => uint[]) prescribedMeds;


    function registerDoctor(string calldata name_, string calldata qual_, string calldata location_) external {
        require(bytes(name_).length != 0 && bytes(qual_).length != 0 && bytes(location_).length != 0, 'invalid input');
        Doctor memory doctor = Doctor(DoctorID,name_,qual_,location_);
        doctors[DoctorID] = doctor;
        doctorsID[msg.sender] = DoctorID;
        ++DoctorID;
    }

    function registerPatient(string calldata name_, uint age_) external {
        require(bytes(name_).length != 0 && age_ != 0, 'invalid input');
        require(patientsID[msg.sender] == 0, 'already registered');
        Patient memory patient = Patient(patientID,age_,name_,"");
        patients[patientID] = patient;
        patientsID[msg.sender] = patientID;
        ++patientID;
    }

    function addDisease(string calldata disease_) external {
        require(patientsID[msg.sender] != 0, 'not registered');
        patients[patientsID[msg.sender]].disease = disease_;
    }

    function RegisterMedicine(uint medicineID_, string calldata name_, string calldata expiryDate_, string calldata dose_, uint price_) external{
        require(bytes(name_).length != 0 && bytes(expiryDate_).length != 0 && bytes(dose_).length != 0, 'invalid input');
        require(bytes(medicines[medicineID_].name).length == 0, 'already registered');
        Medicine memory medicine = Medicine(name_,expiryDate_,dose_,price_);
        medicines[medicineID_] = medicine;
    }

    function prescribe(uint medicineID_, address patient_) external {
        require(doctorsID[msg.sender] != 0, 'doc not registered');
        require(patientsID[patient_] != 0, 'patient not registered');
        require(bytes(medicines[medicineID_].name).length != 0, 'med not registered');
        prescribedMeds[patient_].push(medicineID_);
    }

    function update(uint age_) external{
        require(patientsID[msg.sender] != 0, 'patient not registered');
        patients[patientsID[msg.sender]].age = age_;
    }

    function patientDetails() external view returns(Patient memory){
        return patients[patientsID[msg.sender]];
    }

    function medicineDetails(uint medicineID_) external view returns(Medicine memory) {
        return medicines[medicineID_];
    }

    function patientDetailsByDoc(uint patientID_) external view returns(Patient memory) {
        return patients[patientID_];
    }

    function prescribedMed(address patient_) external view returns(uint[] memory) {
        return prescribedMeds[patient_];
    }

    function doctorDetails(uint docID_) external view returns(Doctor memory) {
        return doctors[docID_];
    }


}