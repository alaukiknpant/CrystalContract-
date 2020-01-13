pragma solidity ^0.4.23;

contract InterfaceMediatorStorage {

    function addMediator(string name, address _address) public;
    function getMediatorId(address _address) public view returns (uint256);
    function getMediatorAddress(uint256 _id) public view returns(address);
    function getCount() public view returns(uint256);
    function getMediatorName(uint256 _id) public view returns (string);
    function isMediator(address _address)  public returns (bool);
    function removeMediator(address _address) public;
    
}
