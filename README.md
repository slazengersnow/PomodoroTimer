# Pomodoro Timer

macOS向けのデスクトップウィジェット風ポモドーロタイマーアプリです。

A desktop widget-style Pomodoro timer app for macOS.

![macOS](https://img.shields.io/badge/macOS-14.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5-orange)

## 特徴 / Features

- **ウィジェット風UI / Widget-style UI** - フロストガラス(半透明)デザインのコンパクトなウィンドウ / Compact frosted glass (translucent) window
- **他のウィンドウの後ろに配置 / Stays behind other windows** - 作業の邪魔にならず、デスクトップを表示すると確認できる / Never interrupts your work; visible when you show the desktop
- **ドラッグで自由に配置 / Drag to reposition** - 好きな位置に移動可能（タイマー実行中も可）/ Move anywhere, even while the timer is running
- **3つのモード / 3 modes** - 集中 / 小休憩 / 長休憩 / Focus / Short Break / Long Break
- **2つのプリセット / 2 presets** - スタンダード(25分) / ディープフォーカス(50分) / Standard (25 min) / Deep Focus (50 min)
- **時間のカスタマイズ / Customizable duration** - +/- ボタンで1分単位の調整が可能 / Adjust in 1-minute increments with +/- buttons
- **メニューバー表示 / Menu bar integration** - タイマー実行中は残り時間をメニューバーに表示 / Shows remaining time in the menu bar while running
- **統計機能 / Statistics** - 今日のセッション数、集中時間、連続日数、週間チャート / Daily sessions, focus time, streaks, weekly chart
- **完了通知 / Completion sound** - セッション完了時にサウンドで通知 / Plays a sound when a session ends
- **フローティングオーバーレイ / Floating overlay** - ウィンドウを閉じてもタイマー実行中は小窓で残り時間を表示 / Shows a small overlay with remaining time even after closing the main window

## 必要環境 / Requirements

- macOS 14.0 (Sonoma) or later

## ビルド・実行 / Build & Run

```bash
swift build
.build/debug/PomodoroTimer
```

## 使い方 / Usage

1. アプリを起動するとデスクトップ右下にウィジェットが表示されます / Launch the app and a widget appears at the bottom-right of your desktop
2. ▶ ボタンでタイマー開始、⏸ で一時停止 / Press ▶ to start, ⏸ to pause
3. 停止中に +/- ボタンで時間を調整 / Adjust duration with +/- buttons while stopped
4. 下部のタブで集中 / 小休憩 / 長休憩を切り替え / Switch modes with the bottom tab bar
5. ページドットで統計ページに切り替え / Tap the page dots to view statistics
6. メニューバーのタイマーアイコンでウィンドウの表示/非表示を切り替え / Toggle visibility from the menu bar icon

## ライセンス / License

MIT
