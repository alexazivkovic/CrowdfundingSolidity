// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Crowdfunding{
    address payable public vlasnikKampanje;
    uint public potrebnaSuma;
    uint public trenutnaSuma;
    string public nazivProjekta;
    string public opisProjekta;
    uint public rokProjekta;
    bool public zavrsen;

    mapping (address=>uint) individualniDoprinosi;

    event EvidencijaUplate(address uplatilac, uint iznos, uint status);

    constructor(address payable vlasnik, uint potSuma, string memory naziv, string memory opis, uint rok){
        vlasnikKampanje = vlasnik;
        potrebnaSuma = potSuma;
        trenutnaSuma = 0;
        nazivProjekta = naziv;
        opisProjekta = opis;
        zavrsen = false;
        rokProjekta = block.timestamp + rok;
    }

    function doniraj() external payable{
        if(msg.value<=0){
            revert("Ne mozete uplatiti iznos manji od nule.");
        }
        if(zavrsen){
            revert("Donacije su zavrsene.");
        }
        if(block.timestamp>rokProjekta){
            revert("Prosao je rok za donacije.");
        }
        individualniDoprinosi[msg.sender] += msg.value;
        trenutnaSuma += msg.value;
        if(trenutnaSuma+msg.value < potrebnaSuma){
            emit EvidencijaUplate(msg.sender, msg.value, trenutnaSuma);
            vlasnikKampanje.transfer(msg.value);
        }
        if(trenutnaSuma+msg.value >= potrebnaSuma){
            emit EvidencijaUplate(msg.sender, msg.value, trenutnaSuma);
            zavrsen = true;
            vlasnikKampanje.transfer(msg.value);
        }
        // if(trenutnaSuma+msg.value > potrebnaSuma){
        //     emit EvidencijaUplate(msg.sender, potrebnaSuma - trenutnaSuma, trenutnaSuma);
        //     zavrsen = true;
        //     payable (msg.sender).transfer(trenutnaSuma+msg.value - potrebnaSuma);
        // }
    }
}