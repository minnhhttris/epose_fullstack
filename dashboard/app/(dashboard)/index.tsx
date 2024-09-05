import React from 'react';
import Link from 'next/link';

const Dashboard = () => {
  return (
    <div>
      <h1>Admin Dashboard</h1>
      <nav>
        <ul>
          <li>
            <Link href="/dashboard/users">Manage Users</Link>
          </li>
        </ul>
      </nav>
    </div>
  );
};

export default Dashboard;
