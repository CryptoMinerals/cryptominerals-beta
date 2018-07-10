module.exports = {
    networks: {
      development: {
        host: "localhost",
        port: 9545,
        network_id: "*" // Match any network id
      },
        rinkeby: {
        host: "localhost",
        port: 9545,
        from: "0xE700D0c54F54025256490676014464a2fF532A18",
        network_id: 4,
        gas: 4612388 // Gas limit used for deploys
      }
    },
    rpc: {
      host: "localhost",
      gas: 4712388,
      port: 9545
    },
    solc: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    },
  };
