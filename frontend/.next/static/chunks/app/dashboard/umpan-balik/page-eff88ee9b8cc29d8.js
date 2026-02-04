(self.webpackChunk_N_E=self.webpackChunk_N_E||[]).push([[3618],{3113:function(e,a,s){Promise.resolve().then(s.bind(s,3308))},2940:function(e,a,s){"use strict";s.d(a,{Z:function(){return t}});/**
 * @license lucide-react v0.379.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */let t=(0,s(8030).Z)("CircleCheckBig",[["path",{d:"M22 11.08V12a10 10 0 1 1-5.93-9.14",key:"g774vq"}],["path",{d:"m9 11 3 3L22 4",key:"1pflzl"}]])},933:function(e,a,s){"use strict";s.d(a,{Z:function(){return t}});/**
 * @license lucide-react v0.379.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */let t=(0,s(8030).Z)("Clock",[["circle",{cx:"12",cy:"12",r:"10",key:"1mglay"}],["polyline",{points:"12 6 12 12 16 14",key:"68esgv"}]])},5733:function(e,a,s){"use strict";s.d(a,{Z:function(){return t}});/**
 * @license lucide-react v0.379.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */let t=(0,s(8030).Z)("Eye",[["path",{d:"M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z",key:"rwhkz3"}],["circle",{cx:"12",cy:"12",r:"3",key:"1v7zrd"}]])},3274:function(e,a,s){"use strict";s.d(a,{Z:function(){return t}});/**
 * @license lucide-react v0.379.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */let t=(0,s(8030).Z)("LoaderCircle",[["path",{d:"M21 12a9 9 0 1 1-6.219-8.56",key:"13zald"}]])},4817:function(e,a,s){"use strict";s.d(a,{Z:function(){return t}});/**
 * @license lucide-react v0.379.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */let t=(0,s(8030).Z)("Search",[["circle",{cx:"11",cy:"11",r:"8",key:"4ej97u"}],["path",{d:"m21 21-4.3-4.3",key:"1qie3q"}]])},9338:function(e,a,s){"use strict";s.d(a,{Z:function(){return t}});/**
 * @license lucide-react v0.379.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */let t=(0,s(8030).Z)("Star",[["polygon",{points:"12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2",key:"8f66p6"}]])},5636:function(e,a,s){"use strict";s.d(a,{Z:function(){return t}});/**
 * @license lucide-react v0.379.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */let t=(0,s(8030).Z)("ThumbsUp",[["path",{d:"M7 10v12",key:"1qc93n"}],["path",{d:"M15 5.88 14 10h5.83a2 2 0 0 1 1.92 2.56l-2.33 8A2 2 0 0 1 17.5 22H4a2 2 0 0 1-2-2v-8a2 2 0 0 1 2-2h2.76a2 2 0 0 0 1.79-1.11L12 2h0a3.13 3.13 0 0 1 3 3.88Z",key:"y3tblf"}]])},4697:function(e,a,s){"use strict";s.d(a,{Z:function(){return t}});/**
 * @license lucide-react v0.379.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */let t=(0,s(8030).Z)("X",[["path",{d:"M18 6 6 18",key:"1bl5f8"}],["path",{d:"m6 6 12 12",key:"d8bk6v"}]])},3308:function(e,a,s){"use strict";s.r(a),s.d(a,{default:function(){return k}});var t=s(7437),n=s(2265),r=s(7138),l=s(2394),i=s(9338),o=s(5733),c=s(5636),u=s(933),d=s(2940),m=s(4817);let p=[{id:1,noAsesmen:"AL-2024-001",prodi:"Teknik Kimia",institusi:"Universitas Borneo",asesor:"Prof. Dr. Abdul Chalim",tanggalSubmit:"2024-03-20",skorKepuasan:4.5,status:"SUBMITTED",komentarUtama:"Proses asesmen berjalan sangat profesional dan terstruktur."},{id:2,noAsesmen:"AL-2024-002",prodi:"Teknik Mesin",institusi:"Universitas Garuda",asesor:"Prof. Dr. Ahmad Wijaya",tanggalSubmit:null,skorKepuasan:0,status:"PENDING",komentarUtama:null},{id:3,noAsesmen:"AL-2024-003",prodi:"Teknik Elektro",institusi:"Universitas Cakra",asesor:"Dr. Ir. Siti Rahayu",tanggalSubmit:"2024-03-22",skorKepuasan:5,status:"SUBMITTED",komentarUtama:"Asesor sangat kooperatif dan memberikan masukan yang konstruktif."}],h={PENDING:{label:"Menunggu",variant:"warning"},SUBMITTED:{label:"Sudah Mengisi",variant:"success"}};function k(){let[e,a]=(0,n.useState)(""),[s,k]=(0,n.useState)(""),x=p.filter(a=>{let t=a.prodi.toLowerCase().includes(e.toLowerCase())||a.noAsesmen.toLowerCase().includes(e.toLowerCase())||a.asesor.toLowerCase().includes(e.toLowerCase()),n=!s||a.status===s;return t&&n}),b=p.filter(e=>e.skorKepuasan>0).reduce((e,a)=>e+a.skorKepuasan,0)/p.filter(e=>e.skorKepuasan>0).length||0,f=[{label:"Total Umpan Balik",value:p.length,color:"bg-blue-100 text-blue-600",icon:c.Z},{label:"Menunggu",value:p.filter(e=>"PENDING"===e.status).length,color:"bg-amber-100 text-amber-600",icon:u.Z},{label:"Sudah Mengisi",value:p.filter(e=>"SUBMITTED"===e.status).length,color:"bg-green-100 text-green-600",icon:d.Z},{label:"Rata-rata Skor",value:b.toFixed(1),color:"bg-purple-100 text-purple-600",icon:i.Z}];return(0,t.jsxs)("div",{className:"space-y-6",children:[(0,t.jsxs)("div",{children:[(0,t.jsx)("h1",{className:"text-2xl font-bold text-secondary-900",children:"Umpan Balik Asesor"}),(0,t.jsx)("p",{className:"text-secondary-500 mt-1",children:"Umpan balik dari prodi terhadap kinerja asesor"})]}),(0,t.jsx)("div",{className:"grid grid-cols-2 md:grid-cols-4 gap-4",children:f.map(e=>{let a=e.icon;return(0,t.jsx)(l.Zb,{className:"p-4",children:(0,t.jsxs)("div",{className:"flex items-center gap-3",children:[(0,t.jsx)("div",{className:"p-3 rounded-lg ".concat(e.color),children:(0,t.jsx)(a,{className:"w-5 h-5"})}),(0,t.jsxs)("div",{children:[(0,t.jsx)("p",{className:"text-2xl font-bold text-secondary-900",children:e.value}),(0,t.jsx)("p",{className:"text-sm text-secondary-500",children:e.label})]})]})},e.label)})}),(0,t.jsxs)(l.Zb,{children:[(0,t.jsx)("div",{className:"p-4 border-b border-secondary-200",children:(0,t.jsxs)("div",{className:"flex flex-col sm:flex-row gap-4",children:[(0,t.jsxs)("div",{className:"relative flex-1 max-w-md",children:[(0,t.jsx)(m.Z,{className:"absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-secondary-400"}),(0,t.jsx)("input",{type:"text",placeholder:"Cari umpan balik...",value:e,onChange:e=>a(e.target.value),className:"w-full pl-10 pr-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"})]}),(0,t.jsxs)("select",{value:s,onChange:e=>k(e.target.value),className:"px-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500",children:[(0,t.jsx)("option",{value:"",children:"Semua Status"}),(0,t.jsx)("option",{value:"PENDING",children:"Menunggu"}),(0,t.jsx)("option",{value:"SUBMITTED",children:"Sudah Mengisi"})]})]})}),(0,t.jsx)(l.iA,{columns:[{key:"noAsesmen",label:"No. Asesmen"},{key:"prodi",label:"Program Studi"},{key:"institusi",label:"Institusi"},{key:"asesor",label:"Asesor"},{key:"skorKepuasan",label:"Skor",render:e=>e>0?(0,t.jsxs)("div",{className:"flex items-center gap-1",children:[(0,t.jsx)(i.Z,{className:"w-4 h-4 text-amber-500 fill-amber-500"}),(0,t.jsx)("span",{className:"font-medium",children:e.toFixed(1)})]}):(0,t.jsx)("span",{className:"text-secondary-400",children:"-"})},{key:"tanggalSubmit",label:"Tanggal",render:e=>e||"-"},{key:"status",label:"Status",render:e=>{let a=h[e];return(0,t.jsx)(l.Ct,{variant:null==a?void 0:a.variant,children:(null==a?void 0:a.label)||e})}},{key:"actions",label:"Aksi",render:(e,a)=>(0,t.jsx)(r.default,{href:"/dashboard/umpan-balik/".concat(a.id),children:(0,t.jsx)("button",{className:"p-1.5 text-secondary-500 hover:text-primary-600 hover:bg-primary-50 rounded-lg",children:(0,t.jsx)(o.Z,{className:"w-4 h-4"})})})}],data:x})]})]})}}},function(e){e.O(0,[9661,7138,2394,2971,7023,1744],function(){return e(e.s=3113)}),_N_E=e.O()}]);