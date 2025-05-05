DRIVER_PORT_NUM = 1235

def launch(
    plan,
    data_dirpath,
    jwtsecret_path,
    el_context,
    cl_context,
    geth,
    index,
    taiko_result,
):
    jwtsecret_file = "/tmp/jwt/jwtsecret"
    service = plan.add_service(
        name = "surge-taiko-driver-{0}".format(index),
        config = ServiceConfig(
            image = "nethsurge/taiko-client:latest",
            files = {
                "/data/l2_nethermind": "l2_files",
                "/tmp/jwt": "l2_files",
            },
            entrypoint = ["taiko-client"],
            cmd = [
                "driver",
                "--l1.ws={0}".format(el_context.ws_url),
                "--l2.ws={0}".format(geth.ws_url),
                "--l1.beacon={0}".format(cl_context.beacon_http_url),
                "--l2.auth={0}".format(geth.auth_url),
                "--taikoL1={0}".format(taiko_result.taiko),
                "--taikoL2=0x7633740000000000000000000000000000010001",
                "--jwtSecret={0}".format(jwtsecret_file),
                "--metrics true",
            ],
        ),
    )

    driver_url = "http://{0}:{1}".format(service.ip_address, DRIVER_PORT_NUM)

    return struct(
        client_name="taiko-driver",
        ip_addr=service.ip_address,
        driver_port_num=DRIVER_PORT_NUM,
        driver_url=driver_url,
        service_name=service.name,
    )
