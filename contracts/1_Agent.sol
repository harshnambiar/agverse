// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract Agent {


    uint count = 0;
    
   
    mapping (uint => address) public owners;
    mapping (uint => uint) public charges;
    mapping (uint => uint) public redeemables;
    
    
    function getCount() public view returns (uint) {
        return count;
    }
    

  
    function createAgent(uint percharge) public payable {
        require(
            msg.value >=  0.03 ether, 
            "not enough amount attached"
        );
        require(
            percharge >= 1,
            "per usage charge must be at least 1 * 0.001 ETH"
        );
        
        
        uint c = count + 1;
        owners[c] = msg.sender;
        charges[c] = percharge;

    }

    function useAgent(uint aid) public payable {
        uint pc = charges[aid];
        require (pc > 0, "not a valid agent");
        require(
            msg.value >=  pc * 0.001 ether, 
            "not enough amount attached"
        );
        
        
        
        uint c = redeemables[aid];
        redeemables[aid] = c + 1;
    }

    function redeem(uint aid) public {
        uint pc = charges[aid];
        require (pc > 0, "not a valid agent");
        address o = owners[aid];
        require(
            o == msg.sender, 
            "can only redeem ones own agents"
        );
        uint c = redeemables[aid];
        require(
            c >=  1, 
            "nothing to redeem"
        );
        payable(msg.sender).transfer(pc * 0.0009 ether);
    }

    

   
    // getter as in: https://stackoverflow.com/questions/74249392/how-can-i-access-a-solidity-mapping-address-struct-using-ether-js
    
}
