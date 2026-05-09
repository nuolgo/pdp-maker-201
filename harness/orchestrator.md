# Orchestrator — 어떤 agent를 언제 부를지

## 라우팅 표

| 사용자 요청 신호 | 호출 agent | 비고 |
|---|---|---|
| "버튼/페이지/UI/디자인", `apps/web/...` 언급 | `frontend-engineer` | |
| "API/엔드포인트/서버/Gemini", `apps/api/...` 언급 | `backend-engineer` | |
| "Prisma/DB/마이그레이션/스키마" | `backend-engineer` + `prisma-migration` skill | |
| "테니스/대회/소스/파싱" | `data-integrator` | |
| "공통 타입/shared" | `backend-engineer` 또는 `frontend-engineer` + `shared-type` skill | 작업 출처 따라 |
| "PR 만들어/배포해/푸시해" | `release-manager` | 절대 본인이 직접 푸시하지 말 것 |
| "리뷰해/검토해/괜찮은지 봐줘" | `code-reviewer` | 읽기 전용 |

## 다중 도메인 작업

웹+API가 모두 변경되는 작업은 다음 순서:

1. **설계** (orchestrator가 진행, agent 호출 안 함)
2. **타입 먼저** (`shared-type` skill, agent는 가까운 쪽 — 보통 backend)
3. **API 구현** (`backend-engineer` + `new-api-route` skill)
4. **UI 구현** (`frontend-engineer`)
5. **자가 리뷰** (`code-reviewer`)
6. **릴리스** (`release-manager`)

## 병렬화

독립적으로 진행 가능한 작업은 병렬로 위임:
- UI 작업 + 무관한 API 작업 → 병렬 OK
- 같은 파일 수정 작업 → 순차

## 에스컬레이션

다음 상황에서는 agent 호출 멈추고 **사용자에게 확인**:
- 새 npm 의존성 추가
- 운영 DB 영향 가능성 (Prisma 마이그레이션의 위험 신호)
- 비밀값/환경변수 추가
- main 브랜치 직접 변경 또는 force push 필요 추정
- README의 듀얼 리모트 전략과 다른 push 동작
- 외부 서비스 호출이 새로 추가됨 (rate limit, 비용)

## 메모

- 작은 작업(한 파일 한 줄 수정)은 agent 위임 없이 직접 처리해도 됨
- 작업 크기가 모호하면 `_workspace/drafts/`로 먼저 정리해 사용자에게 보여주는 것이 항상 안전
