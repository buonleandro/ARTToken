const Web3 = require('web3');
const IPFS = require('ipfs-core');
const CryptoJS = require("crypto-js/core");
CryptoJS.AES = require("crypto-js/aes");

const web3 = new Web3(Web3.currentProvider);

const account = web3.eth.accounts.create();
const ownerAddr = account.address;
const pKey = account.privateKey;

function convertToBase64(){

    let file = document.querySelector(
        'input[type=file]')['files'][0];

    let reader = new FileReader();

    let base64String;

    reader.onload = function () {
        base64String = reader.result.replace("data:", "").replace(/^.+,/, "");
    }
    reader.readAsDataURL(file);

    return base64String;
}

function convertToImage(data){

    let arr = data.split(','),
        mime = arr[0].match(/:(.*?);/)[1],
        b64 = atob(arr[1]),
        n = b64.length,
        u8arr = new Uint8Array(n);

    while(n--){
        u8arr[n] = b64.charCodeAt(n);
    }

    return new File([u8arr], "result", {type:mime});

}

async function encryptImage() {

    let b64Img = convertToBase64();
    let signedObj = web3.eth.accounts.sign(b64Img, pKey);
    let pwd = signedObj.messageHash;

    let encrypted = CryptoJS.AES.encrypt(b64Img,pwd);

    let ipfs = await IPFS.create();
    let result = await ipfs.add(encrypted);

    let CID = result.cid;

    return CID,pwd;

}

async function decryptImage(cid,pwd) {

    let ipfs = await IPFS.create();
    let encB64Img = ipfs.cat(cid);

    let decrypted = CryptoJS.AES.decrypt(encB64Img,pwd);

    const img = document.querySelector("img");
    img.getAttribute('src').split(".",1);
    window.open(img[0] + convertToImage(decrypted));

}
