import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export async function middleware(request: NextRequest) {
  const url = request.nextUrl.clone();
  const token = request.cookies.get('token');

  if (!token) {
    url.pathname = '/login';
    return NextResponse.redirect(url);
  }

  // Check if the user has the 'admin' role
  try {
    const response = await fetch(`${process.env.BACKEND_URL}/api/auth/check-role`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });
    const data = await response.json();

    if (data.role !== 'admin') {
      url.pathname = '/login';
      return NextResponse.redirect(url);
    }
  } catch (error) {
    url.pathname = '/login';
    return NextResponse.redirect(url);
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/dashboard'],
};
