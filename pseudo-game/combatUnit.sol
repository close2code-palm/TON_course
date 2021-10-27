pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import './gameObject.sol';

abstract contract CombatUnit is GameObject {

    address internal baseStationAddress;
    uint8 internal attack;

    // event Defeated(address _killed_by);

    constructor(address baseSt) public {
        baseStationAddress = baseSt;
    }

    modifier commandsFromBase {
        require(msg.sender == baseStationAddress, 101, 
        "Only my basestation can command");
        _;
    }

    function getAttack() virtual view public returns (uint8) {
        return attack;
    }

    function death(address name) commandsFromBase override public {    }

    function doAttack(address _target) internal {
        CombatUnit target = new CombatUnit(_target);
        // should get attak from getter
        target.underAttack();
    }

}