// Station Info — sheet content shown when a station is tapped. Direction A.

function amenitiesFor(name) {
  const cityCenter = ['City Hall', 'Franklin Square', '8th & Market', '9/10th & Locust', '12/13th & Locust', '15/16th & Locust'];
  if (cityCenter.includes(name)) return ['Elevator', 'Escalator'];
  return ['Parking', 'Bike racks', 'Elevator'];
}

// Simple, recognizable amenity glyphs (kept geometric).
function amenityIcon(a) {
  const s = PT.ink, w = 1.8;
  if (a === 'Parking') return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><rect x="3" y="3" width="18" height="18" rx="5" stroke={s} strokeWidth={w}/><path d="M9 17V8h3.2a2.6 2.6 0 0 1 0 5.2H9" stroke={s} strokeWidth={w} strokeLinecap="round" strokeLinejoin="round"/></svg>
  );
  if (a === 'Bike racks') return (
    <svg width="20" height="18" viewBox="0 0 24 24" fill="none"><circle cx="5.5" cy="16.5" r="3.6" stroke={s} strokeWidth={w}/><circle cx="18.5" cy="16.5" r="3.6" stroke={s} strokeWidth={w}/><path d="M5.5 16.5l4.2-7.5h5.5M12 9l3.5 7.5M9 9h4.5" stroke={s} strokeWidth={w} strokeLinecap="round" strokeLinejoin="round"/><circle cx="14.5" cy="5.5" r="1.1" fill={s}/></svg>
  );
  if (a === 'Elevator') return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><rect x="5" y="3" width="14" height="18" rx="2.5" stroke={s} strokeWidth={w}/><path d="M12 6.5l-2.2 3h4.4L12 6.5zM12 17.5l-2.2-3h4.4L12 17.5z" fill={s}/></svg>
  );
  if (a === 'Escalator') return (
    <svg width="20" height="18" viewBox="0 0 24 24" fill="none"><path d="M4 18h3.5l9-12H20" stroke={s} strokeWidth={w} strokeLinecap="round" strokeLinejoin="round"/><path d="M16.5 6h3.5v3.5" stroke={s} strokeWidth={w} strokeLinecap="round" strokeLinejoin="round"/></svg>
  );
  return (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><path d="M4 12l5 5 11-11" stroke={PT.green} strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"/></svg>
  );
}

function StationInfo({ station, onClose }) {
  if (!station) return null;
  const amenities = amenitiesFor(station);

  const dirRow = (icon, label, ext, last) => (
    <button style={{ width: '100%', border: 'none', cursor: 'pointer', background: 'transparent', display: 'flex', alignItems: 'center', gap: 13, padding: '0 16px', minHeight: 54, position: 'relative', textAlign: 'left' }}>
      <span style={{ width: 30, height: 30, borderRadius: 8, background: PT.fill, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>{icon}</span>
      <span style={{ flex: 1, fontSize: 16.5, fontFamily: 'CircularStd-Medium, system-ui' }}>{label}</span>
      {ext
        ? <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><path d="M14 4h6v6M20 4l-9 9M18 13v6H5V6h6" stroke={PT.ink3} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>
        : <Chev s={13} />}
      {!last && <div style={{ position: 'absolute', left: 59, right: 0, bottom: 0, height: 0.5, background: PT.hair }} />}
    </button>
  );

  const navIcon = <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><path d="M3 11l18-7-7 18-2.5-8.5L3 11z" stroke={PT.ink} strokeWidth="1.8" strokeLinejoin="round"/></svg>;
  const pinIcon = <svg width="14" height="16" viewBox="0 0 24 24" fill="none"><path d="M12 22s7-7.6 7-13A7 7 0 1 0 5 9c0 5.4 7 13 7 13Z" fill={PT.red}/><circle cx="12" cy="9" r="2.6" fill="#fff"/></svg>;
  const globe = <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke={PT.ink} strokeWidth="1.6"/><path d="M3 12h18M12 3c2.5 2.5 2.5 15 0 18M12 3c-2.5 2.5-2.5 15 0 18" stroke={PT.ink} strokeWidth="1.6"/></svg>;

  return (
    <React.Fragment>
      {/* hero photo placeholder with close button */}
      <div style={{ position: 'relative', height: 200, flexShrink: 0, background: `repeating-linear-gradient(135deg, #E7E7EC, #E7E7EC 11px, #EDEDF1 11px, #EDEDF1 22px)`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <div style={{ fontFamily: 'ui-monospace, Menlo, monospace', fontSize: 12, color: PT.ink3, letterSpacing: 0.5, background: 'rgba(255,255,255,0.72)', padding: '6px 12px', borderRadius: 8 }}>{station.toLowerCase()} · station photo</div>
        <button onClick={onClose} style={{ position: 'absolute', top: 14, right: 14, width: 36, height: 36, borderRadius: 999, border: 'none', cursor: 'pointer', background: 'rgba(255,255,255,0.9)', backdropFilter: 'blur(8px)', color: PT.ink, fontSize: 18, display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 2px 8px rgba(0,0,0,0.12)' }}>×</button>
      </div>

      <div className="pt-scroll" style={{ flex: 1, overflowY: 'auto', padding: '18px 16px 28px' }}>
        <div style={{ fontFamily: 'CircularStd-Black, system-ui', fontSize: 30, letterSpacing: -0.5, marginBottom: 18 }}>{station}</div>

        <div style={siHdr}>Directions</div>
        <div style={{ background: PT.card, borderRadius: 16, overflow: 'hidden', boxShadow: '0 1px 2px rgba(0,0,0,0.04)', marginBottom: 22 }}>
          {dirRow(navIcon, 'Open in Apple Maps', false, false)}
          {dirRow(pinIcon, 'Open in Google Maps', false, false)}
          {dirRow(globe, 'Station website', true, true)}
        </div>

        <div style={siHdr}>Amenities</div>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 10 }}>
          {amenities.map(a => (
            <span key={a} style={{ display: 'inline-flex', alignItems: 'center', gap: 8, background: PT.card, borderRadius: 12, padding: '11px 15px', fontSize: 15, fontFamily: 'CircularStd-Medium, system-ui', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' }}>
              {amenityIcon(a)}
              {a}
            </span>
          ))}
        </div>
      </div>
    </React.Fragment>
  );
}

const siHdr = { fontSize: 12.5, fontFamily: 'CircularStd-Bold, system-ui', letterSpacing: 0.6, color: PT.ink2, textTransform: 'uppercase', padding: '0 4px 8px' };

window.StationInfo = StationInfo;
