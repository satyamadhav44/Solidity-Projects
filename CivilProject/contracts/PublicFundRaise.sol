pragma solidity ^0.5.16;

/*
Execution order of function of this contract 

1) DepositFundstoContract
2) registerVendor
3) createProposal
4) castingVote
5) TransferfundstoVendor
*/

/*
Programmer name : Satya Venkata
Date : 05/05/2020
About Contract :
this contract is build to decentralize the local governing concept of the traditional system, thus implementing decentralisation,concensus using
solidity language to build smart contract in etherium platform.

*/
contract PublicFundRaise {
    //using SafeMath for uint;
    address payable[] internal ComunityPeople;
    address payable internal contractowner;

    //struct to keep a track of ComunityPeople details
    struct Societyepeople {
        string name;
        address addr;
        bool voted;
        uint256 money;
        uint256 voteindex; // index of the proposal that was voted for
    }
    

    //to keep the track of addresses of the community investors
    mapping(address => Societyepeople) internal SocietyepeopleMapping;

    Vendor[] public arryVendor;
    Proposal[] public ProposalDetails;

    //struct to keep tract of vendor details
    struct Vendor {
        string Name;
        string Desc;
        address payable addr;
    }

    //proposal for voteing
    struct Proposal {
        string Name;
        string descofProposal;
        address vendorAddress;
        uint256 vendorAmount;
        uint256 voteCount;
    }

    //address payable internal  vendor;
    event Fundtransaction(address, uint256);

    //constructor to store the owner of the contract.
    constructor() public {
        contractowner = msg.sender;
    }

    modifier checkowner {
        require(contractowner != msg.sender, "owner cannot be a investor");
        _;
    }

    /*
    Function Description : this fucntion get the ethers from the different accounts and stores them into contract.
    Input : String 
    */
    function DepositFundstoContract(string memory _name) public payable checkowner {
        Societyepeople memory inv;
        inv.name = _name;
        //inv.voted = _vote;
        inv.addr = msg.sender;
        inv.money = msg.value;
        inv.voteindex = 25;
        require(
            SocietyepeopleMapping[msg.sender].addr != msg.sender,
            "same investors cannot invest more than once in the same proposal"
        );
        SocietyepeopleMapping[msg.sender] = inv;
        ComunityPeople.push(msg.sender); //to the addresss of the investors
        emit Fundtransaction(msg.sender, msg.value);
    }

    /*
    Function Description : gets the contract balance
    */
    function getbalance() public view returns (uint256) {
        uint bal = address(this).balance;
        return bal;

    }
    
    /*
    function Description : to check the ether send by each community person
    Input : Address
    */
    function getInverstorfund(address addr) public view returns (uint256) {
        return SocietyepeopleMapping[addr].money;
    }

    /*
    Fucntion Description : to create Proposal and store the Proposal details in an array for furthur use.
    Input : String,String,Address,ether
    */
    function createProposal(
        string memory _name,
        string memory _desc,
        address payable _venAddr,
        uint _vendorAmount
    ) public {
        Proposal memory prop;
        prop.Name = _name;
        prop.descofProposal = _desc;
        prop.vendorAddress = _venAddr;
        prop.vendorAmount = _vendorAmount;
        ProposalDetails.push(prop);
        //add the vendor details to the struct.
    }
    
    
    /*
    Fucntion Description : to register Vendor to map to proposal.
    Input : String,String,Address
    */
    
    function registerVendor(
        string memory _vendorName,
        string memory _desc,
        address payable _addr
    ) public {
        Vendor memory vendorDetails;
        vendorDetails.Name = _vendorName;
        vendorDetails.Desc = _desc;
        vendorDetails.addr = _addr;
        arryVendor.push(vendorDetails);
    }

    /*
    Function Description : calculate the voting percentage to Transfer funds to Vendor based on the Proposal id.
    Input : Proposal index.
    */
    function TransferfundstoVendor(uint256 _proposalID)
        external
        payable
        returns (bool)
    {
        Proposal memory prop;
        prop = ProposalDetails[_proposalID];
        bool flag = false;
        require(
            prop.vendorAmount <= address(this).balance,
            "vendor amount is more than the contract balance"
        );

        // Proposal memory prop;
        // prop = ProposalDetails[_proposalID];
        address venaddr = prop.vendorAddress;

        require(
            venaddr == arryVendor[_proposalID].addr,
            "vendor address mismatch"
        ); //to check if it is register vendor or not
        uint256 votecount = prop.voteCount;
        require(
            votecount <= ComunityPeople.length,
            "vote count is more that the number of investers"
        );
        votecount *= 100;
        uint256 votePer = votecount / ComunityPeople.length;
        if (votePer >= 50 && votePer <= 100) {
            arryVendor[_proposalID].addr.transfer(prop.vendorAmount);
            emit Fundtransaction(arryVendor[_proposalID].addr, prop.vendorAmount);
            flag = true;
        }
            if(flag == false){
                revert("voteing is less the 50%");
            }
        return flag;
    }

    /*
    function Description : casting vote against each proposal by passing proposal id
    Input : proposal index
    */
    function castingVote(uint256 _value) public {
        Societyepeople storage sender = SocietyepeopleMapping[msg.sender];
        require(sender.voteindex != _value, "this vote index is Already voted");
        //require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.voteindex = _value;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        ProposalDetails[_value].voteCount += 1;
    }
    
    

    //function to vote for the idea.(call transfer functiom in case )

    //self distruct the contact after successfull operation
    
    /*
    Function Description : to Distroy the contract.
    */
    function destroyme() public {
        //owner.transfer(address(this).balance);
        require(
            contractowner == msg.sender,
            "only owner can call the distruct function"
        );
        selfdestruct(contractowner);
    }

    function() external payable {}
}
