<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<style type="text/css">

			html {
				/*-webkit-font-smoothing: antialiased;*/
				font-family: Helvetica Neue;
			}

			.ui-iconView {
				overflow: auto;
				padding: 10px;
			}


			.ui-iconView-items {
				margin-top: -10px;
				margin-left: -14px;
			}

			.ui-iconView-item {
				text-decoration: none;
				color: inherit;
				float: left;
				/*width: 20%;*/
				width: 16.66%;
				/*width: 14.28%;*/
				/*width: 12.5%;*/
				/*width: 11.11%;*/
				/*width: 10%;*/

				font-size: 0.8em;
				box-sizing: border-box;
				text-align: center;
				white-space: normal;
				word-wrap: break-word;
				position: relative;
				border-top: 10px solid transparent;
				border-left: 14px solid transparent;
			}


			.ui-iconView-item:after {
				display: block;
				white-space: pre;
				content: '0\00000A0';
				color: transparent;
				padding-top: 4px;
				padding-bottom: 3px;
				padding-left: 6px;
				padding-right: 6px;
			}

			.ui-iconView-item img {
				width: 56%;
				-webkit-user-drag: none;
			}

			.ui-iconView-item div {
				left: 0px;
				right: 0px;
				overflow: hidden;
				position: absolute;
				border-radius: 0px;
				display: -webkit-box;
				-webkit-line-clamp: 2;
				-webkit-box-orient: vertical;
				padding-top: 4px;
				padding-bottom: 3px;
				padding-left: 6px;
				padding-right: 6px;
			}

		</style>
	</head>
	<body>

		<div style="position: absolute; border: 1px solid red; top: 100px; bottom: 100px; right: 100px; left: 100px; overflow: auto;">
			<div class="ui-iconView">
				<div class="ui-iconView-items">
					{{for item in getFiles(this.path)}}
						<a href="?path={{item.path}}" class="ui-iconView-item">
							<img src="{{item.icon}}" />
							<div>{{item.name}}</div>
						</a>
					{{/for}}
				</div>
			</div>
		</div>

	</body>
</html>