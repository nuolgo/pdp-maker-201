---
name: pdp-flow
description: Use when adding or modifying PDP analyze/image generation endpoints (/v1/pdp/analyze, /v1/pdp/images) or related Gemini calls
---

# PDP 분석·이미지 생성 흐름

## 관련 파일
- `apps/api/src/main.ts` — 라우트 `POST /v1/pdp/analyze`, `POST /v1/pdp/images`
- `apps/api/src/modules/pdp/pdp.controller.ts` — 컨트롤러
- `packages/shared` — `PdpAnalyzeRequest`, `PdpGenerateImageRequest` 타입

## 새 PDP 엔드포인트 추가 절차
1. 요청/응답 타입을 `packages/shared`에 추가하고 export
2. `pdp.controller.ts`에 메서드 추가 (또는 새 컨트롤러)
3. `main.ts`에서 라우트 매칭 추가:
   ```ts
   if (req.method === "POST" && pathname === "/v1/pdp/<new>") {
     const body = await readJsonBody<...>(req);
     respondJson(res, 200, await pdpController.<method>(body, readGeminiApiKeyOverride(req)));
     return;
   }
   ```
4. 사용자 키 오버라이드 필요하면 `readGeminiApiKeyOverride(req)` 두 번째 인자로 전달
5. 프론트의 호출부(`apps/web/lib`)에 클라이언트 함수 추가

## Gemini 키 처리 규칙
- 서버 환경변수 `GEMINI_API_KEY`가 기본
- 클라이언트가 `X-Gemini-Api-Key` 헤더로 보내면 그 값 우선
- 키를 로그·에러 메시지에 출력 금지

## 검증
- `pnpm --filter @runacademy/api typecheck`
- `curl -X POST http://127.0.0.1:4000/v1/pdp/analyze -H "Content-Type: application/json" -d '{...}'`
