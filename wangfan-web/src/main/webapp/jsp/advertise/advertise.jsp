<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@	include file="/jsp/inc/inc-jstl.jsp"%>

<!DOCTYPE html >
<html lang="zh-cmn-Hans">
<head>
<meta charset="UTF-8">
<title>广告管理</title>
<%@	include file="/jsp/inc/inc-meta.jsp"%>
<%@	include file="/jsp/inc/inc-manager-css.jsp"%>

</head>
<body>
	<div class="container-flush">
		<div class="row">
			<div class="col-md-12">
				<div id="toolbar">
					<button id="addBtn" type="button" class="btn btn-success">添加</button>
					<button id="editBtn" type="button" class="btn btn-info">修改</button>
					<button id="deleteBtn" type="button" class="btn btn-danger">删除</button>
				</div>
				<table id="table"></table>
			</div>
		</div>
	</div>



	<%@	include file="/jsp/inc/inc-manager-js.jsp"%>

	<script type="text/javascript">
		var table = $('#table').bootstrapTable({
			url : ctx + "/advertise/table",
			searchPlaceholder : "广告",
			search : true,
			toolbar : '#toolbar',
			columns : [ {
				checkbox : true
			}, {
				title : '广告标题',
				field : 'title',
				align : 'left',
				valign : 'middle',
				sortable:true
			}, {
				title : '广告类型',
				field : 'adLocation',
				align : 'left',
				valign : 'middle',
				sortable:true,
				formatter:function(data,row,c){
                	if (data == 'LOGIN') {
                      	return "登录广告";
					}else{
						return "退出广告";
					}
                 }
			}, {
				title : '广告图片',
				field : 'picUrl',
				align : 'left',
				valign : 'middle',
				sortable:true,
				formatter:function(data,row,c){
                	return '<a href="' + data + '" target="_blank">点击查看</a>'
                }
			}, {
				title : '显示秒数',
				field : 'second',
				align : 'left',
				valign : 'middle',
				sortable:true
			}, {
				title : 'h5的链接地址',
				field : 'h5url',
				align : 'left',
				valign : 'middle',
				sortable:true
			} , {
				title : '广告描述',
				field : 'descript',
				align : 'left',
				valign : 'middle',
				sortable:true
			}]
		});

		$('#deleteBtn').click(function() {
			var st = $('#table').bootstrapTable('getSelections');
			if(st <= 0){
				$.smkAlert({
					text : '请选中一条数据再操作',
					position : 'top-right',
					type : 'warning'
				});
				return ;
			}
			var seleted = st[0];
			parent.$.smkConfirm({
				text : '是否删除?',
				accept : '是',
				cancel : '否'
			}, function(res) {
				if (res) {
					$.post(ctx + '/advertise/delete', {id:st[0].id}, function(data){
						if(data.success){
							table.bootstrapTable('refresh');
							$.smkAlert({
								text : '删除成功',
								position : 'top-right',
								type : 'success'
							});
						} else {
							$.smkAlert({
								text : '删除失败:' + data.message,
								position : 'top-right',
								type : 'danger'
							});
						}
					}, 'json');
				}
			});

		});
		$('#addBtn').click(function() {
			window.top.layer.open({
				type : 2,
				title : '广告添加',
				maxmin : true,
				shadeClose : false, //点击遮罩关闭层
				area : [ '800px', '600px' ],
				content : ctx + '/advertise/addPage',
				btnAlign : 'c',
				btn : [ '确定', "关闭" ],
				yes : function(index, layero) {
					if(!layero.find('#layui-layer-iframe' + index).contents()[0].defaultView.$('#myForm').valid()){
						return ;
					}
					$.post(ctx + '/advertise/add', layero.find('#layui-layer-iframe' + index).contents().find('#myForm').serialize(), function(data) {
						if (data.success) {
							window.top.layer.closeAll();
							table.bootstrapTable('refresh');
						} else {
							$.smkAlert({
								text : '添加失败:' + data.message,
								position : 'top-right',
								type : 'danger'
							});
						}
					}, 'json');
					return false;
				},
				btn2 : function(index, layero) {
					window.top.layer.closeAll();
					return false;
				},
				cancel : function() {

				}
			});
		});
		$('#editBtn').click(function() {
			var st = $('#table').bootstrapTable('getSelections');
			if(st <= 0){
				$.smkAlert({
					text : '请选中一条数据再操作',
					position : 'top-right',
					type : 'warning'
				});
				return ;
			}
			var seleted = st[0];
			window.top.layer.open({
				type : 2,
				title : '广告修改',
				maxmin : true,
				shadeClose : false, //点击遮罩关闭层
				area : [ '800px', '600px' ],
				content : ctx + '/advertise/editPage',
				btnAlign : 'c',
				btn : [ '确定', "关闭" ],
				yes : function(index, layero) {
					if(!layero.find('#layui-layer-iframe' + index).contents()[0].defaultView.$('#myForm').valid()){
						return ;
					}
					$.post(ctx + '/advertise/edit', layero.find('#layui-layer-iframe' + index).contents().find('#myForm').serialize(), function(data) {
						if (data.success) {
							window.top.layer.closeAll();
							table.bootstrapTable('refresh');
						} else {
							$.smkAlert({
								text : '修改失败:' + data.message,
								position : 'top-right',
								type : 'danger'
							});
						}
					}, 'json');
					return false;
				},
				btn2 : function(index, layero) {
					window.top.layer.closeAll();
					return false;
				},
				cancel : function() {

				},
				success : function(layero, index) {
					mk.load(layero.find('#layui-layer-iframe' + index).contents().find('#myForm'), ctx + '/advertise/get?id=' + st[0].id, function(data){
						layero.find('#layui-layer-iframe' + index).contents()[0].defaultView.kk.addFile(data.picUrl);
						//console.info(layero.find('#layui-layer-iframe' + index).contents()[0].defaultView.kk.addFile(data.picUrl))
					});
				}
			});
		});
	</script>

</body>
</html>