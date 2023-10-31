pragma solidity ^0.8;

import "../interfaces/IAggregator.sol";

abstract contract AbsAA {

    /**
    * User Operation struct
    * @param sender                - The sender account of this request.
    * @param nonce                 - Unique value the sender uses to verify it is not a replay.
    * @param initCode              - If set, the account contract will be created by this constructor/
    * @param callData              - The method call to execute on this account.
    * @param callGasLimit          - The gas limit passed to the callData method call.
    * @param verificationGasLimit  - Gas used for validateUserOp and validatePaymasterUserOp.
    * @param preVerificationGas    - Gas not calculated by the handleOps method, but added to the gas paid.
    *                                Covers batch overhead.
    * @param maxFeePerGas          - Same as EIP-1559 gas parameter.
    * @param maxPriorityFeePerGas  - Same as EIP-1559 gas parameter.
    * @param paymasterAndData      - If set, this field holds the paymaster address and paymaster-specific data.
    *                                The paymaster will pay for the transaction instead of the sender.
    * @param signature             - Sender-verified signature over the entire request, the EntryPoint address and the chain ID.
    */
    struct UserOperation {
        address sender;
        uint256 nonce;
        bytes initCode;
        bytes callData;
        uint256 callGasLimit;
        uint256 verificationGasLimit;
        uint256 preVerificationGas;
        uint256 maxFeePerGas;
        uint256 maxPriorityFeePerGas;
        bytes paymasterAndData;
        bytes signature;
    }

    function handleOps(
        UserOperation[] calldata ops, 
        address payable beneficiary
    ) private;

    function handleAggregatedOps(
        UserOpsPerAggregator[] calldata opsPerAggregator,
        address payable beneficiary
    ) private ;

        
    struct UserOpsPerAggregator {
        UserOperation[] userOps;
        IAggregator aggregator;
        bytes signature;
    }

    function simulateValidation(UserOperation calldata userOp) private;

    error ValidationResult(ReturnInfo returnInfo,
        StakeInfo senderInfo, StakeInfo factoryInfo, StakeInfo paymasterInfo);

    error ValidationResultWithAggregation(ReturnInfo returnInfo,
        StakeInfo senderInfo, StakeInfo factoryInfo, StakeInfo paymasterInfo,
        AggregatorStakeInfo aggregatorInfo);

    struct ReturnInfo {
        uint256 preOpGas;
        uint256 prefund;
        bool sigFailed;
        uint48 validAfter;
        uint48 validUntil;
        bytes paymasterContext;
    }

    struct StakeInfo {
        uint256 stake;
        uint256 unstakeDelaySec;
    }

    struct AggregatorStakeInfo {
        address actualAggregator;
        StakeInfo stakeInfo;
    }


}
