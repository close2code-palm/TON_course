pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


interface GameObjectInterface {
    function underAttack(uint8 attack) external;
}


contract GameObject is GameObjectInterface {

    uint8 private lifeCells = 50;
    uint8 constant private defense_power = 17;


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


contract BaseStation is GameObject {

    address[] private static units;
    
// // explicitly calling for different types of units
//     function addUnit(string unType) external {
//         if (unType == "Archer") {
//             Archer unitGuy = new Archer();
//         } else {
//             Warrior unit = new Warrior();
//         }
//         // CombatUnit combatUnit = new CombatUnit(this, unType);
//         address unitAddress = address(unit);
//         address  unitAddressPay = payable(unitAddress);
//         units.push(unitAddressPay);
//     }
// failed polymorphism

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


abstract contract CombatUnit is GameObject {

    address internal baseStationAddress;
    uint8 internal attack;

    // event Defeated(address _killed_by);

    constructor(address baseSt) public {
        baseStationAddress = baseSt;
    }

    modifier commandsFromBase {
        require(msg.sender == baseStationAddress, 101, "Only my basestation can command");
        _;
    }

    function death(address name) commandsFromBase override public {    }

    // function getAttack(address _target) internal {
    //     _target.underAttack(attack);
    // }

}


contract Archer is CombatUnit(msg.sender) {

    uint8 lifeCells = 30;

    constructor()
    override //CombatUnit(BaseStationa 
    public {    
        // addArcher();
        // baseStationAddress.call(bytes4(keccak256("addArcher")));
        BaseStation baseAr = BaseStation(msg.sender);
        baseAr.addArcher();
    }

    function getAttack() pure public returns (uint8 attackPower) {
        return 25;
    }
    // atck  attack = 25;
    // defense = 10;
    
}


contract Warrior is CombatUnit(msg.sender) {

    uint8 lifeCells = 40;

    constructor() override public {  
        BaseStation baseWr = BaseStation(msg.sender);
        baseWr.addWarrior();
    }

    function getAttack() public pure returns (uint8 attackPower) {
        return 30;
    }

}