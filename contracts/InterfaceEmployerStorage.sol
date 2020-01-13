pragma solidity ^0.4.23;

contract InterfaceEmployerStorage {

    function addCompany(string name, address employerAddress) public;
    function getCompanyCount() public constant returns(uint256);
    function getCompanyId(address _address) public view returns (uint256);
    function getCompanyAddress(uint256 _id) public view returns(address);
    function getCompanyName(uint256 _id) public view returns (string);
    function isEmployer(address _address)  public returns (bool);
    function removeCompany(address _address) public;
}
