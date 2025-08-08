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

        // Refund the previous highest bidder (skipped for simplicity in this example)

        let bid = coin::withdraw<AptosCoin>(bidder, amount);
        coin::deposit<AptosCoin>(auction.seller, bid);

        auction.highest_bid = amount;
        auction.highest_bidder = signer::address_of(bidder);
    }
}
