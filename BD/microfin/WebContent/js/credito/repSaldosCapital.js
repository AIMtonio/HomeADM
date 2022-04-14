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
			mensajeSis("El convenio de nòmina no existe");
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
	if($("#institucionNominaID").val()!="" && $("#institucionNominaID").val()!=0){
		consultaNomInstit();
	}
	else{
		$("#institucionNominaID").val(0);
		$("#nombreInstit").val("TODOS");
	}

});

$('#institNominaID').bind('keyup', function(e) {
	lista('institucionNominaID', '2', '1', 'institNominaID', $('#institucionNominaID').val(), 'institucionesNomina.htm');
});



$(document).ready(function() {
	// Definicion de Constantes y Enums
	$('.datosNominaE').hide();
	$('.datosNominaC').hide();
	esTab = true;
	consultaManejaConvenios();
	var atrasoInicial = 0;
	var atrasoFinal = 99999;
	var parametroBean = consultaParametrosSession();
	$('#fechaInicio').focus();
	var catTipoLisRepSalCapCred = {
			'saldoCapitalExcel'	: 4
	};

	var catTipoRepSalCapCredito = {
			'salCapitalPantalla'	: 1,
			'saldoCapitalPDF'		: 2,
			'saldoCapitalExcel'		: 3
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	consultaMoneda();
	consultaProductoCredito();
	$('#atrasoInicial').val(atrasoInicial);
	$('#atrasoFinal').val(atrasoFinal);

	$.validator.setDefaults({
		invalidHandler: function() {

		}
	});

	$('#pdf').attr("checked",true) ;
	$('#detallado').attr("checked",true) ;
	$('#contable').attr("checked",true) ;

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


	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});

	$('#estadoID').blur(function() {
		consultaEstado(this.id);
	});

	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
		var Yfecha= parametroBean.fechaSucursal;
		if ( mayor(Xfecha, Yfecha) )
		{
			$('#fechaInicio').focus();
			mensajeSis("La Fecha es mayor a la fecha del sistema.")	;
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaInicio').blur(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) )
			{
				$('#fechaInicio').focus();
				mensajeSis("La Fecha es mayor a la fecha del sistema.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#atrasoInicial').bind('keydown',function() {
		if(isNaN($('#atrasoInicial').val())){
			if($('#atrasoInicial').val().trim() != ''){
				$('#atrasoInicial').val(atrasoInicial);
			}

		}else{
			if(Number($('#atrasoInicial').val())>=0 && Number($('#atrasoInicial').val()) <= Number($('#atrasoFinal').val()))
			{
				atrasoInicial = Number($('#atrasoInicial').val());
			}else{
				$('#atrasoInicial').val(atrasoInicial);
			}

		}
	});

	$('#atrasoFinal').bind('keydown',function() {
		if(isNaN($('#atrasoFinal').val())){
			if($('#atrasoFinal').val().trim() != ''){
				$('#atrasoFinal').val(atrasoFinal);
			}
		}else{
			if(Number($('#atrasoFinal').val())>=0 && Number($('#atrasoInicial').val()) <= Number($('#atrasoFinal').val()))
			{
				atrasoFinal = Number($('#atrasoFinal').val());
			}else{
				$('#atrasoFinal').val(atrasoFinal);
			}
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

	$('#convenioNominaID').blur(function(event) {
		if(esTab){

			if($("#convenioNominaID").val()!="" && $("#convenioNominaID").val()!=0){
				consultaConvenioNomina();
			}
			else{
				$("#convenioNominaID").val(0);
				$("#desConvenio").val("TODOS");
			}
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


	$('#formaGenerica').validate({
		rules: {
			atrasoInicial :{
				required: true
			},
			atrasoFinal :{
				required: true
			}
		},

		messages: {
			remesaCatalogoID :{
				required: 'Especifica Días de Atraso Inicial.'
			}
			,nombre :{
				required: 'Especifica Días de Atraso Final.'
			}
		}
	});


	function consultaPromotorI(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor == '' || numPromotor==0){
			$(jqPromotor).val(0);
			$('#nombrePromotorI').val('TODOS');
		}
		else

			if(numPromotor != '' && !isNaN(numPromotor) ){
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) {
					if(promotor!=null){
						$('#nombrePromotorI').val(promotor.nombrePromotor);

					}else{
						$('#promotorID').focus();
						mensajeSis("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotorI').val('TODOS');
					}
				});
			}
	}


	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numEstado == '' || numEstado==0){
			$('#estadoID').val(0);
			$('#nombreEstado').val('TODOS');

			var municipio= $('#municipioID').val();
			if(municipio != '' && municipio!=0){
				$('#municipioID').val('');
				$('#nombreMuni').val('TODOS');
			}
		}
		else
			if(numEstado != '' && !isNaN(numEstado) ){
				estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
					if(estado!=null){
						$('#nombreEstado').val(estado.nombre);

						var municipio= $('#municipioID').val();
						if(municipio != '' && municipio!=0){
							consultaMunicipio('municipioID');
						}

					}else{
						$('#estadoID').focus();
						$('#estadoID').val(0);
						mensajeSis("No Existe el Estado");
						$('#nombreEstado').val('TODOS');
					}
				});
			}
	}



	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();
		var numEstado =  $('#estadoID').val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMunicipio == '' || numMunicipio==0 || numEstado == '' || numEstado==0){

			if(numEstado == '' || numEstado==0 && numMunicipio!=0){
				$('#estadoID').focus();
				mensajeSis("No ha selecionado ningún estado.");
			}
			$('#municipioID').val(0);
			$('#nombreMuni').val('TODOS');
		}
		else
			if(numMunicipio != '' && !isNaN(numMunicipio)){
				municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){
						$('#nombreMuni').val(municipio.nombre);

					}else{
						$('#municipioID').focus();
						mensajeSis("No Existe el Municipio");
						$('#municipioID').val(0);
						$('#nombreMuni').val('TODOS');
					}
				});
			}
	}
	//------------ Validaciones de la Forma -------------------------------------
	$('#excel').click(function() {
		if($('#excel').is(':checked')){
			$('#tdPresenacion').hide('slow');
		}
	});

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){
			$('#tdPresenacion').show('slow');
		}
	});
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


	$('#pantalla').click(function() {
		if($('#pantalla').is(':checked')){
			$('#pdf').attr("checked",false) ;
			$('#excel').attr("checked",false);

			var tr= catTipoRepSalCapCredito.salCapitalPantalla;
			var fechaInicio = $('#fechaInicio').val();
			var sucursal = $("#sucursal option:selected").val();
			var moneda = $("#monedaID option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var usuario = 	parametroBean.claveUsuario;
			var atrasoInicial 	=  $('#atrasoInicial').val();
			var atrasoFinal 	=  $('#atrasoFinal').val();
			institucionNominaID = $("#institucionNominaID").val();
			convenioNominaID = $("#convenioNominaID").val();
			nombreInstit = $("#nombreInstit").val();
			desConvenio = $("#desConvenio").val();

			$('#ligaImp').attr('href','RepSaldosCapitalCredito.htm?fechaInicio='+fechaInicio+'&monedaID='+moneda+
					'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+
					'&atrasoInicial='+atrasoInicial+
					'&atrasoFinal='+atrasoFinal+
					'&institucionNominaID='+institucionNominaID+
					'&convenioNominaID='+convenioNominaID+
					'&nombreInstit='+nombreInstit+
					'&desConvenio='+desConvenio
			);
			url = $(ligaImp).attr("href");
			window.open(url, '_blank');
		}

	});



	function generaExcel() {

		if($('#excel').is(':checked')){
			var tr= catTipoRepSalCapCredito.saldoCapitalExcel;
			var tl= catTipoLisRepSalCapCred.saldoCapitalExcel;
			var fechaInicio = $('#fechaInicio').val();
			var sucursal = $("#sucursal option:selected").val();
			var moneda = $("#monedaID option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var usuario = 	parametroBean.numeroUsuario;
			var promotorID = $('#promotorID').val();
			var genero =$("#sexo option:selected").val();
			var estadoID=$('#estadoID').val();
			var municipioID=$('#municipioID').val();
			var fechaEmision = parametroBean.fechaSucursal;

			/// VALORES TEXTO

			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreMoneda = $("#monedaID option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombrePromotor = $('#nombrePromotorI').val();
			var nombreGenero =$("#sexo option:selected").val();
			var nombreEstado=$('#nombreEstado').val();
			var nombreMunicipio=$('#nombreMuni').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion;

			var atrasoInicial 	=  $('#atrasoInicial').val();
			var atrasoFinal 	=  $('#atrasoFinal').val();

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

			if(nombreGenero=='0'){
				nombreGenero='';
			}else{
				nombreGenero =$("#sexo option:selected").html();
			}
			if(genero=='0'){
				genero='';
			}

			var criterio="C";
			if($('#contable').is(':checked'))	{
				criterio='C';
			}
			
			$('#ligaGenerar').attr('href','RepSaldosCapitalCredito.htm?fechaInicio='+fechaInicio+'&monedaID='+moneda+
					'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&promotorID='+promotorID+'&sexo='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
					'&parFechaEmision='+fechaEmision+
					'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombrePromotor='+nombrePromotor+'&nombreGenero='+nombreGenero+'&nombreEstado='+nombreEstado+'&nombreMunicipi='+nombreMunicipio+'&nombreInstitucion='+nombreInstitucion+
					'&criterio='+criterio+
					'&atrasoInicial='+atrasoInicial+
					'&atrasoFinal='+atrasoFinal+
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

			$('#pantalla').attr("checked",false) ;
			$('#excel').attr("checked",false);
			var tr= catTipoRepSalCapCredito.saldoCapitalPDF;
			var fechaInicio = $('#fechaInicio').val();
			var sucursal = $("#sucursal option:selected").val();
			var moneda = $("#monedaID option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var usuario = 	parametroBean.claveUsuario;
			var promotorID = $('#promotorID').val();
			var genero =$("#sexo option:selected").val();
			var estadoID=$('#estadoID').val();
			var municipioID=$('#municipioID').val();
			var fechaEmision = parametroBean.fechaSucursal;

			var atrasoInicial 	=  $('#atrasoInicial').val();
			var atrasoFinal 	=  $('#atrasoFinal').val();

			var nivelDetalle=1;
			institucionNominaID = $("#institucionNominaID").val();
			convenioNominaID = $("#convenioNominaID").val();
			nombreInstit = $("#nombreInstit").val();
			desConvenio = $("#desConvenio").val();
			manejaConv  = $("#manejaConvenio").val();
			esProducNom = $("#esproducNomina").val();

			if($('#detallado').is(':checked'))	{
				nivelDetalle=1;
			}
			else
				if($('#sumarizado').is(':checked'))	{
					nivelDetalle=0;
				}

			var criterio = '';
				if($('#contable').is(':checked'))	{
					criterio='C';
				}

			/// VALORES TEXTO
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreMoneda = $("#monedaID option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombrePromotor = $('#nombrePromotorI').val();
			var nombreGenero =$("#sexo option:selected").val();
			var nombreEstado=$('#nombreEstado').val();
			var nombreMunicipio=$('#nombreMuni').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion;

			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursal option:selected").html();
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

			if(nombreGenero=='0'){
				nombreGenero='';
			}else{
				nombreGenero =$("#sexo option:selected").html();
			}
			if(genero=='0'){
				genero='';
			}

			$('#ligaGenerar').attr('href','RepSaldosCapitalCredito.htm?fechaInicio='+fechaInicio+'&monedaID='+moneda+
					'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+
					'&promotorID='+promotorID+'&sexo='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
					'&nivelDetalle='+nivelDetalle+'&parFechaEmision='+fechaEmision+
					'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombrePromotor='+nombrePromotor+'&nombreGenero='+nombreGenero+'&nombreEstado='+nombreEstado+'&nombreMunicipi='+nombreMunicipio+'&nombreInstitucion='+nombreInstitucion+
					'&criterio='+criterio+
					'&atrasoInicial='+atrasoInicial+
					'&atrasoFinal='+atrasoFinal+
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

		if (fecha != undefined && fecha!= "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
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
				mensajeSis("Fecha introducida errónea  ");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea  ");
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
