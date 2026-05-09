---
name: dual-push
description: Use whenever pushing to remote — currently single origin (pdp-maker-201). Documents how to push and how to enable a future mirror without breaking the script.
---

# 푸시 (`origin` 단일, 미러는 옵션)

## 현재 리모트 구성
| 이름 | URL | 용도 |
|---|---|---|
| `origin` | `pdp-maker-201` | 유일한 리모트, Vercel 배포 기준 |

미러 저장소(`pdp-maker-202` 등)는 아직 셋업되지 않았습니다. 추가하지 않은 상태에서는 단일 push로 충분합니다.

## 표준 푸시
```bash
git push origin <branch>
```
또는
```bash
pnpm run push:all   # MIRROR_REMOTE 미설정 시 origin만 push
```

스크립트: `scripts/push-all.sh` — `MIRROR_REMOTE` 환경변수가 비어 있거나 해당 리모트가 없으면 자동으로 미러 단계를 건너뜁니다.

## 사전 점검
1. `git status` — 의도한 변경만 staged
2. `git log origin/main..HEAD` — 푸시될 커밋 목록 확인
3. 비밀값 흔적 없는지 마지막 grep
4. `pnpm typecheck` 통과

## 미러 추가 (필요해질 때)
새 미러를 셋업하려면:
```bash
git remote add local202 https://github.com/<owner>/pdp-maker-202.git
MIRROR_REMOTE=local202 pnpm run push:all
```
미러는 origin과 fast-forward 관계여야 합니다. 분기되면 push가 거부되므로 사전 동기화 필요.

## 푸시 실패 시
1. 인증/권한 이슈인지, non-fast-forward인지 진단
2. non-fast-forward면 `git pull --rebase origin <branch>` 후 재푸시 (force push 금지)

## 금지
- `git push --force` — 사용자 명시 승인 시에만
- main에 직접 push (PR 경유 원칙)
