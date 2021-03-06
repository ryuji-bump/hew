<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String id = (String)session.getAttribute("userId");
	if(id == null){//転送
		RequestDispatcher disp = request.getRequestDispatcher("msg.jsp");
		//メッセージをリクエストに設定
		request.setAttribute("msg", "無効なアクセスです。");
		//フォワード
		disp.forward(request, response);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<script type="text/javascript" src="js/upload.js"></script>
	<link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.3/themes/smoothness/jquery-ui.css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.3/jquery-ui.min.js"></script>
	<link rel="stylesheet" type="text/css" href="./css/common.css" />
</head>
<body>
	<nav class="navbar navbar-inverse">
	  <div class="container">
	    <div class="navbar-header">
	      <a class="navbar-brand" href="index.jsp">Adler</a>
	      <ul class="nav navbar-nav">
	          <li class="active"><a href="index.jsp">ホーム</a></li>
	          <li><a href="ranking.jsp">アプリレビュー</a></li>
	          <li><a href="ranking.jsp">ランキング</a></li>
	          <li><a href="">カテゴリ</a></li>
	          <li><a href="#">新作</a></li>
	      </ul>
	      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
	        <span class="sr-only">navigation</span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	      </button>
	    </div>
	    <div id="navbar" class="navbar-collapse collapse">
	<%
		if(session.getAttribute("userId")!=null){
			id = (String)session.getAttribute("userId");
	%>
			<div class="navbar-right navbar-form">
				<div class="form-group" style="font-size:14px;color:white;">
					こんにちは、<%= id %>さん
				</div>
				<form action="UserServlet" method="post" style="display:inline;">
					<button class="btn btn-primary" name="logout">
						LogOut <span class="glyphicon glyphicon-log-out"></span>
					</button>
				</form>
			</div>
	<%		
		}else{
	%>
	     <form action="UserServlet" method="post" class="navbar-form navbar-right">      
	        <div class="form-group">
	          <input type="text" name="userId" placeholder="UserID" class="form-control">
	        </div>
	        <div class="form-group">
	          <input type="password" name="passwd" placeholder="Password" class="form-control">
	        </div>
	        <button name="login" type="submit" class="btn btn-success">LogIn <span class="glyphicon glyphicon-log-in"></span></button>
		 </form>
	<% 
		out.println(id);
		}
	%>
	    </div><!--/.navbar-collapse -->
	  </div>
	</nav>
	<div class="container">
		<h1>アプリアップロード</h1>
		<p class="margin-10">全ての項目を入力し、アップロードするファイルを選択して下さい。</p>
		<div class="row margin-10">
			<label for="productName" class="col-md-2 col-md-offset-1">商品名：</label><input id="productName" type="text" name="name" class="col-md-3">
		</div>
		<div class="row margin-10">
			<label for="textarea" class="col-md-2 col-md-offset-1">商品説明：</label>
			<textarea id="textarea" class="col-md-3" rows="4" cols="40" placeholder="商品説明をご記入下さい" name="description"></textarea>
		</div>
		<div class="row margin-10">
			<label for="point" class="col-md-2 col-md-offset-1">購入ポイント：</label><input type="text" name="point" id="point" class="col-md-3">
		</div>
		<div class="row margin-10">
			<label for="select" class="col-md-2 col-md-offset-1">カテゴリ：</label>
			<select id="select" name="select" class="col-md-3">
				<option>カテゴリ</option>
				<option>ゲーム</option>
				<option>ツール</option>
				<option>ニュース</option>
				<option>test</option>
				<option>-----</option>
				<option>-----</option>
			</select>
		</div>
		<button id="apk" class="btn">apk</button>
		<button id="icon" class="btn">icon</button>
		<button id="button" class="btn">送信</button>
		<input type="hidden" name="msg" value="送信しました。">
		
		
		<div id="dialog1">
			<div id="drag-area1" style="width:100%;height:80%;border:dashed 1px #333;">
				<p>アップロードするファイルをドロップ</p>
			</div>
			<div id="fileNameArea1"></div>
		</div>
		<div id="dialog2">
			<div id="drag-area2" style="width:100%;height:80%;border:dashed 1px #333;">
				<p>アップロードするファイルをドロップ</p>
			</div>
			<div id="fileNameArea2"></div>
			<div id="imageArea"></div>
		</div>
	</div>
	<script type="text/javascript">
	$(function(){
		
		var files = null;
		// FormDataオブジェクトを用意
		var fd = new FormData();
		var x = 0;
		var y = 0;
		
		$('document').ready(function(){
			$('#button').click(function(e){
				e.preventDefault();
				if(files && checkName() && checkDesc() && checkPoint() && checkCategory()){
					uploadFiles(fd);

				}else{
					alert('入力項目を確認して下さい');
				}
			});
			
			x = $(window).width() * 0.8;
			y = $(window).height() * 0.8;
			$('#dialog1').dialog({
				  autoOpen: false,
				  height: y,
				  width: x,
				  title: 'apk',
				  closeOnEscape: false,
				  modal: true,
				  buttons: {
				    "OK": function(){
				      $(this).dialog('close');
				    }
				  }
				});
			$('#dialog2').dialog({
				  autoOpen: false,
				  height: y,
				  width: x,
				  title: 'icon',
				  closeOnEscape: false,
				  modal: true,
				  buttons: {
				    "OK": function(){
				      $(this).dialog('close');
				    }
				  }
				});
			$('#apk').click(function(){
				$('#dialog1').dialog('open');
			});
			$('#icon').click(function(){
				$('#dialog2').dialog('open');
			});

		});
		
		function checkName(){
			var val = $('input[name="name"]').val();
			if(val != '') return true;
			else return false;
		}
		
		function checkDesc(){
			var val = $('textarea[name="description"]').val();
			if(val != '') return true;
			else return false;
		}
		
		function checkPoint(){
			var val = $('#point').val();
			val = val.replace(/[Ａ-Ｚａ-ｚ０-９]/g,function(s){
				return String.fromCharCode(s.charCodeAt(0)-0xFEE0);
				});
			if(val != '' && val.match(/\d/)) return true;
			else return false;
		}
		
		function checkCategory(){
			var val = $('select[name="select"]').val();
			if(val != '' && val != 'カテゴリ') return true;
			else return false;
		}
		

		$("#drag-area2").on("dragover",function(e){
			e.preventDefault();
			$('#dialog2').css('background-color', '#ccc');
		});
		$("#drag-area2").on("dragleave",function(e){
			e.preventDefault();
			$('#dialog2').css('background-color', '#fff');
		});
		/*================================================
		  ファイルをドロップした時の処理
		=================================================*/
		$('#drag-area1').bind('drop', function(e){

			// デフォルトの挙動を停止
			e.preventDefault();
			// ファイル情報を取得
			files = e.originalEvent.dataTransfer.files;
			for(var i=0; i<files.length; i++){
				//fileNameAreaにファイル情報を表示
				var elm = $('<p>' + files[i].name + " " + files[i].size + "byte" + '</p>');
				$('#fileNameArea1').append(elm);
			}

			// ファイルの個数を取得
			var filesLength = files.length;
			// ファイル情報を追加
			for (var i = 0; i < filesLength; i++) {
				fd.append("files[]", files[i]);
			}
			
			console.log(fd);
		
		}).bind('dragenter', function(){
			// デフォルトの挙動を停止
			return false;
		}).bind('dragover', function(){
			// デフォルトの挙動を停止
			return false;
		});
		
		
		$('#drag-area2').bind('drop', function(e){
			// デフォルトの挙動を停止
			e.preventDefault();
			// ファイル情報を取得
			files = e.originalEvent.dataTransfer.files;
			for(var i=0; i<files.length; i++){
				files[i].name = ('icon_' + files[i].name);
				//fileNameAreaにファイル情報を表示s
				var elm = $('<p>' + files[i].name + " " + files[i].size + "byte" + '</p>');
				$('#fileNameArea2').append(elm);
				console.log(files[i].name);
			}

			// ファイルの個数を取得
			var filesLength = files.length;
			// ファイル情報を追加
			for (var i = 0; i < filesLength; i++) {
				fd.append("files[]", files[i]);
			}
			console.log(fd);
			
			var file = event.dataTransfer.files[0];
			// ファイルタイプ(MIME)で対応しているファイルか判定
			if (!file.type.match(/image\/\w+/)) {
			    alert('画像ファイル以外は利用できません');
			    return;
			}
			
			//ドラッグした画像を表示
			var reader = new FileReader(); 
			reader.onload = function() {
			    var imageObject = $('<img>');
			    imageObject.attr('width', '100px');
			    imageObject.attr('src', reader.result);
			    imageObject.attr('id', 'image');
			    $('#drag-area2').append(imageObject);
			};
			
			reader.onerror = function(e) {
			    var result = $('#result');
			    result.html('');
			    for (var key in reader.error) {
			        result.append(key + '=' + reader.error[key] + '<br>');
			    }
			};
			reader.readAsDataURL(file);
			
			
			
		}).bind('dragenter', function(){
			// デフォルトの挙動を停止
			return false;
		}).bind('dragover', function(){
			// デフォルトの挙動を停止
			return false;
		});
	});
		/*================================================
		  アップロード処理
		=================================================*/
		function uploadFiles(fd) {

			//フォームの値をFormDataオブジェクトに追加
			fd.append('name', $('input[name="name"]').val());
			fd.append('description', $('textarea[name="description"]').val());
			fd.append('point', $('#point').val());
			fd.append('select', $('select[name="select"]').val());
			
			// Ajaxでアップロード処理をするファイルへ内容渡す
			$.ajax({
				url: './UploadFileServlet',
				type: 'POST',
				data: fd,
				processData: false,
				contentType: false,
				success: function(data) {
					console.log('ファイルがアップロードされました。');
					window.location.href = "successUpload.jsp";
				}
			});
		}
	</script>
	<div id="footerMenu" class="text-center col-xs-12">
		<p><a href="index.jsp">HOME</a>／<a href="profile.jsp">会社概要</a>／<a href="tos.jsp">利用規約</a>／<a href="plicy.jsp">プライバシーポリシー</a>／<a href="qanda.jsp">よくある質問</a>／<a href="info.jsp">問い合わせ</a></p>
		<p>Copyright&copy; team-ogawa All Rights Reserved.</p>
	</div>
</body>
</html>