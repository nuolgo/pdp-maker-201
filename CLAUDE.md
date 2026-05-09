# Claude Code 프로젝트 규칙집 — Hanirum PDP Maker

이 저장소에서 Claude가 작업할 때 반드시 지켜야 할 규칙과 컨벤션입니다.

## 프로젝트 개요
- **주 도메인**: PDP(상세페이지) 마법사 — Gemini AI로 분석·이미지 생성
- **부 도메인**: 어드민 챗/지식/티켓, 테니스 대회 통합, e-commerce 분석
- **모노레포 구조**:
  - `apps/web` — Next.js 14 App Router (포트 3000)
  - `apps/api` — Node http 서버 (포트 4000)
  - `packages/shared` — 공용 타입

## 환경
- **Node**: 24 (devcontainer와 일치)
- **패키지 매니저**: pnpm 9 — `npm`/`yarn` 사용 금지
- **포트 고정**: web `3000`, api `4000`

## 작성 규칙
- **언어**: 한글 메시지/주석 OK (UI 텍스트도 한글 우선)
- **타입 공유**: 가능하면 `packages/shared`에서 정의 후 `@runacademy/shared`로 import
- **Workspace deps**: `workspace:^` 사용
- **Comments**: WHY가 비자명할 때만. WHAT은 코드와 식별자로 충분
- **API 라우트**: `apps/api/src/main.ts`의 핸들러에 등록하고, 비즈니스 로직은 `modules/<domain>/`로 분리

## 명령
| 작업 | 명령 |
|---|---|
| 의존성 설치 | `pnpm install` |
| 전체 dev | `pnpm dev` (web+api 병렬) |
| web만 | `pnpm --filter @runacademy/web dev` |
| api만 | `pnpm --filter @runacademy/api dev` |
| 빌드 | `pnpm build` |
| 타입체크 | `pnpm typecheck` |
| Prisma 클라이언트 재생성 | `pnpm --filter @runacademy/api prisma:generate` |
| 듀얼 푸시 | `pnpm run push:all` |

## Git 워크플로
- **main 직접 푸시 금지** — feature 브랜치 만들고 PR로 머지
- **리모트**: `origin` → `pdp-maker-201` (현재 유일, Vercel 배포 기준)
- 푸시: `git push origin <branch>` 또는 `pnpm run push:all`
- 미러 저장소(`pdp-maker-202`)는 미사용 상태 — 추가 시 `MIRROR_REMOTE`로 활성화 (`scripts/push-all.sh`)

## 비밀 정보
- API 키, DB URL, 어드민 비번 등은 `.env`에만 두고 **절대 커밋 금지**
- 새 환경변수 추가 시 `.env.example` 동기화 필수
- Claude는 어떤 harness 파일(`CLAUDE.md`, `.claude/`, `harness/`, `_workspace/`)에도 비밀값을 기록하지 않음

## Prisma
- 스키마 수정 → `prisma migrate dev` → `prisma generate`
- 클라이언트 코드는 `apps/api/src/prisma/prisma.service.ts`를 통해 사용

## 작업 흐름
1. 요구 접수 → `_workspace/drafts/`에 설계안 작성
2. 사용자 승인 → 관련 agent가 구현
3. `_workspace/reviews/`에 자가 점검
4. `_workspace/outputs/`에 PR 요약
5. feature 브랜치 커밋 → `pnpm run push:all` → Vercel 확인

## 자세한 가이드
- 에이전트별 역할: `.claude/agents/`
- 반복 작업 매뉴얼: `.claude/skills/`
- 워크플로 상세: `harness/workflow.md`
- 오케스트레이션: `harness/orchestrator.md`
