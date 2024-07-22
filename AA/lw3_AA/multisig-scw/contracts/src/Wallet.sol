// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";
import {BaseAccount} from "account-abstraction/core/BaseAccount.sol";
import {PackedUserOperation} from "account-abstraction/interfaces/PackedUserOperation.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {TokenCallbackHandler} from "account-abstraction/samples/callback/TokenCallbackHandler.sol";
import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "lib/account-abstraction/contracts/core/Helpers.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";


contract Wallet is BaseAccount, Initializable, UUPSUpgradeable, TokenCallbackHandler {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;
    
    address[] public owners;
    address public immutable walletFactory;
    IEntryPoint private immutable _entryPoint;

    event WalletInitialized(IEntryPoint indexed entryPoint, address[] owners);

    modifier _requireFromEntryPointOrFactory() {
        require(
            msg.sender == address(_entryPoint) || msg.sender == walletFactory,
            "only entry point or wallet factory can call"
        );
        _;
    }

    constructor(IEntryPoint anEntryPoint, address ourWalletFactory) {
        _entryPoint = anEntryPoint;
        walletFactory = ourWalletFactory;
    }

    function entryPoint() public view override returns (IEntryPoint) {
        return _entryPoint;
    }

    function _validateSignature(
        PackedUserOperation calldata userOp, // UserOperation data structure passed as input
        bytes32 userOpHash // Hash of the UserOperation without the signatures
    ) internal view override returns (uint256) {
        // Convert the userOpHash to an Ethereum Signed Message Hash
        bytes32 hash = userOpHash.toEthSignedMessageHash();

        // Decode the signatures from the userOp and store them in a bytes array in memory
        bytes[] memory signatures = abi.decode(userOp.signature, (bytes[]));

        // Loop through all the owners of the wallet
        for (uint256 i = 0; i < owners.length; i++) {
            // Recover the signer's address from each signature
            // If the recovered address doesn't match the owner's address, return SIG_VALIDATION_FAILED
            if (owners[i] != hash.recover(signatures[i])) {
                return SIG_VALIDATION_FAILED;
            }
        }
        // If all signatures are valid (i.e., they all belong to the owners), return 0
        return SIG_VALIDATION_SUCCESS;
    }

    function initialize(address[] memory initialOwners) public initializer {
        _initialize(initialOwners);
    }

    function _initialize(address[] memory initialOwners) internal {
        require(initialOwners.length > 0, "no owners");
        owners = initialOwners;
        emit WalletInitialized(_entryPoint, initialOwners);
    }

    function _call(address target, uint256 value, bytes memory data) internal {
    (bool success, bytes memory result) = target.call{value: value}(data);
        if (!success) {
            assembly {
                // The assembly code here skips the first 32 bytes of the result, which contains the length of data.
                // It then loads the actual error message using mload and calls revert with this error message.
                revert(add(result, 32), mload(result))
            }
        }
    }

    function execute(
    address dest,
    uint256 value,
    bytes calldata func
    ) external _requireFromEntryPointOrFactory {
        _call(dest, value, func);
    }

    function executeBatch(
        address[] calldata dests,
        uint256[] calldata values,
        bytes[] calldata funcs
    ) external _requireFromEntryPointOrFactory {
        require(dests.length == funcs.length, "wrong dests lengths");
        require(values.length == funcs.length, "wrong values lengths");
        for (uint256 i = 0; i < dests.length; i++) {
            _call(dests[i], values[i], funcs[i]);
        }
    }


    function _authorizeUpgrade(
        address
    ) internal view override _requireFromEntryPointOrFactory {}

    function encodeSignatures(

    bytes[] memory signatures

    ) public pure returns (bytes memory) {

        return abi.encode(signatures);

    }

    function getDeposit() public view returns (uint256) {

        return entryPoint().balanceOf(address(this));

    }

    function addDeposit() public payable {

        entryPoint().depositTo{value: msg.value}(address(this));

    }

    receive() external payable {}
}