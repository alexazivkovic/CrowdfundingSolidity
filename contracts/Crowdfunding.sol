// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Crowdfunding{
    address payable public vlasnikKampanje;
    uint public potrebnaSuma;
    uint public trenutnaSuma;
    string public nazivProjekta;
    string public opisProjekta;
    uint public rokProjekta;

    mapping (address=>uint) individualniDoprinosi;

    event EvidencijaUplate(address uplatilac, uint iznos, uint status);

    constructor(address payable vlasnik, uint potSuma, string memory naziv, string memory opis, uint rok){
        vlasnikKampanje = vlasnik;
        potrebnaSuma = potSuma;
        trenutnaSuma = 0;
        nazivProjekta = naziv;
        opisProjekta = opis;
        rokProjekta = block.timestamp + rok;
    }

    function doniraj() external payable{
        if(msg.value<=0){
            revert("Ne mozete uplatiti iznos manji od nule.");
        }
        if(block.timestamp>rokProjekta || trenutnaSuma>=potrebnaSuma){
            revert("Donacije su zavrsene.");
        }
        individualniDoprinosi[msg.sender] += msg.value;
        trenutnaSuma += msg.value;
        emit EvidencijaUplate(msg.sender, msg.value, trenutnaSuma);
        vlasnikKampanje.transfer(msg.value);
    }

    function istorijaDonacija() external view returns(uint){
        return individualniDoprinosi[msg.sender];
    }
 
}
