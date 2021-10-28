pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import "./GameObjectInterface.sol";

abstract contract GameObject is GameObjectInterface {

    uint8 internal lifeCells = 50;
    uint8 constant internal defense_power = 17;

    event LoseOne(address owned, address eliminator, uint reward);

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
            death(_by);
    }

    function death(address _killed_by) public virtual {
        emit LoseOne(address(this), _killed_by, address(this).balance);
        _killed_by.transfer(160);
    }

}