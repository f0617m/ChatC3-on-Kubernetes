# ChatC3
ChatC3は、見知らぬ相手と1:1でチャットできるランダムチャットサービスです。

チャット相手と一緒にお絵かきすることもできます。


※ゲストログイン機能有(画面右上の[ログイン]→[ゲストログイン])

【URL】https://chatc3.com

![chatc3_sample](https://user-images.githubusercontent.com/10390016/88374055-017dbd80-cdd4-11ea-9d80-5ce135a8b659.png)

# チャットの始め方
ログインした状態でトップページの「チャット相手を探す」ボタンを押下すると、チャット相手とのマッチングが開始されます。

マッチングが完了したら、相手の方とチャット＋一緒にお絵かきが楽しめます。

# 機能一覧
## ユーザー
- アカウント登録機能
- ログイン/ログアウト機能
- 簡易ログイン(ゲストログイン)機能
- プロフィール設定機能
  - プロフィール画像/ユーザ名/パスワード変更

## チャット画面
- チャット機能
- お絵かき機能

# 使用言語/フレームワーク一覧
- フロントエンド
  - HTML/CSS/JavaScript
  - Vue.js(+Vuetify)
- バックエンド
  - ruby 2.6.3
  - Ruby on Rails 5.2.3

# 使用技術一覧
- Kubernetes 1.18.5
- Docker 19.03
- Nginx
- MySQL
- CircleCI
- git/github
- rubocop/Rspec

# 構築環境　アーキテクチャ
![chatc3](https://user-images.githubusercontent.com/10390016/88372922-d2664c80-cdd1-11ea-87e9-872bb8a0039e.png)


# アピールポイント
- Kubernetesによるコンテナオーケストレーション環境の構築
- CircleCI+rubocop+RspecによるCIの実装
- ActionCableによるチャット＋お絵かき機能の実装
