---
name: ui-component
description: Use when adding or modifying components in apps/web/components — covers Radix + Tailwind conventions, cva variant patterns, and the lucide-react icon set
---

# UI 컴포넌트 작성 패턴

## 위치
- `apps/web/components/ui/` — 일반화된 primitive (Button, Dialog 등)
- `apps/web/components/<domain>/` — 도메인 전용 (pdp, admin 등)

## 스택
- **Tailwind CSS** — 모든 스타일
- **Radix UI** — 접근성 primitive (`@radix-ui/react-dialog`, `-dropdown-menu`, `-slot`)
- **class-variance-authority (cva)** — variant 정의
- **tailwind-merge (twMerge)** — 클래스 충돌 해결
- **clsx** — 조건부 클래스
- **lucide-react** — 아이콘

## 표준 패턴

### 1. cn() 유틸 (이미 있다면 재사용)
```ts
// apps/web/lib/utils.ts
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

### 2. cva variant 컴포넌트
```tsx
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

const buttonVariants = cva("inline-flex items-center justify-center rounded font-medium", {
  variants: {
    variant: {
      default: "bg-primary text-white",
      ghost: "hover:bg-muted",
    },
    size: { sm: "h-8 px-3", md: "h-10 px-4" },
  },
  defaultVariants: { variant: "default", size: "md" },
});

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement>,
  VariantProps<typeof buttonVariants> {}

export function Button({ className, variant, size, ...props }: ButtonProps) {
  return <button className={cn(buttonVariants({ variant, size }), className)} {...props} />;
}
```

### 3. Radix primitive 래핑
```tsx
import * as DialogPrimitive from "@radix-ui/react-dialog";
export const Dialog = DialogPrimitive.Root;
export const DialogTrigger = DialogPrimitive.Trigger;
// 스타일 입힌 Content/Overlay/Title을 추가 export
```

### 4. asChild 패턴 (Slot)
부모가 자식 element 타입을 그대로 쓰고 싶을 때 `@radix-ui/react-slot` 활용.

## 컨벤션
- 파일명: PascalCase (`PdpEditor.tsx`)
- export: named export 우선 (default 지양)
- props 타입: 컴포넌트 옆에 같이 정의
- 사이즈/색상: 디자인 토큰 클래스 사용 (`primary`, `muted` 등 — `tailwind.config.ts` 참조)

## 금지
- inline style ❌ — Tailwind class로
- 새 UI 라이브러리 도입 ❌ — 사용자 승인 후
- 컴포넌트 안에서 직접 fetch ❌ — props 또는 server action 경유
