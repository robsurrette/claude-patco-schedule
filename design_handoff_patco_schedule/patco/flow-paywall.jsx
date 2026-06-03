// Remove Ads — in-app purchase sheet. Direction A premium treatment.

function RemoveAdsSheet({ onClose, onPurchase }) {
  const benefits = [
    ['No banner ads', 'Every screen, completely ad-free', <path d="M5 13l4 4L19 7" stroke={PT.green} strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"/>],
    ['Faster, cleaner schedules', 'Nothing between you and your train', <path d="M13 2L4.5 13H11l-1 9 8.5-11H12l1-9z" fill={PT.green}/>],
    ['Support an indie developer', 'A one-time thank you, no subscription', <path d="M12 21s-7-4.5-7-10a4 4 0 0 1 7-2.5A4 4 0 0 1 19 11c0 5.5-7 10-7 10z" fill={PT.green}/>],
  ];

  return (
    <React.Fragment>
      <div style={{ display: 'flex', justifyContent: 'flex-end', padding: '6px 14px 0', flexShrink: 0 }}>
        <button onClick={onClose} aria-label="Close" style={{ width: 36, height: 36, borderRadius: 999, border: 'none', cursor: 'pointer', background: PT.fill2, color: PT.ink2, fontSize: 18, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>×</button>
      </div>

      <div className="pt-scroll" style={{ flex: 1, overflowY: 'auto', padding: '4px 22px 0' }}>
        {/* hero */}
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', textAlign: 'center', paddingTop: 6 }}>
          <div style={{ width: 84, height: 84, borderRadius: 22, background: `linear-gradient(135deg, ${PT.red} 0%, #B30E37 100%)`, display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 10px 26px rgba(209,17,65,0.32)' }}>
            <svg width="42" height="42" viewBox="0 0 24 24" fill="#fff"><path d="M12 2.5l2.9 6 6.6.6-5 4.4 1.5 6.5L12 16.9 5.9 20l1.5-6.5-5-4.4 6.6-.6z"/></svg>
          </div>
          <div style={{ fontFamily: 'CircularStd-Black, system-ui', fontSize: 27, letterSpacing: -0.5, marginTop: 18 }}>Remove Ads</div>
          <div style={{ fontSize: 15, color: PT.ink2, marginTop: 7, lineHeight: 1.5, maxWidth: 280 }}>Unlock a clean, ad-free PATCO Schedule with a single one-time purchase.</div>
        </div>

        {/* benefits */}
        <div style={{ background: PT.card, borderRadius: 18, padding: '6px 16px', boxShadow: '0 1px 2px rgba(0,0,0,0.04)', marginTop: 24 }}>
          {benefits.map(([title, sub, icon], i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 14, padding: '14px 0', position: 'relative' }}>
              <span style={{ width: 34, height: 34, borderRadius: 10, background: PT.greenSoft, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                <svg width="19" height="19" viewBox="0 0 24 24" fill="none">{icon}</svg>
              </span>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 16, fontFamily: 'CircularStd-Bold, system-ui' }}>{title}</div>
                <div style={{ fontSize: 13, color: PT.ink2, marginTop: 1 }}>{sub}</div>
              </div>
              {i < benefits.length - 1 && <div style={{ position: 'absolute', left: 48, right: 0, bottom: 0, height: 0.5, background: PT.hair }} />}
            </div>
          ))}
        </div>
      </div>

      {/* sticky purchase footer */}
      <div style={{ flexShrink: 0, padding: '14px 22px 26px', borderTop: `0.5px solid ${PT.hair}`, background: 'rgba(241,241,244,0.9)', backdropFilter: 'blur(12px)' }}>
        <button onClick={onPurchase} style={{ width: '100%', border: 'none', cursor: 'pointer', background: PT.red, color: '#fff', borderRadius: 15, padding: '16px', fontSize: 17, fontFamily: 'CircularStd-Bold, system-ui', boxShadow: '0 6px 18px rgba(209,17,65,0.28)' }}>
          Buy now · $1.99
        </button>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 18, marginTop: 13 }}>
          <button onClick={onPurchase} style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 13.5, fontFamily: 'CircularStd-Medium, system-ui', color: PT.ink2 }}>Restore purchase</button>
          <span style={{ width: 3, height: 3, borderRadius: 99, background: PT.ink3 }} />
          <button style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 13.5, fontFamily: 'CircularStd-Medium, system-ui', color: PT.ink2 }}>Terms</button>
        </div>
        <div style={{ textAlign: 'center', fontSize: 12, color: PT.ink3, marginTop: 11 }}>One-time purchase · no subscription</div>
      </div>
    </React.Fragment>
  );
}

window.RemoveAdsSheet = RemoveAdsSheet;
