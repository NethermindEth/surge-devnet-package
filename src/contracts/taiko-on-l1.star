SOLIDITY_SCRIPT_PATH = "./script/layer1/based/DeployProtocolOnL1.s.sol:DeployProtocolOnL1"

def deploy(
    plan,
    taiko_params,
    prefunded_account,
    el_rpc_url,
):
    FORK_URL_COMMAND = "--fork-url {0}".format(el_rpc_url)

    PRIVATE_KEY_COMMAND = "--private-key {0}".format(prefunded_account.private_key)

    ENV_VARS = {
        "TAIKO_ANCHOR_ADDRESS": "0x{0}0000000000000000000000000000000001".format(taiko_params.taiko_protocol_l2_network_id),
        "L2_SIGNAL_SERVICE": "0x{0}0000000000000000000000000000000005".format(taiko_params.taiko_protocol_l2_network_id),
        "CONTRACT_OWNER": prefunded_account.address,
        "PROVER_SET_ADMIN": prefunded_account.address,
        "SHARED_RESOLVER": "0x0000000000000000000000000000000000000000",
        "L2_GENESIS_HASH": taiko_params.taiko_protocol_l2_genesis_hash,
        "PAUSE_BRIDGE": "true",
        "FOUNDRY_PROFILE": taiko_params.taiko_protocol_foundry_profile,
        "DEPLOY_PRECONF_CONTRACTS": "false",
        "PRECONF_INBOX": "false",
        "INCLUSION_WINDOW": "24",
        "INCLUSION_FEE_IN_GWEI": "100",
        "PRIVATE_KEY": "0x{0}".format(prefunded_account.private_key),
        "FORGE_FLAGS": "--broadcast --ffi -vv --block-gas-limit 200000000",
    }

    plan.run_sh(
        run = "forge script {0} {1} {2} $FORGE_FLAGS".format(SOLIDITY_SCRIPT_PATH, PRIVATE_KEY_COMMAND, FORK_URL_COMMAND),
        name = "taiko-on-l1",
        # Protocol Image
        image = taiko_params.taiko_protocol_image,
        env_vars = ENV_VARS,
        store = [StoreSpec(src = "app/deployments/deploy_l1.json", name = "taiko_on_l1_deployment")],
        wait = None,
        description = "Deploying taiko on l1",
    )

    plan.add_service(
        name = "taiko-on-l1-result",
        config = ServiceConfig(
            image = "badouralix/curl-jq",
            files = {
                "/test": "taiko_on_l1_deployment",
            },
        ),
    )

    result = plan.exec(
        service_name = "taiko-on-l1-result",
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", "cat /test/deploy_l1.json"],
            extract = {
                "automata_dcap_attestation": "fromjson | .automata_dcap_attestation",
                "bridge": "fromjson | .bridge",
                "erc1155_vault": "fromjson | .erc1155_vault",
                "erc20_vault": "fromjson | .erc20_vault",
                "erc721_vault": "fromjson | .erc721_vault",
                "op_verifier": "fromjson | .op_verifier",
                "proof_verifier": "fromjson | .proof_verifier",
                "rollup_address_resolver": "fromjson | .rollup_address_resolver",
                "shared_resolver": "fromjson | .shared_resolver",
                "signal_service": "fromjson | .signal_service",
                "taiko": "fromjson | .taiko",
                "sgx_verifier": "fromjson | .sgx_verifier",
                "risc0_verifier": "fromjson | .risc0_verifier",
                "sp1_verifier": "fromjson | .sp1_verifier",
            }
        ),
    )

    return struct(
        automata_dcap_attestation = result["extract.automata_dcap_attestation"],
        bridge = result["extract.bridge"],
        erc1155_vault = result["extract.erc1155_vault"],
        erc20_vault = result["extract.erc20_vault"],
        erc721_vault = result["extract.erc721_vault"],
        op_verifier = result["extract.op_verifier"],
        proof_verifier = result["extract.proof_verifier"],
        rollup_address_resolver = result["extract.rollup_address_resolver"],
        shared_resolver = result["extract.shared_resolver"],
        signal_service = result["extract.signal_service"],
        taiko = result["extract.taiko"],
        sgx_verifier = result["extract.sgx_verifier"],
        risc0_verifier = result["extract.risc0_verifier"],
        sp1_verifier = result["extract.sp1_verifier"],
    )
