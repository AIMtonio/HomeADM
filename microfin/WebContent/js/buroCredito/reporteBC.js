$(document).ready(function() {
		esTab = true;
	 
//Definicion de Constantes y Enums  
	var catTipoConsultaBuro = {
  		'principal':1,
  		'consultaporFolioCirculo':2
	};		
	
	var parametroBean = consultaParametrosSession();   
 	$('#folioConsulta').focus();	
	consultaParametrosSistema(); // funcion para validar la opcion por default. 
	deshabilitaBoton('generar','button');

//------------ Metodos y Manejo de Eventos -----------------------------------------


	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {	
	 	esTab = false;
	});					

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#consultaBC').attr("checked",true) ;  
	
	$('#folioConsulta').blur(function() {
	  if($('#consultaBC').is(':checked')){
  		consultaFolioBC(this.id);
	  }
	  if($('#consultaCC').is(':checked')){
	      consultaFolioCC(this.id); 
	  }
	  
	});		
	
	$('#folioConsulta').blur(function(){
		if($('#folioConsulta').val() == '' || $('#folioConsulta').val() == 0){
			limpiaformulario();
		}
	});
	
	$('#folioConsulta').bind('keyup',function(e) {
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "folioConsulta";
			camposLista[0] = "nombreCompleto";
			
			parametrosLista[0] = $('#folioConsulta').val();
			if($('#consultaBC').is(':checked')){
				lista('folioConsulta', '1', '4', camposLista, parametrosLista, 'listaFolioConsulta.htm');	
			}
			if($('#consultaCC').is(':checked')){
				lista('folioConsulta', '1', '3', camposLista, parametrosLista, 'listaFolioConsulta.htm');
			}
		}
	});

	
	$('#generar').click(function() {
		quitaFormatoControles('formaGenerica');
		var tipoReporte = 2;
		var tipoReporteCirculo = 1;
		var nombreInst = 	parametroBean.nombreInstitucion;
		var fechaCon = $('#fechaConsulta').val().substring(0,10);
		var hrCon	 =   $('#hora').val();
		var folio	=		$('#folioConsulta').val();
		var usuario	= parametroBean.claveUsuario;
		var nombreUsuario = parametroBean.nombreUsuario;
		
		if($('#consultaBC').is(':checked')){
		$('#ligaPDF').attr('href','ReporteBC.htm?programaID='+nombreInst+'&fechaConsulta='+fechaCon+'&fechaActual='+hrCon
				+'&folioConsulta='+folio+'&usuario='+nombreUsuario+"&tipoReporte="+tipoReporte);
		}
		if($('#consultaCC').is(':checked')){
			$('#ligaPDF').attr('href','ReporteCC.htm?programaID='+nombreInst+'&fechaConsulta='+fechaCon+'&fechaActual='+hrCon+'&folioConsulta='+folio+'&usuario='+$('#claveUsuario').val()+"&tipoReporte="+tipoReporteCirculo
			+"&nombreConsultado="+$('apellidoPaterno').val()+" "+$('apellidoMaterno').val()+" "+$('primerNombre').val()+" "+$('segundoNombre').val()+" "+" "+$('tercerNombre').val()+" "
			+"&direccion="+"CALLE "+$('calle').val()+" NÚMERO INTERIOR "+", NÚMERO EXTERIOR "+", PISO "+", COLONIA"
			+"&municipio="+$('#nombreMuni').val()
			+"&edocp="+tipoReporteCirculo+"&usuarioCirculo="+$('#usuarioCirculo').val());
		}
		
	});
	
	
	
	$('#consultaBC').click(function (){		
		$('#legendtext').text('Reporte de Buró Crédito');
		$('#consultaCC').attr("checked",false) ;
		$('#consultaBC').attr("checked",true) ;
	  if($('#folioConsulta').val() != ''){
		consultaFolioBC('folioConsulta');
	  }
		
	});
	$('#consultaCC').click(function (){
		$('#legendtext').text('Reporte de Círculo Crédito');
		$('#consultaCC').attr("checked",true) ;
		$('#consultaBC').attr("checked",false) ;
	    if($('#folioConsulta').val() != ''){
		consultaFolioCC('folioConsulta');
	    }

		consultaUsuarioCirculo(parametroBean.numeroUsuario);
	});

	
	
//------------ Validaciones de Controles -------------------------------------

//Funcion para consultar el folio de Buro de Credito
	function consultaFolioBC(idControl) {
		var jqFolio  = eval("'#" + idControl + "'");
		var folioNum = $(jqFolio).val();	
		
		var folio= completaCerosIzquierda(folioNum, 10);
		
		var solicitudBeanCon = { 
				'folioConsulta' :folio,
				'empresaID':1
				};

		setTimeout("$('#cajaLista').hide();", 200);		
		if( folio != '' && !isNaN(folio) && esTab){
				habilitaBoton('generar', 'submit');
				solBuroCredServicio.consulta(catTipoConsultaBuro.principal, solicitudBeanCon,function(solicitud) {
						if(solicitud!=null){ 
							dwr.util.setValues(solicitud);							
							consultaEstado('estadoID');
							consultaLocalidad('localidadID');
							consultaMunicipio('municipioID');
							$('#claveUsuariob').val(solicitud.claveUsuario);
							var fecha = solicitud.fechaConsulta.substring(0,16);
							$('#fechaConsulta').val(fecha);
							var fech =fecha.substring(11,16);
							$('#hora').val(fech);
											
						}else{							
							$('#folioConsulta').val("");
							$('#primerNombre').val("");
							$('#segundoNombre').val("");
							$('#terceroNombre').val("");
							$('#apellidoPaterno').val("");
							$('#apellidoMaterno').val("");
							$('#RFC').val("");
							$('#fechaNacimiento').val("");
						  
							$('#calle').val("");
							$('#numeroExterior').val("");
							$('#numeroInterior').val("");
							$('#piso').val("");
							$('#lote').val("");
							$('#manzana').val("");
							$('#nombreColonia').val("");
							$('#estadoID').val("");
							$('#municipioID').val("");
							$('#coloniaID').val("");
							$('#nombreEstado').val("");
							$('#nombreMuni').val("");
							$('#CP').val("");
							$('#fechaConsulta').val("");
							$('#diasVigencia').val("");
							$('#localidadID').val("");
							$('#nombreLocalidad').val("");
							
							$('#folioConsulta').focus();
							$('#folioConsulta').select();
						deshabilitaBoton('generar', 'submit');
						}
				});										
											 				
		}
	}
// Funcion para consultar el folio de Circulo de credito
	function consultaFolioCC(idControl) {
		var jqFolio  = eval("'#" + idControl + "'");
		var folio = $(jqFolio).val();	
		
		var solicitudBeanCon = { 
		'folioConsultaC' :folio
		};		

		setTimeout("$('#cajaLista').hide();", 200);

		if( folio != '' && !isNaN(folio)){
			habilitaBoton('generar', 'submit');
			  solBuroCredServicio.consulta(catTipoConsultaBuro.consultaporFolioCirculo, solicitudBeanCon,function(solicitud) {
				if(solicitud!=null){ 
						dwr.util.setValues(solicitud);
						$('#claveUsuario').val(solicitud.claveUsuario);						
						consultaEstado('estadoID');
						consultaLocalidad('localidadID');
						consultaMunicipio('municipioID');	
						var fecha = solicitud.fechaConsulta.substring(0,16);
						$('#fechaConsulta').val(fecha);
						var fech =fecha.substring(11,16);
						$('#hora').val(fech);
						$('#usuarioCirculo').val(solicitud.usuario);
											
					}else{						
						$('#folioConsulta').val("");;
						$('#primerNombre').val("");
						$('#segundoNombre').val("");
						$('#terceroNombre').val("");
						$('#apellidoPaterno').val("");
						$('#apellidoMaterno').val("");
						$('#RFC').val("");
						$('#fechaNacimiento').val("");
						  
						$('#calle').val("");
						$('#numeroExterior').val("");
						$('#numeroInterior').val("");
						$('#piso').val("");
						$('#lote').val("");
						$('#manzana').val("");
						$('#nombreColonia').val("");
						$('#estadoID').val("");
						$('#municipioID').val("");
						$('#coloniaID').val("");
						$('#nombreEstado').val("");
						$('#nombreMuni').val("");
						$('#nombreLocalidad').val("");
						$('#localidadID').val("");
						$('#CP').val("");
						$('#fechaConsulta').val("");
						$('#diasVigencia').val("");
							
						$('#folioConsulta').focus();
						$('#folioConsulta').select();
						deshabilitaBoton('generar', 'submit');
						}
				});										
											 				
		}
	}	 
	

	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && esTab){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
						if(estado!=null){							
							$('#nombreEstado').val(estado.nombre);
																	
						}else{
							alert("No Existe el Estado");
							$('#estadoID').focus();
							$('#estadoID').select();
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
		if(numMunicipio != '' && !isNaN(numMunicipio) && esTab && $(jqMunicipio).asNumber()>0){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
						if(municipio!=null){							
							$('#nombreMuni').val(municipio.nombre);
																	
						}else{
							alert("No Existe el Municipio");
								$('#municipioID').focus();
								$('#municipioID').select();
						}    	 						
				});
			}
		}
	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();				
		var tipConPrincipal = 1;		
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numLocalidad != '' && !isNaN(numLocalidad) && esTab && $(jqLocalidad).asNumber()>0){
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {			
				if(localidad!=null){							
				  $('#nombreLocalidad').val(localidad.nombreLocalidad);
				}else{
				  alert("No Existe la Localidad");
				  $('#nombreLocalidad').val("");
				  $('#localidadID').val("");
				  $('#localidadID').focus();
				  $('#localidadID').select();
				}    	 						
			});
		}
	}
 // funcion para Completar con Ceros a la Izquierda de una Cadena
	function   completaCerosIzquierda(cadena, longitud) {
	  var strPivote = '';
	  var i=0;	
	  var longitudCadena=cadena.toString().length;
	  var cadenaString=cadena.toString();
	
	  for ( i = longitudCadena; i < longitud; i++) {
		strPivote = strPivote + '0';
	  }
	
	  return strPivote +cadenaString;
	}
	
	
	// funcion para validar si el usuario puede realizar consultas a circulo de credito.
	function consultaUsuarioCirculo(numUsuario) {
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			var usuarioBeanCon = {
					'usuarioID':numUsuario 
			};
			usuarioServicio.consulta(1,usuarioBeanCon,function(usuario) {
				if(usuario!=null){
					if(usuario.realizaConsultasCC == 'S'){
						$('#usuarioCirculo').val(usuario.usuarioCirculo);
						$('#contrasenaCirculo').val(usuario.contrasenaCirculo);
						$('#realizaConsultasCC').val('S');
						habilitaBoton('consulta');
					}
//					else if(usuario.realizaConsultasCC == 'N'){
//						$('#usuarioCirculo').val('');
//						$('#contrasenaCirculo').val('');
//						$('#realizaConsultasCC').val('N');
//						alert("El Usuario No Puede Realizar Consultas a Círculo de Crédito ");
//						deshabilitaBoton('consulta'); 
//					}						
				}else{
					$('#usuarioCirculo').val('');
					$('#contrasenaCirculo').val('');
					$('#realizaConsultasCC').val('N');													
				}
			});			
							
		}
	}
	
	// Consulta de Parametro de sistema para obtener valor a seleccionar por default 
	function consultaParametrosSistema() {			
		setTimeout("$('#cajaLista').hide();", 200);
		var parametrosSisCon ={
	 		 	'empresaID' : 1
		};				
		parametrosSisServicio.consulta(1,parametrosSisCon, function(varParamSistema) {
			if (varParamSistema != null) {			
				if (varParamSistema.conBuroCreDefaut == 'B') {	// si tiene por default Buro 					
					$('#consultaCC').attr("checked",false) ;
					$('#consultaBC').attr("checked",true) ;
					
				}else{	// si tiene por default Circulo
					esTab = true;
					$('#consultaCC').attr("checked",true) ;
					$('#consultaBC').attr("checked",false) ;
					consultaUsuarioCirculo(parametroBean.numeroUsuario);
				}
			} 
		});
	}
	
	function limpiaformulario(){		
		$('#folioConsulta').val("");;
		$('#primerNombre').val("");
		$('#segundoNombre').val("");
		$('#terceroNombre').val("");
		$('#apellidoPaterno').val("");
		$('#apellidoMaterno').val("");
		$('#RFC').val("");
		$('#fechaNacimiento').val("");
		  
		$('#calle').val("");
		$('#numeroExterior').val("");
		$('#numeroInterior').val("");
		$('#piso').val("");
		$('#lote').val("");
		$('#manzana').val("");
		$('#nombreColonia').val("");
		$('#estadoID').val("");
		$('#municipioID').val("");
		$('#coloniaID').val("");
		$('#nombreEstado').val("");
		$('#nombreMuni').val("");
		$('#nombreLocalidad').val("");
		$('#localidadID').val("");
		$('#CP').val("");
		$('#fechaConsulta').val("");
		$('#diasVigencia').val("");
			
		$('#folioConsulta').focus();
		$('#folioConsulta').select();
		deshabilitaBoton('generar', 'submit');
		
	}
	
});

function limpiaformulario2(){		
	$('#folioConsulta').val("");;
	$('#primerNombre').val("");
	$('#segundoNombre').val("");
	$('#terceroNombre').val("");
	$('#apellidoPaterno').val("");
	$('#apellidoMaterno').val("");
	$('#RFC').val("");
	$('#fechaNacimiento').val("");
	  
	$('#calle').val("");
	$('#numeroExterior').val("");
	$('#numeroInterior').val("");
	$('#piso').val("");
	$('#lote').val("");
	$('#manzana').val("");
	$('#nombreColonia').val("");
	$('#estadoID').val("");
	$('#municipioID').val("");
	$('#coloniaID').val("");
	$('#nombreEstado').val("");
	$('#nombreMuni').val("");
	$('#nombreLocalidad').val("");
	$('#localidadID').val("");
	$('#CP').val("");
	$('#fechaConsulta').val("");
	$('#diasVigencia').val("");
		
	$('#folioConsulta').focus();
	$('#folioConsulta').select();
	deshabilitaBoton('generar', 'submit');
	
}