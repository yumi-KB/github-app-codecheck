# 株式会社ゆめみ iOS エンジニアコードチェック課題
2021/01/01  修正

2020/12/25  課題提出

## 動作環境

Xcode Version 12.3

iOS Deployment Target iOS 13.4

Swift language version uspecified

使用ライブラリ: MBProgressHUD [https://github.com/jdg/MBProgressHUD]

## #10 テストの追加
簡単なXCUnitTestとXCUITestを追加しました。

## #9 新機能の追加/ #8 UIのブラッシュアップ
1. 検索結果を最下部までスクロールすると、追加のAPI通信を行い、続きの結果を表示する機能を追加しました。
2. API通信を行っている間、indicatorを表示する機能を追加しました。  検索時、追加のデータを読み込む時、詳細画面で画像URLを読み込む時に表示されます。
3. searchBarをsearchControllerに変更しました。 searchControllerの機能を使用して、スクロール時はsearchBarが隠れるようにしました。 参考サイト: [https://dev.classmethod.jp/articles/ios-11-uinavigationitem-searchcontroller/]
4. リポジトリの詳細表示画面にscrollViewを導入しました。  iPadで横に倒した状態ではページ全体を確認することができませんでしたので、通常のViewをscrollViewに置き換えることで改善させました。

## #7 アーキテクチャを適用： MVC / #5 FatVCの回避
主にAPI通信のコードをモデルとしてVCから切り離しました。

## #6 リファクタリング
命名規則として、値を格納する関数には先頭にsetを、値を取得して返す関数には先頭にgetをつけました。

## #3 ソースコードの安全性の向上
オプショナルバインディングの使用や初期値を設定し極力nilを入れないようにし、強制アンラップを多用しないコードに変更しました。


## 他
API通信に関して普段は見やすくなるからといった理由でAlamofireなどを使って書くことが多かったのですが、このアプリはすでにURLSessionで書かれていましたので、ライブラリを導入するような大きな変更はせずに調べながら改修を行いました。

