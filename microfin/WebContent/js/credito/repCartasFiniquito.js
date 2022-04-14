$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var atrasoInicial = 0;
	var atrasoFinal = 99999;
	var parametroBean = consultaParametrosSession();   

	var catTipoConsultaInstitucion = {
			'principal':1 
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	
	consultaSucursal();
	consultaMoneda(); 
	$('#promotorID').val(0);
	$('#institNominaID').val(0);
	$('#estadoID').val(0);
	$('#municipioID').val(0);
	$('#sucursal').val(0);
	$('#producCreditoID').val(0);
	$('#nombrePromotorI').val('TODOS');	
	$('#nombreInstit').val('TODAS');
	$('#nombreEstado').val('TODOS');	
	$('#nombreMuni').val('TODOS');
	$('#nombreSucursal').val('TODOS');
	$('#nomProducto').val('TODOS');

	$('#atrasoInicial').val(atrasoInicial);
	$('#atrasoFinal').val(atrasoFinal);
	
	$('#pdf').attr("checked",true) ; 
	$('#detallado').attr("checked",true) ; 



	$(':text').focus(function() {	
		esTab = false;
	});

	$('#sucursal').bind('keyup',function(e){
		lista('sucursal', '2', '4', 'nombreSucurs', $('#sucursal').val(), 'listaSucursales.htm');
	});

	$('#sucursal').blur(function() {
		consultaSucursal(this.id);
	});

	$('#producCreditoID').bind('keyup',function(e) {
		lista('producCreditoID', '2', '1','descripcion', $('#producCreditoID').val(),'listaProductosCredito.htm');
	});

	
	$('#promotorID').bind('keyup',function(e){
		lista('promotorID', '1', '1', 'nombrePromotor',
				$('#promotorID').val(), 'listaPromotores.htm');
	});	

	$('#institNominaID').bind('keyup',function(e) {
		lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
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

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){	
			$('#tdPresenacion').show('slow');
		}
	});

	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});

	$('#producCreditoID').blur(function() {
		if($('#producCreditoID').val()=="0" || $('#producCreditoID').val()==""){
			$('#producCreditoID').val("0");
			$('#nomProducto').val("TODOS");

			$('#lblNomina').show();
			$('#institNominaID').show();
			$('#nombreInstit').show();
		}else{
			esTab=true;
			consultaProducCredito(this.id);
		}
		
	});

	$('#institNominaID').blur(function(){
		validaInstitucionNomina(this.id);
	});
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimien').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaVencimien').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimien').val();
		var fechaAplicacion = parametroBean.fechaAplicacion;
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimien').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaVencimien').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaVencimien').val(parametroBean.fechaSucursal);
		}

		if (Yfecha > fechaAplicacion && Yfecha != '') {
						alert('La fecha Fin no puede ser mayor a la del sistema');
						$('#fechaVencimien').focus();
						$('#fechaVencimien').select();
						$('#fechaVencimien').val('');
					}
	});

	$('#estadoID').blur(function() {
		consultaEstado(this.id);
	});

	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
	});
	

	$('#generar').click(function(){
		var reportePDF = 1;
		enviaDatosCartasFiniquito(reportePDF); 
		
	});
	
	$('#formaGenerica').validate({
		rules: {
			fechaInicio :{
				required: true
			},
			fechaVencimien :{
				required: true
			}
		},
		
		messages: {
			fechaInicio :{
				required: 'Especifica Fecha Inicio.'
			}
			,fechaVencimien :{
				required: 'Especifica Fecha Fin.'
			}
		}
	});

	// ***********  Inicio  validacion Promotor, Estado, Municipio  ***********

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
						alert("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotorI').val('TODOS');
					}    	 						
				});
			}
	}

	// ------------ Validaciones de Institución de Nómina-------------------------------------	
	
	function validaInstitucionNomina(idControl) {
		var jqInstitucion  = eval("'#" + idControl + "'");
		var numInstitucion = $(jqInstitucion).val();
		var institNominaBean = {
				'institNominaID': numInstitucion
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numInstitucion == '' || numInstitucion==0){
			$(jqInstitucion).val(0);
			$('#nombreInstit').val('TODAS');
		}
		else	

			if(numInstitucion != '' && !isNaN(numInstitucion) ){ 
				institucionNomServicio.consulta(catTipoConsultaInstitucion.principal,institNominaBean,function(institNominaBean) {
					if(institNominaBean!=null){							
						$('#nombreInstit').val(institNominaBean.nombreInstit); 

					}else{
						alert("No Existe la Empresa de Nómina");
						$(jqInstitucion).val(0);
						$('#nombreInstit').val('TODAS');
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
						alert("No Existe el Estado");
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
				alert("No ha selecionado ningún estado.");
				$('#estadoID').focus();
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
						alert("No Existe el Municipio");
						$('#municipioID').val(0);
						$('#nombreMuni').val('TODOS');
					}    	 						
				});
			}
	}	

	// fin validacion Promotor, Estado, Municipio

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && numSucursal != 0) {
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#nombreSucursal').val(sucursal.nombreSucurs);
						} else {
							alert("No Existe la Sucursal");
							$('#sucursalID').val('0');
							$('#nombreSucursal').val('TODAS');
						}
					});
		}
		else{
			$('#sucursalID').val('0');
			$('#nombreSucursal').val('TODAS');
		}
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimien').val(parametroBean.fechaSucursal);


	function consultaMoneda() {		
		var tipoCon = 3;
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'TODAS'});
		monedasServicio.listaCombo(tipoCon, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}


	function consultaProducCredito(idControl) {				
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();		
		var tipConPrincipal = 1;		
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);


		if(ProdCred != '' && !isNaN(ProdCred)){		
			productosCreditoServicio.consulta(tipConPrincipal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					if(prodCred.productoNomina == 'S'){											
							$('#lblNomina').show();
							$('#institNominaID').show();
							$('#nombreInstit').show();

						}else{
							$('#lblNomina').hide();
							$('#institNominaID').hide();
							$('#nombreInstit').hide();
						} 
					$('#nomProducto').val(prodCred.descripcion);							
				}else{
					alert("No Existe el Producto de Crédito");
					$('#producCreditoID').val('0');	
					$('#nomProducto').val('TODOS');	
					$(jqProdCred).focus();	
				}
			});
		}				 					
	}  
	

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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
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


	function enviaDatosCartasFiniquito(tipoReporte){
		var fechaInicio=$('#fechaInicio').val();
		var fechaFinal=$('#fechaVencimien').val();
		var sucursal=$('#sucursal').val();
		var moneda=$('#monedaID').val();
		var productoCredito=$('#producCreditoID').val();
		var institucion=$('#institNominaID').val();
		var promotor=$('#promotorID').val();
		var sexo=$('#sexo').val();
		var estado=$('#estadoID').val();
		var municipio=$('#municipioID').val();
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
	
		if(sexo=='0'){
			sexo='';
		}
			var pagina ='reporteCartasFiniquito.htm?fechaInicio='+fechaInicio+'&fechaFin='+fechaFinal+'&sucursalID='+sucursal+
			'&monedaID='+moneda+'&producCreditoID='+productoCredito+'&institucionNominaID='+institucion+'&promotorID='+promotor+
			'&genero='+sexo+'&estadoID='+estado+'&municipioID='+municipio+'&nombreInstitucion='+nombreInstitucion;
			window.open(pagina,'_blank');
	
		
		}


});
