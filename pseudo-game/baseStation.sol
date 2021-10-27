pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import "./gameObject.sol";


contract BaseStation is GameObject {

    address[] private static units;

    constructor() public {
        
    }
    
    function addArcher() external {
        Archer archer = new Archer();
        address archPay = payable(archer);
        units.push(archPay);
    }

    function addWarrior() external {
        Warrior warrior = new Warrior();
        address warPay =payable(warrior);
        units.push(warPay);
    }

    function defeat(address _winner) private {
        for (uint7 i = 0; i < units.length; i++) {
            CombatUnit(units[i]).death(_winner);
        }
        death(_winner);
    }


    function getDefense() 
    public
    view 
    override
    returns(uint7 defense_power) {
        return defense_power;
    }

}
