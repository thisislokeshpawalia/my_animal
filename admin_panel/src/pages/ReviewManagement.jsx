import React, { useState, useEffect } from 'react'
import { apiFetch } from '../utils/api'

export default function ReviewManagement() {
  const [reviews, setReviews] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    loadReviews()
  }, [])

  const loadReviews = async () => {
    try {
      const data = await apiFetch('/reviews/')
      setReviews(data)
    } catch (err) {
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this review?')) return;
    try {
      await apiFetch(`/reviews/${id}`, { method: 'DELETE' })
      loadReviews()
    } catch (err) {
      alert(err.message)
    }
  }

  return (
    <div className="p-8">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-bold text-slate-800">Review Moderation</h1>
      </div>
      
      <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-slate-500">Loading reviews...</div>
        ) : (
          <table className="w-full text-left">
            <thead className="bg-slate-50 border-b border-slate-200">
              <tr>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Product / Vendor ID</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">User ID</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Rating</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Review Text</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {reviews.map((review) => (
                <tr key={review._id} className="hover:bg-slate-50 transition-colors">
                  <td className="px-6 py-4">
                    <p className="font-medium text-slate-800">{review.product_id || review.vendor_id || 'Unknown'}</p>
                    <p className="text-xs text-slate-500">{(new Date(review.created_at)).toLocaleDateString()}</p>
                  </td>
                  <td className="px-6 py-4 text-slate-600">{review.user_id}</td>
                  <td className="px-6 py-4 text-slate-600 font-medium">⭐ {review.rating}/5</td>
                  <td className="px-6 py-4 text-slate-600 text-sm max-w-sm">
                    {review.text || <span className="text-slate-400 italic">No text</span>}
                  </td>
                  <td className="px-6 py-4 text-right">
                    <button onClick={() => handleDelete(review._id)} className="text-red-500 hover:text-red-700 font-medium text-sm">Delete</button>
                  </td>
                </tr>
              ))}
              {reviews.length === 0 && (
                <tr><td colSpan="5" className="text-center py-8 text-slate-500">No reviews found.</td></tr>
              )}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}
