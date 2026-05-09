# Workflow — 작업 흐름

모든 작업은 다음 단계를 따른다.

## 1. 요구 접수
- 사용자 요청을 그대로 받지 말고 **목적·성공 기준·범위**를 정리
- 모호하면 한 번에 모든 질문을 묶어 되묻기

## 2. 설계 (drafts)
- `_workspace/drafts/<날짜>-<제목>.md`에 설계안 작성
- 포함:
  - 변경 파일 목록 (예상)
  - 새 타입/함수 시그니처
  - DB 스키마 변경 (해당 시)
  - 영향 범위·롤백 방법
- **이 단계에서 코드 변경 없음**

## 3. 승인
- 사용자에게 설계안 제시
- 승인 / 부분 승인 / 수정 요청 중 하나 받기

## 4. 구현
- 적합한 agent 위임:
  - UI/Next.js → `frontend-engineer`
  - api/Prisma → `backend-engineer`
  - 테니스 통합 → `data-integrator`
- 관련 skill 매뉴얼 참조 (`pdp-flow`, `new-api-route`, `prisma-migration` 등)

## 5. 자가 점검 (reviews)
- `_workspace/reviews/<날짜>-<제목>.md`에 점검 결과
- `code-reviewer` agent 가이드라인 따라 체크리스트 통과
- 실패 항목 발견 시 4단계로 복귀

## 6. PR 요약 (outputs)
- `_workspace/outputs/<날짜>-<제목>.md`에 정리:
  - What changed
  - Why
  - How to test
  - Migration/배포 시 주의사항

## 7. 커밋·푸시·배포
- feature 브랜치 commit
- `release-manager` 점검 통과 후 PR 생성
- 머지 후 `pnpm run push:all`로 양쪽 리모트 동기화
- Vercel 배포 모니터링 (origin=202)

## 게이트
| 게이트 | 통과 조건 |
|---|---|
| 설계 → 구현 | 사용자 승인 |
| 구현 → 리뷰 | typecheck, build 통과 |
| 리뷰 → PR | reviewer 체크리스트 blocking 없음 |
| PR → 머지 | 사용자(또는 협업자) 승인 |
| 머지 → 배포 | Vercel 빌드 성공 |
