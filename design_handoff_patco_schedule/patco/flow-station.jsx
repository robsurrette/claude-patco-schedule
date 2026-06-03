// Station picker — full sheet with search + favorites, Direction A language.

const FAV_KEY = 'patco.favStations';
const DEFAULT_FAVS = ['Woodcrest', '15/16th & Locust', 'Haddonfield'];

function loadFavs() {
  try {
    const raw = JSON.parse(localStorage.getItem(FAV_KEY) || 'null');
    if (Array.isArray(raw)) return raw.filter(s => STATIONS.includes(s));
  } catch (e) {}
  return DEFAULT_FAVS.filter(s => STATIONS.includes(s));
}

function StationSheet({ title, selected, onSelect, onClose }) {
  const [q, setQ] = React.useState('');
  const [favs, setFavs] = React.useState(loadFavs);
  const query = q.trim().toLowerCase();
  const filtered = STATIONS.filter(s => s.toLowerCase().includes(query));

  React.useEffect(() => {
    try { localStorage.setItem(FAV_KEY, JSON.stringify(favs)); } catch (e) {}
  }, [favs]);

  const toggleFav = (name) => {
    setFavs(prev => prev.includes(name) ? prev.filter(s => s !== name) : [...prev, name]);
  };

  // Star icon — filled when favorited, hairline outline when not.
  const Star = ({ on }) => (
    <svg width="20" height="20" viewBox="0 0 24 24" fill={on ? PT.red : 'none'} stroke={on ? PT.red : PT.ink3} strokeWidth="1.8" strokeLinejoin="round">
      <path d="M12 3l2.7 5.5 6.1.9-4.4 4.3 1 6.1L12 17.9 6.6 19.8l1-6.1L3.2 9.4l6.1-.9z"/>
    </svg>
  );

  // Row: a selectable region + (optionally) a star toggle, side by side.
  const Row = ({ name, last, fav }) => {
    const active = name === selected;
    const isFav = favs.includes(name);
    return (
      <div style={{ display: 'flex', alignItems: 'center', background: active ? PT.redSoft : 'transparent', position: 'relative' }}>
        <button onClick={() => onSelect(name)} style={{ flex: 1, textAlign: 'left', border: 'none', cursor: 'pointer', background: 'transparent', display: 'flex', alignItems: 'center', gap: 13, padding: '0 4px 0 16px', minHeight: 54 }}>
          <span style={{ width: 12, height: 12, borderRadius: 999, border: `2.5px solid ${active ? PT.red : PT.ink3}`, background: active ? PT.red : 'transparent', flexShrink: 0 }} />
          <span style={{ flex: 1, fontSize: 17, fontFamily: active ? 'CircularStd-Bold, system-ui' : 'CircularStd-Book, system-ui', color: PT.ink }}>{name}</span>
          {active && <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><path d="M4 12l5 5 11-11" stroke={PT.red} strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"/></svg>}
        </button>
        {!fav && (
          <button onClick={() => toggleFav(name)} aria-label={isFav ? `Unfavorite ${name}` : `Favorite ${name}`} aria-pressed={isFav} style={{ border: 'none', cursor: 'pointer', background: 'transparent', display: 'flex', alignItems: 'center', justifyContent: 'center', width: 50, alignSelf: 'stretch', flexShrink: 0 }}>
            <Star on={isFav} />
          </button>
        )}
        {fav && (
          <button onClick={() => toggleFav(name)} aria-label={`Remove ${name} from favorites`} style={{ border: 'none', cursor: 'pointer', background: 'transparent', display: 'flex', alignItems: 'center', justifyContent: 'center', width: 50, alignSelf: 'stretch', flexShrink: 0 }}>
            <Star on={true} />
          </button>
        )}
        {!last && <div style={{ position: 'absolute', left: 41, right: 0, bottom: 0, height: 0.5, background: PT.hair }} />}
      </div>
    );
  };

  return (
    <React.Fragment>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 16px 12px 20px', flexShrink: 0 }}>
        <span style={{ fontSize: 23, fontFamily: 'CircularStd-Bold, system-ui', letterSpacing: -0.3 }}>{title}</span>
        <button onClick={onClose} aria-label="Close" style={{ width: 38, height: 38, borderRadius: 999, border: 'none', cursor: 'pointer', background: PT.fill2, color: PT.ink2, fontSize: 19, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>×</button>
      </div>

      {/* search */}
      <div style={{ padding: '0 16px 12px', flexShrink: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 9, background: PT.card, borderRadius: 12, padding: '11px 14px', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' }}>
          <svg width="17" height="17" viewBox="0 0 24 24" fill="none"><circle cx="11" cy="11" r="7" stroke={PT.ink3} strokeWidth="2"/><path d="M16.5 16.5L21 21" stroke={PT.ink3} strokeWidth="2" strokeLinecap="round"/></svg>
          <input value={q} onChange={e => setQ(e.target.value)} placeholder="Search stations" style={{ flex: 1, border: 'none', outline: 'none', background: 'transparent', fontSize: 16, fontFamily: 'CircularStd-Book, system-ui', color: PT.ink }} />
          {q && <button onClick={() => setQ('')} style={{ border: 'none', background: 'none', cursor: 'pointer', color: PT.ink3, fontSize: 17 }}>×</button>}
        </div>
      </div>

      <div className="pt-scroll" style={{ flex: 1, overflowY: 'auto', padding: '0 16px 24px' }}>
        {!query && favs.length > 0 && (
          <React.Fragment>
            <div style={{ ...ssHdr, marginTop: 2 }}>Favorites</div>
            <div style={{ background: PT.card, borderRadius: 16, overflow: 'hidden', boxShadow: '0 1px 2px rgba(0,0,0,0.04)', marginBottom: 18 }}>
              {favs.map((s, i) => <Row key={s} name={s} fav last={i === favs.length - 1} />)}
            </div>
          </React.Fragment>
        )}
        <div style={ssHdr}>{query ? 'Results' : 'All stations'}</div>
        <div style={{ background: PT.card, borderRadius: 16, overflow: 'hidden', boxShadow: '0 1px 2px rgba(0,0,0,0.04)' }}>
          {filtered.length === 0 && <div style={{ padding: '20px 16px', color: PT.ink3, fontSize: 15 }}>No stations match “{q}”.</div>}
          {filtered.map((s, i) => <Row key={s} name={s} last={i === filtered.length - 1} />)}
        </div>
      </div>
    </React.Fragment>
  );
}

const ssHdr = { fontSize: 12.5, fontFamily: 'CircularStd-Bold, system-ui', letterSpacing: 0.6, color: PT.ink2, textTransform: 'uppercase', padding: '0 4px 8px' };

window.StationSheet = StationSheet;
