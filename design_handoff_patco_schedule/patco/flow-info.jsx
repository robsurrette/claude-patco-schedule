// Patco Info tab — Direction A. PATCO's own contact channels lifted into a
// quick-actions card; reference links grouped into clean inset cards.
// Rows are non-interactive for now (creative redesign of the original list).

function tile(bg, child) {
  return <span style={{ width: 32, height: 32, borderRadius: 9, background: bg, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>{child}</span>;
}

function LinkRow({ icon, label, sub, external = true, last }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 13, padding: '0 16px', minHeight: 56, position: 'relative', cursor: 'pointer' }}>
      {icon}
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 16.5, fontFamily: 'CircularStd-Medium, system-ui' }}>{label}</div>
        {sub && <div style={{ fontSize: 12.5, color: PT.ink2, marginTop: 1 }}>{sub}</div>}
      </div>
      {external
        ? <svg width="15" height="15" viewBox="0 0 24 24" fill="none"><path d="M14 4h6v6M20 4l-9 9M18 13v6H5V6h6" stroke={PT.ink3} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>
        : <Chev s={13} />}
      {!last && <div style={{ position: 'absolute', left: 61, right: 0, bottom: 0, height: 0.5, background: PT.hair }} />}
    </div>
  );
}

function Monogram(letters, bg) {
  return tile(bg, <span style={{ fontFamily: 'CircularStd-Bold, system-ui', fontSize: 13, color: '#fff', letterSpacing: 0.2 }}>{letters}</span>);
}

function FlowInfo() {
  // quick-action icons
  const phone = <svg width="22" height="22" viewBox="0 0 24 24" fill="none"><path d="M6.5 3h3l1.5 4-2 1.5a12 12 0 0 0 5 5l1.5-2 4 1.5v3a2 2 0 0 1-2.2 2A16.5 16.5 0 0 1 4.5 5.2 2 2 0 0 1 6.5 3z" fill="#fff"/></svg>;
  const mail = <svg width="22" height="22" viewBox="0 0 24 24" fill="none"><rect x="3" y="5.5" width="18" height="13" rx="2.5" stroke="#fff" strokeWidth="1.9"/><path d="M4 7l8 6 8-6" stroke="#fff" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"/></svg>;
  const globe = <svg width="22" height="22" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="8.5" stroke="#fff" strokeWidth="1.8"/><path d="M3.5 12h17M12 3.5c2.4 2.6 2.4 14.4 0 17M12 3.5c-2.4 2.6-2.4 14.4 0 17" stroke="#fff" strokeWidth="1.8"/></svg>;
  const xlogo = <svg width="19" height="19" viewBox="0 0 24 24" fill="#fff"><path d="M17.5 3h3l-7 8 8.2 10h-6.4l-5-6.2L8 21H5l7.4-8.5L4.5 3h6.6l4.5 5.7L17.5 3zm-1.1 16h1.7L8 4.6H6.2L16.4 19z"/></svg>;

  const quick = [
    ['Call', phone, PT.green],
    ['Email', mail, '#3A6FD8'],
    ['Website', globe, PT.ink],
    ['X', xlogo, '#111'],
  ];

  return (
    <div style={{ minHeight: '100%', background: PT.bg, color: PT.ink }}>
      <div style={{ position: 'sticky', top: 0, zIndex: 20, background: 'rgba(241,241,244,0.86)', backdropFilter: 'blur(18px)', WebkitBackdropFilter: 'blur(18px)', padding: '56px 16px 14px', borderBottom: `0.5px solid ${PT.hair}` }}>
        <div style={{ fontFamily: 'CircularStd-Black, system-ui', fontSize: 28, letterSpacing: -0.4 }}>Patco Info</div>
      </div>

      <div style={{ padding: '16px 16px 96px' }}>
        {/* Contact PATCO — quick actions */}
        <div style={{ background: PT.card, borderRadius: 20, padding: '16px 14px 14px', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 14, paddingLeft: 2 }}>
            <span style={{ fontSize: 13, fontFamily: 'CircularStd-Bold, system-ui', letterSpacing: 0.5 }}>Contact PATCO</span>
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            {quick.map(([label, icon, bg]) => (
              <div key={label} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 7, cursor: 'pointer' }}>
                <span style={{ width: 54, height: 54, borderRadius: 16, background: bg, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>{icon}</span>
                <span style={{ fontSize: 13, fontFamily: 'CircularStd-Medium, system-ui', color: PT.ink2 }}>{label}</span>
              </div>
            ))}
          </div>
          <div style={{ marginTop: 14, paddingTop: 12, borderTop: `0.5px solid ${PT.hair}`, display: 'flex', alignItems: 'center', justifyContent: 'space-between', fontSize: 13.5, color: PT.ink2 }}>
            <span>Customer service</span>
            <span style={{ fontFamily: 'CircularStd-Bold, system-ui', color: PT.ink, fontVariantNumeric: 'tabular-nums' }}>(856) 772-6900</span>
          </div>
        </div>

        {/* Fares & cards */}
        <div style={infHdr}>Fares &amp; cards</div>
        <div style={infCard}>
          <LinkRow icon={tile(PT.redSoft, <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><path d="M3 7.5h18v9H3z" stroke={PT.red} strokeWidth="1.9" strokeLinejoin="round"/><circle cx="12" cy="12" r="2.2" stroke={PT.red} strokeWidth="1.9"/></svg>)} label="Fares" sub="Single ride, FREEDOM & more" />
          <LinkRow icon={tile(PT.redSoft, <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><rect x="3" y="5.5" width="18" height="13" rx="2.5" stroke={PT.red} strokeWidth="1.9"/><path d="M3 9.5h18" stroke={PT.red} strokeWidth="1.9"/></svg>)} label="Reload FREEDOM Card" sub="Add rides to your account" last />
        </div>

        {/* Accessibility */}
        <div style={infHdr}>Station accessibility</div>
        <div style={infCard}>
          <LinkRow icon={tile('#E7EEF9', <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="4.5" r="2" fill="#3A6FD8"/><path d="M9 8h5l1 5h3M9 8c-1 4 0 8 4 8l2 4" stroke="#3A6FD8" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"/></svg>)} label="Current availability" sub="Elevators & escalators status" />
          <LinkRow icon={tile('#E7EEF9', <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><rect x="4" y="4" width="16" height="16" rx="4" stroke="#3A6FD8" strokeWidth="1.9"/><path d="M9 16V8h3.2a2.6 2.6 0 0 1 0 5.2H9" stroke="#3A6FD8" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"/></svg>)} label="Parking, elevators & bikes" sub="Facilities at every station" last />
        </div>

        {/* Connecting transit */}
        <div style={infHdr}>Connecting transit</div>
        <div style={infCard}>
          <LinkRow icon={Monogram('SE', '#1A6DB4')} label="SEPTA" />
          <LinkRow icon={Monogram('RL', '#3AA5C4')} label="River Line" />
          <LinkRow icon={Monogram('NJ', '#E07B1A')} label="NJ Transit" />
          <LinkRow icon={Monogram('AK', '#1C2C57')} label="Amtrak" last />
        </div>
      </div>
    </div>
  );
}

const infHdr = { fontSize: 12.5, fontFamily: 'CircularStd-Bold, system-ui', letterSpacing: 0.6, color: PT.ink2, textTransform: 'uppercase', padding: '22px 4px 8px' };
const infCard = { background: PT.card, borderRadius: 16, overflow: 'hidden', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' };

window.FlowInfo = FlowInfo;
