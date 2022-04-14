var institucionNominaID;
var convenioNominaID;
var nombreInstit;
var desConvenio;
var manejaConvenio = 'N';

function limpiaDatosProdNom(){
	$('.datosNominaE').hide();
	$('.datosNominaC').hide();
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
}

function consultaProductoCred(){
	var prodCreditoBeanCon = {
			'producCreditoID':$('#producCreditoID').val()
	};
	productosCreditoServicio.consulta(1,prodCreditoBeanCon,function(prodCred) {

		if(prodCred!=null){
			if (prodCred.productoNomina == "S") {
				$('.datosNominaE').show();
				if( manejaConvenio == "S")
					{
						$('.datosNominaC').show();
					}else
						{
							$('.datosNominaC').hide();
						}
				
				$("#manejaConvenio").val(manejaConvenio);
				$("#esproducNomina").val(prodCred.productoNomina);
				inicializaCamposNom();
			}else{
				$("#manejaConvenio").val(manejaConvenio);
				$("#esproducNomina").val(prodCred.productoNomina);
				limpiaDatosProdNom();
			}
		}else{
			$("#manejaConvenio").val(manejaConvenio);
		    $("#esproducNomina").val('N');
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
			if(resultado.institNominaID !=$("#institucionNominaID").val()){
				mensajeSis("El convenio seleccionado no corresponde a la empresa de nómina");
				dwr.util.removeAllOptions('conveniosNominaServicio');
				$('#convenioNominaID').val('0');
				$('#desConvenio').val('TODOS');
				$('#convenioNominaID').focus();
			}else{
				$("#desConvenio").val(resultado.descripcion);
			}
		}else{
			mensajeSis("El convenio de nómina no existe");
			$('#convenioNominaID').val('0');
			$('#desConvenio').val('TODOS');
			$('#convenioNominaID').focus();
		}
	});
}

$('#producCreditoID').change(function(event) {
	consultaProductoCred();
});

$('#institucionNominaID').blur(function(event) {
	if($("#institucionNominaID").val()!="" && $("#institucionNominaID").val()!=0 && esTab){
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

$(document).ready(function() {
	$('.datosNominaE').hide();
	$('.datosNominaC').hide();
	inicializaCamposNom();
	consultaManejaConvenios();
	// Definicion de Constantes y Enums
	esTab = true;
	var atrasoInicial = 0;
	var atrasoFinal = 99999;
	var parametroBean = consultaParametrosSession();

	var catTipoLisCastigos  = {
			'castigosExcel'	: 1
	};

	var catTipoReCastigos = {
			'PDF'		: 2,
			'Excel'		: 3
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	consultaMoneda();
	consultaProductoCredito();
	consultaMotivosCastigo();
	$('#promotorID').val(0);
	$('#nombrePromotorI').val('TODOS');
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);


	$('#pdf').attr("checked",true) ;
	$(':text').focus(function() {
		esTab = false;
	});

	$('#promotorID').bind('keyup',function(e){
		lista('promotorID', '1', '1', 'nombrePromotor', $('#promotorID').val(), 'listaPromotores.htm');
	});

	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				if($('#fechaFin').val() !=''){
					alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}

			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

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
			fechaInicio :{
				required: true,
			},
			fechaFin :{
				required: true
			}
		},

		messages: {
			fechaInicio :{
				required: 'Ingrese la Fecha de Inicio',
			}
			,fechaFin :{
				required: 'Ingrese la Fecha Final'
			}
		}
	});

	// Validacion Promotor  Verificar sonculta
	function consultaPromotorI(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor == '' || numPromotor == 0){
			$(jqPromotor).val(0);
			$('#nombrePromotorI').val('TODOS');
		}else
			if(numPromotor != '' && !isNaN(numPromotor) ){
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) {
					if(promotor!=null){
						$('#nombrePromotorI').val(promotor.nombrePromotor);

					}else{
						alert("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotorI').val('TODOS');
					}
				});
			}
	}

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



	function consultaMoneda() {
		var tipoCon = 3;
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'TODAS'});
		monedasServicio.listaCombo(tipoCon, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	function consultaProductoCredito() {
		var tipoCon = 2;
		dwr.util.removeAllOptions('producCreditoID');
		dwr.util.addOptions( 'producCreditoID', {'0':'TODOS'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('producCreditoID', productos, 'producCreditoID', 'descripcion');
		});
	}


	function consultaMotivosCastigo() {
  		dwr.util.removeAllOptions('motivoCastigoID');
  		dwr.util.addOptions('motivoCastigoID', {'0':'TODOS'});
		castigosCarteraServicio.listaCombo(1, function(motivosCastigo){
		dwr.util.addOptions('motivoCastigoID', motivosCastigo, 'motivoCastigoID', 'descricpion');
			});
	}

	function generaExcel() {
		$('#pdf').attr("checked",false) ;
		if($('#excel').is(':checked')){
			// ???
			var tr= catTipoReCastigos.Excel;
			var tl= catTipoLisCastigos .castigosExcel;
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaFin').val();
			var sucursal = $("#sucursalID option:selected").val();
			var moneda = $("#monedaID option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var usuario = 	parametroBean.claveUsuario;
			var promotorID = $('#promotorID').val();
			var fechaEmision = parametroBean.fechaSucursal;
			var motivoCastigoID = $("#motivoCastigoID option:selected").val();

			/// VALORES TEXTO
			var nombreSucursal = $("#sucursalID option:selected").val();
			var nombreMoneda = $("#monedaID option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombrePromotor = $('#nombrePromotorI').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var nombreMotivoCastigo	= $("#motivoCastigoID option:selected").val();
			institucionNominaID = $("#institucionNominaID").val();
			convenioNominaID = $("#convenioNominaID").val();
			nombreInstit = $("#nombreInstit").val();
			desConvenio = $("#desConvenio").val();
			manejaConv  = $("#manejaConvenio").val();
			esProducNom = $("#esproducNomina").val();

			if(nombreSucursal=='0'){
				nombreSucursal='';
			}else{
				nombreSucursal = $("#sucursalID option:selected").html();
			}

			if(nombreMoneda=='0'){
				nombreMoneda='';
			}else{
				nombreMoneda = $("#monedaID option:selected").html();
			}

			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#producCreditoID option:selected").html();
			}

			if(nombreMotivoCastigo=='0'){
				nombreMotivoCastigo='';
			}else{
				nombreMotivoCastigo = $("#motivoCastigoID option:selected").html();
			}

			$('#ligaGenerar').attr('href','ReporteCredCastigos.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&monedaID='+moneda+'&fechaEmision='+fechaEmision+
					'&sucursalID='+sucursal+'&producCreditoID='+producto+'&claveUsuario='+usuario+'&tipoReporte='+tr+
					'&promotorID='+promotorID+'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+
					nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombrePromotor='+nombrePromotor+'&nombreInstitucion='+nombreInstitucion+'&motivoCastigoID='+motivoCastigoID+
					'&desMotivoCastigo='+nombreMotivoCastigo+'&tipoLista='+tl+
					'&institucionNominaID='+institucionNominaID+
					'&convenioNominaID='+convenioNominaID+
					'&nombreInstit='+nombreInstit+
					'&desConvenio='+desConvenio+
					'&manejaConvenio='+manejaConv+
					'&esproducNomina='+esProducNom
			);

		}
	}

	function generaPDF() {
		if($('#pdf').is(':checked')){
			$('#excel').attr("checked",false);

			var tr= catTipoReCastigos.PDF;

			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaFin').val();
			var sucursal = $("#sucursalID option:selected").val();
			var moneda = $("#monedaID option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var usuario = 	parametroBean.claveUsuario;
			var promotorID = $('#promotorID').val();
			var fechaEmision = parametroBean.fechaSucursal;
			var motivoCastigoID = $("#motivoCastigoID option:selected").val();

			/// VALORES TEXTO
			var nombreSucursal = $("#sucursalID option:selected").val();
			var nombreMoneda = $("#monedaID option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombrePromotor = $('#nombrePromotorI').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var nombreMotivoCastigo	= $("#motivoCastigoID option:selected").val();
			institucionNominaID = $("#institucionNominaID").val();
			convenioNominaID = $("#convenioNominaID").val();
			nombreInstit = $("#nombreInstit").val();
			desConvenio = $("#desConvenio").val();
			manejaConv  = $("#manejaConvenio").val();
			esProducNom = $("#esproducNomina").val();

			if(nombreSucursal=='0'){
				nombreSucursal='';
			}else{
				nombreSucursal = $("#sucursalID option:selected").html();
			}

			if(nombreMoneda=='0'){
				nombreMoneda='';
			}else{
				nombreMoneda = $("#monedaID option:selected").html();
			}

			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#producCreditoID option:selected").html();
			}

			if(nombreMotivoCastigo=='0'){
				nombreMotivoCastigo='';
			}else{
				nombreMotivoCastigo = $("#motivoCastigoID option:selected").html();
			}

			$('#ligaGenerar').attr('href','ReporteCredCastigos.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&monedaID='+moneda+'&fechaEmision='+fechaEmision+
					'&sucursalID='+sucursal+'&producCreditoID='+producto+'&claveUsuario='+usuario+'&tipoReporte='+tr+
					'&promotorID='+promotorID+'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+
					nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombrePromotor='+nombrePromotor+'&nombreInstitucion='+nombreInstitucion+'&motivoCastigoID='+motivoCastigoID+
					'&desMotivoCastigo='+nombreMotivoCastigo+
					'&institucionNominaID='+institucionNominaID+
					'&convenioNominaID='+convenioNominaID+
					'&nombreInstit='+nombreInstit+
					'&desConvenio='+desConvenio+
					'&manejaConvenio='+manejaConv+
					'&esproducNomina='+esProducNom
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

	
	//Metodo Para consultar si se maneja convenios
	function consultaManejaConvenios(){
	    var tipoConsulta = 36;
	    var bean = {
	            'empresaID'     : 1
	        };

	    paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
	            if (parametro != null){
	                manejaConvenio = parametro.valorParametro;
	            }else {
	                manejaConvenio = 'N';
	            }

	    }});
	}



});
