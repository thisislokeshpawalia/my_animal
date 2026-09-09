import React, { useState, useEffect } from 'react'
import { apiFetch } from '../utils/api'

export default function ProductManagement() {
  const [products, setProducts] = useState([])
  const [loading, setLoading] = useState(true)
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [isEditing, setIsEditing] = useState(false)
  const [editingId, setEditingId] = useState(null)
  const [formData, setFormData] = useState({
    title: '', description: '', price: '', category: '', image: '', vendor_id: 'admin'
  })

  useEffect(() => {
    loadProducts()
  }, [])

  const loadProducts = async () => {
    try {
      const data = await apiFetch('/products/')
      setProducts(data)
    } catch (err) {
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this product?')) return;
    try {
      await apiFetch(`/products/${id}`, { method: 'DELETE' })
      loadProducts()
    } catch (err) {
      alert(err.message)
    }
  }

  const handleOpenAdd = () => {
    setIsEditing(false)
    setEditingId(null)
    setFormData({ title: '', description: '', price: '', category: '', image: '', vendor_id: 'admin' })
    setIsModalOpen(true)
  }

  const handleOpenEdit = (product) => {
    setIsEditing(true)
    setEditingId(product._id)
    setFormData({
      title: product.title || '',
      description: product.description || '',
      price: product.price || '',
      category: product.category || '',
      image: product.image || '',
      vendor_id: product.vendor_id || 'admin'
    })
    setIsModalOpen(true)
  }

  const handleSaveProduct = async (e) => {
    e.preventDefault()
    try {
      const payload = {
        ...formData,
        price: parseFloat(formData.price)
      }

      if (isEditing) {
        await apiFetch(`/products/${editingId}`, {
          method: 'PUT',
          body: JSON.stringify(payload)
        })
      } else {
        await apiFetch('/products/', {
          method: 'POST',
          body: JSON.stringify(payload)
        })
      }
      
      setIsModalOpen(false)
      loadProducts()
    } catch (err) {
      alert(err.message)
    }
  }

  return (
    <div className="p-8">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-bold text-slate-800">Product Management</h1>
        <button 
          onClick={handleOpenAdd}
          className="bg-primary text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-primary/90"
        >
          Add Product
        </button>
      </div>
      
      <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-slate-500">Loading products...</div>
        ) : (
          <table className="w-full text-left">
            <thead className="bg-slate-50 border-b border-slate-200">
              <tr>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Product Name</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Vendor</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600">Price</th>
                <th className="px-6 py-4 text-sm font-semibold text-slate-600 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {products.map((product) => (
                <tr key={product._id} className="hover:bg-slate-50 transition-colors">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      {product.image && <img src={product.image} alt={product.title} className="w-10 h-10 rounded object-cover" />}
                      <div>
                        <p className="font-medium text-slate-800">{product.title}</p>
                        <p className="text-xs text-slate-500">{product.category}</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4 text-slate-600">{product.vendor_id}</td>
                  <td className="px-6 py-4 text-slate-600">₹{product.price}</td>
                  <td className="px-6 py-4 text-right">
                    <button onClick={() => handleOpenEdit(product)} className="text-blue-500 hover:text-blue-700 font-medium text-sm mr-4">Edit</button>
                    <button onClick={() => handleDelete(product._id)} className="text-red-500 hover:text-red-700 font-medium text-sm">Delete</button>
                  </td>
                </tr>
              ))}
              {products.length === 0 && (
                <tr><td colSpan="4" className="text-center py-8 text-slate-500">No products found.</td></tr>
              )}
            </tbody>
          </table>
        )}
      </div>

      {isModalOpen && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-xl p-6 w-full max-w-md">
            <h2 className="text-xl font-bold mb-4">{isEditing ? 'Edit Product' : 'Add New Product'}</h2>
            <form onSubmit={handleSaveProduct} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Title</label>
                <input required type="text" className="w-full border rounded-lg p-2" value={formData.title} onChange={e => setFormData({...formData, title: e.target.value})} />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Price (₹)</label>
                <input required type="number" step="0.01" className="w-full border rounded-lg p-2" value={formData.price} onChange={e => setFormData({...formData, price: e.target.value})} />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Category</label>
                <input required type="text" className="w-full border rounded-lg p-2" value={formData.category} onChange={e => setFormData({...formData, category: e.target.value})} />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Image URL</label>
                <input type="text" className="w-full border rounded-lg p-2" value={formData.image} onChange={e => setFormData({...formData, image: e.target.value})} />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Description</label>
                <textarea className="w-full border rounded-lg p-2" value={formData.description} onChange={e => setFormData({...formData, description: e.target.value})}></textarea>
              </div>
              <div className="flex justify-end gap-3 mt-6">
                <button type="button" onClick={() => setIsModalOpen(false)} className="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-lg">Cancel</button>
                <button type="submit" className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90">{isEditing ? 'Save Changes' : 'Save Product'}</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  )
}
