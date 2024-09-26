// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./Crowdfunding.sol";

contract CrowdfundingFactory {
    Crowdfunding[] public projekti;

    function kreirajProjekat(address payable vlasnik, uint pSuma, string memory naziv, string memory opis, uint rok) public{
        projekti.push(new Crowdfunding(vlasnik, pSuma, naziv, opis, rok));
    }

    function prikaziSveProjekte() public view returns (Crowdfunding[] memory){
        return projekti;
    }
}