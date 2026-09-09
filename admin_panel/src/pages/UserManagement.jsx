import React, { useState, useEffect } from 'react'
import { apiFetch } from '../utils/api'

export default function UserManagement() {
  const [users, setUsers] = useState([])
  const [loading, setLoading] = useState(true)
  const [editingUser, setEditingUser] = useState(null)
  const [editForm, setEditForm] = useState({ loyalty_points: 0 })

  useEffect(() => {
    loadUsers()
  }, [])

  const loadUsers = async () => {
    try {
      const data = await apiFetch('/auth/users')
      setUsers(data)
    } catch (err) {
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const handleUpdateClick = (user) => {
    setEditingUser(user._id)
    setEditForm({
      loyalty_points: user.loyalty_points || 0
    })
  }

  const handleSaveUpdate = async (e) => {
    e.preventDefault()
    try {
      await apiFetch(`/auth/users/${editingUser}`, {
        method: 'PUT',
        body: JSON.stringify(editForm)
      })
      setEditingUser(null)
      loadUsers()
    } catch (err) {
      alert(err.message)
    }
  }

  return (
    <div className="p-8">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-bold text-slate-800">User Management</h1>
      </div>
      
      <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-slate-500">Loading users...</div>
        ) : (
          <table className="w-full text-left">
            <thead className="bg-slate-50 border-b border-slate-200">
              <tr>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Email</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Role</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Loyalty Points</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {users.map((user) => (
                <tr key={user._id} className="hover:bg-slate-50 transition-colors">
                  <td className="px-6 py-4 text-slate-600 font-medium">{user.email}</td>
                  <td className="px-6 py-4">
                    <span className={`px-2.5 py-1 rounded-full text-xs font-medium ${
                      user.role === 'vendor' ? 'bg-purple-100 text-purple-700' : 'bg-blue-100 text-blue-700'
                    }`}>
                      {user.role || 'customer'}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-slate-600 font-medium">
                    {user.loyalty_points || 0} pts
                  </td>
                  <td className="px-6 py-4 text-right">
                    <button onClick={() => handleUpdateClick(user)} className="text-blue-600 hover:text-blue-800 font-medium text-sm">Edit Points</button>
                  </td>
                </tr>
              ))}
              {users.length === 0 && (
                <tr><td colSpan="4" className="text-center py-8 text-slate-500">No users found.</td></tr>
              )}
            </tbody>
          </table>
        )}
      </div>

      {editingUser && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-xl p-6 w-full max-w-sm">
            <h2 className="text-xl font-bold mb-4">Edit Loyalty Points</h2>
            <form onSubmit={handleSaveUpdate} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Points Balance</label>
                <input 
                  type="number" 
                  className="w-full border rounded-lg p-2" 
                  value={editForm.loyalty_points} 
                  onChange={e => setEditForm({...editForm, loyalty_points: parseInt(e.target.value) || 0})} 
                />
              </div>
              <div className="flex justify-end gap-3 mt-6">
                <button type="button" onClick={() => setEditingUser(null)} className="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-lg">Cancel</button>
                <button type="submit" className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90">Save</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  )
}
