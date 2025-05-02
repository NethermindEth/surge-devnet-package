def deploy(
    plan,
    taiko_params,
    prefunded_account,
    el_rpc_url,
    deployment_result,
):
    FORK_URL_COMMAND = "--fork-url {0}".format(el_rpc_url)

    PRIVATE_KEY_COMMAND = "--private-key {0}".format(prefunded_account.private_key)

    ENV_VARS = {
        "GUEST_PROOF_PROGRAM_VK": taiko_params.taiko_protocol_guest_vk,
        "AGGREGATION_PROOF_PROGRAM_VK": taiko_params.taiko_protocol_aggregation_vk,
        "SP1_VERIFIER": deployment_result.tier_zkvm_sp1,
        "PRIVATE_KEY": "0x{0}".format(prefunded_account.private_key),
        "FORK_URL": el_rpc_url,
    }

    deployment_result = plan.run_sh(
        run = "cast send $SP1_VERIFIER 'setProgramTrusted(bytes32,bool)' $GUEST_PROOF_PROGRAM_VK true --rpc-url $FORK_URL --private-key $(PRIVATE_KEY) && cast send $SP1_VERIFIER 'setProgramTrusted(bytes32,bool)' $AGGREGATION_PROOF_PROGRAM_VK true --rpc-url $FORK_URL --private-key $PRIVATE_KEY"
        name = "set-trusted-program-vk",
        image = taiko_params.taiko_protocol_image,
        env_vars = ENV_VARS,
        wait = None,
        description = "Deploying taiko SP1 set trusted program vk",
    )
