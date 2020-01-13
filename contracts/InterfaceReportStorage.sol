pragma solidity ^0.4.23;

contract InterfaceReportStorage {

    function addReport(string name, address _companyAddress,  string message) public returns (uint256);
    
    // for others to be able to sign it
    function signReport(uint256 _reportID) public;
    
    
    // For company to respond
    function companyResponse(uint _reportID, string message) public;
    
    // For original employee to respond when it has been resolved
    function resolved(uint _reportID) public;
    
    //To print all reports and status
    // function getAllReports() public;
    
    function getReport(uint _reportID) public returns (string name, bool _resolved, uint256 _numberOfSignatures, 
    address _companyAddress, string _messageFromEmployee, string _responseFromEmployer) ;
    
    function getCompanyAddress(uint256 _reportID) public view returns (address);
    
    function EmployeeBelongstoReport(uint256 _reportID, address _address) public view returns (bool);
    
}
