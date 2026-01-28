---
name: clickable-code-refs
description: 确保引用代码时使用可点击跳转的格式。当显示、引用或讨论代码库中现有的代码时使用。Use when showing code from the codebase, referencing existing files, or discussing specific code locations.
---

# 可点击的代码引用

## 核心规则

当引用代码库中已存在的代码时，**必须**使用可点击跳转格式：

```startLine:endLine:filepath
// 代码内容
```

这种格式允许用户直接点击跳转到文件的具体位置。

## 格式要求

### ✅ 正确格式（可点击跳转）

引用现有代码时：

```12:25:src/components/Button.tsx
export function Button({ label, onClick }: ButtonProps) {
  return (
    <button onClick={onClick}>
      {label}
    </button>
  );
}
```

**必需组成部分**：
1. `startLine` - 起始行号（必需）
2. `endLine` - 结束行号（必需）  
3. `filepath` - 完整文件路径（必需）

### ❌ 错误格式

**不要**使用语言标签（这会破坏跳转功能）：
```typescript:src/components/Button.tsx
// 错误 - 包含了语言标签
```

**不要**省略行号：
```src/components/Button.tsx
// 错误 - 缺少行号
```

### 新代码或建议代码

对于**不在代码库中**的新代码，使用标准 markdown 代码块：

```python
# 这是建议的新代码
def new_function():
    pass
```

## 使用场景

| 场景 | 使用格式 | 示例 |
|------|---------|------|
| 引用现有代码 | ```startLine:endLine:filepath | 显示某个函数的实现 |
| 讨论代码位置 | ```startLine:endLine:filepath | 指出需要修改的地方 |
| 展示错误代码 | ```startLine:endLine:filepath | 说明有问题的代码段 |
| 建议新代码 | ```language | 提供新的实现方案 |
| 示例代码 | ```language | 演示某个概念 |

## 关键注意事项

1. **必须包含至少 1 行代码** - 空代码块会破坏渲染
2. **三个反引号不能缩进** - 即使在列表中也要顶格写
3. **代码块前要有空行** - 确保正确渲染
4. **可以截断长代码** - 使用注释如 `// ... 更多代码 ...`

## 示例对比

### 场景：讨论需要修改的函数

❌ **错误方式**（用户无法跳转）：
```
在 Button.tsx 文件中的 Button 组件需要修改。

```typescript
export function Button({ label }: ButtonProps) {
  return <button>{label}</button>;
}
```
```

✅ **正确方式**（用户可以点击跳转）：
```
需要修改这个 Button 组件：

```45:48:src/components/Button.tsx
export function Button({ label }: ButtonProps) {
  return <button>{label}</button>;
}
```

建议添加 onClick 处理器。
```

## 快速检查清单

引用代码时检查：
- [ ] 代码是否在代码库中？
  - 是 → 使用 ```startLine:endLine:filepath 格式
  - 否 → 使用 ```language 格式
- [ ] 是否包含了起始和结束行号？
- [ ] 是否包含了完整的文件路径？
- [ ] 是否至少包含 1 行代码内容？
- [ ] 三个反引号是否顶格（未缩进）？
- [ ] 代码块前是否有空行？

## 总结

**黄金规则**：引用现有代码 = 使用行号格式 = 用户可以点击跳转
