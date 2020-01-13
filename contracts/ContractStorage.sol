pragma solidity ^0.4.23;


// import "./InterfaceContractStorage.sol";


import "./Ownable.sol";

contract ContractStorage is Ownable {
    
    

    /*
     *  Storage
     */
    struct Contract {
        bool exists;
        string name;
        bool employeeSigned;
        bool employerSigned;
        bool mediatorSigned;
        uint256 id;
        address _employeeAddress;
        address _employerAddress;
        address _MediatorAddress;
        uint salary;
        uint startdate;
        uint durationInWeeks;
        string jobType;
        string description;
    }

    uint256 nextContractId;
    uint256 contractCount;
    uint256 signedcontractCount;

    mapping (uint256 => Contract) contractsById;
    mapping (address => uint256) contractsByAddress;
    mapping (uint256 => Contract) signedContractsById;

    /*
     *  Modifiers
     */
   

    modifier existingContractId(uint256 _id) {
        require(contractsById[_id].exists);
        _;
    }



     constructor () public {
             nextContractId = 1;
             contractCount = 0;
             signedcontractCount = 0;
    }
    
    
    /*
     * Public functions
     */
     // Everyone with a single adress in the blockchain should be able to own only 1 adress in the blockchain
     // You also do not want someone else creating an adress for your adress
    function addContract( string name,  address _employerAddress, address _employeeAddress, address _MediatorAddress,
    uint salary, uint startdate, uint durationInWeeks, string jobType, string description) 
        public
        
    {
        
        contractsById[nextContractId].name = name;
        contractsById[nextContractId].exists = true;
        contractsById[nextContractId].employerSigned = false;
        contractsById[nextContractId].employeeSigned = false;
        contractsById[nextContractId].mediatorSigned = false;
        contractsById[nextContractId].id = nextContractId;
        contractsById[nextContractId]._employeeAddress = _employeeAddress;
        contractsById[nextContractId]._employerAddress = _employerAddress;
        contractsById[nextContractId]._MediatorAddress = _MediatorAddress;
        contractsById[nextContractId].salary = salary;
        contractsById[nextContractId].startdate = startdate;
        contractsById[nextContractId].durationInWeeks = durationInWeeks;
        contractsById[nextContractId].jobType = jobType;
        contractsById[nextContractId].description = description;
        contractCount++;
        nextContractId++;
        
    }
    
    
    

    function EmployeesignContract(uint256 _contractID)
    public
    
    existingContractId(_contractID)
    {
        contractsById[_contractID].employeeSigned = true;
        if (contractsById[_contractID].employerSigned && contractsById[_contractID].employeeSigned) {
            if (!signedContractsById[_contractID].exists) {
                signedContractsById[_contractID] = contractsById[_contractID];
                signedcontractCount++;
            }
            
        }
            
            
    }
    
    
    
    

    function EmployersignContract(uint256 _contractID)
    public
    
     existingContractId(_contractID)
    {
        contractsById[_contractID].employerSigned = true;
        if (contractsById[_contractID].employerSigned && contractsById[_contractID].employeeSigned) {
            if (!signedContractsById[_contractID].exists) {
                signedContractsById[_contractID] = contractsById[_contractID];
                signedcontractCount++;
            }
                
        }
            
    }
    
    

     
     
    function MediatorsignContract(uint256 _contractID)
    public
    
    existingContractId(_contractID)
    {
       
        contractsById[_contractID].mediatorSigned = true;
            
    }
    
    // If contract is expired then it is removed
    function CheckExpired(uint256 _contractID)
    public
    existingContractId(_contractID)
    returns(bool)
    {
        if (contractsById[_contractID].startdate + contractsById[nextContractId].durationInWeeks * 1 weeks >= block.timestamp) {
            remove(_contractID);
            return true;
        }
        return false;
    }
     
    



    // Returns Contract count from all of history
    function getCount()
        public
        view
        returns (uint256)
    {
        return contractCount;
    }
 





    /// @dev removes a contract.
    /// @param _contractID Id of existing Contract.
    function remove(uint256 _contractID)
        public
        onlyOwner
        existingContractId(_contractID)
    {
        Contract storage cntract = getContract(_contractID);
        if (signedContractsById[_contractID].exists) {
            signedcontractCount--;
        }
        delete cntract.exists;
        delete cntract.name;
        
        delete cntract.id;


        delete cntract.employerSigned;
        delete cntract.employeeSigned;
        delete cntract.mediatorSigned;
        delete cntract.id;
        delete cntract._employeeAddress;
        delete cntract._employerAddress;
        delete cntract._MediatorAddress;
        delete cntract.salary;
        delete cntract.startdate;
        delete cntract.durationInWeeks;
        delete cntract.jobType;
        delete cntract.description;
        
        contractCount--; //number of active Contracts
    }

    /*
    * Internal functions
    */
    //get Contract function
    function getContract(uint256 _contractID)
        internal
        view
        returns (Contract storage)
    {
        return contractsById[_contractID];
    }
    
    
    function getContractInfo(uint256 _contractID)
    public
        view
        returns (string name, address _employeeAddress, address _employerAddress,
    uint salary, uint startdate, uint durationInWeeks, string description)
    {
        if (signedContractsById[_contractID].exists) {
            return (contractsById[_contractID].name,
                    contractsById[_contractID]._employeeAddress,
                    contractsById[_contractID]._employerAddress,
                    contractsById[_contractID].salary,
                    contractsById[_contractID].startdate,
                    contractsById[_contractID].durationInWeeks, 
                    contractsById[_contractID].description);
        }
    }





    function getSignedContracts(uint256 _contractID)
        internal
        view
        returns (Contract storage)
    {
        return signedContractsById[_contractID];
    }


    function getCompanyAddress(uint256 _contractID) 
    public
    existingContractId(_contractID)
    view
    returns (address)
    {
        return signedContractsById[_contractID]._employerAddress;
    }



    function  getContractCount() 
        public
        view
        returns (uint256)
    {
        return contractCount;
    }
    
    function  getSignedContractCount() 
        public
        view
        returns (uint256)
    {
        return signedcontractCount;
    }
    
    function EmployeeBelongstoContract(uint256 _contractID, address _address) 
    public 
    existingContractId(_contractID)
    view returns (bool)
    {
        return contractsById[_contractID]._employeeAddress == _address;
    }
    
    function EmployerBelongstoContract(uint256 _contractID, address _address) 
    public 
    existingContractId(_contractID)
    view returns (bool)
    {
        return contractsById[_contractID]._employerAddress == _address;
    }
    
    function MediatorBelongstoContract(uint256 _contractID, address _address) 
    public 
    existingContractId(_contractID)
    view returns (bool)
    {
        return contractsById[_contractID]._MediatorAddress == _address;
    }

    
    
    
    function getContractDuration(uint256 _id) 
     public
        view
        returns (uint256)
    {
        return contractsById[_id].durationInWeeks;
    }
    
    
    function get_ContractStartdate(uint256 _id)
        public 
        view
        returns(uint)
    {
        return contractsById[_id].startdate;
    }
    
    
    
    
}
