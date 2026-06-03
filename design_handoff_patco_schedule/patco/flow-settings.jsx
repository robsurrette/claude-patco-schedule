// Settings tab — Direction A. Remove Ads lifted into a premium upsell card,
// theme as visual swatch cards, plus app icon & feedback. Rows non-interactive
// except the Remove Ads card, which opens the purchase sheet.

function ThemeSwatch({ kind }) {
  // mini phone preview
  const bar = (c, w) => <div style={{ height: 4, borderRadius: 2, background: c, width: w }} />;
  let bg, bars, extra = null;
  if (kind === 'light') { bg = '#fff'; bars = ['rgba(0,0,0,0.16)', 'rgba(0,0,0,0.10)']; }
  else if (kind === 'dark') { bg = '#1C1C20'; bars = ['rgba(255,255,255,0.35)', 'rgba(255,255,255,0.18)']; }
  else { // system split
    return (
      <div style={{ width: '100%', height: 58, borderRadius: 10, overflow: 'hidden', position: 'relative', boxShadow: 'inset 0 0 0 1px rgba(0,0,0,0.08)' }}>
        <div style={{ position: 'absolute', inset: 0, background: '#fff', clipPath: 'polygon(0 0, 100% 0, 0 100%)' }} />
        <div style={{ position: 'absolute', inset: 0, background: '#1C1C20', clipPath: 'polygon(100% 0, 100% 100%, 0 100%)' }} />
        <div style={{ position: 'absolute', left: 9, top: 12, width: 7, height: 7, borderRadius: 99, background: PT.red }} />
        <div style={{ position: 'absolute', right: 9, bottom: 12, width: 7, height: 7, borderRadius: 99, background: PT.red }} />
      </div>
    );
  }
  return (
    <div style={{ width: '100%', height: 58, borderRadius: 10, background: bg, boxShadow: 'inset 0 0 0 1px rgba(0,0,0,0.08)', padding: 9, display: 'flex', flexDirection: 'column', gap: 5, justifyContent: 'center' }}>
      <div style={{ width: 9, height: 9, borderRadius: 99, background: PT.red, marginBottom: 1 }} />
      {bar(bars[0], '78%')}
      {bar(bars[1], '54%')}
    </div>
  );
}

function FlowSettings({ onUpgrade, isPremium, appIcon = 'classic', onChangeIcon }) {
  const [theme, setTheme] = React.useState('light');
  const themes = [['system', 'Automatic'], ['light', 'Light'], ['dark', 'Dark']];

  const row = (icon, label, sub, last) => (
    <div style={{ display: 'flex', alignItems: 'center', gap: 13, padding: '0 16px', minHeight: 54, position: 'relative', cursor: 'pointer' }}>
      <span style={{ width: 30, height: 30, borderRadius: 8, background: PT.fill, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>{icon}</span>
      <span style={{ flex: 1, fontSize: 16.5, fontFamily: 'CircularStd-Medium, system-ui' }}>{label}</span>
      {sub && <span style={{ fontSize: 14.5, color: PT.ink3, marginRight: 4 }}>{sub}</span>}
      <Chev s={13} />
      {!last && <div style={{ position: 'absolute', left: 59, right: 0, bottom: 0, height: 0.5, background: PT.hair }} />}
    </div>
  );

  const ic = (path) => <svg width="17" height="17" viewBox="0 0 24 24" fill="none">{path}</svg>;

  return (
    <div style={{ minHeight: '100%', background: PT.bg, color: PT.ink }}>
      <div style={{ position: 'sticky', top: 0, zIndex: 20, background: 'rgba(241,241,244,0.86)', backdropFilter: 'blur(18px)', WebkitBackdropFilter: 'blur(18px)', padding: '56px 16px 14px', borderBottom: `0.5px solid ${PT.hair}` }}>
        <div style={{ fontFamily: 'CircularStd-Black, system-ui', fontSize: 28, letterSpacing: -0.4 }}>Settings</div>
      </div>

      <div style={{ padding: '16px 16px 96px' }}>
        {/* Premium upsell / status */}
        {isPremium ? (
          <div style={{ background: PT.card, borderRadius: 20, padding: '16px 18px', boxShadow: '0 1px 2px rgba(0,0,0,0.04)', display: 'flex', alignItems: 'center', gap: 13 }}>
            <span style={{ width: 44, height: 44, borderRadius: 12, background: PT.greenSoft, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none"><path d="M4 12l5 5 11-11" stroke={PT.green} strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"/></svg>
            </span>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 17, fontFamily: 'CircularStd-Bold, system-ui' }}>Ad-free unlocked</div>
              <div style={{ fontSize: 13.5, color: PT.ink2, marginTop: 1 }}>Thanks for supporting the app.</div>
            </div>
          </div>
        ) : (
          <button onClick={onUpgrade} style={{ width: '100%', textAlign: 'left', cursor: 'pointer', border: 'none', borderRadius: 20, padding: 0, overflow: 'hidden', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' }}>
            <div style={{ background: PT.card, padding: '16px 16px', position: 'relative', display: 'flex', alignItems: 'center', gap: 14 }}>
              <span style={{ width: 46, height: 46, borderRadius: 13, background: PT.redSoft, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                <svg width="22" height="22" viewBox="0 0 24 24" fill={PT.red}><path d="M12 2.5l2.9 6 6.6.6-5 4.4 1.5 6.5L12 16.9 5.9 20l1.5-6.5-5-4.4 6.6-.6z"/></svg>
              </span>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 17, fontFamily: 'CircularStd-Bold, system-ui' }}>Remove ads</div>
                <div style={{ fontSize: 13.5, color: PT.ink2, marginTop: 2 }}>Go ad-free · one-time $1.99</div>
              </div>
              <span style={{ fontSize: 14, fontFamily: 'CircularStd-Bold, system-ui', color: PT.red, background: PT.redSoft, padding: '8px 14px', borderRadius: 999, flexShrink: 0 }}>Upgrade</span>
            </div>
          </button>
        )}

        {/* Appearance */}
        <div style={stHdr}>Appearance</div>
        <div style={{ background: PT.card, borderRadius: 16, padding: '14px 14px 16px', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' }}>
          <div style={{ display: 'flex', gap: 10 }}>
            {themes.map(([key, label]) => {
              const on = theme === key;
              return (
                <button key={key} onClick={() => setTheme(key)} style={{ flex: 1, border: 'none', background: 'none', cursor: 'pointer', padding: 0 }}>
                  <div style={{ borderRadius: 12, padding: 3, background: on ? PT.red : 'transparent' }}>
                    <ThemeSwatch kind={key} />
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 5, marginTop: 8 }}>
                    {on && <svg width="14" height="14" viewBox="0 0 24 24" fill="none"><path d="M4 12l5 5 11-11" stroke={PT.red} strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/></svg>}
                    <span style={{ fontSize: 14, fontFamily: on ? 'CircularStd-Bold, system-ui' : 'CircularStd-Medium, system-ui', color: on ? PT.ink : PT.ink2 }}>{label}</span>
                  </div>
                </button>
              );
            })}
          </div>
        </div>

        {/* App icon */}
        <div style={{ ...stCard, marginTop: 14 }}>
          <button onClick={onChangeIcon} style={{ width: '100%', border: 'none', background: 'transparent', cursor: 'pointer', textAlign: 'left', display: 'flex', alignItems: 'center', gap: 13, padding: '0 16px', minHeight: 64 }}>
            <img src={`patco/icons/${appIcon}.png`} alt="App icon" style={{ width: 40, height: 40, borderRadius: 10, flexShrink: 0, boxShadow: '0 1px 2px rgba(0,0,0,0.18), inset 0 0 0 0.5px rgba(0,0,0,0.08)' }} />
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 16.5, fontFamily: 'CircularStd-Medium, system-ui' }}>Change app icon</div>
              <div style={{ fontSize: 13, color: PT.ink2, marginTop: 1, textTransform: 'capitalize' }}>{appIcon}</div>
            </div>
            <Chev s={13} />
          </button>
        </div>

        {/* Feedback */}
        <div style={stHdr}>Feedback</div>
        <div style={stCard}>
          {row(ic(<><path d="M4 5.5h16v10H9l-4 3.5V5.5z" stroke={PT.ink} strokeWidth="1.8" strokeLinejoin="round"/></>), 'Submit PATCO feedback', null, false)}
          {row(ic(<><path d="M4 5.5h16v10H9l-4 3.5V5.5z" stroke={PT.ink} strokeWidth="1.8" strokeLinejoin="round"/><path d="M9 10h6M9 12.5h4" stroke={PT.ink} strokeWidth="1.6" strokeLinecap="round"/></>), 'Submit app developer feedback', null, true)}
        </div>

        {/* footer */}
        <div style={{ textAlign: 'center', marginTop: 26, color: PT.ink3 }}>
          <div style={{ fontSize: 13.5, fontFamily: 'CircularStd-Medium, system-ui' }}>PATCO Schedule</div>
          <div style={{ fontSize: 12.5, marginTop: 3 }}>Version 4.2.0</div>
        </div>
      </div>
    </div>
  );
}

const stHdr = { fontSize: 12.5, fontFamily: 'CircularStd-Bold, system-ui', letterSpacing: 0.6, color: PT.ink2, textTransform: 'uppercase', padding: '22px 4px 8px' };
const stCard = { background: PT.card, borderRadius: 16, overflow: 'hidden', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' };

window.FlowSettings = FlowSettings;
