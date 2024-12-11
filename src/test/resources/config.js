function fn() {
    var baseURL = '';
    var env = karate.env;

    if (!env) {
            env = 'qa';
    }

    if (env === 'qa') {
        baseURL = 'https://restful-booker.herokuapp.com';
    }

    var config = {
            env: env,
            baseURL: baseURL
    };

    return config;
}