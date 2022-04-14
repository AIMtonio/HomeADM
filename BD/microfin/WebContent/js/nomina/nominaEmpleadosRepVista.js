var institucionNominaID;
var convenioNominaID;
var nombreInstit;
var desConvenio;


$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	consultaSucursal();
	inicializaCamposNom();
	$('#institucionNominaID').focus();
	$('#pdf').attr("checked",true) ;
	$(':text').focus(function() {
		esTab = false;
	});



	$('#generar').click(function() {
		if($('#pdf').is(":checked") ){
			generaPDF();
		}
		if($('#excel').is(":checked") ){
			generaExcel();
		}
	});

	$('#formaGenerica').validate({
		rules: {
		},
		messages: {
		}
	});


	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'TODAS'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	function generaExcel() {
		$('#pdf').attr("checked",false) ;
		if($('#excel').is(':checked')){
			var tr= 2;
			var tl= 1;
			var fechaEmision = parametroBean.fechaSucursal;
			var sucursal = $("#sucursalID").val();
			var usuario = 	parametroBean.claveUsuario;
			institucionNominaID = $("#institucionNominaID").val();
			convenioNominaID = $("#convenioNominaID").val();
			var clienteID = $('#clienteID').val();
			/// VALORES TEXTO
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombreSucursal = $("#sucursalID option:selected").html();
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			nombreInstit = $("#nombreInstit").val();
			desConvenio = $("#desConvenio").val();
			var NombreCompleto = $('#nombreCliente').val();


			$('#ligaGenerar').attr('href','reporteNomEmpleados.htm?&fechaEmision='+fechaEmision+
					'&sucursalID='+sucursal+
					'&claveUsuario='+usuario+
					'&nombreUsuario='+nombreUsuario+
					'&tipoReporte='+tr+
					'&nombreSucursal='+nombreSucursal+
					'&nombreInstitucion='+nombreInstitucion+
					'&tipoLista='+tl+
					'&institNominaID='+institucionNominaID+
					'&convenioNominaID='+convenioNominaID+
					'&nombreInstNomina='+nombreInstit+
					'&descripcionConvenio='+desConvenio+
					'&clienteID='+clienteID+
					'&nombreCompleto='+NombreCompleto
			);

		}
	}

	function generaPDF() {
		if($('#pdf').is(':checked')){
			$('#excel').attr("checked",false);

			var tr= 1;
			var fechaEmision = parametroBean.fechaSucursal;
			var sucursal = $("#sucursalID").val();
			var usuario = 	parametroBean.claveUsuario;
			institucionNominaID = $("#institucionNominaID").val();
			convenioNominaID = $("#convenioNominaID").val();
			var clienteID = $('#clienteID').val();
			/// VALORES TEXTO
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombreSucursal = $("#sucursalID option:selected").html();
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			nombreInstit = $("#nombreInstit").val();
			desConvenio = $("#desConvenio").val();
			var NombreCompleto = $('#nombreCliente').val();

			$('#ligaGenerar').attr('href','reporteNomEmpleados.htm?&fechaEmision='+fechaEmision+
					'&sucursalID='+sucursal+
					'&claveUsuario='+usuario+
					'&nombreUsuario='+nombreUsuario+
					'&tipoReporte='+tr+
					'&nombreSucursal='+nombreSucursal+
					'&nombreInstitucion='+nombreInstitucion+
					'&institNominaID='+institucionNominaID+
					'&convenioNominaID='+convenioNominaID+
					'&nombreInstNomina='+nombreInstit+
					'&descripcionConvenio='+desConvenio+
					'&clienteID='+clienteID+
					'&nombreCompleto='+NombreCompleto
			);


		}
	}




//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

	function mayor(fecha, fecha2){
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);



		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		}
	}
//	FIN VALIDACIONES DE REPORTES

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("formato de fecha no válido (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				alert("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea");
				return false;
			}
			return true;
		}
	}


	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	/***********************************/


});


function limpiaDatosProdNom(){
	$('.datosNomina').hide();
	$("#institucionNominaID").val(0);
	$("#nombreInstit").val("TODAS");
	$("#convenioNominaID").val(0);
	$("#desConvenio").val("TODOS");
}
function inicializaCamposNom(){
	$("#institucionNominaID").val(0);
	$("#nombreInstit").val("TODAS");
	$("#convenioNominaID").val(0);
	$("#desConvenio").val("TODOS");
	$("#clienteID").val(0);
	$("#nombreCliente").val("TODOS");
}

function consultaProductoCred(){
	var prodCreditoBeanCon = {
			'producCreditoID':$('#producCreditoID').val()
	};
	productosCreditoServicio.consulta(1,prodCreditoBeanCon,function(prodCred) {

		if(prodCred!=null){
			if (prodCred.productoNomina == "S") {
				$('.datosNomina').show();
				inicializaCamposNom();
			}else{
				limpiaDatosProdNom();
			}
		}else{
			limpiaDatosProdNom();
		}
	});

}

function consultaNomInstit() {
	var institNominaBean = {
			'institNominaID' : $("#institucionNominaID").val()
	};
	institucionNomServicio.consulta(1, institNominaBean, function(institucionNomina) {
		if(institucionNomina != null){
			$('#nombreInstit').val(institucionNomina.nombreInstit);
			$("#convenioNominaID").val(0);
			$("#desConvenio").val("TODOS");
		}
		else {
			inicializaCamposNom();
		}
	});

}

function consultaConvenioNomina() {
	var convenioBean = {
		'convenioNominaID': $("#convenioNominaID").val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	conveniosNominaServicio.consulta(1, convenioBean, function(resultado) {
		if(resultado != null) {
			if($('#institucionNominaID').val()==0 ||
					(resultado.institNominaID == $('#institucionNominaID').val())){
				$("#desConvenio").val(resultado.descripcion);
			}else{
				
				mensajeSis("El convenio "+$("#convenioNominaID").val()+" no corresponde con la Empresa de Nómina.");
				$("#convenioNominaID").val(0);
				$("#desConvenio").val("TODOS");
			}
			
		}else{
			mensajeSis("El convenio no existe");
		}
	});
}

$('#producCreditoID').change(function(event) {
	consultaProductoCred();
});

$('#institucionNominaID').blur(function(event) {
	if($("#institucionNominaID").val()!="" && $("#institucionNominaID").val()!=0){
		consultaNomInstit();
	}
	else{
		inicializaCamposNom();
	}

});

$('#institNominaID').bind('keyup', function(e) {
	lista('institucionNominaID', '2', '1', 'institNominaID', $('#institucionNominaID').val(), 'institucionesNomina.htm');
});

$('#convenioNominaID').blur(function(event) {
	if($("#convenioNominaID").val()!="" && $("#convenioNominaID").val()!=0 && esTab){
		consultaConvenioNomina();
	}
	else{
		$("#convenioNominaID").val(0);
		$("#desConvenio").val("TODOS");
	}

});


$('#convenioNominaID').bind('keyup', function(e) {
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = 'institNominaID';
	camposLista[1] = 'descripcion';
	parametrosLista[0] = $('#institucionNominaID').val();
	parametrosLista[1] = $('#convenioNominaID').val();
	if($('#institucionNominaID').asNumber()==0){
		lista('convenioNominaID', '2', 7, camposLista, parametrosLista, 'listaConveniosNomina.htm');
	}else{
		lista('convenioNominaID', '2', 1, camposLista, parametrosLista, 'listaConveniosNomina.htm');
	}
});

$('#clienteID').bind('keyup',function(e) {
	lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
});

$('#clienteID').blur('keyup',function(e) {
	consultaCliente();
});

function consultaCliente() {
	setTimeout("$('#cajaLista').hide();", 200);
	if ($('#clienteID').asNumber()!=0 && $('#clienteID').asNumber()!="") {
		clienteServicio.consulta(1, $('#clienteID').val(), function(cliente) {
			if(cliente != null) {
				$("#nombreCliente").val(cliente.nombreCompleto);
			}else{
				mensajeSis("El cliente no existe.");
			}
		});
	}
	else{
		$("#clienteID").val(0);
		$("#nombreCliente").val("TODOS");
	}

}