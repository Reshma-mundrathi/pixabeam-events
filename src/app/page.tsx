import { supabase } from "../lib/supabase";  // fallback to relative path

export default async function Home() {
  const { data, error } = await supabase
    .from("v_events_with_counts")
    .select("*")
    .order("date", { ascending: true });

  if (error) {
    return (
      <main style={{ padding: 24 }}>
        <h2>Error</h2>
        <pre>{error.message}</pre>
      </main>
    );
  }

  return (
    <main style={{ padding: 24 }}>
      <h1>Upcoming Events</h1>
      <ul>
        {data?.map((e: any) => (
          <li key={e.id} style={{ margin: "8px 0" }}>
            <strong>{e.title}</strong> — {new Date(e.date).toLocaleString()} — {e.city}
            {" "} | ✅ {e.yes_count} | ❌ {e.no_count} | 🤔 {e.maybe_count}
          </li>
        ))}
      </ul>
    </main>
  );
}

