pragma solidity ^0.4.23;


import "./InterfaceEmployerStorage.sol";
import "./Ownable.sol";





contract EmployerStorage is InterfaceEmployerStorage, Ownable {
    

    /*
     *  Storage
     */
    struct Company {
        string name;
        bool exists;
        uint256 id;
        address accountAddress;
    }

    uint256 nextCompanyId;
    uint256 CompanyCount;

    mapping (uint256 => Company) companiesById;
    mapping (address => uint256) companiesByAddress;
    
    
    // constructor
    
    constructor () public {
            nextCompanyId=1;
            CompanyCount=0;
    }
     

    /*
     *  Modifiers
     */
    modifier existingCompanyAddress(address _address) {
        require(getCompany(_address).exists);
        _;
    }

    modifier existingCompanyId(uint256 _id) {
        require(companiesById[_id].exists);
        _;
    }

    modifier notExistingCompanyAddress(address _address) {
        require(!getCompany(_address).exists);
        _;
    }

    /*
     * Public functions
     */
     
     
     // Everyone with a single adress in the blockchain should be able to own only 1 adress in the blockchain
     // You also do not want someone else creating an adress for your adress
    function addCompany(string name, address employerAddress) 
        public
        
        notExistingCompanyAddress(employerAddress)
    {
        companiesById[nextCompanyId].exists = true;
        companiesById[nextCompanyId].id = nextCompanyId;
        companiesById[nextCompanyId].name = name;
        companiesById[nextCompanyId].accountAddress = employerAddress;
        companiesByAddress[employerAddress] = nextCompanyId;
        CompanyCount++;
        nextCompanyId++;
    }



 

    // Returns Company count from all of history
    function getCompanyCount()
        public
        view
        returns (uint256)
    {
        return CompanyCount;
    }
 
    /// @dev gets the Company ID.
    /// @param _address Address of existing Company.
    /// @return Returns Company ID.
    function getCompanyId(address _address)
        public
        existingCompanyAddress(_address)
        view
        returns (uint256)
    {
        return getCompany(_address).id;
    }

    /// @dev gets the total Company address from ID.
    /// @param _id ID of existing Company.
    /// @return Returns Company address.
    function getCompanyAddress(uint256 _id)
        public
        existingCompanyId(_id)
        view
        returns (address)
    {
        return companiesById[_id].accountAddress;
    }
    
    




    /// @dev removes and Company.
    /// @param _address Address of existing Company.
    function removeCompany(address _address)
        public
        onlyOwner
        existingCompanyAddress(_address)
    {
        Company memory company = getCompany(_address);
        
        delete company.exists;
        delete company.id;
        delete company.accountAddress;
        CompanyCount--; //number of active Companys
    }
    
    function getCompanyName(uint256 _id) 
        public 
        view
        returns(string)
    {
        return companiesById[_id].name;
    }
    
    function isEmployer(address _address) 
    public
    existingCompanyAddress(_address)
    returns (bool) {
        return getCompany(_address).exists;
    }

    /*
    * Internal functions
    */
    //get Company function
    function getCompany(address _address)
        internal
        view
        returns (Company)
    {
        uint256 CompanyId = companiesByAddress[_address];
        return companiesById[CompanyId];
    }
    
    

}
