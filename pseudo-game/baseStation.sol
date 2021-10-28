pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import "./gameObject.sol";

import './archer.sol';
import './warrior.sol';


contract BaseStation is GameObject {

    address[] private static units;

    constructor() public {
        
    }
    
    function addFighter(CombatUnit _name) public {
        address unitAdd = address(_name);
        units.push(unitAdd)
    }

    // function addArcher() external {
    //     Archer archer = new Archer();
    //     address archPay = payable(archer);
    //     units.push(archPay);
    // }

    // function addWarrior() external {
    //     Warrior warrior = new Warrior();
    //     address warPay =payable(warrior);
    //     units.push(warPay);
    // }

    function defeat(address _winner) private {
        for (uint8 i = 0; i < units.length; i++) {
            CombatUnit(units[i]).death(_winner);
        }
        death(_winner);
    }


    function getDefense() 
    public
    view 
    override
    returns(uint8 defense_power) {
        return defense_power;
    }

}
