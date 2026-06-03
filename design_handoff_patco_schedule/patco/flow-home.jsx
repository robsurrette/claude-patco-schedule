// Home screen for the flow — Direction A "Up Next", with navigation wired:
// tap a station → station picker, tap the date → calendar, tap a trip → details.

function FlowHome({ origin, dest, onSwap, onOpenStation, onOpenTrip, dayLabel, dateLabel, onStepDay, selectedDate, today, onSelectDate, favOpen, setFavOpen, onApplyFav, alertOpen, onCloseAlert }) {
  const trips = React.useMemo(buildTrips, []);
  const t = useTick(0);
  const [dateOpen, setDateOpen] = React.useState(false);
  const live = trips.map(tr => ({ ...tr, until: minsUntil(tr.dep, t) })).filter(tr => tr.until > -1);
  const next = live[0];
  const rest = live.slice(1, 6);

  const favs = [
    { label: 'Home', sub: 'Woodcrest → Center City', o: 'Woodcrest', d: '15/16th & Locust' },
    { label: 'Work', sub: 'Center City → Woodcrest', o: '15/16th & Locust', d: 'Woodcrest' },
    { label: 'Haddonfield → City Hall', sub: 'Weekend route', o: 'Haddonfield', d: 'City Hall' },
  ];

  return (
    <div style={{ minHeight: '100%', background: PT.bg, color: PT.ink }}>
      {/* header */}
      <div style={{ position: 'sticky', top: 0, zIndex: 20, background: 'rgba(241,241,244,0.86)', backdropFilter: 'blur(18px)', WebkitBackdropFilter: 'blur(18px)', padding: '56px 16px 12px', borderBottom: `0.5px solid ${PT.hair}` }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
          <div style={{ fontFamily: 'CircularStd-Black, system-ui', fontSize: 28, letterSpacing: -0.4 }}>Schedule</div>
          <button onClick={() => setFavOpen(v => !v)} style={{ display: 'flex', alignItems: 'center', gap: 7, border: 'none', cursor: 'pointer', background: favOpen ? PT.ink : PT.card, color: favOpen ? '#fff' : PT.ink, borderRadius: 999, padding: '8px 14px', boxShadow: favOpen ? 'none' : '0 1px 2px rgba(0,0,0,0.05)', fontSize: 14.5, fontFamily: 'CircularStd-Medium, system-ui' }}>
            <svg width="15" height="15" viewBox="0 0 24 24" fill={favOpen ? '#fff' : PT.red}><path d="M12 2.5l2.9 6 6.6.6-5 4.4 1.5 6.5L12 16.9 5.9 20l1.5-6.5-5-4.4 6.6-.6z"/></svg>
            Saved
          </button>
        </div>

        {/* route selector */}
        <div style={{ display: 'flex', alignItems: 'center', background: PT.card, borderRadius: 16, padding: '6px 8px 6px 14px', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' }}>
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', marginRight: 12, paddingTop: 2 }}>
            <span style={{ width: 9, height: 9, borderRadius: 999, border: `2.5px solid ${PT.ink3}` }} />
            <span style={{ width: 2, height: 14, background: PT.hairBold, margin: '3px 0', borderRadius: 2 }} />
            <svg width="13" height="15" viewBox="0 0 24 24" fill="none"><path d="M12 22s7-7.6 7-13A7 7 0 1 0 5 9c0 5.4 7 13 7 13Z" fill={PT.red}/><circle cx="12" cy="9" r="2.6" fill="#fff"/></svg>
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <button onClick={() => onOpenStation('origin')} style={fhRowBtn}><span style={fhStation}>{origin}</span></button>
            <div style={{ height: 0.5, background: PT.hair, margin: '2px 0' }} />
            <button onClick={() => onOpenStation('dest')} style={fhRowBtn}><span style={fhStation}>{dest}</span></button>
          </div>
          <button onClick={onSwap} style={fhSwap} aria-label="Swap stations"><SwapIcon c={PT.ink} s={19} /></button>
        </div>

        {/* day stepper + iOS 26 date popover */}
        <div style={{ position: 'relative', display: 'flex', alignItems: 'center', gap: 8, marginTop: 10 }}>
          <button onClick={() => onStepDay(-1)} style={fhArrow} aria-label="Previous day"><svg width="8" height="14" viewBox="0 0 8 14"><path d="M7 1L1 7l6 6" stroke={PT.ink} strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg></button>
          <button onClick={() => setDateOpen(v => !v)} style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8, background: dateOpen ? PT.redSoft : PT.card, border: 'none', cursor: 'pointer', borderRadius: 12, padding: '10px', boxShadow: dateOpen ? 'none' : '0 1px 2px rgba(0,0,0,0.04)' }}>
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none"><rect x="3" y="4.5" width="18" height="16" rx="3" stroke={dateOpen ? PT.red : PT.ink2} strokeWidth="1.8"/><path d="M3 9h18M8 2.5v4M16 2.5v4" stroke={dateOpen ? PT.red : PT.ink2} strokeWidth="1.8" strokeLinecap="round"/></svg>
            <span style={{ fontSize: 15.5, fontFamily: 'CircularStd-Bold, system-ui', color: dateOpen ? PT.red : PT.ink }}>{dayLabel}</span>
            <span style={{ fontSize: 14.5, color: dateOpen ? PT.red : PT.ink2 }}>{dateLabel}</span>
          </button>
          <button onClick={() => onStepDay(1)} style={fhArrow} aria-label="Next day"><svg width="8" height="14" viewBox="0 0 8 14"><path d="M1 1l6 6-6 6" stroke={PT.ink} strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg></button>

          {dateOpen && (
            <React.Fragment>
              <div onClick={() => setDateOpen(false)} style={{ position: 'absolute', top: '100%', left: -1000, right: -1000, height: 1200, zIndex: 4 }} />
              <div style={{ position: 'absolute', top: 'calc(100% + 10px)', left: 24, right: 24, zIndex: 6, transformOrigin: 'top center', animation: 'ptPop 0.22s cubic-bezier(0.32,0.72,0,1)' }}>
                <div style={{ position: 'absolute', top: -6, left: '50%', marginLeft: -6, width: 12, height: 12, background: 'rgba(252,252,254,0.96)', transform: 'rotate(45deg)', borderTop: '0.5px solid rgba(0,0,0,0.06)', borderLeft: '0.5px solid rgba(0,0,0,0.06)' }} />
                <div style={{ position: 'relative', background: 'rgba(252,252,254,0.96)', backdropFilter: 'blur(20px)', WebkitBackdropFilter: 'blur(20px)', borderRadius: 20, boxShadow: '0 18px 44px rgba(17,17,27,0.24)', border: '0.5px solid rgba(0,0,0,0.06)', overflow: 'hidden' }}>
                  <IOSCalendar selected={selectedDate} today={today} onSelect={(d) => { onSelectDate(d); setDateOpen(false); }} />
                </div>
              </div>
            </React.Fragment>
          )}
        </div>

        {/* saved popover */}
        {favOpen && (
          <React.Fragment>
            <div onClick={() => setFavOpen(false)} style={{ position: 'absolute', top: '100%', left: 0, right: 0, height: 900, background: 'rgba(20,20,26,0.18)' }} />
            <div style={{ position: 'absolute', top: 'calc(100% - 6px)', right: 14, width: 286, background: PT.card, borderRadius: 18, boxShadow: '0 16px 40px rgba(17,17,27,0.22)', overflow: 'hidden', zIndex: 5 }}>
              <div style={{ padding: '13px 16px 9px', fontSize: 12, fontFamily: 'CircularStd-Bold, system-ui', letterSpacing: 0.8, color: PT.ink2, textTransform: 'uppercase' }}>Saved routes</div>
              {favs.map((f, i) => {
                const active = f.o === origin && f.d === dest;
                return (
                  <button key={i} onClick={() => onApplyFav(f)} style={{ width: '100%', textAlign: 'left', border: 'none', cursor: 'pointer', background: 'transparent', display: 'flex', alignItems: 'center', gap: 12, padding: '11px 16px', position: 'relative' }}>
                    <svg width="15" height="15" viewBox="0 0 24 24" fill={PT.red} style={{ flexShrink: 0 }}><path d="M12 2.5l2.9 6 6.6.6-5 4.4 1.5 6.5L12 16.9 5.9 20l1.5-6.5-5-4.4 6.6-.6z"/></svg>
                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ fontSize: 15.5, fontFamily: 'CircularStd-Bold, system-ui' }}>{f.label}</div>
                      <div style={{ fontSize: 12.5, color: PT.ink2, marginTop: 1, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{f.sub}</div>
                    </div>
                    {active && <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><path d="M4 12l5 5 11-11" stroke={PT.red} strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"/></svg>}
                    {i < favs.length - 1 && <div style={{ position: 'absolute', left: 43, right: 0, bottom: 0, height: 0.5, background: PT.hair }} />}
                  </button>
                );
              })}
              <button style={{ width: '100%', textAlign: 'left', border: 'none', cursor: 'pointer', background: PT.fill, display: 'flex', alignItems: 'center', gap: 10, padding: '13px 16px', borderTop: `0.5px solid ${PT.hair}` }}>
                <span style={{ width: 18, height: 18, borderRadius: 999, background: PT.red, color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 15, lineHeight: 1 }}>+</span>
                <span style={{ fontSize: 14.5, fontFamily: 'CircularStd-Medium, system-ui' }}>Save current route</span>
              </button>
            </div>
          </React.Fragment>
        )}
      </div>

      {/* body */}
      <div style={{ padding: '14px 16px 96px' }}>
        {next && (
          <button onClick={() => onOpenTrip(next)} style={{ width: '100%', textAlign: 'left', cursor: 'pointer', border: 'none', background: PT.card, borderRadius: 20, padding: '14px 16px 15px', boxShadow: '0 5px 18px rgba(17,17,27,0.07)' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 9 }}>
              <Dot color={PT.red} pulse />
              <span style={{ fontSize: 12, fontFamily: 'CircularStd-Bold, system-ui', letterSpacing: 1.2, color: PT.ink2 }}>UP NEXT</span>
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <div style={{ display: 'flex', alignItems: 'flex-end', gap: 7 }}>
                <div style={{ fontFamily: 'CircularStd-Black, system-ui', fontSize: 48, lineHeight: '0.88', letterSpacing: -1.3 }}>{Math.max(0, Math.ceil(next.until))}</div>
                <div style={{ paddingBottom: 4 }}>
                  <div style={{ fontSize: 16, fontFamily: 'CircularStd-Bold, system-ui' }}>min</div>
                  <div style={{ fontSize: 12.5, color: PT.ink2, fontVariantNumeric: 'tabular-nums' }}>{mmss(next.dep, t)}</div>
                </div>
              </div>
              <div style={{ flex: 1 }} />
              <div style={{ display: 'flex', flexDirection: 'column', gap: 4, paddingLeft: 14, borderLeft: `0.5px solid ${PT.hair}` }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, alignItems: 'baseline' }}>
                  <span style={{ fontSize: 12.5, color: PT.ink2 }}>Depart</span>
                  <span style={{ fontSize: 16, fontFamily: 'CircularStd-Bold, system-ui', fontVariantNumeric: 'tabular-nums' }}>{next.depStr}</span>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, alignItems: 'baseline' }}>
                  <span style={{ fontSize: 12.5, color: PT.ink2 }}>Arrive</span>
                  <span style={{ fontSize: 16, fontFamily: 'CircularStd-Bold, system-ui', fontVariantNumeric: 'tabular-nums' }}>{next.arrStr}</span>
                </div>
              </div>
              <span style={{ display: 'inline-flex', marginLeft: 2 }}><Chev s={15} /></span>
            </div>
          </button>
        )}

        {alertOpen && (
          <div style={{ marginTop: 14, background: PT.amberSoft, borderRadius: 14, padding: '12px 14px', display: 'flex', gap: 11, alignItems: 'flex-start' }}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" style={{ flexShrink: 0, marginTop: 1 }}><path d="M12 3l9 16H3l9-16z" stroke={PT.amber} strokeWidth="2" strokeLinejoin="round"/><path d="M12 10v4M12 16.5v.5" stroke={PT.amber} strokeWidth="2" strokeLinecap="round"/></svg>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontFamily: 'CircularStd-Bold, system-ui', color: '#7A5210' }}>Minor delays · Westmont</div>
              <div style={{ fontSize: 13, color: '#8A6420', marginTop: 2 }}>The 1:33 is running about 3 min behind.</div>
            </div>
            <button onClick={onCloseAlert} style={{ background: 'none', border: 'none', cursor: 'pointer', color: PT.amber, fontSize: 18, lineHeight: 1, padding: 2 }}>×</button>
          </div>
        )}

        <div style={{ marginTop: 20, marginBottom: 8 }}><span style={fhHdr}>Later today</span></div>
        <div style={{ background: PT.card, borderRadius: 18, overflow: 'hidden', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' }}>
          {rest.map((tr, i) => (
            <button key={tr.id} onClick={() => onOpenTrip(tr)} style={{ width: '100%', border: 'none', cursor: 'pointer', textAlign: 'left', background: 'transparent', display: 'flex', alignItems: 'center', padding: '0 16px', minHeight: 62, position: 'relative' }}>
              <div style={{ flex: 1 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 9, fontFamily: 'CircularStd-Bold, system-ui', fontSize: 18, fontVariantNumeric: 'tabular-nums' }}>
                  {tr.depStr}
                  <svg width="15" height="9" viewBox="0 0 24 12" fill="none"><path d="M0 6h21M16 1l5 5-5 5" stroke={PT.ink3} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/></svg>
                  {tr.arrStr}
                </div>
                <div style={{ fontSize: 13, color: tr.onTime ? PT.ink2 : PT.amber, marginTop: 3 }}>{tr.onTime ? `departs in ${untilLabel(Math.ceil(tr.until))}` : `+${tr.delayMin} min delay · ${untilLabel(Math.ceil(tr.until))}`}</div>
              </div>
              <Chev />
              {i < rest.length - 1 && <div style={{ position: 'absolute', left: 16, right: 0, bottom: 0, height: 0.5, background: PT.hair }} />}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

const fhRowBtn = { width: '100%', textAlign: 'left', background: 'none', border: 'none', cursor: 'pointer', padding: '6px 0' };
const fhStation = { fontSize: 17, fontFamily: 'CircularStd-Medium, system-ui', color: PT.ink };
const fhSwap = { width: 42, height: 42, borderRadius: 11, background: PT.fill, border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 };
const fhArrow = { width: 42, height: 42, borderRadius: 12, background: PT.card, border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0, boxShadow: '0 1px 2px rgba(0,0,0,0.04)' };
const fhHdr = { fontSize: 13, fontFamily: 'CircularStd-Bold, system-ui', letterSpacing: 0.3, color: PT.ink2, textTransform: 'uppercase' };

window.FlowHome = FlowHome;
