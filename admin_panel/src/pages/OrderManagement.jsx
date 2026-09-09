import React, { useState, useEffect } from 'react'
import { apiFetch } from '../utils/api'

export default function OrderManagement() {
  const [orders, setOrders] = useState([])
  const [loading, setLoading] = useState(true)
  const [editingOrder, setEditingOrder] = useState(null)
  const [editForm, setEditForm] = useState({ status: '', tracking_id: '' })

  useEffect(() => {
    loadOrders()
  }, [])

  const loadOrders = async () => {
    try {
      const data = await apiFetch('/orders/')
      setOrders(data)
    } catch (err) {
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const handleUpdateClick = (order) => {
    setEditingOrder(order._id)
    setEditForm({
      status: order.status || 'pending',
      tracking_id: order.trackingId || ''
    })
  }

  const handleSaveUpdate = async (e) => {
    e.preventDefault()
    try {
      await apiFetch(`/orders/${editingOrder}`, {
        method: 'PUT',
        body: JSON.stringify(editForm)
      })
      setEditingOrder(null)
      loadOrders()
    } catch (err) {
      alert(err.message)
    }
  }

  return (
    <div className="p-8">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-bold text-slate-800">Order Management</h1>
      </div>
      
      <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-slate-500">Loading orders...</div>
        ) : (
          <table className="w-full text-left">
            <thead className="bg-slate-50 border-b border-slate-200">
              <tr>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Order ID</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Customer</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Products</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Amount</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Status</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {orders.map((order) => {
                const productList = (order.items || []).map(i => i.productName).join(', ');
                
                return (
                  <tr key={order._id} className="hover:bg-slate-50 transition-colors">
                    <td className="px-6 py-4">
                      <p className="font-medium text-slate-800">{order._id.substring(0,8)}...</p>
                      <p className="text-xs text-slate-500">Tracking: {order.trackingId || 'N/A'}</p>
                    </td>
                    <td className="px-6 py-4 text-slate-600 font-medium">{order.receiverName || 'Unknown'}</td>
                    <td className="px-6 py-4 text-slate-500 text-sm max-w-xs truncate" title={productList}>
                      {productList || 'No items'}
                    </td>
                    <td className="px-6 py-4 text-slate-600 font-medium">₹{order.price || order.total_amount || 0}</td>
                    <td className="px-6 py-4">
                      <span className={`px-2.5 py-1 rounded-full text-xs font-medium capitalize ${
                        order.status === 'shipped' || order.status === 'delivered' 
                        ? 'bg-indigo-100 text-indigo-700' 
                        : 'bg-orange-100 text-orange-700'
                      }`}>
                        {order.status || 'pending'}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button onClick={() => handleUpdateClick(order)} className="text-blue-600 hover:text-blue-800 font-medium text-sm">Update</button>
                    </td>
                  </tr>
                )
              })}
              {orders.length === 0 && (
                <tr><td colSpan="6" className="text-center py-8 text-slate-500">No orders found.</td></tr>
              )}
            </tbody>
          </table>
        )}
      </div>

      {editingOrder && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-xl p-6 w-full max-w-sm">
            <h2 className="text-xl font-bold mb-4">Update Order</h2>
            <form onSubmit={handleSaveUpdate} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Status</label>
                <select 
                  className="w-full border rounded-lg p-2 capitalize"
                  value={editForm.status}
                  onChange={e => setEditForm({...editForm, status: e.target.value})}
                >
                  <option value="pending">Pending</option>
                  <option value="processing">Processing</option>
                  <option value="shipped">Shipped</option>
                  <option value="delivered">Delivered</option>
                  <option value="cancelled">Cancelled</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Tracking ID</label>
                <input 
                  type="text" 
                  className="w-full border rounded-lg p-2" 
                  value={editForm.tracking_id} 
                  onChange={e => setEditForm({...editForm, tracking_id: e.target.value})} 
                />
              </div>
              <div className="flex justify-end gap-3 mt-6">
                <button type="button" onClick={() => setEditingOrder(null)} className="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-lg">Cancel</button>
                <button type="submit" className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90">Save</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  )
}
