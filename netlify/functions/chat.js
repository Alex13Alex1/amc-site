// netlify/functions/chat.js

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const CORS_HEADERS = {
  'Content-Type': 'application/json',
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'Content-Type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

exports.handler = async function (event) {
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 204,
      headers: CORS_HEADERS,
      body: '',
    };
  }

  // Разрешаем только POST
  if (event.httpMethod !== 'POST') {
    return {
      statusCode: 405,
      headers: CORS_HEADERS,
      body: JSON.stringify({ error: 'Method Not Allowed' }),
    };
  }

  if (!OPENAI_API_KEY) {
    console.error('Missing OPENAI_API_KEY env var');
    return {
      statusCode: 500,
      headers: CORS_HEADERS,
      body: JSON.stringify({ error: 'Server is not configured (no API key).' }),
    };
  }

  try {
    let body;
    try {
      body = JSON.parse(event.body || '{}');
    } catch (parseErr) {
      return {
        statusCode: 400,
        headers: CORS_HEADERS,
        body: JSON.stringify({ error: 'Invalid JSON payload' }),
      };
    }
    const userMessage = (body.message || '').toString().trim();

    if (!userMessage) {
      return {
        statusCode: 400,
        headers: CORS_HEADERS,
        body: JSON.stringify({ error: 'Empty message' }),
      };
    }

    // Профильный промпт для твоего домена
    const systemPrompt = `
You are a domain AI consultant for "Advanced Medicinal Consulting".
Focus only on:
- DTC/CIK cell therapy programs (autologous CIK, oncology and immune-compromised patients)
- Injectable Larifan (dsRNA interferon inducer) as supportive antiviral and immunomodulating therapy.

Guidelines:
- Explain in clear, concise professional English.
- You may discuss: high-level mechanisms, program design, indications, safety considerations on a conceptual level, EU/UK regulatory context.
- You MUST NOT: give individual treatment advice, dosing instructions for specific patients, or recommend therapy for a particular person.
- If the question looks like personal medical advice, respond with a gentle warning and suggest they speak with their doctor.
`;

    // Запрос к OpenAI
    const apiResponse = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${OPENAI_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-4o-mini',
        temperature: 0.3,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userMessage },
        ],
      }),
    });

    if (!apiResponse.ok) {
      const errText = await apiResponse.text();
      console.error('OpenAI API error:', apiResponse.status, errText);
      return {
        statusCode: 502,
        headers: CORS_HEADERS,
        body: JSON.stringify({
          error: 'Upstream AI error',
        }),
      };
    }

    const data = await apiResponse.json();
    const reply =
      data.choices?.[0]?.message?.content?.trim() ||
      'I could not generate a reply at this moment.';

    return {
      statusCode: 200,
      headers: CORS_HEADERS,
      body: JSON.stringify({ reply }),
    };
  } catch (err) {
    console.error('Function error:', err);
    return {
      statusCode: 500,
      headers: CORS_HEADERS,
      body: JSON.stringify({ error: 'Unexpected server error' }),
    };
  }
};
