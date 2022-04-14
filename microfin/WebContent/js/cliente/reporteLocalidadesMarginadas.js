$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	
	var catTipoRepOpVentanilla = { 
			
			'PDF'		: 2,
			'Excel'		: 3 
	};
	
	
	
//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	agregaFormatoControles('formaGenerica');
	
	$('#pdf').attr("checked",true) ; 
	
	$(':text').focus(function() {	
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	//poner valores pordefault
	$('#estadoMarginadasID').val(0);
	$('#nombreEstadoMarginadas').val('TODOS');
	$('#municipioMarginadasID').val(0);
	$('#nombreMunicipioMarginadas').val('TODOS');
	$('#localidadMarginadasID').val(0);
	$('#nombreLocalidadMarginadas').val('TODAS');
	$('#fechaInicioLocMarginada').val(parametroBean.fechaSucursal);
	$('#fechaFinalLocMarginada').val(parametroBean.fechaSucursal);
	

	$('#estadoMarginadasID').change(function(){
		if(this.value == 0){
			$('#estadoMarginadasID').val(0);
			$('#nombreEstadoMarginadas').val('TODOS');
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


		
	$('#estadoMarginadasID').bind('keyup',function(e){
		lista('estadoMarginadasID', '2', '1', 'nombre', $('#estadoMarginadasID').val(), 'listaEstados.htm');
	});
	
	$('#municipioMarginadasID').bind('keyup',function(e){		
		var camposLista = new Array();
		var parametrosLista = new Array();				
		camposLista[0] = "estadoID"; //valor que trae de la anterior
		camposLista[1] = "nombre";		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioMarginadasID').val();
		
		lista('municipioMarginadasID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});
	
	$('#localidadMarginadasID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";
		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#localidadMarginadasID').val();
		
		lista('localidadMarginadasID', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
	});
	
	$('#estadoMarginadasID').blur(function() {
  		consultaEstado(this.id);
  		$('#estadoID').val(	$('#estadoMarginadasID').val());
	});
	$('#municipioMarginadasID').blur(function() {
  		consultaMunicipio(this.id);
  		$('#municipioID').val(	$('#municipioMarginadasID').val());
	});
	
	$('#localidadMarginadasID').blur(function() {
		consultaLocalidad(this.id);
	});

	//-------  Funciones------///	
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && numEstado >0){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if(estado!=null){							
					$('#nombreEstadoMarginadas').val(estado.nombre);					
				}else{
					alert("No Existe el Estado");					
					$('#estadoMarginadas').focus();
					$('#estadoMarginadas').val("0");
					$('#nombreEstadoMarginadas').val("TODOS");
				} 				
			});
		}else{
			$('#estadoMarginadasID').val("0");
			$('#nombreEstadoMarginadas').val('TODOS');

		}
	}
	
	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio) && numMunicipio >0 ){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
				if(municipio!=null){							
					$('#nombreMunicipioMarginadas').val(municipio.nombre);
				}else{
					alert("No Existe el Municipio");
					$('#nombreMunicipioMarginadas').val("TODOS");
					$('#municipioMarginadasID').val("0");
					$('#municipioMarginadasID').focus();
				}				
			});
		}else{
			$('#nombreMunicipioMarginadas').val("TODOS");
			$('#municipioMarginadasID').val("0");
		}
	}	
	
	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numLocalidad != '' && !isNaN(numLocalidad)  && numLocalidad >0){
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
				if(localidad!=null){							
					$('#nombreLocalidadMarginadas').val(localidad.nombreLocalidad);
				}else{
					alert("No Existe la Localidad");
					$('#nombrelocalidad').val("TODAS");
					$('#localidadMarginadasID').val("0");
					$('#localidadMarginadasID').focus();
					
				}    	 						
			});
		}else{
			$('#nombreLocalidadMarginadas').val("TODAS");
			$('#localidadMarginadasID').val("0");							
		}
	}

	
	function generaPDF() {	
		if($('#pdf').is(':checked')){	
			$('#excel').attr("checked",false); 
			var tipoReporte= 2; 
			var numRep = 1;
			var estadoMarginadasID = $('#estadoMarginadasID').val();
			var nombreEstadoMarginadas = $('#nombreEstadoMarginadas').val();
			var municipioMarginadasID = $('#municipioMarginadasID').val();
			var nombreMunicipioMarginadas = $('#nombreMunicipioMarginadas').val();
			var localidadMarginadasID = $('#localidadMarginadasID').val();
			var nombreLocalidadMarginadas = $('#nombreLocalidadMarginadas').val();
			
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			
			$('#ligaGenerar').attr('href','generaRepLocMarginadas.htm?estadoMarginadasID='+estadoMarginadasID+
					'&nombreEstadoMarginadas='+nombreEstadoMarginadas+'&municipioMarginadasID='+municipioMarginadasID+
					'&nombreMunicipioMarginadas='+nombreMunicipioMarginadas+'&localidadMarginadasID='+localidadMarginadasID+
					'&nombreLocalidadMarginadas='+nombreLocalidadMarginadas+'&nombreUsuario='+usuario+'&tipoReporte='+tipoReporte+
					'&fechaEmision='+fechaEmision+'&nombreInstitucion='+nombreInstitucion+'&numRep='+numRep);
		}
	}
	
	// cachando los valores que necesito para el reporte de excel
	function generaExcel() {
		
		if($('#excel').is(':checked')){	
			$('#pdf').attr("checked",false) ;
			var tipoReporte= 3;
			var tipoLista = 1;
			var estadoMarginadasID = $('#estadoMarginadasID').val();
			var nombreEstadoMarginadas = $('#nombreEstadoMarginadas').val();
			var municipioMarginadasID = $('#municipioMarginadasID').val();
			var nombreMunicipioMarginadas = $('#nombreMunicipioMarginadas').val();
			var localidadMarginadasID = $('#localidadMarginadasID').val();
			var nombreLocalidadMarginadas = $('#nombreLocalidadMarginadas').val();
			
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
	
						
			$('#ligaGenerar').attr('href','generaRepLocMarginadas.htm?estadoMarginadasID='+estadoMarginadasID+
					'&nombreEstadoMarginadas='+nombreEstadoMarginadas+'&municipioMarginadasID='+municipioMarginadasID+
					'&nombreMunicipioMarginadas='+nombreMunicipioMarginadas+'&localidadMarginadasID='+localidadMarginadasID+
					'&nombreLocalidadMarginadas='+nombreLocalidadMarginadas+'&nombreUsuario='+usuario+'&tipoReporte='+tipoReporte+
					'&fechaEmision='+fechaEmision+'&nombreInstitucion='+nombreInstitucion+'&tipoLista='+tipoLista);
			
		}
	}

	
});
	