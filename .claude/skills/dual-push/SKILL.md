---
name: dual-push
description: Use whenever pushing to remote — this repo has TWO remotes (origin=202 for Vercel, local201=201 for sync) that must stay in lockstep
---

# 듀얼 리모트 푸시 (`origin` + `local201`)

## 리모트 구성
| 이름 | URL | 용도 |
|---|---|---|
| `origin` | `pdp-maker-202` | Vercel 배포 기준 |
| `local201` | `pdp-maker-201` | 로컬 동기화 |

**기능 수정은 이 워크트리에서 한 번만 하고, 같은 커밋을 양쪽에 반영한다.**

## 표준 푸시
```bash
pnpm run push:all
```
스크립트: `scripts/push-all.sh`
동작: `origin`과 `local201`에 동일 브랜치를 차례로 push

## 사전 점검
1. `git status` — 의도한 변경만 staged
2. `git log origin/main..HEAD` — 푸시될 커밋 목록 확인
3. 비밀값 흔적 없는지 마지막 grep
4. `pnpm typecheck` 통과

## 리모트 확인
```bash
git remote -v
```
양쪽이 모두 보여야 함. 누락 시:
```bash
git remote add origin https://github.com/nuolgo/pdp-maker-202.git
git remote add local201 https://github.com/nuolgo/pdp-maker-201.git
```

## 한쪽만 푸시 실패 시
1. 출력 로그에서 어느 리모트가 실패했는지 확인
2. 인증/권한 이슈인지, 푸시 거부(non-fast-forward)인지 진단
3. 개별 재시도:
   ```bash
   git push origin <branch>
   git push local201 <branch>
   ```
4. non-fast-forward면 `git pull --rebase <remote> <branch>` 후 재푸시 (force push 금지)

## 첫 클론이 한쪽만 있을 때
이 저장소가 `pdp-maker-201`만으로 클론되어 origin이 201을 가리키는 경우, README의 듀얼 리모트 전략과 충돌한다. 사용자에게 다음 중 하나를 확인:
- (A) `origin`을 202로 변경하고 `local201`을 201로 추가
- (B) 이 워크트리에서는 단일 푸시만 사용 (push:all 스킵)

## 금지
- `git push --force` — 사용자 명시 승인 시에만
- 한쪽 리모트만 푸시하고 끝내기 — 두 저장소 분기 발생
- main에 직접 push (PR 경유 원칙)
