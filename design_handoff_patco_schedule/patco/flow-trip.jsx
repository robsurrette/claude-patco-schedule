// Trip details — full sheet, Direction A language: summary, route-map placeholder,
// and the stop-by-stop rail.

function TripSheet({ trip, origin, dest, onClose }) {
  const t = useTick(0);
  const until = trip ? minsUntil(trip.dep, t) : 0;
  const [cardBg, setCardBg] = React.useState(true);

  // stops between origin and dest (inclusive), respecting direction
  const oi = STATIONS.indexOf(origin), di = STATIONS.indexOf(dest);
  let stops = [];
  if (oi !== -1 && di !== -1) {
    stops = oi <= di ? STATIONS.slice(oi, di + 1) : STATIONS.slice(di, oi + 1).reverse();
  }
  const nStops = Math.max(stops.length - 1, 0);

  if (!trip) return null;

  return (
    <React.Fragment>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 16px 12px 20px', flexShrink: 0 }}>
        <span style={{ fontSize: 19, fontFamily: 'CircularStd-Bold, system-ui' }}>Trip details</span>
        <button onClick={onClose} style={{ width: 38, height: 38, borderRadius: 999, border: 'none', cursor: 'pointer', background: PT.fill2, color: PT.ink2, fontSize: 19, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>×</button>
      </div>

      <div className="pt-scroll" style={{ flex: 1, overflowY: 'auto', padding: '0 16px 28px' }}>
        {/* live status */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 12 }}>
          <Dot color={trip.onTime ? PT.green : PT.amber} pulse />
          {!trip.onTime && (
            <span style={{ fontSize: 14.5, fontFamily: 'CircularStd-Bold, system-ui', color: PT.amber }}>
              +{trip.delayMin} min delay ·
            </span>
          )}
          <span style={{ fontSize: 14.5, color: PT.ink2 }}>departs in {untilLabel(Math.max(0, Math.ceil(until)))}</span>
        </div>

        {/* summary card */}
        <div style={{ background: PT.card, borderRadius: 20, padding: '18px', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 16 }}>
            <div style={{ minWidth: 0 }}>
              <div style={{ fontSize: 12.5, color: PT.ink2, marginBottom: 3 }}>Depart</div>
              <div style={{ fontSize: 18, fontFamily: 'CircularStd-Bold, system-ui' }}>{origin}</div>
            </div>
            <div style={{ textAlign: 'right', flexShrink: 0 }}>
              <div style={{ fontSize: 12.5, color: PT.ink2, marginBottom: 3 }}>{trip.depStr.slice(-2) === 'am' ? 'AM' : ''}</div>
              <div style={{ fontSize: 18, fontFamily: 'CircularStd-Bold, system-ui', fontVariantNumeric: 'tabular-nums' }}>{trip.depStr}</div>
            </div>
          </div>
          <div style={{ height: 0.5, background: PT.hair, margin: '14px 0' }} />
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 16 }}>
            <div style={{ minWidth: 0 }}>
              <div style={{ fontSize: 12.5, color: PT.ink2, marginBottom: 3 }}>Arrive</div>
              <div style={{ fontSize: 18, fontFamily: 'CircularStd-Bold, system-ui' }}>{dest}</div>
            </div>
            <div style={{ textAlign: 'right', flexShrink: 0 }}>
              <div style={{ fontSize: 12.5, color: PT.ink2, marginBottom: 3 }}>&nbsp;</div>
              <div style={{ fontSize: 18, fontFamily: 'CircularStd-Bold, system-ui', fontVariantNumeric: 'tabular-nums' }}>{trip.arrStr}</div>
            </div>
          </div>
          <div style={{ display: 'flex', gap: 10, marginTop: 16 }}>
            <div style={{ flex: 1, background: PT.fill, borderRadius: 12, padding: '10px 14px' }}>
              <div style={{ fontSize: 12.5, color: PT.ink2 }}>One way</div>
              <div style={{ fontSize: 18, fontFamily: 'CircularStd-Bold, system-ui' }}>$3.00</div>
            </div>
            <div style={{ flex: 1, background: PT.fill, borderRadius: 12, padding: '10px 14px' }}>
              <div style={{ fontSize: 12.5, color: PT.ink2 }}>Round trip</div>
              <div style={{ fontSize: 18, fontFamily: 'CircularStd-Bold, system-ui' }}>$6.00</div>
            </div>
          </div>
        </div>

        {/* route map placeholder */}
        <div style={{ marginTop: 14, height: 150, borderRadius: 18, overflow: 'hidden', position: 'relative', background: `repeating-linear-gradient(135deg, #E7E7EC, #E7E7EC 11px, #EDEDF1 11px, #EDEDF1 22px)`, border: `0.5px solid ${PT.hair}`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <div style={{ fontFamily: 'ui-monospace, Menlo, monospace', fontSize: 12, color: PT.ink3, letterSpacing: 0.5, background: 'rgba(255,255,255,0.7)', padding: '6px 12px', borderRadius: 8 }}>route map · Apple Maps</div>
        </div>

        {/* stops */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, margin: '22px 2px 12px' }}>
          <span style={{ fontSize: 16, fontFamily: 'CircularStd-Bold, system-ui' }}>Ride for {nStops} {nStops === 1 ? 'stop' : 'stops'}</span>
          <span style={{ fontSize: 14, color: PT.ink2 }}>· {RIDE} min</span>
          <button onClick={() => setCardBg(v => !v)} style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 8, background: 'none', border: 'none', cursor: 'pointer', padding: 0 }}>
            <span style={{ fontSize: 13, color: PT.ink2, fontFamily: 'CircularStd-Medium, system-ui' }}>Card</span>
            <span style={{ width: 38, height: 23, borderRadius: 99, background: cardBg ? PT.green : PT.fill2, position: 'relative', transition: 'background 0.2s', flexShrink: 0 }}>
              <span style={{ position: 'absolute', top: 2, left: cardBg ? 17 : 2, width: 19, height: 19, borderRadius: 99, background: '#fff', boxShadow: '0 1px 3px rgba(0,0,0,0.25)', transition: 'left 0.2s' }} />
            </span>
          </button>
        </div>
        <div style={{ background: cardBg ? PT.card : 'transparent', borderRadius: 18, padding: '6px 16px', boxShadow: cardBg ? '0 1px 2px rgba(0,0,0,0.04)' : 'none' }}>
          {stops.map((s, i) => {
            const first = i === 0, last = i === stops.length - 1;
            return (
              <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 14, minHeight: 46, position: 'relative' }}>
                <div style={{ position: 'relative', width: 16, alignSelf: 'stretch', display: 'flex', justifyContent: 'center', flexShrink: 0 }}>
                  {!last && <span style={{ position: 'absolute', top: 23, bottom: -23, left: '50%', transform: 'translateX(-50%)', width: 3, background: PT.red }} />}
                  {first || last
                    ? <svg width="16" height="16" viewBox="0 0 24 24" style={{ marginTop: 15, zIndex: 1 }}><circle cx="12" cy="12" r="9" fill={PT.red}/><circle cx="12" cy="12" r="3.4" fill="#fff"/></svg>
                    : <span style={{ width: 11, height: 11, borderRadius: 999, background: PT.card, border: `3px solid ${PT.red}`, marginTop: 17.5, zIndex: 1 }} />}
                </div>
                <span style={{ flex: 1, fontSize: 16.5, fontFamily: first || last ? 'CircularStd-Bold, system-ui' : 'CircularStd-Book, system-ui', color: first || last ? PT.ink : PT.ink2 }}>{s}</span>
                {first && <span style={{ fontSize: 14.5, fontFamily: 'CircularStd-Bold, system-ui', fontVariantNumeric: 'tabular-nums' }}>{trip.depStr}</span>}
                {last && <span style={{ fontSize: 14.5, fontFamily: 'CircularStd-Bold, system-ui', fontVariantNumeric: 'tabular-nums' }}>{trip.arrStr}</span>}
                {!first && !last && <span style={{ fontSize: 14.5, fontFamily: 'CircularStd-Book, system-ui', color: PT.ink2, fontVariantNumeric: 'tabular-nums' }}>{fmt(Math.round(trip.dep + RIDE * i / (stops.length - 1)))}</span>}
                {!last && <div style={{ position: 'absolute', left: 30, right: 0, bottom: 0, height: 0.5, background: PT.hair }} />}
              </div>
            );
          })}
        </div>
      </div>
    </React.Fragment>
  );
}

window.TripSheet = TripSheet;
