pragma ton-solidity >= 0.40.0;

// structres, which represents entities(list item and list counts)
// Used over smart contracts and debots
struct ToBuy {
        uint32 id;
        string naming;
        uint16 amount;
        uint32 addedAt;
        bool bought;
        uint128 price;
    }

struct BuysSummary {
    uint32 paid;
    uint32 notPaid;
    uint totalPrice;    
}