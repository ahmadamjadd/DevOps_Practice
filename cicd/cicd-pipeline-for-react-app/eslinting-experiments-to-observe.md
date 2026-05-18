# ESLint Lab: Learn by Breaking Code

## Objective

Understand how ESLint helps detect bugs, enforce best practices, and improve code quality by experimenting with real code.

## Setup

Run lint using:

```bash
npm run lint
```

For better output:

```bash
npm run lint -- --format stylish
```

## Experiment 1: Unused Variables

### Task

```js
const x = 10;
```

### Observe

* What warning/error do you see?

## Experiment 2: Equality Check

### Task

```js
if (5 == "5") {
  console.log("Equal");
}
```

### Observe

* What does lint say?

### Learn

* Difference between `==` and `===`
* Hidden bugs due to type coercion

## Experiment 3: Undefined Variables

### Task

```js
console.log(myVar);
```

### Observe

* What error appears?

### Learn

* Why undefined variables are dangerous

## Experiment 4: Unreachable Code

### Task

```js
function test() {
  return;
  console.log("Hello");
}
```

### Observe

* Which line is flagged?

### Learn

* Logical errors in code flow

## Conclusion

You’ve learned how linting:

* Detects bugs early
* Enforces best practices
* Improves code quality
