pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import "./gameObject.sol";
import './combatUnit.sol';

// import './archer.sol';
// import './warrior.sol';

contract BaseStation is GameObject {

    address[] private units;

    function addUnit(CombatUnit _name) public {
        address unitAdd = address(_name);
        units.push(unitAdd);
    }

    function removeUnit(address _dead) public {
        for (uint8 j = 0; j < units.length; ++j) {
            if (units[j] == _dead) {
                delete units[j];
            }
        }
    }


    function death(address _winner) override public {
        for (uint8 i = 0; i < units.length; ++i) {
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
