import React from 'react'

export default function OrderManagement() {
  const orders = [
    { id: 'ORD-8374', customer: 'John Doe', amount: '₹1,200', date: '2026-08-25', status: 'Shipped', tracking: 'AWB12345' },
    { id: 'ORD-8375', customer: 'Jane Smith', amount: '₹25,000', date: '2026-08-24', status: 'Pending', tracking: 'N/A' },
  ]

  return (
    <div className="p-8">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-bold text-slate-800">Order Management</h1>
      </div>
      
      <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <table className="w-full text-left">
          <thead className="bg-slate-50 border-b border-slate-200">
            <tr>
              <th className="px-6 py-4 text-sm font-semibold text-slate-600">Order ID</th>
              <th className="px-6 py-4 text-sm font-semibold text-slate-600">Customer</th>
              <th className="px-6 py-4 text-sm font-semibold text-slate-600">Amount</th>
              <th className="px-6 py-4 text-sm font-semibold text-slate-600">Date</th>
              <th className="px-6 py-4 text-sm font-semibold text-slate-600">Status</th>
              <th className="px-6 py-4 text-sm font-semibold text-slate-600 text-right">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {orders.map((order) => (
              <tr key={order.id} className="hover:bg-slate-50 transition-colors">
                <td className="px-6 py-4">
                  <p className="font-medium text-slate-800">{order.id}</p>
                  <p className="text-xs text-slate-500">Tracking: {order.tracking}</p>
                </td>
                <td className="px-6 py-4 text-slate-600">{order.customer}</td>
                <td className="px-6 py-4 text-slate-600">{order.amount}</td>
                <td className="px-6 py-4 text-slate-600">{order.date}</td>
                <td className="px-6 py-4">
                  <span className={`px-2.5 py-1 rounded-full text-xs font-medium ${
                    order.status === 'Shipped' ? 'bg-indigo-100 text-indigo-700' : 'bg-orange-100 text-orange-700'
                  }`}>
                    {order.status}
                  </span>
                </td>
                <td className="px-6 py-4 text-right">
                  <button className="text-blue-600 hover:text-blue-800 font-medium text-sm">View Details</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
