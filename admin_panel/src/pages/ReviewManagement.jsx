import React from 'react'

export default function ReviewManagement() {
  return (
    <div className="p-8">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-bold text-slate-800">Review Moderation</h1>
      </div>
      
      <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden p-12 text-center">
        <div className="w-16 h-16 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center mx-auto mb-4">
          <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
        </div>
        <h2 className="text-xl font-bold text-slate-800 mb-2">Coming Soon</h2>
        <p className="text-slate-500 max-w-md mx-auto">
          The Product Reviews feature is currently being integrated into the backend database. 
          Once the backend API is ready to support storing and fetching reviews, this page will allow you to read, approve, and delete customer reviews.
        </p>
      </div>
    </div>
  )
}
