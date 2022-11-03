import axios from "axios";

const awsApi = axios.create(
    {
        baseURL: `https://62xvsqwe1k.execute-api.us-east-1.amazonaws.com/dev/vue-spike`
    }
);

export default awsApi;