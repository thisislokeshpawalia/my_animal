import React, { useState, useEffect } from 'react'
import { apiFetch } from '../utils/api'

export default function VendorManagement() {
  const [vendors, setVendors] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    loadVendors()
  }, [])

  const loadVendors = async () => {
    try {
      const data = await apiFetch('/vendors/')
      setVendors(data)
    } catch (err) {
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const handleUpdateStatus = async (id, newStatus) => {
    if (!window.confirm(`Are you sure you want to ${newStatus} this vendor?`)) return;
    try {
      await apiFetch(`/vendors/${id}/status`, {
        method: 'PUT',
        body: JSON.stringify({ status: newStatus })
      })
      loadVendors()
    } catch (err) {
      alert(err.message)
    }
  }

  return (
    <div className="p-8">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-bold text-slate-800">Vendor Management</h1>
      </div>
      
      <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-slate-500">Loading vendors...</div>
        ) : (
          <table className="w-full text-left">
            <thead className="bg-slate-50 border-b border-slate-200">
              <tr>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Business Name</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Email</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Status</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {vendors.map((vendor) => (
                <tr key={vendor._id} className="hover:bg-slate-50 transition-colors">
                  <td className="px-6 py-4">
                    <p className="font-medium text-slate-800">{vendor.business_name}</p>
                    <p className="text-xs text-slate-500">ID: {vendor.uid}</p>
                  </td>
                  <td className="px-6 py-4 text-slate-600">{vendor.email}</td>
                  <td className="px-6 py-4">
                    <span className={`px-2.5 py-1 rounded-full text-xs font-medium ${
                      vendor.status === 'approved' ? 'bg-emerald-100 text-emerald-700' :
                      vendor.status === 'rejected' ? 'bg-red-100 text-red-700' :
                      'bg-orange-100 text-orange-700'
                    }`}>
                      {vendor.status || 'pending'}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-right">
                    {(!vendor.status || vendor.status === 'pending') && (
                      <div className="flex justify-end gap-3">
                        <button onClick={() => handleUpdateStatus(vendor._id, 'approved')} className="text-emerald-600 hover:text-emerald-800 font-medium text-sm">Approve</button>
                        <button onClick={() => handleUpdateStatus(vendor._id, 'rejected')} className="text-red-500 hover:text-red-700 font-medium text-sm">Reject</button>
                      </div>
                    )}
                  </td>
                </tr>
              ))}
              {vendors.length === 0 && (
                <tr><td colSpan="4" className="text-center py-8 text-slate-500">No vendors found.</td></tr>
              )}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}
