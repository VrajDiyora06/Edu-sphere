import type { Plugin, ViteDevServer } from 'vite';
import { IncomingMessage, ServerResponse } from 'http';
import { answerLessonDoubt, getCourseRecommendations, getGeminiApiKey } from './aiService.ts';

function parseJsonBody<T>(req: IncomingMessage): Promise<T> {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', (chunk) => {
      body += chunk;
    });
    req.on('end', () => {
      try {
        resolve(body ? JSON.parse(body) : {});
      } catch (err) {
        reject(err);
      }
    });
    req.on('error', reject);
  });
}

export function aiApiPlugin(): Plugin {
  return {
    name: 'edusphere-ai-api-plugin',
    configureServer(server: ViteDevServer) {
      server.middlewares.use(async (req: IncomingMessage, res: ServerResponse, next) => {
        const url = req.url?.split('?')[0];

        // 1. Status endpoint
        if (url === '/api/ai/status' && req.method === 'GET') {
          const hasApiKey = Boolean(getGeminiApiKey());
          res.setHeader('Content-Type', 'application/json');
          res.end(
            JSON.stringify({
              status: 'online',
              hasApiKey,
              activeProvider: hasApiKey ? 'gemini-3-flash-preview' : 'controlled_fallback',
            })
          );
          return;
        }

        // 2. Lesson Doubt Assistance endpoint
        if (url === '/api/ai/doubt' && req.method === 'POST') {
          try {
            const body = await parseJsonBody<any>(req);
            const result = await answerLessonDoubt(body);
            res.setHeader('Content-Type', 'application/json');
            res.statusCode = result.success ? 200 : 403;
            res.end(JSON.stringify(result));
          } catch (err) {
            res.setHeader('Content-Type', 'application/json');
            res.statusCode = 500;
            res.end(
              JSON.stringify({
                success: false,
                error: err instanceof Error ? err.message : 'Internal error processing doubt',
              })
            );
          }
          return;
        }

        // 3. Course Recommendations endpoint
        if (url === '/api/ai/recommendations' && req.method === 'POST') {
          try {
            const body = await parseJsonBody<any>(req);
            const result = await getCourseRecommendations(body);
            res.setHeader('Content-Type', 'application/json');
            res.statusCode = 200;
            res.end(JSON.stringify(result));
          } catch (err) {
            res.setHeader('Content-Type', 'application/json');
            res.statusCode = 500;
            res.end(
              JSON.stringify({
                success: false,
                error: err instanceof Error ? err.message : 'Internal error generating recommendations',
              })
            );
          }
          return;
        }

        next();
      });
    },
  };
}
