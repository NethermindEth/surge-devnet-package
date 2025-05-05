el_admin_node_info = import_module("../el/el_admin_node_info.star")

RPC_PORT_NUM = 8547
WS_PORT_NUM = 8548
DISCOVERY_PORT_NUM = 30303
ENGINE_RPC_PORT_NUM = 8552
METRICS_PORT_NUM = 8018

GENESIS_HASH = "0x5b5ed0c10625de4c92c913c1751b819fece6d132fe47662c86d541e276b99568"
# ENABLED_MODULES = "debug,eth,net,web3,txpool,rpc,subscribe,trace,personal,proof,parity,health"
LOG_LEVEL = "debug"

# The min/max CPU/memory that the execution node can use
EXECUTION_MIN_CPU = 100
EXECUTION_MIN_MEMORY = 512
EXECUTION_MAX_CPU = 1000
EXECUTION_MAX_MEMORY = 2048

def launch(
    plan,
    data_dirpath,
    enode,
    index,
):
    service = plan.add_service(
        name = "surge-nethermind-{0}".format(index),
        config = ServiceConfig(
            image = "nethermindeth/nethermind:master-fd56a42",
            files = {
                "/data/l2_nethermind": "l2_files",
                "/tmp/jwt": "l2_files",
            },
            ports = {
                "metrics": PortSpec(
                    number=8018, transport_protocol="TCP"
                ),
                "http": PortSpec(
                    number=8547, transport_protocol="TCP"
                ),
                "ws": PortSpec(
                    number=8548, transport_protocol="TCP"
                ),
                "tcp-discovery": PortSpec(
                    number=30303, transport_protocol="TCP"
                ),
                "udp-discovery": PortSpec(
                    number=30303, transport_protocol="UDP"
                ),
                "authrpc": PortSpec(
                    number=8552, transport_protocol="TCP"
                ),
            },
            cmd = [
                "--config=none",
                "--datadir=/data/l2_nethermind",
                "--Init.ChainSpecPath=/data/l2_nethermind/chainspec.json",
                "--Init.GenesisHash={0}".format(GENESIS_HASH),
                "--Init.DiscoveryEnabled=false",
                "--Metrics.Enabled=true",
                "--Metrics.ExposePort={0}".format(METRICS_PORT_NUM),
                # "--Network.Bootnodes={0}".format(BOOT_NODES),
                "--JsonRpc.Enabled=true",
                "--JsonRpc.EnabledModules=[admin,debug,eth,net,web3,txpool,rpc,subscribe,trace,personal,proof,parity,health]",
                "--JsonRpc.Host=0.0.0.0",
                "--JsonRpc.Port={0}".format(RPC_PORT_NUM),
                "--JsonRpc.WebSocketsPort={0}".format(WS_PORT_NUM),
                "--JsonRpc.JwtSecretFile=/tmp/jwt/jwtsecret",
                "--JsonRpc.EngineHost=0.0.0.0",
                "--JsonRpc.EnginePort={0}".format(ENGINE_RPC_PORT_NUM),
                "--Network.DiscoveryPort={0}".format(DISCOVERY_PORT_NUM),
                "--Network.P2PPort={0}".format(DISCOVERY_PORT_NUM),
                "--HealthChecks.Enabled=true",
                "--log={0}".format(LOG_LEVEL),
            ],
            min_cpu = EXECUTION_MIN_CPU,
            max_cpu = EXECUTION_MAX_CPU,
            min_memory = EXECUTION_MIN_MEMORY,
            max_memory = EXECUTION_MAX_MEMORY,
        ),
    )

    enode = el_admin_node_info.get_enode_for_node(
        plan, service.name, "http"
    )

    enode_shell = plan.run_sh(
        run = "echo -n '" + enode + "' | sed 's/127.0.0.1/" + service.ip_address + "/'",
        name = "nethermind-enode",
        description = "Replace enode with actual IP",
    )

    http_url = "http://{0}:{1}".format(service.ip_address, RPC_PORT_NUM)
    ws_url = "ws://{0}:{1}".format(service.ip_address, WS_PORT_NUM)
    auth_url = "http://{0}:{1}".format(service.ip_address, ENGINE_RPC_PORT_NUM)

    # plan.store_service_files(
    #     service_name=service.name,
    #     src=data_dirpath,
    #     name="taiko_genesis_{0}".format(index),
    #     description="Copying taiko genesis files to the execution node",
    # )

    return struct(
        client_name="surge-nethermind",
        ip_addr=service.ip_address,
        rpc_port_num=RPC_PORT_NUM,
        ws_port_num=WS_PORT_NUM,
        engine_rpc_port_num=ENGINE_RPC_PORT_NUM,
        rpc_http_url=http_url,
        ws_url=ws_url,
        auth_url=auth_url,
        enode=enode_shell.output,
        # enr=enr,
        service_name=service.name,
    )
