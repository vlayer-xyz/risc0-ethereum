// Copyright 2024 RISC Zero, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {IRiscZeroVerifier} from "risc0/IRiscZeroVerifier.sol";
import {RiscZeroCheats} from "risc0/test/RiscZeroCheats.sol";
import {Counter} from "../src/Counter.sol";
import {ERC20FixedSupply} from "../test/Counter.t.sol";

/// @notice Deployment script for the Counter contract.
/// @dev Use the following environment variable to control the deployment:
///     * ETH_WALLET_PRIVATE_KEY private key of the wallet to be used for deployment.
///
/// See the Foundry documentation for more information about Solidity scripts.
/// https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployCounter is Script, RiscZeroCheats {
    function run() external {
        uint256 deployerKey = uint256(vm.envBytes32("ETH_WALLET_PRIVATE_KEY"));
        address tokenOwner = vm.envAddress("TOKEN_OWNER");

        vm.startBroadcast(deployerKey);

        ERC20FixedSupply toyken = new ERC20FixedSupply("TOYKEN", "TOY", tokenOwner);
        console2.log("Deployed ERC20 TOYKEN to", address(toyken));

        IRiscZeroVerifier verifier = deployRiscZeroVerifier();

        Counter counter = new Counter(verifier, address(toyken));
        console2.log("Deployed Counter to", address(counter));

        vm.stopBroadcast();
    }
}
