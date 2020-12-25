# 株式会社ゆめみ iOS エンジニアコードチェック課題
## 動作環境

Xcode Version 12.3

iOS Deployment Target iOS 13.4

Swift language version uspecified

使用ライブラリ: MBProgressHUD

## テスト
テストはあまり書いたことがなかったのですが、簡単にXCUnitTestとUITestを書いてみました。

とりあえずテストを触ってみようというのを目標に書いたので、テストとしての機能は不十分だとは思います。
特にUITestで自動で文字が入力されてアプリが自動で動いていくさまは衝撃的でした。見てて面白いです。

## 新機能
検索結果の最下部までスクロールすると、続きの検索結果を表示する機能を追加しました。

量が多いとスクロールがしんどいので、本当は横にページングする方が良さそうとは思いました(思っただけ)

## UI
searchBarをsearchControllerに変更しました。かなり便利ですね。

リポジトリの詳細表示画面にscrollViewを導入しました。

## アーキテクチャ: MVC
主にAPI通信のコードをモデルとしてVCから切り離しました。

クラスをとりあえず作ったのですが、非同期通信やクロージャの扱いが難しく理解できていないところも多いです。

・weakで循環参照を防ぐ、メモリリークを防ぐこと

・HUD(特に閉じる時)やエラーアラートの表示のタイミング

この辺もあまり理解できていません。


## 他
API通信に関して普段は見やすくなるからといった理由でAlamofireなどを使って書くことが多かったのですが、このアプリはすでにURLSessionで書かれていましたので、ライブラリを導入するような大きな変更はせずに調べながら改修を行いました。

