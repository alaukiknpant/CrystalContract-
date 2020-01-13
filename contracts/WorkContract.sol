pragma solidity ^0.4.23;


import "./InterfaceWorkcontract.sol";
import "./EmployeeStorage.sol";
import "./EmployerStorage.sol";
import "./MediatorStorage.sol";
import "./ContractStorage.sol";
import "./ReportStorage.sol";




// contract Workcontract is InterfaceWorkcontract, Ownable {
    contract Workcontract is Ownable {

    /*
     *  Events
     */
    event NewEmployee(address indexed newEmployee);
    event NewEmployer(address indexed newEmployer);
    event NewMediator(address indexed newMediator);
    event EmployeeAddressChange(address indexed newAddress);
    // event EmployeePaydayChange(address indexed employeeAddress, uint indexed newPayday);
    // event EmployeeSalaryChange(address indexed employeeAddress, uint indexed newSalary);
    event EmployeeRemoved(address indexed employeeAddress, uint indexed_id);
    event EmployeePayed(address indexed employeeAddress, uint payPeriod);
    

    /*
     *  Storage
     */
    InterfaceEmployeeStorage public employeeStorage;
    InterfaceEmployerStorage public employerStorage;
    InterfaceMediatorStorage public mediatorStorage;
    InterfaceContractStorage public contractStorage;
    InterfaceReportStorage public reportStorage;

    /*
    * Modifiers
    */
    modifier validAddress(address _address) {
        require (_address != 0x0);
        _;
    }

    modifier higherThanZero(uint256 _uint) {
        require(_uint > 0);
        _;
    }
    
    modifier isEmployee(address _address) {
        require(employeeStorage.isEmployee(_address));
        _;
    }
    
    modifier isEmployer(address _address) {
        require(employerStorage.isEmployer(_address));
        _;
    }
    
    modifier isMediator(address _address) {
        require(mediatorStorage.isMediator(_address));
        _;
    }
    
    modifier canMakeContract(address _address) {
        require(employerStorage.isEmployer(_address) || mediatorStorage.isMediator(_address));
        _;
    }
    
    modifier checkEmployeeBelongstoContract(uint256 _contractID, address _address) {
        require(contractStorage.EmployeeBelongstoContract(_contractID, _address));
        _;
    }
    
    modifier checkEmployerBelongstoContract(uint256 _contractID, address _address) {
        require(contractStorage.EmployerBelongstoContract(_contractID, _address));
        _;
    }
    
    modifier checkMediatorBelongstoContract(uint256 _contractID, address _address) {
        require(contractStorage.MediatorBelongstoContract(_contractID, _address));
        _;
    }
    
    // Check if a person can break a contract
    modifier checkCanBreakContract(uint256 _contractID, address _address) {
        require(contractStorage.EmployeeBelongstoContract(_contractID, _address) || 
        contractStorage.EmployerBelongstoContract(_contractID, _address));
        _;
    }


     /*
      * Public functions
      */
    /// @dev Contract constructor sets employee storage, employer storage, mediator storage, contract storage, report storage.
    constructor()
        public
    {
        setEmployerStorage(new EmployerStorage());
        setEmployeeStorage(new EmployeeStorage());
        setMediatorStorage(new MediatorStorage());
        setContractStorage(new ContractStorage());
        setReportStorage(new ReportStorage());
    }
    
    
    

    /// @dev adds a new employee.
    /// @param name Name of new employee.
    // Must be done by company account
    /// add countrycode Country code of new employee?
    function addEmployee(string name)
        public
        validAddress(msg.sender)
    {

        employeeStorage.addEmployee(name, msg.sender);
        emit NewEmployee(msg.sender); //event
    }
    
    /// @dev adds a new company.
    /// @param name Name of new company.
    // Must be done by company account
    function addCompany(address _address, string name)
        public
        onlyOwner
        validAddress(_address)
    {
        employerStorage.addCompany(name, _address);
        emit NewEmployer(_address); //event
    }
    
    /// @dev adds a new mediator.
    /// @param _address Address of new mediator.
    /// @param name Name of new mediator.
    function addMediator(address _address, string name)
        public
        onlyOwner
        validAddress(_address)
    {
        mediatorStorage.addMediator(name, _address);
        emit NewMediator(_address); //event
    }
    
    /// @dev adds a new contract.
    /// @param _employerId Id of employer in the contract.
    /// @param _employeeId Id of employer in the contract.
    /// @param _mediatorId Id of employer in the contract.
    /// @param name name of the contract.
    /// @param salary monthly salary of the contract.
    /// @param startdate startdate of the contract.
    /// @param durationInWeeks duration of the contract in weeks.
    /// @param jobType type of job.
    /// @param description contract description.
    function addContract(uint256 _employerId, uint256 _employeeId, uint256 _mediatorId, string name, uint salary,
    uint startdate, uint durationInWeeks, string jobType, string description)
        public
        canMakeContract(msg.sender)
    {
        address _employerAddress = employerStorage.getCompanyAddress(_employerId);
        address _employeeAddress = employeeStorage.getEmployeeAddress(_employeeId);
        address _MediatorAddress = mediatorStorage.getMediatorAddress(_mediatorId);
        contractStorage.addContract(name, _employerAddress, _employeeAddress, _MediatorAddress,
    salary, startdate, durationInWeeks, jobType, description);
        // emit NewContract(_id); //event
    }
    
    
    function employeeSignContract(uint256 _contractID) 
    public 
    checkEmployeeBelongstoContract(_contractID, msg.sender)
    {
        contractStorage.EmployeesignContract(_contractID);
    }
    
    function employerSignContract(uint256 _contractID) 
    public 
    checkEmployerBelongstoContract(_contractID, msg.sender)
    {
        contractStorage.EmployersignContract(_contractID);
    }
    
    function mediatorSignContract(uint256 _contractID) 
    public 
    checkMediatorBelongstoContract(_contractID, msg.sender)
    {
        contractStorage.MediatorsignContract(_contractID);
    }

    function checkExpiredContract(uint256 _contractID) 
    public 
    returns(string)
    {
        if (contractStorage.CheckExpired(_contractID)) {
            return "Contract is expired and automatically terminated."; 
        }
        return "Contract is not expired.";
    }


    /// @dev gets the total employee count.
    /// @return Returns employee count.
    function getEmployeeCount()
        public
        // onlyOwner
        view
        returns (uint256)
    {
        return employeeStorage.getCount();
    }
    
    /// @dev gets the total company count.
    /// @return Returns company count.
    function getCompanyCount()
        public
        // onlyOwner
        view
        returns (uint256)
    {
        return employerStorage.getCompanyCount();
    }
    
    /// @dev gets the total mediator count.
    /// @return Returns mediator count.
    function getMediatorCount()
        public
        // onlyOwner
        view
        returns (uint256)
    {
        return mediatorStorage.getCount();
    }
    
    /// @dev gets the total contract count.
    /// @return Returns contract count.
    function getContractCount()
        public
        // onlyOwner
        view
        returns (uint256)
    {
        return contractStorage.getContractCount();
    }
    
    

    /// @dev gets the employee ID.
    /// @param _address Address of existing employee.
    /// @return Returns employee ID.
    function getEmployeeID(address _address)
        public
        onlyOwner
        validAddress(_address)
        view
        returns (uint256)
    {
        return employeeStorage.getId(_address);
    }
    
    /// @dev gets the employer ID.
    /// @param _address Address of existing employer.
    /// @return Returns employer ID.
    function getCompanyID(address _address)
        public
        onlyOwner
        validAddress(_address)
        view
        returns (uint256)
    {
        return employerStorage.getCompanyId(_address);
    }
    
    /// @dev gets the mediator ID.
    /// @param _address Address of existing mediator.
    /// @return Returns mediator ID.
    function getMediatorID(address _address)
        public
        onlyOwner
        validAddress(_address)
        view
        returns (uint256)
    {
        return mediatorStorage.getMediatorId(_address);
    }

    /// @dev gets the total employee address from ID.
    /// @param _id ID of existing employee.
    /// @return Returns employee address.
    function getEmployeeAddress(uint256 _id)
        public
        onlyOwner
        view
        returns (address)
    {
        return employeeStorage.getEmployeeAddress(_id);
    }
    
    /// @dev gets the total employer address from ID.
    /// @param _id ID of existing employer.
    /// @return Returns employer address.
    function getCompanyAddress(uint256 _id)
        public
        onlyOwner
        view
        returns (address)
    {
        return employerStorage.getCompanyAddress(_id);
    }
    
    /// @dev gets the total mediator address from ID.
    /// @param _id ID of existing mediator.
    /// @return Returns mediator address.
    function getMediatorAddress(uint256 _id)
        public
        onlyOwner
        view
        returns (address)
    {
        return mediatorStorage.getMediatorAddress(_id);
    }
    
    



    /// @dev gets the total employee info.
    /// @param _id ID of existing employee.
    /// @return Returns all existing employee info.
    function getEmployee(uint256 _id)
        public
        onlyOwner
        view
        returns (address _address, string _name)
    {
        _address = employeeStorage.getEmployeeAddress(_id);
        _name = employeeStorage.getName(_id);
        return (_address, _name);
    }
    
    /// @dev gets the total employer info.
    /// @param _id ID of existing employer.
    /// @return Returns all existing employer info.
    function getCompany(uint256 _id)
        public
        onlyOwner
        view
        returns (address _address, string _name)
    {
        _address = employerStorage.getCompanyAddress(_id);
        _name = employerStorage.getCompanyName(_id);
        return (_address, _name);
    }
    
    /// @dev gets the total mediator info.
    /// @param _id ID of existing mediator.
    /// @return Returns all existing mediator info.
    function getMediator(uint256 _id)
        public
        onlyOwner
        view
        returns (address _address, string _name)
    {
        _address = mediatorStorage.getMediatorAddress(_id);
        _name = mediatorStorage.getMediatorName(_id);
        return (_address, _name);
    }



    /// @dev removes an employee.
    /// @param _id ID of existing employee.
    function removeEmployee(uint256 _id)
        public
        onlyOwner
    {
        address employeeAddress = employeeStorage.getEmployeeAddress(_id);
        employeeStorage.remove(employeeAddress);
        emit EmployeeRemoved(employeeAddress, _id);
    }
    
    /// @dev removes an employer.
    /// @param _id ID of existing employer.
    function removeEmployer(uint256 _id)
        public
        onlyOwner
    {
        address employerAddress = employerStorage.getCompanyAddress(_id);
        employerStorage.removeCompany(employerAddress);
        // emit EmployerRemoved(employerAddress, _id); 
    }
    
    /// @dev removes an mediator.
    /// @param _id ID of existing mediator.
    function removeMediator(uint256 _id)
        public
        onlyOwner
    {
        address mediatorAddress = mediatorStorage.getMediatorAddress(_id);
        mediatorStorage.removeMediator(mediatorAddress);
        // emit MediatorRemoved(mediatorAddress, _id); 
    }
    
    /// @dev removes a contract.
    /// @param _id ID of existing contract.
    function breakContract(uint256 _id)
    public
    checkCanBreakContract(_id, msg.sender)
    {
        contractStorage.remove(_id);
        // emit ContractRemoved(_id); 
    }
    
    
    function addReport(string name, address _companyAddress,  string message, uint256 _contractID) 
    public
    checkEmployeeBelongstoContract(_contractID, msg.sender)
    checkEmployerBelongstoContract(_contractID, _companyAddress)
    returns (uint256)
    {
        uint256 reportID = reportStorage.addReport(name, _companyAddress, message);
        return reportID;
    }
    
     function signReport(uint256 _reportID, uint256 _contractID) 
    public
    checkEmployeeBelongstoContract(_contractID, msg.sender)
    checkEmployerBelongstoContract(_contractID, contractStorage.getCompanyAddress(_contractID))
    {   
        reportStorage.signReport(_reportID);
    }
    
    
    function companyResponse(uint _reportID, string message) 
    public {
        if (msg.sender == reportStorage.getCompanyAddress(_reportID)){
            reportStorage.companyResponse(_reportID, message);
        }
    }
    
    function resolved(uint _reportID) public {
        if (reportStorage.EmployeeBelongstoReport(_reportID, msg.sender)) {
            reportStorage.resolved(_reportID);
        }
        
    }
    
    function getReport(uint _reportID) 
    public 
    returns (string name, bool _resolved, uint256 _numberOfSignatures, 
    address _companyAddress, string _messageFromEmployee, string _responseFromEmployer) {
        return reportStorage.getReport(_reportID);
    }
    
    function getContract(uint _contractID) 
    public 
    view returns 
    (string name, address _employeeAddress, address _employerAddress,
    uint salary, uint startdate, uint durationInWeeks, string description)
    
    {
        return contractStorage.getContractInfo(_contractID);
    }


    /*
    * Internal functions
    */
    /// @dev sets the employee storage contract.
    /// @param _newEmployeeStorage Address of new employee storage.
    function setEmployeeStorage(address _newEmployeeStorage)
        internal
        onlyOwner
        validAddress(_newEmployeeStorage)
    {
        employeeStorage = InterfaceEmployeeStorage(_newEmployeeStorage);
    }
    
    function setEmployerStorage(address _newEmployerStorage)
        internal
        onlyOwner
        validAddress(_newEmployerStorage)
    {
        employerStorage = InterfaceEmployerStorage(_newEmployerStorage);
    }
    
    function setMediatorStorage(address _newMediatorStorage)
        internal
        onlyOwner
        validAddress(_newMediatorStorage)
    {
        mediatorStorage = InterfaceMediatorStorage(_newMediatorStorage);
    }
    
    
    function setContractStorage(address _newContractStorage)
        internal
        onlyOwner
        validAddress(_newContractStorage)
    {
        contractStorage = InterfaceContractStorage(_newContractStorage);
    }

    function setReportStorage(address _newReportStorage)
        internal
        onlyOwner
        validAddress(_newReportStorage)
    {
        reportStorage = InterfaceReportStorage(_newReportStorage);
    }


}
