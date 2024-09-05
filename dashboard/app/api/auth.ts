import axios from 'axios';

export const login = async (email: string, password: string) => {
  try {
    const response = await axios.post('/api/users/login', { email, password });
    return response.data;
  } catch (error) {
    throw new Error('Login failed');
  }
};
