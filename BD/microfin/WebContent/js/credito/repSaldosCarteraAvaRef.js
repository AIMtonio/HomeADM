$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var atrasoInicial = 0;
	var atrasoFinal = 99999;
	var parametroBean = consultaParametrosSession();   

	var catTipoLisVencimientos  = {
			'saldosCarteraAvalRef'	: 16
	};	

	var catTipoRepVencimientos = { 
			'excel'		: 1
	};	

	var catTipoListaSucursal = {
			'principal' :1,
			'combo': 2
	};
	var catTipoConsulta ={
			'principal':1
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	
	consultaMoneda(); 
	
	$('#fechaInicio').focus();
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#atrasoInicial').val(atrasoInicial);
	$('#atrasoFinal').val(atrasoFinal);

	$('#sucursalID').val(0);
	$('#nombreSucursal').val("TODOS");

	$('#producCreditoID').val(0);
	$('#descripProducto').val("TODOS");

	$('#promotorID').val(0);
	$('#nombrePromotorI').val('TODOS');
	
	$('#estadoID').val(0);
	$('#nombreEstado').val('TODOS');
	
	$('#municipioID').val(0);
	$('#nombreMuni').val('TODOS');
	
	$('#excel').attr("checked",true) ; 

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#sucursalID').bind('keyup',function(e){
		lista(this.id,'2',catTipoListaSucursal.principal,'nombreSucurs',$('#sucursalID').val(),'listaSucursales.htm');
	});
	
	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});
	
	$('#producCreditoID').bind('keyup',function(e){
		lista('producCreditoID', '1', '1', 'descripcion', $('#producCreditoID').val(), 'listaProductosCredito.htm');
	});
	
	$('#producCreditoID').blur(function() {	 
		consultaProducCredito(this.id);
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

	$('#excel').click(function() {
		if($('#excel').is(':checked')){	
		}
	});

	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var fechaSistema = parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha=fechaSistema;
			if(mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha es Mayor a la Fecha del Sistema.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#estadoID').blur(function() {
		consultaEstado(this.id);
	});

	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
	});
	
	
	$('#atrasoInicial').bind('keyup',function() {
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
	
	$('#atrasoFinal').bind('keyup',function() {
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
		if($('#excel').is(":checked") ){
			generaExcel();
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
			atrasoInicial :{
				required: 'Especifica Días de Atraso Inicial.'
			},
			atrasoFinal:{
				required: 'Especifica Días de Atraso Final.'
			}
		}
	});

	// *********** Inicia consultas de Sucursal, Promotor, Estado, Municipio  ***********

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
					mensajeSis("No Existe la Sucursal.");
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

	function consultaProducCredito() {
		var producto = $('#producCreditoID').asNumber();
		var ProdCredBeanCon = {
			'producCreditoID' : producto
		};

		if(producto > 0){
			productosCreditoServicio.consulta(catTipoConsulta.principal, ProdCredBeanCon, function(prodCred) {
				if (prodCred != null) {
					$('#descripProducto').val(prodCred.descripcion);

				} else {
					mensajeSis("No Existe el Producto de Crédito.");
					$('#producCreditoID').val('');
					$('#producCreditoID').select();
					$('#descripProducto').val('');
				}
			});
		} else if(producto == 0){
			$('#producCreditoID').val('0');
			$('#descripProducto').val('TODOS');
		}
	}

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
		} else if(numPromotor != '' && !isNaN(numPromotor) ){ 
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
					if(promotor!=null){							
						$('#nombrePromotorI').val(promotor.nombrePromotor); 

					}else{
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
						mensajeSis("No Existe el Estado");
						$('#estadoID').val(0);
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
				mensajeSis("No ha selecionado ningún estado.");
				$('#estadoID').focus();
			}
			$('#municipioID').val(0);
			$('#nombreMuni').val('TODOS');
		} else if(numMunicipio != '' && !isNaN(numMunicipio)){
				municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){							
						$('#nombreMuni').val(municipio.nombre);

					}else{
						mensajeSis("No Existe el Municipio");
						$('#municipioID').val(0);
						$('#nombreMuni').val('TODOS');
					}    	 						
				});
			}
	}	

	// fin validacion Promotor, Estado, Municipio

	function consultaMoneda() {		
		var tipoCon = 3;
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'TODAS'});
		monedasServicio.listaCombo(tipoCon, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	function generaExcel() {
		if($('#excel').is(':checked')){	
			var tr= catTipoRepVencimientos.excel; 
			var tl= catTipoLisVencimientos.saldosCarteraAvalRef;  
			var fechaInicio = $('#fechaInicio').val();	 
			var sucursal = $("#sucursalID").val();
			var moneda = $("#monedaID option:selected").val();
			var producto = $("#producCreditoID").val();
			var usuario = 	parametroBean.claveUsuario;
			var promotorID = $('#promotorID').val();
			var genero =$("#sexo option:selected").val();
			var estadoID=$('#estadoID').val();
			var municipioID=$('#municipioID').val();
			var fechaEmision = parametroBean.fechaSucursal;
			/// VALORES TEXTO
			var nombreSucursal = $("#nombreSucursal").val();
			var nombreMoneda = $("#monedaID option:selected").text();
			var nombreProducto = $("#descripProducto").val();
			var nombrePromotor = $('#nombrePromotorI').val();
			var nombreGenero =$("#sexo option:selected").text();
			var nombreEstado=$('#nombreEstado').val();
			var nombreMunicipio=$('#nombreMuni').val();	
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			if(genero=='0'){
				genero='';
			}
			var atrasoInicial 	=  $('#atrasoInicial').val().trim(); 
			var atrasoFinal 	=  $('#atrasoFinal').val().trim(); 

			if(atrasoInicial!='' && atrasoFinal!='' && Number(atrasoFinal)>=0){
				var pagina = 'reporteSaldosCarAvaRef.htm?fechaInicio='+fechaInicio+
					'&monedaID='+moneda+
					'&parFechaEmision='+fechaEmision+
					'&sucursal='+sucursal+
					'&producCreditoID='+producto+
					'&usuario='+usuario+
					'&tipoReporte='+tr+
					'&tipoLista='+tl+
					'&promotorID='+promotorID+
					'&sexo='+genero+
					'&estadoID='+estadoID+
					'&municipioID='+municipioID+
					'&nombreSucursal='+nombreSucursal+
					'&nombreMoneda='+nombreMoneda+
					'&nombreProducto='+nombreProducto+
					'&nombreUsuario='+usuario.toUpperCase()+
					'&nombrePromotor='+nombrePromotor+
					'&nombreGenero='+nombreGenero+
					'&nombreEstado='+nombreEstado+
					'&nombreMunicipi='+nombreMunicipio+
					'&nombreInstitucion='+nombreInstitucion+
					'&atrasoInicial='+atrasoInicial+
					'&atrasoFinal='+atrasoFinal;
				window.open(pagina,'_blank');
			} else if(atrasoInicial==''){
				mensajeSis("Ingresar los Días de Atraso Inicial.");
				$('#atrasoInicial').focus();
			} else if(atrasoFinal==''){
				mensajeSis("Ingresar los Días de Atraso Final.");
				$('#atrasoFinal').focus();
			}
		}
	}

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

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
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
				if (comprobarSiBisisesto(anio)){ numDias=29;}else{ numDias=28;};
				break;
			default:
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
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

});