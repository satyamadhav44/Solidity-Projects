const PublicFundRaising = artifacts.require("PublicFundRaise");

function convertEthertoWei(amount){

    return (amount * 10^18);
}

contract('PublicFundRaising',(accounts)=>{

it('to check if the money is send to contract',async () => {
    const contractInstance = await PublicFundRaising.deployed();
    await contractInstance.investFund("Maddy",{from : accounts[1], value : 1000000000000000000});
    await contractInstance.investFund("Satya",{from : accounts[2],value : 1000000000000000000});
    await contractInstance.investFund("Madhav",{from : accounts[3],value :1000000000000000000});
    await contractInstance.investFund("Shreya",{from : accounts[4],value : 1000000000000000000});
    
});

it('to get the invested amount of each investor', async() => {
    const contractInstance = await PublicFundRaising.deployed();
    const balance1= await contractInstance.getInverstorfund.call(accounts[1]);
    const balance2= await contractInstance.getInverstorfund.call(accounts[2]);
    const balance3= await contractInstance.getInverstorfund.call(accounts[3]);
    const balance4= await contractInstance.getInverstorfund.call(accounts[4]);

});

it('to register the vendor details', async() => {
    const contractInstance = await PublicFundRaising.deployed();
    await contractInstance.registerVendor("Satya Constructions","experts in building roads",accounts[5],{from : accounts[5]});
});

it('to register the proposal details', async() => {
    const contractInstance = await PublicFundRaising.deployed();
    await contractInstance.createProposal("Road constructions"," relay new roads",accounts[5],convertEthertoWei(30),{from : accounts[5]});
});

it('create a poll',async() => {
    const contractInstance = await PublicFundRaising.deployed();
    
    await contractInstance.createPoll(0 ,{from : accounts[1]});
    await contractInstance.createPoll(0 ,{from : accounts[2]});
    await contractInstance.createPoll(0 ,{from : accounts[3]});
    const status = contractInstance.fundstoVendor(0,{from : accounts[0]});
   

});

})