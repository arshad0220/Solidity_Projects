// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ecommerce{                                                                             // Attributes of a product using struct

    struct product{
        string title;
        string desc;
        address payable seller;
        address buyer;
        uint productId;
        uint price;
        bool delevered;
    }

    address payable manager;
    bool destroyed = false;

    constructor() {
        manager = payable(msg.sender);
    }

    uint counter = 1;
    product[] public products;

    modifier IsNotDestroyed{require(!destroyed,"contract doesn't exist");_;} 

    function registerProduct(string memory _title,string memory _desc,uint _price)public isNotDestroyed{                                    // Registering a product
        require(_price>0,"Price should be greater than zero");
        Product memory tempProduct;
        tempProduct.title =_title; 
        tempProduct.desc=_desc; 
        tempProduct.price=_price * 10**18;
        tempProduct.seller=payable(msg.sender); 
        tempProduct.productId=counter; 
        products.push(tempProduct);
        counter++;
    }

    function buy(uint _productId) payable public isNotDestroyed{                                                                            // Buying a product
        require(products[_productId-1].price==msg.value,"Pay the exact price");
        require(products[_productId-1].seller!=msg.sender,"Seller cannot buy");
         products[_productId-1].buyer=msg.sender;
    }

    function delivery(uint _productId) public isNotDestroyed{                                                                               // Delivery of a product
        require(products[_productId-1].buyer==msg.sender,"Only buyer can confirm");
        products[_productId-1].delivered=true;
        products[_productId-1].seller.transfer(products[_productId-1].price); 
    } 

//  function destroy() public{                                                                                                // Destroy contract ! in a right form
//      require(manager==msg.sender,"Only manager can call this function");
//      selfdestruct(manager); 
//      Not the right way to destroy the contract // 
//      }

    function destroy()public isNotDestroyed{                                                                                    // Destroy contract in a right form
        require(manager==msg.sender,"only manager can call this"); 
        manager.transfer(address(this).balance);
        destroyed=true;
        }

    fallback() payable external{                       // solidity fallback function is executed if no one of the opposite functions matches the function identifier
        payable(msg.sender).transfer(msg.value); } 
        }
}