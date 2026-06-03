// Shared tokens, data, and helpers for the PATCO Schedule redesign explorations.

// ── Palette ────────────────────────────────────────────────
// Light mode. PATCO red kept as a sparing accent; cool neutral greys.
const PT = {
  bg:        '#F1F1F4',   // app background (cool neutral)
  card:      '#FFFFFF',
  ink:       '#17171B',   // near-black
  ink2:      '#6C6C75',   // secondary
  ink3:      '#A0A0A8',   // tertiary
  hair:      'rgba(60,60,67,0.10)',
  hairBold:  'rgba(60,60,67,0.16)',
  red:       '#D11141',   // PATCO brand red
  redSoft:   '#FBE7EC',   // red tint surface
  green:     '#1B8A4B',   // on-time
  greenSoft: '#E4F3EA',
  amber:     '#B8791C',   // delay / heads-up
  amberSoft: '#FBEFD8',
  fill:      '#F1F1F4',   // inset fill chips
  fill2:     '#E8E8EC',
};

// ── Stations (west → east, 14 stops) ──────────────────────
const STATIONS = [
  'Lindenwold', 'Ashland', 'Woodcrest', 'Haddonfield', 'Westmont',
  'Collingswood', 'Ferry Avenue', 'Broadway', 'City Hall', 'Franklin Square',
  '8th & Market', '9/10th & Locust', '12/13th & Locust', '15/16th & Locust',
];

// ── Schedule data ──────────────────────────────────────────
// Virtual "now" = 12:59. Departures in minutes-of-day; ride = 25 min.
const VNOW = 12 * 60 + 59; // 12:59
const DEP_MINS = [
  13 * 60 + 3,   // 1:03
  13 * 60 + 18,  // 1:18
  13 * 60 + 33,  // 1:33
  13 * 60 + 48,  // 1:48
  14 * 60 + 3,   // 2:03
  14 * 60 + 15,  // 2:15
  14 * 60 + 27,  // 2:27
  14 * 60 + 42,  // 2:42
];
const RIDE = 25;

function fmt(mins) {
  let h = Math.floor(mins / 60), m = mins % 60;
  const ap = h >= 12 ? 'pm' : 'am';
  h = h % 12; if (h === 0) h = 12;
  return `${h}:${String(m).padStart(2, '0')} ${ap}`;
}
function untilLabel(mins) {
  if (mins <= 0) return 'Departing';
  if (mins < 60) return `${mins} min`;
  const h = Math.floor(mins / 60), m = mins % 60;
  return m ? `${h} hr ${m} min` : `${h} hr`;
}

// trips relative to a base offset (seconds), so the countdown can tick smoothly
function buildTrips() {
  return DEP_MINS.map((d, i) => ({
    id: i,
    dep: d, arr: d + RIDE,
    depStr: fmt(d), arrStr: fmt(d + RIDE),
    // a couple of trips get flavour
    onTime: i !== 2,
    delayMin: i === 2 ? 3 : 0,
    cars: 6,
  }));
}

// virtual clock hook: returns seconds elapsed since VNOW (starts at -? ) ticking up
function useTick(startOffsetSec = 0) {
  const [t, setT] = React.useState(startOffsetSec);
  React.useEffect(() => {
    const id = setInterval(() => setT(v => v + 1), 1000);
    return () => clearInterval(id);
  }, []);
  return t;
}

// minutes (float) until a departure given elapsed seconds
function minsUntil(depMin, elapsedSec) {
  return depMin - VNOW - elapsedSec / 60;
}
function mmss(depMin, elapsedSec) {
  let s = Math.max(0, Math.round((depMin - VNOW) * 60 - elapsedSec));
  const m = Math.floor(s / 60); s = s % 60;
  return `${m}:${String(s).padStart(2, '0')}`;
}

// ── Small shared UI bits ───────────────────────────────────
function Dot({ color = PT.green, size = 8, pulse = false }) {
  return (
    <span style={{ position: 'relative', display: 'inline-flex', width: size, height: size }}>
      {pulse && (
        <span style={{
          position: 'absolute', inset: 0, borderRadius: 999, background: color,
          animation: 'ptpulse 1.8s ease-out infinite',
        }} />
      )}
      <span style={{ width: size, height: size, borderRadius: 999, background: color, position: 'relative' }} />
    </span>
  );
}

// chevron
function Chev({ c = PT.ink3, s = 13 }) {
  return (
    <svg width={s * 0.6} height={s} viewBox="0 0 8 14" style={{ flexShrink: 0 }}>
      <path d="M1 1l6 6-6 6" stroke={c} strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

// swap / reverse icon
function SwapIcon({ c = PT.ink, s = 20 }) {
  return (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none">
      <path d="M7 4v15M7 19l-3.2-3.4M7 19l3.2-3.4" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M17 20V5M17 5l-3.2 3.4M17 5l3.2 3.4" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

Object.assign(window, {
  PT, STATIONS, VNOW, DEP_MINS, RIDE, fmt, untilLabel, buildTrips,
  useTick, minsUntil, mmss, Dot, Chev, SwapIcon,
});
