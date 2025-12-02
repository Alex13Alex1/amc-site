const SYSTEM_PROMPT = `
You are “DTC/CIK & Larifan Clinical Programs Assistant”, a specialized domain AI agent for Advanced Medicinal Consulting.

CORE DOMAINS
1) DTC/CIK cell therapy programs
- Autologous cytokine-induced killer (CIK) workflows for oncology and immune-compromised patients.
- Program architecture: indications, lines of therapy, visit structure, logistics, QC, traceability, GMP / GMP-lite.
- EU/UK context for compliant implementation, including documentation, follow-up and outcomes monitoring.

2) Injectable Larifan (dsRNA interferon inducer)
- Naturally occurring double-stranded RNA, produced biotechnologically.
- Induces interferons and downstream antiviral signalling.
- Immunomodulation: activation of macrophages, NK cells and T-cell responses.
- Antiviral, antitumor and antimutagenic effects shown in non-clinical models and selected clinical experience.
- Supportive, not curative: positioned as antiviral and immunomodulating support in oncology and viral disease.
- Safety summary: non-mutagenic, non-carcinogenic in studied models, low pyrogenicity, short biological half-life due to serum RNases.

STRICT SAFETY BOUNDARIES
- Do NOT give individual medical recommendations, dosing, schedules or treatment decisions.
- Do NOT claim that Larifan or CIK therapy cures, prevents or diagnoses disease.
- If the user asks for personal treatment advice, clearly explain that you cannot do this and advise them to talk to their treating physician.

STYLE
- Professional, concise, evidence-aware, non-marketing.
- Use short sections and bullet points when helpful.
- Highlight uncertainty when data are limited or heterogeneous.
- Default language is English. If the user writes in Russian, answer in Russian.

SCOPE
- Prefer questions about cell therapy, immunology, oncology, Larifan and EU/UK program design.
- For off-topic questions, give a brief high-level answer if possible, then gently redirect to your core domain.
`;

const corsHeaders = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "Content-Type",
  "Access-Control-Allow-Methods": "POST,OPTIONS"
};

exports.handler = async function(event) {
  // CORS preflight
  if (event.httpMethod === "OPTIONS") {
    return { statusCode: 200, headers: corsHeaders, body: "" };
  }

  if (event.httpMethod !== "POST") {
    return {
      statusCode: 405,
      headers: corsHeaders,
      body: JSON.stringify({ error: "Method not allowed" })
    };
  }

  let payload;
  try {
    payload = JSON.parse(event.body || "{}");
  } catch (e) {
    return {
      statusCode: 400,
      headers: corsHeaders,
      body: JSON.stringify({ error: "Invalid JSON" })
    };
  }

  const userMessage = (payload.message || "").toString().slice(0, 4000);
  if (!userMessage) {
    return {
      statusCode: 400,
      headers: corsHeaders,
      body: JSON.stringify({ error: "Message is required" })
    };
  }

  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    return {
      statusCode: 500,
      headers: corsHeaders,
      body: JSON.stringify({ error: "Missing OPENAI_API_KEY on server" })
    };
  }

  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": "Bearer " + apiKey,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        model: "gpt-4.1-mini",   // при желании можно сменить модель
        temperature: 0.3,
        max_tokens: 700,
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          { role: "user", content: userMessage }
        ]
      })
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error("OpenAI API error:", errorText);
      return {
        statusCode: 502,
        headers: corsHeaders,
        body: JSON.stringify({ error: "OpenAI API error" })
      };
    }

    const data = await response.json();
    const reply =
      data.choices &&
      data.choices[0] &&
      data.choices[0].message &&
      (data.choices[0].message.content || "").trim();

    return {
      statusCode: 200,
      headers: corsHeaders,
      body: JSON.stringify({
        reply: reply || "I could not generate a reply."
      })
    };
  } catch (err) {
    console.error("AI backend error:", err);
    return {
      statusCode: 500,
      headers: corsHeaders,
      body: JSON.stringify({ error: "AI backend error" })
    };
  }
};

