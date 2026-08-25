import React from 'react'
import { Users, DollarSign, Package, AlertCircle } from 'lucide-react'

export default function Dashboard() {
  const stats = [
    { label: 'Total Users', value: '2,845', icon: Users, color: 'text-blue-600', bg: 'bg-blue-100' },
    { label: 'Total Revenue', value: '₹4,32,000', icon: DollarSign, color: 'text-emerald-600', bg: 'bg-emerald-100' },
    { label: 'Active Orders', value: '142', icon: Package, color: 'text-violet-600', bg: 'bg-violet-100' },
    { label: 'Pending Approvals', value: '8', icon: AlertCircle, color: 'text-orange-600', bg: 'bg-orange-100' },
  ]

  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold text-slate-800 mb-8">Dashboard Overview</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {stats.map((stat) => {
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
          {[1, 2, 3].map((i) => (
            <div key={i} className="flex items-center gap-4 pb-4 border-b border-slate-100 last:border-0 last:pb-0">
              <div className="w-2 h-2 rounded-full bg-primary"></div>
              <div>
                <p className="text-sm font-medium text-slate-800">New vendor registration: Pet Supplies Co.</p>
                <p className="text-xs text-slate-500">2 hours ago</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
