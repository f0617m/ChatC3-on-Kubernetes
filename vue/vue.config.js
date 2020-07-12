module.exports = {
    devServer: {
        port: 8080,
        disableHostCheck: true,
    },
    chainWebpack: config => {
        config.module.rules.delete('eslint');
    },
};
