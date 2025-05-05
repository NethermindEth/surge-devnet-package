PROPOSER_PORT_NUM = 1234

def launch(
    plan,
    data_dirpath,
    jwtsecret_path,
    el_context,
    cl_context,
    geth,
    prefunded_accounts,
    index,
    taiko_result,
):
    jwtsecret_file = "/tmp/jwt/jwtsecret"
    service = plan.add_service(
        name = "surge-taiko-proposer-{0}".format(index),
        config = ServiceConfig(
            image = "nethsurge/taiko-client:latest",
            files = {
                "/data/l2_nethermind": "l2_files",
                "/tmp/jwt": "l2_files",
            },
            entrypoint = ["taiko-client"],
            cmd = [
                "proposer",
                "--l1.ws={0}".format(el_context.ws_url),
                "--l2.http={0}".format(geth.rpc_http_url),
                "--l2.auth={0}".format(geth.auth_url),
                "--taikoL1={0}".format(taiko_result.taiko),
                "--taikoL2=0x7633740000000000000000000000000000010001",
                "--jwtSecret={0}".format(jwtsecret_file),
                "--l1.proposerPrivKey={0}".format(prefunded_accounts[2].private_key),
                "--l2.suggestedFeeRecipient={0}".format(prefunded_accounts[1].address),
                "--checkProfitability=false",
                "--allowEmptyBlocks=false",
                "--epoch.interval=5s",
                "--l1.blobAllowed",
                "--tx.notInMempoolTimeout=30s",
                "--tx.resubmissionTimeout=10s",
                "--tx.gasLimit=1000000",
                "--gasNeededForProvingBlock=100000",
                "--offChainCosts=50000000000000",
                "--priceFluctuationModifier=15",
                "--verbosity=4",
                "--inbox={0}".format(taiko_result.signal_service),
                "--metrics true",
            ],
        ),
    )

    # proposer_url = "http://{0}:{1}".format(service.ip_address, PROPOSER_PORT_NUM)

    return struct(
        client_name="taiko-proposer",
        ip_addr=service.ip_address,
        proposer_port_num=PROPOSER_PORT_NUM,
        # proposer_url=proposer_url,
        service_name=service.name,
    )
