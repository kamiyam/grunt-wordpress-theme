grunt-wordpress-theme
=====================

This files is Grunt's setting For WordPress Theme


# Precondition

- php version 5.4 or later
- grunt 0.4.2 or later

# Installation

WordPress ``wp-content`` フォルダへ移動します

```cd path/to/wordpress-root```

```cd wp-content```

Grunt のファイル一式をダウンロード

```git clone git@github.com:kamiyam/grunt-wordpress-theme.git grunt```


## Scaffold

ダウンロードしたファイル一式は次の構成となります。

```
WordPress-root
├── wp-admin
├── wp-content
│   ├── grunt
│   │   ├── Gruntfile.coffee
│   │   ├── README.md
│   │   ├── .tmp (自動出力)
│   │   ├── app
│   │   │   ├── linker
│   │   │   │   ├── css
│   │   │   │   │   ├── less.less
│   │   │   │   │   ├── sass.sass
│   │   │   │   │   ├── scss.scss
│   │   │   │   │   └── stylus.styl
│   │   │   │   ├── images
│   │   │   │   └── js
│   │   │   │       ├── coffeescript.coffee
│   │   │   │       └── typescript.ts
│   │   │   └── style.css.default
│   │   ├── node_modules
│   │   ├── package.json
│   │   └── theme.json
│   ├── index.php
│   ├── languages
│   │   ├── ......
│   │   └── ......
│   ├── plugins
│   ├── themes
│   │   ├── index.php
│   │   ├── grunt-twentyfourteen[theme.json badge.text_domainプロパティ値]フォルダ (自動出力)
│   │   └── ......
│   │  
│   └── upgrade
├── wp-includes
├── (wp-** フォルダ)
└── (wordpress ファイル)
```

### Gruntfile.coffee

grunt 設定ファイル

### grunt/app

テーマファイル一式の編集を行うディレクトリ

``grunt`` コマンドにより

- ``grunt/.tmp``フォルダへコンパイル出力
- ``wp-content/themes`` フォルダ以下へ シンボリックリンクを貼る or ファイル一式をコピー


### grunt/app/linker

#### grunt/app/linker/js

``CoffeeScript`` ``TypeScript`` の自動コンパイルを行うフォルダ群

#### grunt/app/linker/css

``Sass``  ``LESS``  ``stylus`` の自動コンパイルを行うフォルダ群

### package.json

``grunt`` の実行に必要なmoduleを定義した設定ファイル

``npm install`` を実行することでダウンロードします

### theme.json

テーマに関する設定を行うファイル

#### badge プロパティ

``style.css`` の badge 部分の出力をここで設定します。

プロパティの設定を変更することで、最終的に出力されるテーマ名･フォルダ名を変更することが出来ます。

#### assets_dir プロパティ

``CoffeeScript`` ``TypeScript`` ``Sass``  ``LESS``  ``stylus`` の変更を監視し自動コンパイルを行う監視フォルダを設定します。

デフォルトで、Twenty Fourteen の利用を想定していますが、それぞれのテーマのフォルダ構成に合わせて変更することも可能です。

また、 ``linker`` フォルダ以下の各ディレクトリも同じ構成を想定しているので、theme.json の設定を変更する場合は、``linker`` 以下の各フォルダ名を変更する必要があります。
(※ ``linker`` フォルダ以下のコンパイルを動作させる場合)

#### url プロパティ

WordPress サイトのURLを指定します。

``grunt`` ``grunt serv`` 実行時に設定されたURLでブラウザが自動的に起動します。


## How to use

### grunt 等のmoduleをダウンロード

```
cd grunt && npm install
```

### テーマファイルの設定

``wp-content/themes`` の任意のテーマファイルを ``grunt/app`` 以下へ移動します。

#### Twenty Fourteen を使用する場合

``wp-content/themes/twentyfourteen/**`` -> ``grunt/app`/**`

次に ``grunt/app/style.css`` 先頭個所のテーマ設定を ``grunt/app/style.css.default`` を参考に編集します。

#### Twenty Fourteen 設定例

```
// 変更前

/*
Theme Name: Twenty Fourteen
Theme URI: http://wordpress.org/themes/twentyfourteen
Author: the WordPress team
Author URI: http://wordpress.org/
Description: In 2014, our default theme lets you create a responsive magazine website with a sleek, modern design. Feature your favorite homepage content in either a grid or a slider. Use the three widget areas to customize your website, and change your content's layout with a full-width page template and a contributor page to show off your authors. Creating a magazine website with WordPress has never been easier.
Version: 1.1
License: GNU General Public License v2 or later
License URI: http://www.gnu.org/licenses/gpl-2.0.html
Tags: black, green, white, light, dark, two-columns, three-columns, left-sidebar, right-sidebar, fixed-layout, responsive-layout, custom-background, custom-header, custom-menu, editor-style, featured-images, flexible-header, full-width-template, microformats, post-formats, rtl-language-support, sticky-post, theme-options, translation-ready, accessibility-ready
Text Domain: twentyfourteen

This theme, like WordPress, is licensed under the GPL.
Use it to make something cool, have fun, and share what you've learned with others.
*/
```

```
//変更後
/*
Theme Name: @@theme_name
Theme URI: @@theme_url
Author: @@author
Author URI: @@author_uri
Description: @@description
Version: @@version
License: @@license
License URI: @@license_uri
Tags: @@tags
Text Domain: @@text_domain

This theme, like WordPress, is licensed under the GPL.
Use it to make something cool, have fun, and share what you've learned with others.

Created at: @@timestamp
*/
```


## Grunt コマンド

`` grunt ``

MAMP等 すでにサーバ とデータベース が起動している場合に使用します。
コンパイル機能と LiveReload を実行する(要プラグイン)設定です。


``grunt serv``

デフォルトの コンパイル機能 LiveReloadと合わせて php の ビルトインサーバを使用して WordPress を起動します。
mysql は各自で起動するよう設定してください。

``grunt build``

各ファイルをコンパイルし、``themes`` フォルダ以下にファイル一式を作成します。


### ``themes`` フォルダ へのファイル出力について

``themes`` フォルダ以下に theme.json で設定している text_domain と同じ名称のフォルダが存在する場合は ``themes`` 以下のフォルダを削除する必要があります。

強制的にファイルを出力(元のテーマファイルは削除されます)する場合は、 ``grunt clean:theme`` タスクの ``force`` プロパティを ``true`` に変更します。
(clean.theme.options.force プロパティのコメントアウトを外します)

※ themeフォルダ以下指定テーマフォルダは強制的に削除されるので注意が必要

ー Gruntfile.coffee

```
    clean:
      grunt:
        src: ".Gruntfile.js"
      theme:
        src: [config.wp.themeDir]
        options:
          force: true
      dev:
        cwd: config.devDir
        src: ["**"]
        options:
          force: true
```
