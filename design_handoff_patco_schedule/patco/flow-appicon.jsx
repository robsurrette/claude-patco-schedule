// Change app icon — sheet with a grid of the real alternate PATCO icons.

function AppIconSheet({ selected, onSelect, onClose }) {
  const groups = [
    ['Colors', [
      ['classic', 'Classic'], ['black', 'Black'], ['white', 'White'],
      ['blue', 'Blue'], ['green', 'Green'], ['mint', 'Mint'],
      ['peach', 'Peach'], ['purple', 'Purple'], ['yellow', 'Yellow'],
    ]],
    ['Styles', [
      ['geometric', 'Geometric'], ['neon', 'Neon'], ['monochrome', 'Mono'],
    ]],
    ['Seasonal', [
      ['halloween', 'Halloween'], ['snow', 'Snow'], ['holidayLights', 'Holiday'],
    ]],
  ];

  return (
    <React.Fragment>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 16px 12px 20px', flexShrink: 0 }}>
        <span style={{ fontSize: 23, fontFamily: 'CircularStd-Bold, system-ui', letterSpacing: -0.3 }}>App icon</span>
        <button onClick={onClose} aria-label="Close" style={{ width: 38, height: 38, borderRadius: 999, border: 'none', cursor: 'pointer', background: PT.fill2, color: PT.ink2, fontSize: 19, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>×</button>
      </div>

      <div className="pt-scroll" style={{ flex: 1, overflowY: 'auto', padding: '0 16px 28px' }}>
        {groups.map(([title, items]) => (
          <div key={title}>
            <div style={aiHdr}>{title}</div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 16 }}>
              {items.map(([key, label]) => {
                const on = key === selected;
                return (
                  <button key={key} onClick={() => onSelect(key)} style={{ border: 'none', background: 'none', cursor: 'pointer', padding: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8 }}>
                    <div style={{ position: 'relative', padding: 3, borderRadius: 21, background: on ? PT.red : 'transparent' }}>
                      <img src={`patco/icons/${key}.png`} alt={label} style={{ width: 72, height: 72, borderRadius: 17, display: 'block', boxShadow: '0 1px 3px rgba(0,0,0,0.18), inset 0 0 0 0.5px rgba(0,0,0,0.08)' }} />
                      {on && (
                        <span style={{ position: 'absolute', right: -3, bottom: -3, width: 24, height: 24, borderRadius: 999, background: PT.red, border: '2.5px solid #F1F1F4', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                          <svg width="13" height="13" viewBox="0 0 24 24" fill="none"><path d="M4 12l5 5 11-11" stroke="#fff" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/></svg>
                        </span>
                      )}
                    </div>
                    <span style={{ fontSize: 13.5, fontFamily: on ? 'CircularStd-Bold, system-ui' : 'CircularStd-Medium, system-ui', color: on ? PT.ink : PT.ink2 }}>{label}</span>
                  </button>
                );
              })}
            </div>
          </div>
        ))}
      </div>
    </React.Fragment>
  );
}

const aiHdr = { fontSize: 12.5, fontFamily: 'CircularStd-Bold, system-ui', letterSpacing: 0.6, color: PT.ink2, textTransform: 'uppercase', padding: '16px 4px 14px' };

window.AppIconSheet = AppIconSheet;
