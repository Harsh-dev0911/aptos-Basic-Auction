# 🛒 Basic Auction Module

## 📌 Overview  
The **Basic Auction Module** is a Move-based smart contract built for the Aptos blockchain.  
It enables users to create simple auctions and allows others to place bids using AptosCoin (`APT`).  
Each auction is owned by a seller and maintains the highest bid and bidder information on-chain.

---

## ✨ Features

- 🧑‍💼 Seller-Created Auctions – Any account can initialize an auction.
- 💸 Bidding System – Participants can place bids using AptosCoin.
- 📊 Highest Bid Tracking – Only the highest bid is stored and accepted.
- 🔐 On-Chain State – Auction data is securely stored on the Aptos blockchain.

---

## 🛠 Functions

### `start_auction(seller: &signer)`  
Initializes a new auction for the given signer.  

**Parameters:**
- `seller` → The signer account that will own the auction.

---

### `place_bid(bidder: &signer, seller: address, amount: u64)`  
Places a bid on the auction created by the given seller.  

**Parameters:**
- `bidder` → The signer placing the bid.  
- `seller` → Address of the auction creator.  
- `amount` → Amount to bid in AptosCoin.

**Notes:**
- The bid must be higher than the current highest bid.
- No refund is issued to previous highest bidders (this can be added later).

---

## 📦 Full Code

```move
module MyModule::BasicAuction {

    use aptos_framework::coin;
    use aptos_framework::signer;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing an Auction
    struct Auction has key, store {
        highest_bid: u64,
        highest_bidder: address,
        seller: address,
    }

    /// Initializes a new auction by the seller
    public fun start_auction(seller: &signer) {
        let auction = Auction {
            highest_bid: 0,
            highest_bidder: @0x0,
            seller: signer::address_of(seller),
        };
        move_to(seller, auction);
    }

    /// Place a bid. If it's higher than the current, update the highest bid.
    public fun place_bid(bidder: &signer, seller: address, amount: u64) acquires Auction {
        let auction = borrow_global_mut<Auction>(seller);

        assert!(amount > auction.highest_bid, 1);

        // Refund the previous highest bidder (skipped for simplicity)

        let bid = coin::withdraw<AptosCoin>(bidder, amount);
        coin::deposit<AptosCoin>(auction.seller, bid);

        auction.highest_bid = amount;
        auction.highest_bidder = signer::address_of(bidder);
    }
}
```
<img width="1899" height="911" alt="Screenshot 2025-08-08 170849" src="https://github.com/user-attachments/assets/9ab038ff-d97b-4c8d-959b-158e34dd6340" />
