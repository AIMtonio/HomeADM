var esTab=false;
var parametroBean = consultaParametrosSession();
$(document).ready(function() {

	inicializarPantalla();

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#formaGenerica').validate({
		rules: {
			sucursal:{
				required: true
				},
			tipoLista:{
				required: true
				}
		},
		messages: {
			sucursal:{
				required: 'Especificar la Sucursal.',
			},
			tipoLista:{
				required: 'Especificar el Tipo de Lista.',
			}
		}
	});

	$('#sucursal').bind('keyup',function(e) {
		lista('sucursal', '2', '1','nombreSucurs', $('#sucursal').val(), 'listaSucursales.htm');
	});
	$('#sucursal').blur(function() {
		if(esTab){
			consultaSucursal(this.id);
		}
	});
	$('#generar').click(function() {
		generaReporte();
	});
});

function inicializarPantalla(){
	$("#sucursal").focus();
	$("#sucursal").val("0");
	$("#nombreSucursal").val("TODAS");
	$("#tipoLista").val("3");
}

function consultaSucursal(idControl){
	var jqSucursal = eval("'#" + idControl + "'");
	var numSucursal = $(jqSucursal).asNumber();
	var conSucursal=2;
	setTimeout("$('#cajaLista').hide();", 200);
	if(numSucursal > 0 && esTab==true){
		sucursalesServicio.consultaSucursal(conSucursal,numSucursal.toString(),function(sucursal) {
			if(sucursal!=null){
				$('#nombreSucursal').val(sucursal.nombreSucurs);
			}else{
				alert("No Existe la Sucursal.");
				$(jqSucursal).focus();
				$(jqSucursal).val("0");
				$('#nombreSucursal').val("TODOS");
			}
		});
	}else{
		$(jqSucursal).val("0");
		$('#nombreSucursal').val("TODOS");
	}
}

function generaReporte(){
	if ($("#formaGenerica").valid()) {
		var sucursal = $("#sucursal").val();
		var tipoLista = $("#tipoLista").val();
		var usuario 	 = (parametroBean.claveUsuario).toUpperCase();
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var tipoReporte = $('input:radio[name=tipoReporte]:checked').val();
		var sucursalDes = $("#nombreSucursal").val();

		var liga = 'reportePersInvListas.htm?'+
		'sucursal='+sucursal+
		'&tipoLista='+tipoLista+
		'&usuario='+usuario+
		'&fechaSistema='+fechaAplicacion+
		'&nombreInstitucion='+nombreInstitucion+
		'&tipoReporte='+tipoReporte+
		'&sucursalDes='+sucursalDes;
		window.open(liga, '_blank');
	}
}