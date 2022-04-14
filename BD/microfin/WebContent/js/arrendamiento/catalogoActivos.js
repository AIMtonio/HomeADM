// DECLARACION DE VARIABLES
var parametroBean = consultaParametrosSession();
var estaAseguradoSi = 'S';
var estaAseguradoNo = 'N';
$(document).ready(function() {
	esTab = false;		
	// Definicion de Constantes y Enums
	var catTipoTransaciones = {
			'agregar' : 1,
			'modificar' : 2
	};
	
	var catTipoListas = {
			'activosInactivosLigados' : 1
	};
	
	var catTipoConsulta = {
			'principalActivos' : 1
	};
	
	var catTipoConsultaSubtipos = {
			'subtiposPrincipal' : 1
	};
	
	var catTipoListaSubtipos = {
			'subtiposLista' : 1
	};
	
	var catTipoConsultaMarcas = {
			'marcasPrincipal' : 1
	};
	
	var catTipoListaMarcas = {
			'marcasLista' : 1
	};
	
	var catTipoConsultaAseguradoras = {
			'principalAseguradoras' : 1
	};
	
	var catTipoListaAseguradoras = {
			'aseguradorasLis' : 1
	};
	
	var cambioFecha = false;
	// ------------ Manejo de Eventos -----------------------------------------
	// INICIALIZAR EL FORMULARIO
	inicializaFormulario();
		
	// EVENTOS
	$(':text').focus(function() {
		esTab = false;
	});
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	// Cuando se cambia el valor del combo
	$("#tipoActivo").change(function(){
		var valorSelec = $('#tipoActivo').val();
		if ( valorSelec == 0){
			mensajeSis("Seleccione un Tipo de Activo");
		}
		camposPorDefault();
		$('#activoID').val('');
		$('#tipoActivo').focus();
		$('#tipoActivo').select();
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('modificar', 'submit');
		
	});
	
	//Mostrar la lista de activos
	$('#activoID').bind('keyup',function(e) {
		if ($('#tipoActivo').val() == 0){
			$('#tipoActivo').focus();
			$('#tipoActivo').select();
			$('#activoID').val('');
		}
		if (this.value.length >= 2) {
			var camposLista = new Array();
            var parametrosLista = new Array();
            camposLista[0] = "activoID";
            camposLista[1] = "tipoActivo";
            parametrosLista[0] = $('#activoID').val();
            parametrosLista[1] = $('#tipoActivo').val();
            lista('activoID', '2', catTipoListas.activosInactivosLigados,camposLista, parametrosLista, 'listaActivos.htm');
        }
		
	});
	
	// realizar la consulta al seleccionar un activo
	$('#activoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var activoID = $('#activoID').val();
		if(activoID != '' && !isNaN(activoID) && esTab) {
			if (activoID == 0){
				inicializaForma('formaGenerica', 'activoID');
				camposPorDefault();
				obtenerValorAsegurado();
				ocultarCamposAseguradora();
				agregaFormatoControles('formaGenerica');
				habilitaBoton('agregar', 'submit');
				deshabilitaBoton('modificar', 'submit');
			}
			else{
				consultaActivo(this.id);
			}	
		}
	});
	
	// subtipos de activos
	$('#subtipoActivoID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
            var parametrosLista = new Array();
            
            camposLista[0] = "subtipoActivoID";
            parametrosLista[0] = $('#subtipoActivoID').val();
            
            lista('subtipoActivoID', '2', catTipoListaSubtipos.subtiposLista,camposLista, parametrosLista, 'subtiposActivoLista.htm');
        }
		
	});
	
	$('#subtipoActivoID').blur(function() {
		var subtipoID = $('#subtipoActivoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(subtipoID != '' && !isNaN(subtipoID) && esTab) {
			consultaSubtipos(this.id);
		}
	});
	
	// marcas de activos
	$('#marcaID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
            var parametrosLista = new Array();
            
            camposLista[0] = "marcaID";
            parametrosLista[0] = $('#marcaID').val();
            
            lista('marcaID', '2', catTipoListaMarcas.marcasLista,camposLista, parametrosLista, 'marcasActivo.htm');
        }
		
	});
	
	$('#marcaID').blur(function() {
		var marcaID = $('#marcaID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(marcaID != '' && !isNaN(marcaID) && esTab) {
			consultaMarcas(this.id);
		}
	});
	
	// Aseguradoras
	$('#aseguradoraID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
            var parametrosLista = new Array();
            
            camposLista[0] = "aseguradoraID";
            parametrosLista[0] = $('#aseguradoraID').val();
            
            lista('aseguradoraID', '2', catTipoListaAseguradoras.aseguradorasLis,camposLista, parametrosLista, 'aseguradorasActivo.htm');
        }
		
	});
	
	$('#aseguradoraID').blur(function() {
		var aseguradoraID = $('#aseguradoraID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(aseguradoraID != '' && !isNaN(aseguradoraID) && esTab) {
			consultaAseguradoras(this.id);
		}
	});	
	
	// Direccion (estado, municipio, localidad y colonia)
	$('#estadoID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "nombre";
			parametrosLista[0] = $('#estadoID').val();
			lista('estadoID', '2', '1', camposLista, parametrosLista, 'listaEstados.htm');
        }
		
	});
	
	$('#estadoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(!isNaN($('#estadoID').val()) && esTab) {
			consultaEstado(this.id);
		}
	});
	
	$('#municipioID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "estadoID";
			camposLista[1] = "nombre";
			parametrosLista[0] = $('#estadoID').val();
			parametrosLista[1] = $('#municipioID').val();
			lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
        }
		
	});
	
	$('#municipioID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(!isNaN($('#municipioID').val()) && esTab) {
			consultaMunicipio(this.id);
		}
	});
	
	$('#localidadID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "estadoID";
			camposLista[1] = 'municipioID';
			camposLista[2] = "nombreLocalidad";			
			parametrosLista[0] = $('#estadoID').val();
			parametrosLista[1] = $('#municipioID').val();
			parametrosLista[2] = $('#localidadID').val();			
			lista('localidadID', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
        }
		
	});
	
	$('#localidadID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(!isNaN($('#localidadID').val()) && esTab) {
			consultaLocalidad(this.id);
		}
	});
	
	$('#coloniaID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "estadoID";
			camposLista[1] = 'municipioID';
			camposLista[2] = "asentamiento";			
			parametrosLista[0] = $('#estadoID').val();
			parametrosLista[1] = $('#municipioID').val();
			parametrosLista[2] = $('#coloniaID').val();			
			lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
        }
		
	});
	
	$('#coloniaID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(!isNaN($('#coloniaID').val()) && esTab) {
			consultaColonia(this.id);
		}
	});
	
	// Aseguradora
	$('#estaAseguradoSi').click(function() {
		limpiarCamposAseguradora();
		$('#estaAseguradoSi').attr("checked",true);
		$('#estaAseguradoNo').attr("checked",false);
		$('#estaAsegurado').val('S');
		verCamposAseguradora();
	});
	
	$('#estaAseguradoNo').click(function() {
		limpiarCamposAseguradora();
		$('#estaAseguradoSi').attr("checked",false);
		$('#estaAseguradoNo').attr("checked",true);
		$('#estaAsegurado').val('N');
		ocultarCamposAseguradora();
	});
	
	$('#agregar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaciones.agregar);
	});

	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaciones.modificar);
	});
	
	$("#fechaAdquisicion").change(function (){
		this.focus();
		cambioFecha = true;
	});
	
	$("#fechaAdquisicion").blur(function() {
		var fechaAdqui= $('#fechaAdquisicion').val(); 
		var fechaSis=  parametroBean.fechaAplicacion;
		if(esTab || cambioFecha){
			cambioFecha = false;
			if(esFechaValida(fechaAdqui, 'fechaAdquisicion')){
				if (mayor(fechaAdqui, fechaSis) ){
					mensajeSis("La Fecha de Adquisicion es Mayor a la de Hoy");
					$('#fechaAdquisicion').val('');
					$('#fechaAdquisicion').focus();
				}
			}else{
				$('#fechaAdquisicion').val('');
				$('#fechaAdquisicion').focus();
			}
		}
		
	});
			
	$('#fechaAdquiSeguro').change(function() {
		this.focus();
		cambioFecha = true;
	});
		
	$('#fechaAdquiSeguro').blur(function() {
		var fechaAdqui= $('#fechaAdquiSeguro').val(); 
		var fechaSis=  parametroBean.fechaAplicacion;
		if(esTab || cambioFecha){
			cambioFecha = false;
			if(esFechaValida(fechaAdqui, 'fechaAdquiSeguro')){
				if(mayor(fechaAdqui, fechaSis) ){
					mensajeSis("La Fecha de Adquisicion del Seguro es Mayor a la de Hoy");
					$('#fechaAdquiSeguro').val('');
					$('#fechaAdquiSeguro').focus();
				}
			}else{
				$('#fechaAdquiSeguro').val('');
				$('#fechaAdquiSeguro').focus();
			}
		}
	});
	
	$('#inicioCoberSeguro').change(function() {
		this.focus();
		cambioFecha = true;
	});
	
	$('#inicioCoberSeguro').blur(function() {
		var fechaIniCob= $('#inicioCoberSeguro').val(); 
		var fechaAdqui=  $('#fechaAdquiSeguro').val();
		if(esTab || cambioFecha){
			cambioFecha = false;
			if(esFechaValida(fechaIniCob, 'inicioCoberSeguro')){
				if (fechaMenor(fechaIniCob, fechaAdqui) ){
					mensajeSis("La Fecha de inicio es Menor a la Fecha de Adquisicion del Seguro");
					$('#inicioCoberSeguro').val('');
					$('#inicioCoberSeguro').focus();
				}
			}else{
				$('#inicioCoberSeguro').val('');
				$('#inicioCoberSeguro').focus();
			}
		}
	});
	
	$('#finCoberSeguro').change(function() {
		this.focus();
		cambioFecha = true;
	});
	
	$('#finCoberSeguro').blur(function() {
		var fechaIniCob= $('#inicioCoberSeguro').val(); 
		var fechaFinCob=  $('#finCoberSeguro').val();
		if(esTab || cambioFecha){
			cambioFecha = false;
			if(esFechaValida(fechaFinCob, 'finCoberSeguro')){
				if (fechaMenor(fechaFinCob, fechaIniCob) ){
					mensajeSis("La Fecha Fin es Menor a la Fecha de Inicio de Cobertura del Seguro");
					$('#finCoberSeguro').val('');
					$('#finCoberSeguro').focus();
				}
			}else{
				$('#finCoberSeguro').val('');
				$('#finCoberSeguro').focus();
			}
		}
	});
		
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoActivo',
					'accionExitosa','accionNoExitosa');
		}
	});		

	$('#porcentDepreFis').blur(function() {
		if($('#porcentDepreFis').asNumber()>999.99){
			mensajeSis('Monto Máximo 999.99');
			this.select();
		}
		if(isNaN($('#porcentDepreFis').val())){
			mensajeSis('No se admiten letras');
			this.select();
		}
	});	
	
	$('#porcentDepreAjus').blur(function() {
		if($('#porcentDepreAjus').asNumber()>999.99){
			mensajeSis('Monto Máximo 999.99');
			this.select();
		}
		if(isNaN($('#porcentDepreAjus').val())){
			mensajeSis('No se admiten letras');
			this.select();
		}
	});	
	
	$('#porcentResidMax').blur(function() {
		if($('#porcentResidMax').asNumber()>999.99){
			mensajeSis('Monto Máximo 999.99');
			this.select();
		}
		if(isNaN($('#porcentResidMax').val())){
			mensajeSis('No se admiten letras');
			this.select();
		}
	});	
	
	// ------------ Metodos -------------------------------------
	
	// consulta los estados de la repblica
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado)){
			estadosServicio.consulta(tipConForanea,numEstado,{ async: false, callback: function(estado) {
				if(estado!=null){							
					$('#estado').val(estado.nombre);
				}else{
					mensajeSis("No Existe el Estado");
					$('#estado').val("");
					$('#estadoID').val("");
					$('#estadoID').focus();
					$('#estadoID').select();
				}    	 						
			}});
		}
	}
	
	// consulta los municipios por estado
	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio)){
			if(numEstado !=''){				
				municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,{ async: false, callback: function(municipio) {
					if(municipio!=null){							
						$('#municipio').val(municipio.nombre);
					}else{
						mensajeSis("No Existe el Municipio");
						$('#municipio').val("");
						$('#municipioID').val("");
						$('#municipioID').focus();
						$('#municipioID').select();
					}    	 						
				}});
				
			}else{
				mensajeSis("Especificar Estado");
				$('#estadoID').focus();
			}
		}else{
			if(isNaN(numMunicipio) && esTab){
				mensajeSis("No Existe el Municipio");
				$('#municipio').val("");
				$('#municipioID').val("");
				$('#municipioID').focus();
				$('#municipioID').select();
				
			}
		}
	}	
	
	// consulta las localidades por estado y municipio
	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numLocalidad != '' && !isNaN(numLocalidad)){
			if(numEstado != '' && numMunicipio !=''){				
				localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,{ async: false, callback: function(localidad) {
					if(localidad!=null){							
						$('#localidad').val(localidad.nombreLocalidad);
					}else{
						mensajeSis("No Existe la Localidad");
						$('#localidad').val("");
						$('#localidadID').val("");
						$('#localidadID').focus();
						$('#localidadID').select();
					}    	 						
				}});
			}else{
				if(numEstado == ''){
					mensajeSis("Especificar Estado");
					$('#estadoID').focus();
				}else{
					mensajeSis("Especificar Municipio");
					$('#municipioID').focus();
				}
			}
			
		}
	}
	
	// consulta las colonias y su cp por estado y municipio
	function consultaColonia(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();		
		var numEstado =  $('#estadoID').val();	
		var numMunicipio =	$('#municipioID').val();
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numColonia != '' && !isNaN(numColonia)){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,{ async: false, callback: function(colonia) {
				if(colonia!=null){							
					$('#colonia').val(colonia.asentamiento);
					$('#cp').val(colonia.codigoPostal);
				}else{
					mensajeSis("No Existe la Colonia");
					$('#colonia').val("");
					$('#cp').val("");
					$('#coloniaID').val("");
					$('#coloniaID').focus();
					$('#coloniaID').select();
				}    	 						
			}});
		}else{
			$('#colonia').val("");
			$('#cp').val("");
		}
	}
	
	// consulta de activo por ID
	function consultaActivo(idControl) {
	    var jqArrenda = eval("'#" + idControl + "'");
	    var activoID = $(jqArrenda).val();	   
	    var activoBean = {
			'activoID': activoID
		};
	    setTimeout("$('#cajaLista').hide();", 200);
	    camposPorDefault();
	    if (activoID != '' && !isNaN(activoID)) {
			// se realiza consulta al servicio
	    	activoArrendaServicio.consulta(catTipoConsulta.principalActivos, activoBean,function(activo) {
	    		if (activo!=null){
	    			$('#descripcion').val((activo.descripcion).toUpperCase());
	    			$('#subtipoActivoID').val(activo.subtipoActivoID);
	    			$('#subtipoActivo').val((activo.subtipoActivo).toUpperCase());
	    			$('#marcaID').val(activo.marcaID);
	    			$('#marca').val((activo.marca).toUpperCase());
	    			$('#modelo').val((activo.modelo).toUpperCase());
	    			$('#numeroSerie').val((activo.numeroSerie).toUpperCase());
	    			$('#numeroFactura').val((activo.numeroFactura).toUpperCase());
	    			$('#valorFactura').val(activo.valorFactura);
	    			$('#costosAdicionales').val(activo.costosAdicionales);
	    			$('#fechaAdquisicion').val(activo.fechaAdquisicion);
	    			$('#vidaUtil').val(activo.vidaUtil);	
	    			$('#porcentDepreFis').val(activo.porcentDepreFis);
	    			$('#porcentDepreAjus').val(activo.porcentDepreAjus);
	    			$('#plazoMaximo').val(activo.plazoMaximo);
	    			$('#porcentResidMax').val(activo.porcentResidMax);
	    			$('#estatus').val(activo.estatus).selected = true;
	    			$('#tipoActivo').val(activo.tipoActivo).selected = true;
	    			
	    			// direccion
	    			$('#estadoID').val(activo.estadoID);
	    			$('#estado').val((activo.estado).toUpperCase());
	    			$('#municipioID').val(activo.municipioID);
	    			$('#municipio').val((activo.municipio).toUpperCase());	
	    			$('#localidadID').val(activo.localidadID);
	    			$('#localidad').val((activo.localidad).toUpperCase());
	    			$('#coloniaID').val(activo.coloniaID);
	    			$('#colonia').val((activo.colonia).toUpperCase());
	    			$('#calle').val((activo.calle).toUpperCase());
	    			$('#numeroCasa').val((activo.numeroCasa).toUpperCase());
	    			$('#numeroInterior').val((activo.numeroInterior).toUpperCase());	
	    			$('#piso').val((activo.piso).toUpperCase());
	    			$('#primerEntrecalle').val((activo.primerEntrecalle).toUpperCase());
	    			$('#segundaEntreCalle').val((activo.segundaEntreCalle).toUpperCase());
	    			$('#cp').val(activo.cp);
	    			$('#latitud').val((activo.latitud).toUpperCase());
	    			$('#longitud').val((activo.longitud).toUpperCase());
	    			$('#descripcionDom').val((activo.descripcionDom).toUpperCase());
	    			$('#lote').val((activo.lote).toUpperCase());
	    			$('#manzana').val((activo.manzana).toUpperCase());

	    			// aseguradora
	    			if((activo.estaAsegurado).toUpperCase() == estaAseguradoSi){
	    				verCamposAseguradora();
	    				$('#estaAseguradoSi').attr("checked",true);
	    				$('#estaAseguradoNo').attr("checked",false);
	    				$('#aseguradoraID').val(activo.aseguradoraID);
		    			$('#aseguradora').val((activo.aseguradora).toUpperCase());
		    			$('#fechaAdquiSeguro').val(activo.fechaAdquiSeguro);
		    			$('#inicioCoberSeguro').val(activo.inicioCoberSeguro);
		    			$('#finCoberSeguro').val(activo.finCoberSeguro);	
		    			$('#numPolizaSeguro').val((activo.numPolizaSeguro).toUpperCase());
		    			$('#sumaAseguradora').val(activo.sumaAseguradora);
		    			$('#valorDeduciSeguro').val(activo.valorDeduciSeguro);
		    			$('#observaciones').val((activo.observaciones).toUpperCase());
		    			$('#estaAsegurado').val(estaAseguradoSi);
	    			}else{
	    				// se ocultan los campos por no estar asegurado el activo
	    				ocultarCamposAseguradora();
	    				$('#estaAseguradoSi').attr("checked",false);
	    				$('#estaAseguradoNo').attr("checked",true);
	    				$('#estaAsegurado').val(estaAseguradoNo);
	    			}  			
	    				// si esta activo o inactivo se puede modificar
	    			if(activo.estatus != 'L'){
		    			habilitaBoton('modificar', 'submit');
						deshabilitaBoton('agregar', 'submit');
	    			}else{					
		    			// si esta ligado no se puede modificar
						deshabilitaBoton('modificar', 'submit');
						deshabilitaBoton('agregar', 'submit');
	    			}
	    			agregaFormatoControles('formaGenerica');
	    			$("#descripcion").focus();
	    		}else{
	    			mensajeSis("No se encontró información del Activo seleccionado.");
	    			inicializaFormulario();
	    			$("#tipoActivo").focus();
	    			$("#tipoActivo").select();
	    			deshabilitaBoton('modificar', 'submit');
					deshabilitaBoton('agregar', 'submit');
	    		}
	        });
	    }
	}
	
	// consulta de subtipos
	function consultaSubtipos(idControl) {
		var jqSubtipo = eval("'#" + idControl + "'");
		var subtipoID = $(jqSubtipo).val();
		var subtipoActivoBean = {
				'subtipoActivoID': subtipoID
		};
		
		setTimeout("$('#cajaLista').hide();", 200);		
		if(subtipoID != '' && !isNaN(subtipoID)){ 
			subtipoActivoServicio.consulta(catTipoConsultaSubtipos.subtiposPrincipal,subtipoActivoBean,function(subtiposActivo) {
				if(subtiposActivo!=null){							
					$('#subtipoActivo').val((subtiposActivo.descripcion).toUpperCase());
				}else{
					mensajeSis("No Existe el Subtipo");
					$('#subtipoActivo').val("");
					$('#subtipoActivoID').val("");
					$('#subtipoActivoID').focus();
					$('#subtipoActivoID').select();
				}    	 						
			});
		}
	}
	
	// consulta de marcas
	function consultaMarcas(idControl) {
		var jqSubtipo = eval("'#" + idControl + "'");
		var marcaID = $(jqSubtipo).val();
		var marcaActivoBean = {
				'marcaID': marcaID
		};
		
		setTimeout("$('#cajaLista').hide();", 200);		
		if(marcaID != '' && !isNaN(marcaID)){ 
			marcaActivoServicio.consulta(catTipoConsultaMarcas.marcasPrincipal,marcaActivoBean,function(marcasActivos) {
				if(marcasActivos!=null){							
					$('#marca').val((marcasActivos.descripcion).toUpperCase());
				}else{
					mensajeSis("No Existe la Marca");
					$('#marca').val("");
					$('#marcaID').val("");
					$('#marcaID').focus();
					$('#marcaID').select();
				}    	 						
			});
		}
	}
	
	// consulta Aseguradoras
	function consultaAseguradoras(idControl) {
		var jqSubtipo = eval("'#" + idControl + "'");
		var aseguradoraID = $(jqSubtipo).val();
		var aseguradoraActivoBean = {
				'aseguradoraID': aseguradoraID
		};
		
		setTimeout("$('#cajaLista').hide();", 200);		
		if(aseguradoraID != '' && !isNaN(aseguradoraID)){ 
			aseguradoraActivoServicio.consulta(catTipoConsultaAseguradoras.principalAseguradoras,aseguradoraActivoBean,function(aseguradora) {
				if(aseguradora!=null){							
					$('#aseguradora').val((aseguradora.descripcion).toUpperCase());
				}else{
					mensajeSis("No Existe la Aseguradora");
					$('#aseguradora').val("");
					$('#aseguradoraID').val("");
					$('#aseguradoraID').focus();
					$('#aseguradoraID').select();
				}    	 						
			});
		}
	}
		
	//  reglas	
	$('#formaGenerica').validate({
		rules: {
			tipoActivo: {
				required : true
			},
			activoID: {
				required : true
			},			
			descripcion: {
				required : true,
				maxlength : 150
			},
			subtipoActivoID: {
				required : true
			},    
			marcaID: {
				required : true
			},            
			modelo: {
				required : true,
				maxlength : 50
			},           
			numeroSerie: {
				required : true,
			 	maxlength	: 45
			},      
			numeroFactura: {
				required : true,
				maxlength	: 10
			},    
			valorFactura: {
				required :  true
			},     
			costosAdicionales: {
				required : false
			},
			fechaAdquisicion: {
				required : true,
				date : true
			}, 
			vidaUtil: {
				required : true,
				number: true,
				numeroMayorCero : true
			},         
			porcentDepreFis: {
				maxlength : 6
				
			},  
			porcentDepreAjus: {
				maxlength : 6
			}, 
			plazoMaximo: {
				required : true,
				numeroMayorCero : true
			},      
			porcentResidMax: {
				maxlength : 6
			},  
			estatus: {
				required :  true
			},			
			estadoID: {
				required : true
			},
			municipioID: {
				required : true
			},	
			localidadID: {
				required : true
			},
			coloniaID: {
				required : true
			},
			calle: {
				required : true, 
				maxlength : 50
			},
			numeroCasa: {
				required : true,
				maxlength : 10
			},
			numeroInterior: {
				required : false,
				maxlength : 10
			},	
			piso: {required : false,
				   maxlength : 50
		    },
			primerEntrecalle: {
				required : false,
				maxlength : 50
			},
			segundaEntreCalle: {
				required : false,
				maxlength : 50
			},
			cp: {
				required : true,
				maxlength : 5
			},
			latitud: {
				required : false,
				maxlength : 45
			},
			longitud: {
				required : false,
				maxlength : 45
			},
			descripcionDom: {
				required : true,
				maxlength : 200
			},
			lote: {
				required : false,
				maxlength : 50
			},
			manzana: {
				required : false,
				maxlength : 50
			},
			aseguradoraID: {
				required :  function() { if($('#estaAseguradoSi').is(':checked')) return true; else return false;}
			},
			numPolizaSeguro: {
				required :  function() { if($('#estaAseguradoSi').is(':checked')) return true; else return false;},
				maxlength : 20
			},
			fechaAdquiSeguro: {
				required :  function() { if($('#estaAseguradoSi').is(':checked')) return true; else return false;},
				date: true
			},
			inicioCoberSeguro: {
				required :  function() { if($('#estaAseguradoSi').is(':checked')) return true; else return false;},
				date: true
			},
			finCoberSeguro: {
				required :  function() { if($('#estaAseguradoSi').is(':checked')) return true; else return false;},
				date: true
			},
			sumaAseguradora: {
				required :  function() { if($('#estaAseguradoSi').is(':checked')) return true; else return false;}
			},
			valorDeduciSeguro: {
				required :  function() { if($('#estaAseguradoSi').is(':checked')) return true; else return false;}
			},
			observaciones: {
				required :  function() { if($('#estaAseguradoSi').is(':checked')) return true; else return false;},
				maxlength : 200
			}
			
		},
		messages: {
			tipoActivo: {
				required : 'Especifique el Tipo de Activo' 
			},
			activoID: {
				required : 'Especifique el ID del activo'
			},			
			descripcion: {
				required : 'Especifique la Descripcion del producto',
				maxlength : 'Máximo 150 caracteres'
			},
			subtipoActivoID: {
				required : 'Especifique el Subtipo del Activo'
			},    
			marcaID: {
				required : 'Especifique la Marca del Activo'
			},            
			modelo: {
				required : 'Especifique el Modelo del Activo',
				maxlength : 'Máximo 50 caracteres'
			},           
			numeroSerie: {
				required : 'Especifique el Num. de Serie',
			 	maxlength	: 'Máximo 45 caracteres'
			},      
			numeroFactura: {
				required : 'Especifique el Num. de la Factura',
				maxlength	: 'Máximo 10 caracteres'
			},    
			valorFactura: {
				required : 'Especifique el valor Factura'
			},
			fechaAdquisicion: {
				required : 'Especifique la Fecha de Adquisición',
				date : 'Fecha Incorrecta'
			}, 
			vidaUtil: {
				required : 'Especifique la vida util en meses',
				number: 'Sólo números',
				numeroMayorCero : 'Vida Util vacia'
			},
			plazoMaximo: {
				required : 'Especifique el Plazo Maximo',
				numeroMayorCero : 'Plazo Maximo vacio'
			},  
			estatus: {
				required : 'Especifique el Estatus'
			},			
			estadoID: {
				required : 'Especifique el Estado'
			},
			municipioID: {
				required : 'Especifique el Municipio'
			},	
			localidadID: {
				required : 'Especifique la Localidad'
			},
			coloniaID: {
				required : 'Especifique la colonia'
			},
			calle: {
				required : 'Especifique la Calle', 
				maxlength : 'Máximo 50 caracteres'
			},
			numeroCasa: {
				required : 'Especifique el Num. del Domicilio',
				maxlength : 'Máximo 10 caracteres'
			},
			numeroInterior: {
				maxlength : 'Máximo 10 caracteres'
			},	
			piso: {
				maxlength : 'Máximo 50 caracteres'
		    },
			primerEntrecalle: {
				maxlength : 'Máximo 50 caracteres'
			},
			segundaEntreCalle: {
				maxlength : 'Máximo 50 caracteres'
			},
			cp: {
				required : 'Especifique el CP',
				maxlength : 'Máximo 5 caracteres'
			},
			latitud: {
				maxlength : 'Máximo 45 caracteres'
			},
			longitud: {
				maxlength : 'Máximo 45 caracteres'
			},
			descripcionDom: {
				required : 'Especifique la Descripcion del Domicilio',
				maxlength : 'Máximo 200 caracteres'
			},
			lote: {
				maxlength : 'Máximo 50 caracteres'
			},
			manzana: {
				maxlength : 'Máximo 50 caracteres'
			},
			aseguradoraID: {
				required : 'Especifique la Aseguradora'
			},
			numPolizaSeguro: {
				required : 'Especifique el Num. de Poliza del Seguro',
				maxlength : 'Máximo 20 caracteres'
			},
			fechaAdquiSeguro: {
				required : 'Especifique la Fecha de Adquisición',
				date : 'Fecha Incorrecta'
			},
			inicioCoberSeguro: {
				required : 'Especifique la Fecha de Inicio de cobertura del seguro',
				date : 'Fecha Incorrecta'
			},
			finCoberSeguro: {
				required : 'Especifique la Fecha Fin de la cobertura del seguro',
				date : 'Fecha Incorrecta'
			},
			sumaAseguradora: {
				required : 'Especifique la Suma Asegurada'
			},
			valorDeduciSeguro: {
				required : 'Especifique el valor deducible del seguro'
			},
			observaciones: {
				required : 'Especifique las observaciones',
				maxlength : 'Máximo 200 caracteres'
			},
			porcentDepreFis:{
				maxlength : 'Monto Máximo: 999.99'
			},
			porcentDepreAjus:{
				maxlength : 'Monto Máximo: 999.99'
			},
			porcentResidMax:{
				maxlength : 'Monto Máximo: 999.99'
			}
			
		}		
	});
	
		
});// fin del Document

// inicializa el formulario
function inicializaFormulario(){
	inicializaForma('formaGenerica', 'tipoActivo');
	camposPorDefault();
	agregaFormatoControles('formaGenerica');
	obtenerValorAsegurado();
	$('#tipoActivo').val(0).selected = true;
	$('#tipoActivo').focus();
	$('#tipoActivo').select();
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modificar', 'submit');
}

//campos en pantalla por default
function camposPorDefault(){
	$('#descripcion').val('');
	$('#subtipoActivoID').val('');
	$('#subtipoActivo').val('');
	$('#marcaID').val('');
	$('#marca').val('');
	$('#modelo').val('');
	$('#numeroSerie').val('');
	$('#numeroFactura').val('');
	$('#valorFactura').val('0.0');
	$('#costosAdicionales').val('0.0');
	$('#fechaAdquisicion').val(parametroBean.fechaAplicacion);
	$('#vidaUtil').val('0');	
	$('#porcentDepreFis').val('0.0');
	$('#porcentDepreAjus').val('0.0');
	$('#plazoMaximo').val('0');
	$('#porcentResidMax').val('0.0');
	$('#estatus').val(0).selected = true;
	
	// Direccion
	$('#estadoID').val('');
	$('#estado').val('');
	$('#municipioID').val('');
	$('#municipio').val('');	
	$('#localidadID').val('');
	$('#localidad').val('');
	$('#coloniaID').val('');
	$('#colonia').val('');
	$('#calle').val('');
	$('#numeroCasa').val('');
	$('#numeroInterior').val('');	
	$('#piso').val('');
	$('#primerEntrecalle').val('');
	$('#segundaEntreCalle').val('');
	$('#cp').val('');
	$('#latitud').val('');
	$('#longitud').val('');
	$('#descripcionDom').val('');
	$('#lote').val('');
	$('#manzana').val('');
	
	$('#tipoTransaccion').val("");
	// Aseguradora
	limpiarCamposAseguradora();
}

function ocultarCamposAseguradora(){
	$('#secAseguradora').hide(500);
}

function verCamposAseguradora(){
	$('#secAseguradora').show(500);
}

function obtenerValorAsegurado(){
	if($('#estaAseguradoSi').is(':checked')){
		$('#estaAsegurado').val(estaAseguradoSi);
	}else if($('#estaAseguradoNo').is(':checked')){
		$('#estaAsegurado').val(estaAseguradoNo);
	}
}

function limpiarCamposAseguradora(){
	$('#estaAseguradoSi').attr("checked",false);
	$('#estaAseguradoNo').attr("checked",true);
	$('#estaAsegurado').val('');
	$('#aseguradoraID').val('');
	$('#aseguradora').val('');
	$('#fechaAdquiSeguro').val(parametroBean.fechaAplicacion);
	$('#inicioCoberSeguro').val(parametroBean.fechaAplicacion);
	$('#finCoberSeguro').val(parametroBean.fechaAplicacion);	
	$('#numPolizaSeguro').val('');
	$('#sumaAseguradora').val(0.0);
	$('#valorDeduciSeguro').val(0.0);
	$('#observaciones').val('');
	$('#secAseguradora').hide();
	agregaFormatoControles('formaGenerica');
}

function accionExitosa(){
	inicializaFormulario();
	$('#tipoActivo').focus();
}

function accionNoExitosa(){
	agregaFormatoControles('formaGenerica');
}

//valida si fecha > fecha2: true else false
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

//valida si fecha < fecha2: true else false
function fechaMenor(fecha, fecha2){
	var xMes=fecha.substring(5, 7);
	var xDia=fecha.substring(8, 10);
	var xAnio=fecha.substring(0,4);

	var yMes=fecha2.substring(5, 7);
	var yDia=fecha2.substring(8, 10);
	var yAnio=fecha2.substring(0,4);
	
	if (xAnio > yAnio){
		return false;
	} else{
		if (xAnio == yAnio){
			if (xMes > yMes){
				return false;
			} else if (xMes == yMes){
				if (xDia > yDia){
					return false;
				} else if (xDia == yDia){
					return false;
				} else{
					return true;
				}
			} else{
				return true;
			}
		} else{
			return true ;
		}
	} 
}

// Se valida la fecha
function esFechaValida(fecha,idfecha) {
	if (fecha != undefined && fecha != "") {
		
		var mes = fecha.substring(5, 7) * 1;
		var dia = fecha.substring(8, 10) * 1;
		var anio = fecha.substring(0, 4) * 1;

		switch (mes) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			numDias = 31;
			break;
		case 4:
		case 6:
		case 9:
		case 11:
			numDias = 30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)) {
				numDias = 29;
			} else {
				numDias = 28;
			}
			;
			break;
		default:
			mensajeSis("Formato de Fecha no Valido (aaaa-mm-dd)");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
		return false;
		}
		if (dia > numDias || dia == 0) {
			mensajeSis("Formato de Fecha no Valido (aaaa-mm-dd)");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
			return false;
		}
		return true;
	}
}