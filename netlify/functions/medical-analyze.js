// netlify/functions/medical-analyze.js
const OpenAI_API_URL = "https://api.openai.com/v1/chat/completions";

exports.handler = async (event) => {
  if (event.httpMethod !== "POST") {
    return {
      statusCode: 405,
      body: JSON.stringify({ error: "Method not allowed" }),
    };
  }

  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "OPENAI_API_KEY is not configured" }),
    };
  }

  try {
    const { images, testType } = JSON.parse(event.body || "{}");

    if (!Array.isArray(images) || images.length === 0) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "No images provided" }),
      };
    }

    const imageContents = images.map((base64) => ({
      type: "image_url",
      image_url: { url: base64, detail: "high" },
    }));

    const userText =
      testType && testType !== "auto"
        ? `Please analyze this medical document. The user indicated it's a ${testType} test. Extract all relevant information and provide a comprehensive health assessment.`
        : "Please analyze this medical document. Automatically detect what type of test it is, extract all relevant information, and provide a comprehensive health assessment.";

    const body = {
      model: "gpt-4o",
      max_tokens: 4000,
      temperature: 0.3,
      messages: [
        {
          role: "system",
          content: `You are an expert medical AI assistant specialized in analyzing medical test results and diagnostic images.

RESPONSE FORMAT (respond in valid JSON only):
{
  "detectedType": "Blood Test / ECG / MRI / CT Scan / X-Ray / Lab Report / Other",
  "healthScore": <number 0-100>,
  "summary": "<1-2 sentence assessment>",
  "findings": [
    {"title": "<finding>", "description": "<explanation>", "severity": "critical/warning/normal/info"}
  ],
  "recommendations": [
    {"title": "<recommendation>", "description": "<details>", "type": "diet/supplement/lifestyle/medical/monitoring"}
  ],
  "rawAnalysis": "<detailed analysis>"
}

Be thorough. Extract all visible values. Compare against reference ranges. Always recommend consulting a healthcare professional.`,
        },
        {
          role: "user",
          content: [
            { type: "text", text: userText },
            ...imageContents,
          ],
        },
      ],
    };

    const resp = await fetch(OpenAI_API_URL, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });

    if (!resp.ok) {
      const err = await resp.json().catch(() => ({}));
      throw new Error(err.error?.message || `OpenAI error: ${resp.status}`);
    }

    const data = await resp.json();
    const aiContent = data.choices?.[0]?.message?.content || "";

    let result;
    try {
      let jsonStr = aiContent;
      const codeBlock = aiContent.match(/```(?:json)?\s*([\s\S]*?)```/);
      if (codeBlock) jsonStr = codeBlock[1].trim();
      const objMatch = jsonStr.match(/\{[\s\S]*\}/);
      if (objMatch) jsonStr = objMatch[0];
      result = JSON.parse(jsonStr);
    } catch {
      result = {
        detectedType: "Medical Document",
        healthScore: 70,
        summary: "Analysis completed",
        findings: [
          {
            title: "Document analyzed",
            description: "See raw analysis below",
            severity: "info",
          },
        ],
        recommendations: [
          {
            title: "Consult doctor",
            description:
              "Share these results with your healthcare provider for proper interpretation.",
            type: "medical",
          },
        ],
        rawAnalysis: aiContent,
      };
    }

    return {
      statusCode: 200,
      body: JSON.stringify({ result }),
    };
  } catch (error) {
    console.error("Medical analyze error:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: "AI processing failed",
        details: error.message,
      }),
    };
  }
};
