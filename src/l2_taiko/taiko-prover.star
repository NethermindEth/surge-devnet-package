PROVER_PORT_NUM = 1234

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
        name = "surge-taiko-prover-{0}".format(index),
        config = ServiceConfig(
            image = "nethsurge/taiko-client:latest",
            files = {
                "/data/l2_nethermind": "l2_files",
                "/tmp/jwt": "l2_files",
            },
            entrypoint = ["taiko-client"],
            cmd = [
                "prover",
                "--l1.ws={0}".format(el_context.ws_url),
                "--l2.http={0}".format(geth.rpc_http_url),
                "--l2.ws={0}".format(geth.ws_url),
                "--taikoL1={0}".format(taiko_result.taiko),
                "--taikoL2=0x7633740000000000000000000000000000010001",
                "--l1.proverPrivKey={0}".format(prefunded_accounts[3].private_key),
                "--prover.capacity=1",
                "--sgxVerifier={0}".format(taiko_result.tier_sgx),
                "--sp1Verifier={0}".format(taiko_result.tier_sp1),
                "--risc0Verifier={0}".format(taiko_result.tier_risc0),
                "--raiko.host={0}".format(taiko_result.raiko),
                "--raiko.host.zkvm={0}".format(taiko_result.tier_zkvm_risc0),
                "--raiko.requestTimeout=120s",
                "--raiko.sp1Recursion=plonk",
                "--raiko.sp1Prover=local",
                "--raiko.risc0Bonsai=false",
                "--raiko.risc0Snark=true",
                "--raiko.risc0Profile=false",
                "--raiko.risc0ExecutionPo2=20",
                "--tx.gasLimit=1000000",
                "--tx.notInMempoolTimeout=30s",
                "--tx.resubmissionTimeout=10s",
                "--prover.blockConfirmations=32",
                "--metrics true",
            ],
        ),
    )

    # proposer_url = "http://{0}:{1}".format(service.ip_address, PROPOSER_PORT_NUM)

    return struct(
        client_name="taiko-prover",
        ip_addr=service.ip_address,
        prover_port_num=PROVER_PORT_NUM,
        # prover_url=prover_url,
        service_name=service.name,
    )
