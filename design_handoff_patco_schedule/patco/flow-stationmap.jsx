// Station Map tab — the 14-station line as a tappable route list, Direction A.

function FlowStationMap({ onOpenStation }) {
  return (
    <div style={{ minHeight: '100%', background: PT.bg, color: PT.ink }}>
      <div style={{ position: 'sticky', top: 0, zIndex: 20, background: 'rgba(241,241,244,0.86)', backdropFilter: 'blur(18px)', WebkitBackdropFilter: 'blur(18px)', padding: '56px 16px 14px', borderBottom: `0.5px solid ${PT.hair}` }}>
        <div style={{ fontFamily: 'CircularStd-Black, system-ui', fontSize: 28, letterSpacing: -0.4 }}>Station Map</div>
      </div>

      <div style={{ padding: '16px 16px 96px' }}>
        <div style={{ background: PT.card, borderRadius: 18, overflow: 'hidden', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' }}>
          {STATIONS.map((name, i) => {
            const first = i === 0, last = i === STATIONS.length - 1;
            return (
              <button key={name} onClick={() => onOpenStation(name)} style={{
                width: '100%', border: 'none', cursor: 'pointer', textAlign: 'left', background: 'transparent',
                display: 'flex', alignItems: 'stretch', padding: '0 16px 0 0', minHeight: 58, position: 'relative',
              }}>
                {/* rail */}
                <div style={{ position: 'relative', width: 54, flexShrink: 0, display: 'flex', justifyContent: 'center' }}>
                  {!first && <span style={{ position: 'absolute', top: 0, bottom: '50%', width: 3, background: PT.red }} />}
                  {!last && <span style={{ position: 'absolute', top: '50%', bottom: 0, width: 3, background: PT.red }} />}
                  <span style={{ alignSelf: 'center', width: 15, height: 15, borderRadius: 999, background: PT.card, border: `3.5px solid ${PT.red}`, zIndex: 1 }} />
                </div>
                <div style={{ flex: 1, display: 'flex', alignItems: 'center', minHeight: 58 }}>
                  <span style={{ flex: 1, fontSize: 17.5, fontFamily: 'CircularStd-Medium, system-ui' }}>{name}</span>
                  <Chev s={14} />
                </div>
                {!last && <div style={{ position: 'absolute', left: 54, right: 0, bottom: 0, height: 0.5, background: PT.hair }} />}
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}

window.FlowStationMap = FlowStationMap;
