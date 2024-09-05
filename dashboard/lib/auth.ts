import axios from 'axios';

export const checkAdmin = async () => {
  try {
    const response = await axios.get('/api/auth/check-admin');
    return response.data;
  } catch (error) {
    throw new Error('Unauthorized');
  }
};
