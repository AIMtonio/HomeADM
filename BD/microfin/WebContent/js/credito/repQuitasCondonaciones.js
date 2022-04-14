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
				if(manejaConvenio == "S")
				{
				$('.datosNominaC').show();
				}else{
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
			$("#desConvenio").val(resultado.descripcion);
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
	consultaManejaConvenios();
	inicializaCamposNom();
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();

	var catTipoConsultaCredito = {
			'principal'	: 1,
			'foranea'	: 2,
			'pagareImp' : 3,
			'ValidaCredAmor':4,
			'resumenCredito' :18

	};

	var catTipoRepQuitas = {
			'Pantalla'	: 1,
			'PDF'		: 2,
			'Excel'		: 3
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();

	consultaProductoCredito();

	$('#pdf').attr("checked",true) ;
	$('#nombreCliente').val('TODOS');
	$('#creditoID').val(0);


	$(':text').focus(function() {
		esTab = false;
	});

	$('#promotorID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('promotorID', '1', '1', 'nombrePromotor',
				$('#promotorID').val(), 'listaPromotores.htm');
	});


	$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});

	$('#municipioID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";


		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();

		lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});






	$('#fechaInicio').change(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var Xfecha= $('#fechaInicio').val();
		var Zfecha= parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').focus();
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			else{
				if (mayor(Xfecha, Zfecha) ){
					mensajeSis("La Fecha Inicial es Mayor a la Fecha Actual.");
					$('#fechaInicio').focus();
					$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
				else{
					$('#fechaVencimien').focus();
				}
			}
		}else{
			$('#fechaInicio').focus();
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});


	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaVencimien').change(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var Xfecha= parametroBean.fechaSucursal;
		var Yfecha= $('#fechaVencimien').val();
		var Zfecha= $('#fechaInicio').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha==''){
				$('#fechaVencimien').val(parametroBean.fechaSucursal);
			}
			else{
				if ( mayor(Yfecha,Xfecha) ){
					mensajeSis("La Fecha Final es mayor a la Fecha Actual.")	;
					$('#fechaVencimien').val(parametroBean.fechaSucursal);
					$('#fechaVencimien').focus();
				}
				else{
					if ( mayor(Zfecha,Yfecha) ){
						mensajeSis("La Fecha de Final es menor a la Fecha Inicial.")	;
						$('#fechaVencimien').val(parametroBean.fechaSucursal);
					}
					else{
						$('#sucursalID').focus();
					}
				}
			}

		}else{
			$('#fechaVencimien').focus();
			$('#fechaVencimien').val(parametroBean.fechaSucursal);
		}
	});


	$('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', '1', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');

	});

	$('#creditoID').blur(function() {
		validaCredito(this.id);

	});


	$('#generar').click(function() {

		if($('#pdf').is(":checked") ){
			generaPDF();
		}

		if($('#pantalla').is(":checked") ){
			generaPantalla();
		}

		if($('#excel').is(":checked") ){
			generaExcel();
		}

	});


	// ***********  Inicio  validacion Credito ***********


	function validaCredito(control) {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) ){

			var creditoBeanCon = {
					'creditoID':$('#creditoID').val()
			};

			if(numCredito==0){
				$('#nombreCliente').val('TODOS');
				$('#creditoID').val(0);
			}
			else{
				creditosServicio.consulta(catTipoConsultaCredito.resumenCredito,creditoBeanCon,function(credito) {
					if(credito!=null){
						esTab=true;

						 if(credito.esAgropecuario != 'S'){
							consultaCliente(credito.clienteID);
						 }else{
		   					mensajeSis("El Crédito " + credito.creditoID + "es Agropecuario.<br>Favor de consultarla en " + "<b><a onclick=\"$('#Contenedor').load('repQuitasCondVistaAgro.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\"> Cartera Agro. <img src=\"images/external.png\"></a></b>");
						 }

					}else{
						mensajeSis("No Existe el Credito");
						$('#nombreCliente').val('TODOS');
						$('#creditoID').val(0);
					}
				});
			}

		}
	}


	function consultaCliente(numCliente) {

		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){

					$('#nombreCliente').val(cliente.nombreCompleto);
				}else{
					mensajeSis("No Existe el Cliente");
					$('#nombreCliente').val('TODOS');
					$('#creditoID').val(0);
				}
			});
		}
	}

	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursal');
		dwr.util.addOptions( 'sucursal', {'0':'TODAS'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursal', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimien').val(parametroBean.fechaSucursal);




	function consultaProductoCredito() {
		var tipoCon = 2;
		dwr.util.removeAllOptions('producCreditoID');
		dwr.util.addOptions( 'producCreditoID', {'0':'TODAS'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('producCreditoID', productos, 'producCreditoID', 'descripcion');
		});
	}




	function generaPantalla() {
		$('#pdf').attr("checked",false) ;
		$('#excel').attr("checked",false) ;

		if($('#pantalla').is(':checked')){
			var tr= catTipoRepQuitas.Pantalla;
			var tl= 0;
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaVencimien').val();
			var sucursal = $("#sucursal option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var creditoID = $('#creditoID').val();
			var usuario = 	parametroBean.claveUsuario;


			var fechaEmision = parametroBean.fechaSucursal;

			/// VALORES TEXTO
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var nombreCredito =$('#creditoID').val();
			var nombreCte =	$('#nombreCliente').val();
			institucionNominaID = $("#institucionNominaID").val();
			convenioNominaID = $("#convenioNominaID").val();
			nombreInstit = $("#nombreInstit").val();
			desConvenio = $("#desConvenio").val();

			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursal option:selected").html();
			}


			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#producCreditoID option:selected").html();
			}

			if(nombreCredito=='0'  ){
				nombreCredito='';
			}else{
				nombreCredito = $('#creditoID').val();
			}

			if(nombreCte==''){
				nombreCte='';
			}else{
				nombreCte=$('#nombreCliente').val();;
			}
			$('#ligaGenerar').attr('href','reporteQuitasCond.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&parFechaEmision='+fechaEmision+'&creditoID='+creditoID+'&nomCliente='+nombreCte+'&nomCredito='+nombreCredito+
					'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&nombreSucursal='+nombreSucursal+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+
					'&institucionNominaID='+institucionNominaID+
					'&convenioNominaID='+convenioNominaID+
					'&nombreInstit='+nombreInstit+
					'&desConvenio='+desConvenio);
		}
	}

	function generaPDF() {
		if($('#pdf').is(':checked')){
			$('#pantalla').attr("checked",false) ;
			$('#excel').attr("checked",false) ;

			var tr= catTipoRepQuitas.PDF;
			var tl=0;

			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaVencimien').val();
			var sucursal = $("#sucursal option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var creditoID = $('#creditoID').val();
			var usuario = 	parametroBean.claveUsuario;


			var fechaEmision = parametroBean.fechaSucursal;

			/// VALORES TEXTO
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var nombreCredito =$('#creditoID').val();
			var nombreCte =$('#nombreCliente').val();
			institucionNominaID = $("#institucionNominaID").val();
			convenioNominaID = $("#convenioNominaID").val();
			nombreInstit = $("#nombreInstit").val();
			desConvenio = $("#desConvenio").val();
			manejaConv  = $("#manejaConvenio").val();
			esProducNom = $("#esproducNomina").val();


			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursal option:selected").html();
			}


			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#producCreditoID option:selected").html();
			}

			if(nombreCredito=='0'  ){
				nombreCredito='';
			}else{
				nombreCredito = $('#creditoID').val();
			}

			if(nombreCte==''){
				nombreCte='';
			}else{
				nombreCte=$('#nombreCliente').val();;
			}
			$('#ligaGenerar').attr('href','reporteQuitasCond.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&parFechaEmision='+fechaEmision+'&creditoID='+creditoID+'&nomCliente='+nombreCte+'&nomCredito='+nombreCredito+
					'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&nombreSucursal='+nombreSucursal+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+
					'&institucionNominaID='+institucionNominaID+
					'&convenioNominaID='+convenioNominaID+
					'&nombreInstit='+nombreInstit+
					'&desConvenio='+desConvenio+
					'&manejaConvenio='+manejaConv+
					'&esproducNomina='+esProducNom);
		}
	}

	function generaExcel() {
		if($('#excel').is(':checked')){
			$('#pantalla').attr("checked",false) ;
			$('#pdf').attr("checked",false) ;

			var tr= catTipoRepQuitas.Excel;
			var tl=0;

			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaVencimien').val();
			var sucursal = $("#sucursal option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var creditoID = $('#creditoID').val();
			var usuario = 	parametroBean.claveUsuario;


			var fechaEmision = parametroBean.fechaSucursal;

			/// VALORES TEXTO
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var nombreCredito =$('#creditoID').val();
			var nombreCte =$('#nombreCliente').val();
			institucionNominaID = $("#institucionNominaID").val();
			convenioNominaID = $("#convenioNominaID").val();
			nombreInstit = $("#nombreInstit").val();
			desConvenio = $("#desConvenio").val();
			manejaConv  = $("#manejaConvenio").val();
			esProducNom = $("#esproducNomina").val();
			

			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursal option:selected").html();
			}


			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#producCreditoID option:selected").html();
			}

			if(nombreCredito=='0'  ){
				nombreCredito='';
			}else{
				nombreCredito = $('#creditoID').val();
			}

			if(nombreCte==''){
				nombreCte='';
			}else{
				nombreCte=$('#nombreCliente').val();;
			}
			$('#ligaGenerar').attr('href','reporteQuitasCond.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&parFechaEmision='+fechaEmision+'&creditoID='+creditoID+'&nomCliente='+nombreCte+'&nomCredito='+nombreCredito+
					'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&nombreSucursal='+nombreSucursal+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+
					'&institucionNominaID='+institucionNominaID+
					'&convenioNominaID='+convenioNominaID+
					'&nombreInstit='+nombreInstit+
					'&desConvenio='+desConvenio+
					'&manejaConvenio='+manejaConv+
					'&esproducNomina='+esProducNom);
		}
	}


	/*funcion valida fecha formato (yyyy-MM-dd)*/

	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd).");
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
				mensajeSis("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea.");
				return false;
			}
			return true;
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
