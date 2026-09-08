import React, { useState, useEffect } from 'react'
import { Users, DollarSign, Package, AlertCircle } from 'lucide-react'
import { apiFetch } from '../utils/api'

export default function Dashboard() {
  const [stats, setStats] = useState({
    users: 0,
    revenue: 0,
    orders: 0,
    vendors: 0
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function loadStats() {
      try {
        const [ordersRes, vendorsRes, productsRes] = await Promise.all([
          apiFetch('/orders'),
          apiFetch('/vendors'),
          apiFetch('/products')
        ])
        
        // Calculate total revenue from orders
        const revenue = ordersRes.reduce((acc, order) => acc + (order.total_amount || 0), 0)

        setStats({
          users: 0, // Placeholder until users endpoint exists
          revenue,
          orders: ordersRes.length,
          vendors: vendorsRes.length,
          products: productsRes.length
        })
      } catch (err) {
        console.error('Failed to load stats:', err)
      } finally {
        setLoading(false)
      }
    }
    loadStats()
  }, [])

  const displayStats = [
    { label: 'Total Products', value: stats.products, icon: Package, color: 'text-blue-600', bg: 'bg-blue-100' },
    { label: 'Total Revenue', value: `₹${stats.revenue.toLocaleString()}`, icon: DollarSign, color: 'text-emerald-600', bg: 'bg-emerald-100' },
    { label: 'Total Orders', value: stats.orders, icon: Package, color: 'text-violet-600', bg: 'bg-violet-100' },
    { label: 'Total Vendors', value: stats.vendors, icon: Users, color: 'text-orange-600', bg: 'bg-orange-100' },
  ]

  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold text-slate-800 mb-8">Dashboard Overview</h1>
      
      {loading ? (
        <div className="text-slate-500">Loading dashboard stats...</div>
      ) : (
        <>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            {displayStats.map((stat) => {
              const Icon = stat.icon;
              return (
                <div key={stat.label} className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm flex items-center gap-4">
                  <div className={`w-12 h-12 rounded-lg ${stat.bg} flex items-center justify-center`}>
                    <Icon className={stat.color} size={24} />
                  </div>
                  <div>
                    <p className="text-sm font-medium text-slate-500">{stat.label}</p>
                    <p className="text-2xl font-bold text-slate-800">{stat.value}</p>
                  </div>
                </div>
              )
            })}
          </div>

          <div className="bg-white rounded-xl border border-slate-200 shadow-sm p-6">
            <h2 className="text-lg font-semibold text-slate-800 mb-4">Recent Activity</h2>
            <div className="space-y-4">
              <p className="text-sm text-slate-500">Activity feed coming soon...</p>
            </div>
          </div>
        </>
      )}
    </div>
  )
}
