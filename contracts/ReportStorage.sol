pragma solidity ^0.4.23;


import "./InterfaceReportStorage.sol";
import "./Ownable.sol";
import "./ContractStorage.sol";



contract ReportStorage is InterfaceReportStorage, Ownable {
    
    

    /*
     *  Storage
     */
    struct Report {
        bool resolved;
        bool exists;
        string name;
        string messageFromEmployee; //pls include company ID in the message if you want others to support your cause
        string responseFromEmployer;
        address reportFiler;
        address companyAddress;
        uint256 numberOfSignatures;
        uint DateofIncident;
        bool EmployerResponded;
        mapping(address => bool) employeeSignatures;
    }
    

    uint256 nextReportId;
    uint256 ReportCount;

    mapping (uint256 => Report) reportById; //ReportID to Report
    
    modifier existingReportId(uint256 _id) {
        require(reportById[_id].exists);
        _;
    }
  
        


     constructor () public {
             nextReportId = 1;
             ReportCount = 0;
    }
    
    




    
        function addReport(string name, address _companyAddress,  string message) 
        public
        returns (uint256)
        {
            reportById[nextReportId].exists = true;
            reportById[nextReportId].name = name;
            reportById[nextReportId].resolved = false;
            reportById[nextReportId].messageFromEmployee = message;
            reportById[nextReportId].companyAddress = _companyAddress;
            reportById[nextReportId].employeeSignatures[msg.sender] = true;
            reportById[nextReportId].reportFiler = msg.sender;
            reportById[nextReportId].numberOfSignatures = 1;
            reportById[nextReportId].EmployerResponded = false;
            ReportCount++;
            nextReportId++;
            return nextReportId-1;
        }
    
    
    
    
        function signReport(uint256 _reportID) 
        public
        
        // Need to check if the employee has signed
        {
            if (!reportById[_reportID].employeeSignatures[msg.sender])
             {
                reportById[_reportID].employeeSignatures[msg.sender] = true;
                reportById[_reportID].numberOfSignatures++;
             }
        }
         
         

         
         function companyResponse(uint _reportId, string message) 
         public
         {
            if (!reportById[_reportId].EmployerResponded) {
                reportById[_reportId].responseFromEmployer = message;
                reportById[_reportId].EmployerResponded = true;
            }
           
         }
    
    
    

    
        function resolved(uint _reportId) 
        public
        {
             reportById[_reportId].resolved = true;
        }
        
    
//
        
  //      for i in range(stringcount) :
    //            require(true,strmap[i]);
    
        function getAllReports() public view
        {
            //string[] memory ret = new string[](ReportCount);
            for (uint i = 1; i < ReportCount+1; i++) {
                require(true,reportById[i].messageFromEmployee);
                //ret[i] = reportById[i].messageFromEmployee;
            }
        }
        
        function getReport(uint _reportID) public returns (string name, bool _resolved, uint256 _numberOfSignatures, 
        address _companyAddress, string _messageFromEmployee, string _responseFromEmployer)
        {
            if (reportById[_reportID].exists) {
                return (reportById[_reportID].name,
                        reportById[_reportID].resolved,
                        reportById[_reportID].numberOfSignatures,
                        reportById[_reportID].companyAddress,
                        reportById[_reportID].messageFromEmployee,
                        reportById[_reportID].responseFromEmployer);
            }
        }
        
        function getCompanyAddress(uint256 _reportID) 
        public
        existingReportId(_reportID)
        view
        returns (address)
        {
            return reportById[_reportID].companyAddress;
        }
        
        function EmployeeBelongstoReport(uint256 _reportID, address _address) 
        public 
        existingReportId(_reportID)
        view
        returns (bool)
        {
            return reportById[_reportID].reportFiler == _address;
        }
        
}
