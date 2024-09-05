import React, { useEffect, useState } from 'react';
import axios from 'axios';
import Table from '../../components/Table';

const Users = () => {
  const [users, setUsers] = useState<any[]>([]);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await axios.get('/api/users/all');
        setUsers(response.data);
      } catch (error) {
        console.error('Error fetching users:', error);
      }
    };
    fetchUsers();
  }, []);

  return (
    <div>
      <h1>Manage Users</h1>
      <Table data={users} />
    </div>
  );
};

export default Users;
