$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var atrasoInicial = 0;
	var atrasoFinal = 99999;
	var esMayor = 0;
	var parametroBean = consultaParametrosSession();   
	$('#fechaInicio').focus();
	var catTipoLisRepSalCapCred = {
			'excel'	: 1 ,
			'csv':	2
	};	

	var catTipoRepSalCapCredito = { 
			'excel'	: 1 ,
			'csv':	2
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	$('#producCreditoID').val("0");
	$('#nombreProducto').val("TODOS");
	$('#sucursalID').val("0");
	$('#nombreSucursal').val("TODAS");
	consultaMoneda(); 
	$('#atrasoInicial').val(atrasoInicial);
	$('#atrasoFinal').val(atrasoFinal);

	obtieneFinMes(parametroBean.fechaSucursal);
	$.validator.setDefaults({ 
		invalidHandler: function() {
		 
		}
	});	


	$(':text').focus(function() {	
		esTab = false;
	});

	$('#promotorID').bind('keyup',function(e){
		lista('promotorID', '1', '1', 'nombrePromotor', $('#promotorID').val(), 'listaPromotores.htm');
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
			mensajeSis("La Fecha es mayor a la fecha del sistema.")	;
			obtieneFinMes(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
			esMayor = 1;
		} 
		else{
			esMayor = 0;
		}
		
		if(esMayor == 0){
				validaFinMes(Xfecha);
		}
	});

	$('#fechaInicio').blur(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) )
			{				
				mensajeSis("La Fecha es mayor a la fecha del sistema.")	;
				obtieneFinMes(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
				esMayor = 1;
			}
			if(esMayor == 0){
				validaFinMes(Xfecha);
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
		var fecha= $('#fechaInicio').val();
		
		if($('#excel').is(":checked")){ 
		   generaExcel();
		}
	   else if($('#csv').is(":checked")){ 
		   generaCSV();
		} 


	});


	$('#sucursalID').bind('keyup', function(e) {
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});
	
	$('#producCreditoID').bind('keyup',function(e){  
		lista('producCreditoID', '1', '3', 'descripcion', $('#producCreditoID').val(), '	listaProductosCredito.htm');
	});
	
	$('#producCreditoID').blur(function() {
		consultaProducCreditoForanea($('#producCreditoID').val());
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

	function consultaSucursal(idControl) {
	var jqSucursal = eval("'#" + idControl + "'");
	var numSucursal = $(jqSucursal).val();
	var conSucursal = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numSucursal != '' && !isNaN(numSucursal)) {
		sucursalesServicio.consultaSucursal(conSucursal, numSucursal, function(sucursal) {
			if (sucursal != null) {
				$('#sucursalID').val(sucursal.sucursalID);
				$('#nombreSucursal').val(sucursal.nombreSucurs);
			} else {
				$('#sucursalID').val('0');
				$('#nombreSucursal').val('TODAS');
			}
		});
	} else {
		$('#sucursalID').val('0');
		$('#nombreSucursal').val('TODAS');
	}
}

function consultaProducCreditoForanea(producto) {
	var ProdCredBeanCon = {
		'producCreditoID' : producto
	};
	if (producto != '' && !isNaN(producto)) {
		productosCreditoServicio.consulta(1, ProdCredBeanCon, function(prodCred) {
			if (prodCred != null) {
				$('#nombreProducto').val(prodCred.descripcion);
			} else {
				$('#producCreditoID').val("0");
				$('#nombreProducto').val("TODOS");
			}
		});
	} else {
		$('#producCreditoID').val("0");
		$('#nombreProducto').val("TODOS");
	}
}





	function generaExcel() {

		if($('#excel').is(':checked')){	
			var tr= catTipoRepSalCapCredito.excel; 
			var tl= catTipoLisRepSalCapCred.excel;
			var fechaInicio = $('#fechaInicio').val();	 
			var sucursal = $("#sucursalID").val();
			var moneda = $("#monedaID option:selected").val();
			var producto = $("#producCreditoID").val();
			var usuario = 	parametroBean.numeroUsuario; 
			var promotorID = $('#promotorID').val();
			var genero =$("#sexo option:selected").val();
			var estadoID=$('#estadoID').val();
			var municipioID=$('#municipioID').val();
			var fechaEmision = parametroBean.fechaSucursal;

			/// VALORES TEXTO

			var nombreSucursal = $("#sucursalID").val();
			var nombreMoneda = $("#monedaID option:selected").val();
			var nombreProducto = $("#producCreditoID").val();
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombrePromotor = $('#nombrePromotorI').val();
			var nombreGenero =$("#sexo option:selected").val();
			var nombreEstado=$('#nombreEstado').val();
			var nombreMunicipio=$('#nombreMuni').val();	
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			
			var atrasoInicial 	=  $('#atrasoInicial').val(); 
			var atrasoFinal 	=  $('#atrasoFinal').val(); 

			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#nombreSucursal").val();
			}

			if(nombreMoneda=='0'){
				nombreMoneda='';
			}else{
				nombreMoneda = $("#monedaID option:selected").html();
			}

			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#nombreProducto").val();
			}

			if(nombreGenero=='0'){
				nombreGenero='';
			}else{
				nombreGenero =$("#sexo option:selected").html();
			}
			if(genero=='0'){
				genero='';
			}


			$('#ligaGenerar').attr('href','ReporteCastigosQuitasCNBV.htm?fechaInicio='+fechaInicio+'&monedaID='+moneda+
					'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&promotorID='+promotorID+'&sexo='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
					'&parFechaEmision='+fechaEmision+
					'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombrePromotor='+nombrePromotor+'&nombreGenero='+nombreGenero+'&nombreEstado='+nombreEstado+'&nombreMunicipi='+nombreMunicipio+'&nombreInstitucion='+nombreInstitucion+
					'&atrasoInicial='+atrasoInicial+'&atrasoFinal='+atrasoFinal
			);

		}
	}

	

	function generaCSV() {

		if($('#csv').is(':checked')){	
			var tr= catTipoRepSalCapCredito.csv; 
			var tl= catTipoLisRepSalCapCred.csv;

			var fechaInicio = $('#fechaInicio').val();	 
			var sucursal = $("#sucursalID").val();
			var moneda = $("#monedaID option:selected").val();
			var producto = $("#producCreditoID").val();
			var usuario = 	parametroBean.numeroUsuario; 
			var promotorID = $('#promotorID').val();
			var genero =$("#sexo option:selected").val();
			var estadoID=$('#estadoID').val();
			var municipioID=$('#municipioID').val();
			var fechaEmision = parametroBean.fechaSucursal;

			/// VALORES TEXTO

			var nombreSucursal = $("#sucursalID").val();
			var nombreMoneda = $("#monedaID option:selected").val();
			var nombreProducto = $("#producCreditoID").val();
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombrePromotor = $('#nombrePromotorI').val();
			var nombreGenero =$("#sexo option:selected").val();
			var nombreEstado=$('#nombreEstado').val();
			var nombreMunicipio=$('#nombreMuni').val();	
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			
			var atrasoInicial 	=  $('#atrasoInicial').val(); 
			var atrasoFinal 	=  $('#atrasoFinal').val(); 

			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursalID").html();
			}

			if(nombreMoneda=='0'){
				nombreMoneda='';
			}else{
				nombreMoneda = $("#monedaID option:selected").html();
			}

			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#producCreditoID").html();
			}

			if(nombreGenero=='0'){
				nombreGenero='';
			}else{
				nombreGenero =$("#sexo option:selected").html();
			}
			if(genero=='0'){
				genero='';
			}

			
			$('#ligaGenerar').attr('href','ReporteCastigosQuitasCNBV.htm?fechaInicio='+fechaInicio+'&monedaID='+moneda+
					'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&promotorID='+promotorID+'&sexo='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
					'&parFechaEmision='+fechaEmision+
					'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombrePromotor='+nombrePromotor+'&nombreGenero='+nombreGenero+'&nombreEstado='+nombreEstado+'&nombreMunicipio='+nombreMunicipio+'&nombreInstitucion='+nombreInstitucion+
					'&atrasoInicial='+atrasoInicial+'&atrasoFinal='+atrasoFinal
			);

		}
	}

	

//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

	function mayor(fecha, fecha2){
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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
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
	
	function validaFinMes(varFecha){
		var fecha = varFecha;	
		var creditoBeanCon = { 
			'fechaFinRep':fecha
			};
			reporteCarteraCNBVServicio.consulta(1,creditoBeanCon,function(credito) {
			if(credito!=null){
				if(credito.fechaFinRep == fecha){					
					$('#fechaInicio').val(credito.fechaFinRep);
				}else {
					mensajeSis("De acuerdo a la fecha seleccionada, el reporte se generará al último día del mes anterior");
					$('#fechaInicio').val(credito.fechaFinRep);
					$('#fechaInicio').focus();
					
				}
			}else{
				mensajeSis("No se encontró información para el Reporte");
			}
		});	
	}

	function obtieneFinMes(varFecha){
		var fecha = varFecha;	
		var creditoBeanCon = { 
			'fechaFinRep':fecha
			};
			reporteCarteraCNBVServicio.consulta(1,creditoBeanCon,function(credito) {
			if(credito!=null){
				$('#fechaInicio').val(credito.fechaFinRep);
		
			}else{
				mensajeSis("No se encontró información para el Reporte");
			}
		});	
	}
    

});
