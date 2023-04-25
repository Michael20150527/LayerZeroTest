// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "https://github.com/LayerZero-Labs/solidity-examples/blob/main/contracts/lzApp/NonblockingLzApp.sol";

/*
    LayerZero Sepolia
      lzChainId:10161 lzEndpoint:0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1
      contract: 0x188570c5F668f32a731dc4618cE86B29c334A487
    LayerZero Goerli
      lzChainId:10121 lzEndpoint:0xbfD2135BFfbb0B5378b56643c2Df8a87552Bfa23
      contract: 
    LayerZero Mumbai
      lzChainId:10109 lzEndpoint:0xf69186dfBa60DdB133E91E9A4B5673624293d8F8
      contract: 0x7B0e51166EfCa27817345f52EDe7F9eEa88EB785
*/

contract LayerZeroTest is NonblockingLzApp {
    string public data = "Nothing received yet";
    uint16 destChainId;
    
    constructor(address _lzEndpoint) NonblockingLzApp(_lzEndpoint) {
        if (_lzEndpoint == 0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1) destChainId = 10109;
        if (_lzEndpoint == 0xf69186dfBa60DdB133E91E9A4B5673624293d8F8) destChainId = 10161;
    }

    function _nonblockingLzReceive(uint16, bytes memory, uint64, bytes memory _payload) internal override {
       data = abi.decode(_payload, (string));
    }

    function send(string memory _message) public payable {
        bytes memory payload = abi.encode(_message);
        _lzSend(destChainId, payload, payable(msg.sender), address(0x0), bytes(""), msg.value);
    }

    function trustAddress(address _remoteContract) public onlyOwner {
        trustedRemoteLookup[destChainId] = abi.encodePacked(_remoteContract, address(this));   
    }
}