export const API_URL = import.meta.env.VITE_API_URL || 'https://myanimal-production.up.railway.app/api';

export const apiFetch = async (endpoint, options = {}) => {
  // We can add auth tokens here later if needed
  const headers = {
    'Content-Type': 'application/json',
    ...options.headers,
  };

  const response = await fetch(`${API_URL}${endpoint}`, {
    ...options,
    headers,
  });

  if (!response.ok) {
    let errorMessage = `API Error: ${response.status} ${response.statusText}`;
    try {
      const errorData = await response.json();
      if (errorData.detail) errorMessage = errorData.detail;
    } catch (e) {
      // Ignore if no JSON body
    }
    throw new Error(errorMessage);
  }

  // Some endpoints might return 204 No Content
  if (response.status === 204) return null;
  
  return response.json();
};
