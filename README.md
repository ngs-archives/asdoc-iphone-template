# ASDoc Templates for iPhone
##iPhoneに最適化されたASDocのテンプレート

 [デモ](http://www.libspark.org/htdocs/asdoc/iphone/Utils/index.html) / ライセンス:[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)

##使い方
asdoc、およびaadocのtemplates-pathにチェックアウトしたディレクトリを指定します。
（flex_sdkのbinにパスを通しておいてください。）

    svn co http://www.libspark.org/svn/asdoc/templates/iphone/trunk iphone-templates
    asdoc -doc-sources path/to/src \
      -templates-path iphone-templates \
      -output asdoc-iphone

### 作り途中です。
まだ、AS2やFlashLite、MXMLなどのソースコードではテストしていません。問題があったら、是非修正してください。

また、その際に使った、asdocが出力するXMLをコミットしていただけると助かります。

### ASDocの出力するXMLの取り方
ASDocの内部では、XMLが出力され、それをテンプレート内のXSLTで変換してHTMLを出力しています。

XMLは、例えば、[こんな感じのものです](http://www.libspark.org/browser/asdoc/templates/iphone/trunk/test/class.xml?rev=2144)。

### 1. 既に存在するASDocのテンプレートの適当なものをコピーします。
（flex_sdkの中にある、asdoc/templatesディレクトリに入っているソースとか）

### 2. namespaceにredirectが指定されていないxslファイルを編集します。

例: appendixes.xsl

### 3. 内容を以下に編集します。

    <?xml version="1.0"?>
    <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:template match="/">
        <xsl:copy-of select="." />
      </xsl:template>
    </xsl:stylesheet>

### 4. asdocを実行します
    
    $ asdoc -doc-sources path/to/src \
       -templates-path templates-edited \
       -output asdoc-output
     }}}

### 5. appendixes.xsl の場合、appendixes.htmlが出力されていると思います。

そのファイルの内容がASDoc内部のXMLとなります。


##開発環境
[Apache Cocoon](http://cocoon.apache.org/)を使っています。

cocoon環境構築方法は[こちら](http://labs.ngsdev.org/wiki/cocoon/MacOSX)に記載してます。（MacOSXのみ、ごめんなさい、Windowsはまだないです。）

以下は構築例です。
### 1. ビルドしたcocoonのディレクトリの中にある、build/webappの中に、devというディレクトリを作ります。
### 2. その中に、sitemap.xmapというファイルを作ります。

__sitemap.xmap__


    <?xml version="1.0" encoding="UTF-8"?>
    <map:sitemap xmlns:map="http://apache.org/cocoon/sitemap/1.0">
     <map:pipelines>
      <map:pipeline>
       <map:match pattern="asdoc/**">
        <map:mount src="file:///path/to/templates-iphone/test/sitemap.xmap" uri-prefix="asdoc"/>
       </map:match>
      </map:pipeline>
     </map:pipelines>
    </map:sitemap>

### 3. cocoonの再起動は不要です。

http://localhost:8888/dev/asdoc/all-classes.html にアクセスして、ページが表示されると成功です。

namespaceにredirectを指定しているXSLTは、複数のHTMLを出力するものです。[[BR]]
それをcocoon上でテストするには、[class.xsl](http://www.libspark.org/browser/asdoc/templates/iphone/trunk/class.xsl?rev=2144)の様に、単体で動くように加工が必要です。