pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "./GameObjectInterface.sol";

abstract contract GameObject is GameObjectInterface {

    uint8 internal lifeCells = 50;
    uint8 constant internal defense_power = 17;


    function getDefense() 
    public 
    virtual 
    view 
    returns(uint8 def) {
        return defense_power;
    }

    function underAttack(uint8 damage) external override {
        uint8 effectiveDamage = damage - getDefense();
        lifeCells -= effectiveDamage;
        isKilled(msg.sender);
    }

    function isKilled(address _by) internal {
        if (lifeCells <= 0)
            death(_by); // just for hints, wrong address
    }

    function death(address _killed_by) public virtual {
        _killed_by.transfer(160);
    }

}