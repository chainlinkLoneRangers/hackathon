module.exports = async({getNamedAccounts, deployments}) => {
    const { deploy } = deployments
    const { deployer } = await getNamedAccounts()

    const reviewDeployment = await deploy("BlockchainReviews", {
        from: deployer,
        log: true,
    })
}

module.exports.tags = ["all", "reviews"]