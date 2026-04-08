# To Do App (Flutter)

## 1. 프로젝트 개요
본 과제는 Flutter를 이용하여 To Do 앱을 구현한 것이다.  
기본 기능으로 할 일 리스트 조회, 할 일 추가, 할 일 삭제 기능을 구현하였다.  
추가적으로 Riverpod을 사용하여 상태 관리를 분리하였으며, Flutter DevTools를 활용하여 위젯 구조, 성능, 메모리 사용을 분석하였다.

---

## 2. 실행 환경
- Flutter SDK
- Dart SDK
- macOS 환경에서 실행 확인
- 실행 대상: Chrome, iOS Simulator

---

## 3. 빌드 및 실행 방법

프로젝트 폴더에서 아래 명령어를 실행한다.

```bash
flutter pub get
flutter run
```
의존성 설치 후 앱이 실행된다.

---


## 4. 구현 기능

본 앱은 다음 3가지 기능을 구현하였다.

- 리스트 기능: 등록된 할 일 목록을 화면에 출력  
- 추가 기능: 입력창에 텍스트 입력 후 할 일 추가  
- 삭제 기능: 삭제 버튼을 눌러 해당 할 일 제거  

---

## 5. 구조 설명

### 5-1. 전체 구조
앱은 모델, 상태 관리, UI로 구성하였다.

- `models/todo.dart`  
  → Todo 데이터 모델 정의  
- `providers/todo_provider.dart`  
  → Riverpod을 이용한 상태 관리  
- `main.dart`  
  → UI 및 앱 실행 구조  

---

### 5-2. 상태 자료구조
할 일 목록은 `List<Todo>` 형태로 관리하였다.  
각 Todo는 `id`, `title`, `isDone` 값을 가지며, `id`는 현재 시간을 기반으로 생성하였다.

(isDone 필드는 향후 완료/미완료 기능 확장을 고려하여 포함하였다.)

---

### 5-3. Riverpod 상태 관리

`TodoNotifier`를 통해 할 일 목록 상태를 관리하였다.

- `addTodo()` → 할 일 추가  
- `removeTodo()` → 할 일 삭제  

UI에서는 다음과 같이 상태를 사용하였다.

- `ref.watch` → 상태 구독  
- `ref.read` → 상태 변경  

이를 통해 UI와 상태 관리 로직을 분리하였다.

---

### 5-4. 사용한 주요 위젯

- `MaterialApp`, `Scaffold`, `SafeArea`  
- `ListView` (스크롤 처리)  
- `TextField` (입력)  
- `FilledButton` (추가 버튼)  
- `Card` (UI 구성)  
- `Column`, `Row`, `Container`  

---

## 6. UI 설명

상단에는 오늘의 상태를 보여주는 영역을 배치하였다.  
중간에는 할 일 입력 영역을 구성하였으며, 하단에는 할 일 목록을 카드 형태로 출력하였다.  
`ListView`를 사용하여 항목이 많아질 경우 스크롤이 가능하도록 구현하였다.

<img width="310" height="647" alt="Image" src="https://github.com/user-attachments/assets/2cd96549-fbe7-4868-b314-062e99e74a4e" />

---

## 7. Bonus point 설명

### 7-1. Riverpod 사용
기본 기능을 구현하면서 상태 관리 방식을 Riverpod으로 구성하였다.  
기능 추가가 아닌 구조 개선을 통해 상태를 중앙에서 관리하도록 하였다.  
이를 통해 UI와 상태 변경 로직을 분리하고, 유지보수성과 확장성을 향상시킬 수 있었다.

---

### 7-2. DevTools 사용

Flutter DevTools를 활용하여 앱의 구조와 성능을 분석하였다.

- **Inspector**  
  위젯 트리를 통해 앱의 전체 구조를 확인하였다.

- **Performance**  
  할 일 추가 및 삭제 시 프레임 변화와 렌더링 흐름을 확인하였다.  
  간단한 구조이므로 성능 저하는 크게 발생하지 않았다.

- **Memory**  
  앱 실행 동안 메모리 사용량이 안정적으로 유지되는 것을 확인하였다.

---

## 8. 스크린샷

### 8-1. 기능 화면

#### 리스트 화면
<img width="297" height="643" alt="Image" src="https://github.com/user-attachments/assets/030fd632-4647-42c7-bd1a-c6389ecda4ac" />

#### 추가 기능 화면
<img width="303" height="657" alt="Image" src="https://github.com/user-attachments/assets/c98dab4a-7fec-489b-ad5e-9e80c4fb4b85" />
<img width="304" height="646" alt="Image" src="https://github.com/user-attachments/assets/6a9aac79-6137-4c5a-9fbc-9f2efe60d9b2" />

#### 삭제 기능 화면
<img width="304" height="646" alt="Image" src="https://github.com/user-attachments/assets/6a9aac79-6137-4c5a-9fbc-9f2efe60d9b2" />
<img width="311" height="643" alt="Image" src="https://github.com/user-attachments/assets/4c5e2700-173a-4182-8e59-16f3655dc701" />

---

### 8-2. DevTools 화면

#### Inspector
<img width="1509" height="880" alt="Image" src="https://github.com/user-attachments/assets/e1c9dc36-4190-4869-8bcc-cd322223d7a6" />

#### Performance / Timeline
<img width="1512" height="840" alt="Image" src="https://github.com/user-attachments/assets/5ba5ea68-df86-4fed-ba74-a7c5f7c56a0e" />

#### Memory
<img width="1510" height="909" alt="Image" src="https://github.com/user-attachments/assets/8d04e377-973e-4a27-82a6-5cbb115f8b2b" />


---

## 9. 제출 파일 구성

- `lib/`
- `pubspec.yaml`
- `README.pdf`

불필요한 dependency 및 빌드 산출물은 제외하였다.