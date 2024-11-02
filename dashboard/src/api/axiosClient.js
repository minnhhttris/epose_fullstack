import axios from "axios";

const http = 'http://localhost:4000/api';

const axiosClient = axios.create({
    baseURL: http,
    headers: {
        "Content-Type": 'application/json',
    }
});

axiosClient.interceptors.request.use(config => {
    const token = localStorage.getItem('accessToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  }, error => {
    return Promise.reject(error);
  });

axiosClient.interceptors.response.use(function (response) {
    return response;
}, function (error) {
    return Promise.reject(error);
});

export default axiosClient;
