pragma solidity ^0.4.23;


import "./InterfaceEmployeeStorage.sol";
import "./Ownable.sol";

    
contract EmployeeStorage is InterfaceEmployeeStorage, Ownable {
    

    /*
     *  Storage
     */
    struct Employee {
        string name;
        bool exists;
        uint256 id;
        address accountAddress;
    }

    uint256 nextEmployeeId = 1;
    uint256 employeeCount = 0;

    mapping (uint256 => Employee) employeesById;
    mapping (address => uint256) employeesByAddress;

    /*
     *  Modifiers
     */
    modifier existingEmployeeAddress(address _address) {
        require(getEmployee(_address).exists);
        _;
    }

    modifier existingEmployeeId(uint256 _id) {
        require(employeesById[_id].exists);
        _;
    }

    modifier notExistingEmployeeAddress(address _address) {
        require(!getEmployee(_address).exists);
        _;
    }

    /*
     * Public functions
     */
     
     
     // Everyone with a single adress in the blockchain should be able to own only 1 adress in the blockchain
     // You also do not want someone else creating an adress for your adress
     
     
     
     
     
    function addEmployee(string name, address employeeAddress) 
        public
        
        notExistingEmployeeAddress(employeeAddress)
    {
        employeesById[nextEmployeeId].exists = true;
        employeesById[nextEmployeeId].id = nextEmployeeId;
        employeesById[nextEmployeeId].name = name;
        employeesById[nextEmployeeId].accountAddress = employeeAddress;
        employeesByAddress[employeeAddress] = nextEmployeeId;
        employeeCount++;
        nextEmployeeId++;
    }





    // Returns employee count from all of history
    function getCount()
        public
        view
        returns (uint256)
    {
        return employeeCount;
    }
 
    /// @dev gets the employee ID.
    /// @param _address Address of existing employee.
    /// @return Returns employee ID.
    
    
     
     
    function getId(address _address)
        public
        existingEmployeeAddress(_address)
        view
        returns (uint256)
    {
        return getEmployee(_address).id;
    }

    /// @dev gets the total employee address from ID.
    /// @param _id ID of existing employee.
    /// @return Returns employee address.
    
     
     
    function getEmployeeAddress(uint256 _id)
        public
        existingEmployeeId(_id)
        view
        returns (address)
    {
        return employeesById[_id].accountAddress;
    }




//     //get passport_number
//   function getPassportNumber(uint256 _id)
//         public
//         existingEmployeeId(_id)
//         view 
//         returns (string)
//     {
//         return employeesById[_id].passport_number;
//     }

    //get name
    function getName(uint256 _id)
        public
        existingEmployeeId(_id)
        view 
        returns (string)
    {
        return employeesById[_id].name;
    }
    
    function isEmployee(address _address) 
    public
    existingEmployeeAddress(_address)
    returns (bool) {
        return getEmployee(_address).exists;
    }





    /// @dev removes and employee.
    /// @param _address Address of existing employee.
    
     
     
    function remove(address _address)
        public
        onlyOwner
        existingEmployeeAddress(_address)
    {
        Employee storage employee = getEmployee(_address);
        
        delete employee.exists;
        delete employee.id;
        delete employee.name;
        delete employee.accountAddress;
        employeeCount--; //number of active employees
    }

    /*
    * Internal functions
    */
    //get employee function
    function getEmployee(address _address)
        internal
        view
        returns (Employee storage employee)
    {
        uint256 employeeId = employeesByAddress[_address];
        return employeesById[employeeId];
    }

}
