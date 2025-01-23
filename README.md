# Kurtosis Package Runbook - taiko-preconf-devnet

# Kurtosis Package Deployment

<aside>
⏱️

The deployment normally takes ~ 25 mins.

</aside>

## Install Docker

1. If you don't already have Docker installed, follow the instructions [here](https://docs.docker.com/get-docker/) to install the Docker application specific to your machine (e.g. Apple Intel, Apple M1, etc.).
2. Start the Docker daemon (e.g. open Docker Desktop)
3. Verify that Docker is running:

    `docker image ls`


## Install Kurtosis CLI

For Ubuntu:

```jsx
echo "deb [trusted=yes] https://apt.fury.io/kurtosis-tech/ /" | sudo tee /etc/apt/sources.list.d/kurtosis.list
sudo apt update
sudo apt install kurtosis-cli
```

For MacOS:

```jsx
brew install kurtosis-tech/tap/kurtosis-cli
```

## Download preconfirm-devnet-package Repository and Start taiko-preconf-devnet Enclave

```jsx
git clone https://github.com/NethermindEth/preconfirm-devnet-package.git && \
cd preconfirm-devnet-package && \
git checkout origin/feat/core-rollup && \
kurtosis run --enclave core-rollup . --args-file network_params.yaml
```

## Pre-funded Accounts

```jsx
# m/44'/60'/0'/0/0
new_prefunded_account(
    "0x8943545177806ED17B9F23F0a21ee5948eCaa776",
    "bcdf20249abf0ed6d944c0288fad489e33f66b3960d9e6229c1cd214ed3bbe31",
),
# m/44'/60'/0'/0/1
new_prefunded_account(
    "0xE25583099BA105D9ec0A67f5Ae86D90e50036425",
    "39725efee3fb28614de3bacaffe4cc4bd8c436257e2c8bb887c4b5c4be45e76d",
),
# m/44'/60'/0'/0/2
new_prefunded_account(
    "0x614561D2d143621E126e87831AEF287678B442b8",
    "53321db7c1e331d93a11a41d16f004d7ff63972ec8ec7c25db329728ceeb1710",
),
# m/44'/60'/0'/0/3
new_prefunded_account(
    "0xf93Ee4Cf8c6c40b329b0c0626F28333c132CF241",
    "ab63b23eb7941c1251757e24b3d2350d2bc05c3c388d06f8fe6feafefb1e8c70",
),
# m/44'/60'/0'/0/4
new_prefunded_account(
    "0x802dCbE1B1A97554B4F50DB5119E37E8e7336417",
    "5d2344259f42259f82d2c140aa66102ba89b57b4883ee441a8b312622bd42491",
),
# m/44'/60'/0'/0/5
new_prefunded_account(
    "0xAe95d8DA9244C37CaC0a3e16BA966a8e852Bb6D6",
    "27515f805127bebad2fb9b183508bdacb8c763da16f54e0678b16e8f28ef3fff",
),
# m/44'/60'/0'/0/6
new_prefunded_account(
    "0x2c57d1CFC6d5f8E4182a56b4cf75421472eBAEa4",
    "7ff1a4c1d57e5e784d327c4c7651e952350bc271f156afb3d00d20f5ef924856",
),
# m/44'/60'/0'/0/7
new_prefunded_account(
    "0x741bFE4802cE1C4b5b00F9Df2F5f179A1C89171A",
    "3a91003acaf4c21b3953d94fa4a6db694fa69e5242b2e37be05dd82761058899",
),
# m/44'/60'/0'/0/8
new_prefunded_account(
    "0xc3913d4D8bAb4914328651C2EAE817C8b78E1f4c",
    "bb1d0f125b4fb2bb173c318cdead45468474ca71474e2247776b2b4c0fa2d3f5",
),
# m/44'/60'/0'/0/9
new_prefunded_account(
    "0x65D08a056c17Ae13370565B04cF77D2AfA1cB9FA",
    "850643a0224065ecce3882673c21f56bcf6eef86274cc21cadff15930b59fc8c",
),
# m/44'/60'/0'/0/10
new_prefunded_account(
    "0x3e95dFbBaF6B348396E6674C7871546dCC568e56",
    "94eb3102993b41ec55c241060f47daa0f6372e2e3ad7e91612ae36c364042e44",
),
# m/44'/60'/0'/0/11
new_prefunded_account(
    "0x5918b2e647464d4743601a865753e64C8059Dc4F",
    "daf15504c22a352648a71ef2926334fe040ac1d5005019e09f6c979808024dc7",
),
# m/44'/60'/0'/0/12
new_prefunded_account(
    "0x589A698b7b7dA0Bec545177D3963A2741105C7C9",
    "eaba42282ad33c8ef2524f07277c03a776d98ae19f581990ce75becb7cfa1c23",
),
# m/44'/60'/0'/0/13
new_prefunded_account(
    "0x4d1CB4eB7969f8806E2CaAc0cbbB71f88C8ec413",
    "3fd98b5187bf6526734efaa644ffbb4e3670d66f5d0268ce0323ec09124bff61",
),
# m/44'/60'/0'/0/14
new_prefunded_account(
    "0xF5504cE2BcC52614F121aff9b93b2001d92715CA",
    "5288e2f440c7f0cb61a9be8afdeb4295f786383f96f5e35eb0c94ef103996b64",
),
# m/44'/60'/0'/0/15
new_prefunded_account(
    "0xF61E98E7D47aB884C244E39E031978E33162ff4b",
    "f296c7802555da2a5a662be70e078cbd38b44f96f8615ae529da41122ce8db05",
),
# m/44'/60'/0'/0/16
new_prefunded_account(
    "0xf1424826861ffbbD25405F5145B5E50d0F1bFc90",
    "bf3beef3bd999ba9f2451e06936f0423cd62b815c9233dd3bc90f7e02a1e8673",
),
# m/44'/60'/0'/0/17
new_prefunded_account(
    "0xfDCe42116f541fc8f7b0776e2B30832bD5621C85",
    "6ecadc396415970e91293726c3f5775225440ea0844ae5616135fd10d66b5954",
),
# m/44'/60'/0'/0/18
new_prefunded_account(
    "0xD9211042f35968820A3407ac3d80C725f8F75c14",
    "a492823c3e193d6c595f37a18e3c06650cf4c74558cc818b16130b293716106f",
),
# m/44'/60'/0'/0/19
new_prefunded_account(
    "0xD8F3183DEF51A987222D845be228e0Bbb932C222",
    "c5114526e042343c6d1899cad05e1c00ba588314de9b96929914ee0df18d46b2",
),
# m/44'/60'/0'/0/20
new_prefunded_account(
    "0xafF0CA253b97e54440965855cec0A8a2E2399896",
    "4b9f63ecf84210c5366c66d68fa1f5da1fa4f634fad6dfc86178e4d79ff9e59",
),
```

## MEV Builder

**MEV Builder is using the first pre-funded account as transaction signing key.**

```jsx
"BUILDER_TX_SIGNING_KEY=0xbcdf20249abf0ed6d944c0288fad489e33f66b3960d9e6229c1cd214ed3bbe31"
```
