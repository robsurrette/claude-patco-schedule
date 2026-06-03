// iOS 26 graphical date picker (DatePickerStyle.graphical look), used inside a
// popover that pops out from the date control.

function IOSCalendar({ selected, today, onSelect }) {
  const [view, setView] = React.useState(new Date(selected.getFullYear(), selected.getMonth(), 1));
  const y = view.getFullYear(), m = view.getMonth();
  const firstDow = new Date(y, m, 1).getDay();
  const days = new Date(y, m + 1, 0).getDate();
  const cells = [];
  for (let i = 0; i < firstDow; i++) cells.push(null);
  for (let d = 1; d <= days; d++) cells.push(d);

  const same = (a, b) => a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate();
  const monthLabel = view.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });

  return (
    <div style={{ padding: '6px 14px 12px' }}>
      {/* header: Month Year + nav */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '6px 2px 12px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 5, color: PT.red }}>
          <span style={{ fontSize: 16.5, fontFamily: 'CircularStd-Bold, system-ui', color: PT.ink }}>{monthLabel}</span>
          <svg width="11" height="7" viewBox="0 0 12 8" style={{ marginTop: 2 }}><path d="M1 1l5 5 5-5" stroke={PT.red} strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg>
        </div>
        <div style={{ display: 'flex', gap: 18, alignItems: 'center' }}>
          <button onClick={() => setView(new Date(y, m - 1, 1))} style={icBtn} aria-label="Previous month"><svg width="9" height="15" viewBox="0 0 9 15"><path d="M8 1L1.5 7.5 8 14" stroke={PT.red} strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg></button>
          <button onClick={() => setView(new Date(y, m + 1, 1))} style={icBtn} aria-label="Next month"><svg width="9" height="15" viewBox="0 0 9 15"><path d="M1 1l6.5 6.5L1 14" stroke={PT.red} strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg></button>
        </div>
      </div>

      {/* weekday row */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)' }}>
        {['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d, i) => (
          <div key={i} style={{ textAlign: 'center', fontSize: 12, fontFamily: 'CircularStd-Bold, system-ui', color: PT.ink3, paddingBottom: 6 }}>{d}</div>
        ))}
      </div>

      {/* day grid */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', rowGap: 2 }}>
        {cells.map((d, i) => {
          if (d === null) return <div key={i} />;
          const date = new Date(y, m, d);
          const isSel = same(selected, date);
          const isToday = same(today, date);
          return (
            <div key={i} style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: 40 }}>
              <button onClick={() => onSelect(new Date(y, m, d))} style={{
                width: 36, height: 36, borderRadius: 999, border: 'none', cursor: 'pointer',
                background: isSel ? PT.red : 'transparent',
                color: isSel ? '#fff' : (isToday ? PT.red : PT.ink),
                fontSize: 16.5, fontFamily: isSel || isToday ? 'CircularStd-Bold, system-ui' : 'CircularStd-Book, system-ui',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>{d}</button>
            </div>
          );
        })}
      </div>
    </div>
  );
}

const icBtn = { background: 'none', border: 'none', cursor: 'pointer', padding: 4, display: 'flex', alignItems: 'center' };

window.IOSCalendar = IOSCalendar;
