// Reusable PATCO device chrome + bottom-sheet for the Home flow prototype.
// Exports: FlowStatusBar, FlowTabBar, FlowFrame, Sheet

function FlowStatusBar({ light = false }) {
  const c = light ? '#FFFFFF' : '#17171B';
  return (
    <div style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 54, zIndex: 40, display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '0 30px' }}>
      <span style={{ fontFamily: 'CircularStd-Bold, system-ui', fontSize: 16, color: c }}>12:52</span>
      <div style={{ display: 'flex', gap: 7, alignItems: 'center' }}>
        <svg width="18" height="12" viewBox="0 0 19 12"><rect x="0" y="7.5" width="3.2" height="4.5" rx="0.7" fill={c}/><rect x="4.8" y="5" width="3.2" height="7" rx="0.7" fill={c}/><rect x="9.6" y="2.5" width="3.2" height="9.5" rx="0.7" fill={c}/><rect x="14.4" y="0" width="3.2" height="12" rx="0.7" fill={c}/></svg>
        <svg width="16" height="12" viewBox="0 0 17 12"><path d="M8.5 3.2C10.8 3.2 12.9 4.1 14.4 5.6L15.5 4.5C13.7 2.7 11.2 1.5 8.5 1.5C5.8 1.5 3.3 2.7 1.5 4.5L2.6 5.6C4.1 4.1 6.2 3.2 8.5 3.2Z" fill={c}/><path d="M8.5 6.8C9.9 6.8 11.1 7.3 12 8.2L13.1 7.1C11.8 5.9 10.2 5.1 8.5 5.1C6.8 5.1 5.2 5.9 3.9 7.1L5 8.2C5.9 7.3 7.1 6.8 8.5 6.8Z" fill={c}/><circle cx="8.5" cy="10.5" r="1.5" fill={c}/></svg>
        <svg width="25" height="12" viewBox="0 0 27 13"><rect x="0.5" y="0.5" width="23" height="12" rx="3.5" stroke={c} strokeOpacity="0.35" fill="none"/><rect x="2" y="2" width="20" height="9" rx="2" fill={c}/><path d="M25 4.5V8.5C25.8 8.2 26.5 7.2 26.5 6.5C26.5 5.8 25.8 4.8 25 4.5Z" fill={c} fillOpacity="0.4"/></svg>
      </div>
    </div>
  );
}

function FlowTabBar({ active = 'schedule', onChange }) {
  const items = [
    ['schedule', 'Schedule', <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" strokeWidth="2"/><path d="M12 7v5l3 2" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>],
    ['stationmap', 'Station Map', <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path d="M9 4L3 6.5v13L9 17l6 2.5 6-2.5v-13L15 6.5 9 4z" strokeWidth="1.8" strokeLinejoin="round"/><path d="M9 4v13M15 6.5v13" strokeWidth="1.8"/></svg>],
    ['info', 'Patco Info', <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" strokeWidth="1.8"/><path d="M12 11v5M12 8v.5" strokeWidth="2" strokeLinecap="round"/></svg>],
    ['settings', 'Settings', <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="3" strokeWidth="1.8"/><path d="M12 2.5v3M12 18.5v3M21.5 12h-3M5.5 12h-3M18.7 5.3l-2.1 2.1M7.4 16.6l-2.1 2.1M18.7 18.7l-2.1-2.1M7.4 7.4L5.3 5.3" strokeWidth="1.8" strokeLinecap="round"/></svg>],
  ];
  return (
    <div style={{ position: 'absolute', bottom: 14, left: 12, right: 12, zIndex: 50, display: 'flex',
      background: 'rgba(255,255,255,0.82)', backdropFilter: 'blur(20px)', WebkitBackdropFilter: 'blur(20px)',
      borderRadius: 26, padding: '8px 6px', boxShadow: '0 6px 24px rgba(0,0,0,0.10), 0 0 0 0.5px rgba(0,0,0,0.04)' }}>
      {items.map(([key, label, icon]) => {
        const on = key === active;
        const color = on ? PT.red : '#17171B';
        return (
          <button key={key} onClick={() => onChange && onChange(key)} style={{ flex: 1, border: 'none', cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3,
            padding: '6px 0', borderRadius: 18, background: on ? 'rgba(0,0,0,0.05)' : 'transparent' }}>
            {React.cloneElement(icon, { stroke: color })}
            <span style={{ fontSize: 11, fontFamily: on ? 'CircularStd-Bold, system-ui' : 'CircularStd-Book, system-ui', color }}>{label}</span>
          </button>
        );
      })}
    </div>
  );
}

// Bottom sheet — mounts at its open position (no transition dependency, so it
// renders reliably even when the preview throttles rAF). height = px or % string.
function Sheet({ open, onClose, height = '90%', children }) {
  if (!open) return null;
  return (
    <React.Fragment>
      <div onClick={onClose} style={{
        position: 'absolute', inset: 0, zIndex: 80, background: 'rgba(15,15,20,0.4)',
      }} />
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0, zIndex: 90, height,
        background: PT.bg, borderRadius: '22px 22px 0 0', overflow: 'hidden',
        boxShadow: '0 -10px 40px rgba(0,0,0,0.18)', display: 'flex', flexDirection: 'column',
        animation: 'ptSheetUp 0.32s cubic-bezier(0.32,0.72,0,1)',
      }}>
        <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 9, flexShrink: 0 }}>
          <div style={{ width: 38, height: 5, borderRadius: 99, background: 'rgba(60,60,67,0.3)' }} />
        </div>
        {children}
      </div>
    </React.Fragment>
  );
}

function FlowFrame({ children, sheets, statusLight = false, hideTabBar = false, tab, onTab }) {
  return (
    <div style={{ width: 390, height: 844, borderRadius: 46, overflow: 'hidden', position: 'relative',
      background: PT.bg, boxShadow: '0 30px 70px rgba(0,0,0,0.20), 0 0 0 1px rgba(0,0,0,0.06)', fontFamily: 'CircularStd, system-ui' }}>
      <div style={{ position: 'absolute', top: 10, left: '50%', transform: 'translateX(-50%)', width: 120, height: 34, borderRadius: 22, background: '#000', zIndex: 60 }} />
      <FlowStatusBar light={statusLight} />
      <div className="pt-scroll" style={{ position: 'absolute', inset: 0, overflowY: 'auto' }}>
        {children}
        <div style={{ height: 96 }} />
      </div>
      {!hideTabBar && <FlowTabBar active={tab} onChange={onTab} />}
      <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, height: 24, zIndex: 95, display: 'flex', justifyContent: 'center', alignItems: 'flex-end', paddingBottom: 7, pointerEvents: 'none' }}>
        <div style={{ width: 134, height: 5, borderRadius: 100, background: 'rgba(0,0,0,0.22)' }} />
      </div>
      {sheets}
    </div>
  );
}

Object.assign(window, { FlowStatusBar, FlowTabBar, FlowFrame, Sheet });
