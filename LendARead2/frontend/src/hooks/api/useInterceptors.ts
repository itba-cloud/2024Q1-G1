import { AxiosInstance } from "axios";
import { AuthContext, logoutStorages } from "../../contexts/authContext.tsx";
import { api, api_ } from "./api.ts";
import { useContext } from "react";
import { useNavigate } from "react-router-dom";

const useInterceptors = () => {

    const { logout } = useContext(AuthContext)
    const navigate = useNavigate()

    const modifyUrl = (url: string | undefined): string | undefined => {
        if (url && url.includes("/webapp/api")) {
            if (url.startsWith("http:")) {
                url = url.replace("http:", "https:");
            }
            const urlObject = new URL(url);
            if (urlObject.port === "8080") {
                urlObject.port = "";
            }
            url = urlObject.toString();
        }
        return url;
    }

    api.interceptors.request.use(request => {
        request.url = modifyUrl(request.url);
        return request;
    }, error => {
        return Promise.reject(error);
    });

    api_.interceptors.request.use(request => {
        request.url = modifyUrl(request.url);
        return request;
    }, error => {
        return Promise.reject(error);
    });

    api.interceptors.response.use(response => {
        return response;
    }, async (error) => { return await handleError(error, api) });

    api_.interceptors.response.use(response => {
        return response;
    }, async (error) => { return await handleError(error, api_) });

    const handleLogout = () => {
        logout();
        navigate('/login');
    }

    const refreshToken = async () => {
        try {
            const rememberMe = localStorage.getItem("rememberMe");
            const refreshToken = rememberMe === "true" ? localStorage.getItem("refreshToken") : sessionStorage.getItem('refreshToken');

            if (refreshToken === "") return null;

            api.defaults.headers.common['Authorization'] = `Bearer ${refreshToken}`;
            const response = await api('/');

            //@ts-ignore
            const token = response.headers.get('x-jwt');

            if (token === null || token === undefined) return null;

            if (rememberMe === "true")
                localStorage.setItem('userAuthToken', token);
            else
                sessionStorage.setItem('userAuthToken', token);

            return token;
        } catch (error) {
            console.error("Error decoding refresh token", error);
            return null;
        }
    }

    const handleError = async (error, Api: AxiosInstance) => {
        try {
            const originalRequest = error.config;

            if (error.response !== undefined && error.response.status === 401 && !originalRequest._retry) {
                originalRequest._retry = true;

                const newToken = await refreshToken();

                if (newToken === null) {
                    handleLogout();
                    return Promise.reject(error);
                }

                Api.defaults.headers.common['Authorization'] = `Bearer ${newToken}`;
                originalRequest.headers['Authorization'] = `Bearer ${newToken}`;

                try {
                    const newRequest = Api(originalRequest);
                    return newRequest;
                } catch (error) {
                    handleLogout();
                    return Promise.reject(error);
                }
            }
        } catch (e) {
            console.error("Error handling the error", e);
        }

        return Promise.reject(error);
    }
}

export default useInterceptors;
