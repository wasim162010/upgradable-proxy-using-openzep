//pragma solidity v0.5.16;   //>=0.4.22 <0.6.0;

pragma solidity ^0.5.16;

import "@openzeppelin/upgrades/contracts/Initializable.sol";


 
contract WLContract is Initializable{
    
 //WLDataStorage obj;

 address ownerAddr;
	uint devicesIndexCount=0; //counter for Devices.
	mapping(uint => mapping(address => address)) Devices;
	mapping(address => address) DeviceToOwnerMapping; //assuming a device and owner has one-to-one mapping.
    address[] _devices;
    address[] WhiteListAddrs; //conains accounts added by the owner as whitelisted account list.
    mapping(address => uint) deviceCountPerAddress;
    
    modifier OnlyWhiteList {
        require(IsWhiteList(msg.sender)); 
        _;
    }
 
 /*
 constructor(address _wldataContract) public {
    obj=WLDataStorage(_wldataContract) ;
 }
 */

  function initialize() initializer public {
       // name = _name;
    }
 
  modifier OnlyOwner {
        require(msg.sender == getOwnerAddress());
        _;
    }

function getOwnerAddress() public view returns (address) {
        return ownerAddr;
    }
 

 function setWhiteListAddress(address _Addr) public {     //OnlyOwner {
        WhiteListAddrs.push(_Addr);
    }
    
  function getWhiteListAddress() public view returns(address[] memory) {
        return WhiteListAddrs;
    }

  function getDevices(address _mainAccnt) public returns(address[] memory) {
        delete _devices;
        _devices.length=0;
        for(uint i=0;i< devicesIndexCount ;i++) {
            _devices.push(Devices[i][_mainAccnt]);                   
        }
        return _devices;
    }

function setDevices(address _device,address _mainAccnt) public { 
      
         require(deviceCountPerAddress[_mainAccnt] <=64);
       
         Devices[devicesIndexCount++][_mainAccnt] = _device; 
         DeviceToOwnerMapping[_device]=_mainAccnt;
         devicesIndexCount++;
         deviceCountPerAddress[_mainAccnt]++;
    }

   function removedWhiteListedAddress(address addr) public returns(bool) {
        remove(addr);
        return true;
    }
    
 function IsWhiteList(address addr) public view returns(bool) {
     
        bool isWL=false;
        for(uint i=0;i<WhiteListAddrs.length;i++) {
                if(WhiteListAddrs[i] == addr)
                    isWL = true;
            }
   
        return isWL;
    }
    
 function getDeviceOwner(address deviceAddr) public view returns(address) {
        return DeviceToOwnerMapping[deviceAddr];
    }
    

function remove(address _addrToRemove) private  returns(address[] memory) { //remove whitelisted addresses.
        uint index=0;
        
        while (WhiteListAddrs[index] != _addrToRemove && index< WhiteListAddrs.length) {
              index++;
        }
    
        if (index >= WhiteListAddrs.length) return WhiteListAddrs;

        for (uint i = index; i<WhiteListAddrs.length-1; i++){
            WhiteListAddrs[i] = WhiteListAddrs[i+1];
        }
        delete WhiteListAddrs[WhiteListAddrs.length - 1];
        WhiteListAddrs.length--;
        
        // removing the corresponding device/child also, if present.
        if(DeviceToOwnerMapping[_addrToRemove] == address(0)) {
        }
        
        else { 
             DeviceToOwnerMapping[_addrToRemove] = address(0);
        }
    }
     
 }
    
   
    