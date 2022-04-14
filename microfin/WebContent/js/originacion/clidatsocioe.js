var varEstatusCliente = '';
var tab2=false;
var tipoIndenConyuge ="";
var esTab = false;
var conyugeID=null;
var campoValorConsecutivo='clienteID';

listaPersBloqBean = {
		'estaBloqueado'	:'N',
		'coincidencia'	:0
};

consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

var esCliente 			='CTE';
var esProspecto			='PRO';

$(document).ready(function() {	
	$("#linNegID").focus();
	camposDatosDemograficos("");
	
	//Definicion de Constantes y Enums  
	var catTipoConsultaDatosSocioEco = {
  		'principal':1,
  		'foranea':2,
  		'infoDatosSocioe':3
	};		
	
	var catTipoTranDatosSocioEco = {
  		'agrega':1,
  		'modifica':2,
  		'grabalista':3
	};
	
	var parametroBean = consultaParametrosSession();  
	llenaCombolineasNegocio();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
 	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('grabarDSE', 'submit');
	deshabilitaBoton('grabarViv', 'submit');
	deshabilitaBoton('grabarCony', 'submit');
 	$('#formaGenerica3').hide();

	agregaFormatoControles('formaGenerica');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			if(($('#clienteID').asNumber()>0) || ($('#clienteID').asNumber()>0 && $('#prospectoID').asNumber()>0)){
				campoValorConsecutivo='clienteID';
			} else if($('#clienteID').asNumber()==0 && $('#prospectoID').asNumber()>0){
				campoValorConsecutivo='prospectoID';
			}
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true', campoValorConsecutivo,'limpiaFormaGenerica','exitoError');
		}
	});					
	/* *****************************************************************************************
   	Fecha : 18-abril-2013, Bloque de funcionalidad extra para esta pantalla
 	Solicitado por FCHIA para pantalla pivote (solicitud credito grupal)
 	Valida en la pantalla de solicitud grupal el numero de solicitud (perteneciente al grupo)seleccionado 
	no eliminar, no afecta el comportamiento de la pantalla de manera individual */

    var mtoSolicitado =   $('#montSolicit').asNumber();
	if(mtoSolicitado > 0){
		$('#montSoliciDeGrupal').val(mtoSolicitado);
		$('#montSoliciDeGrupal').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
	}else{
		insertaMontoExedente(); 
	}
	var cteActual = 0;
	var proActual = 0;
	
 
	cteActual = $('#clientIDGrupal').asNumber();
	proActual = $('#prospectIDGrupal').asNumber();
	
	if(cteActual>0){
		$('#clienteID').val(cteActual);
		consultaCliente('clienteID');
	}else{
		if(proActual >0){
			$('#prospectoID').val(proActual);
			consultaProspecto('prospectoID');
		}
	}
	
	function insertaMontoExedente(){
		var td = ' <label for="lblExedente"><h3>Excedente:</h3>  </label>  '; 
		var tdMto = '<td> <h3>';
			tdMto += '<input type= "text" id="excedente"  style="text-align:right;" name="excedente" size="15" tabindex="7" disabled = "true" esMoneda="true" />';
			tdMto +='</h3></td>';
		$('#labelMontoExecente').replaceWith(td);
		$('#trExedente').replaceWith(''); 
		$('#tdMotoExecente').replaceWith(tdMto); 
	}
	// fin  Bloque de funcionalidad extra
	/* *********************************************************************************************/	
	
//	   Bloque para consultar cliente si viene de flujo de consolidacion de créditos
		if(typeof var_consolidacion !== 'undefined')
		{
			if(var_consolidacion.clienteID != undefined)
			{
			funcionSetValoresConsolidacion();
			}
		}
//		Fin de Bloque de consolidación de créditos
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#fechaRegistro').val(parametroBean.fechaAplicacion);
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTranDatosSocioEco.grabalista);
		guardarDetalle(); 
	});
	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '1', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	}); 
 	

	$('#clienteID').blur(function() {
		var prospec = $('#prospectoID').val();
		if(prospec == '0' || prospec == ''){
			if($('#clienteID').val() == '0' || $('#clienteID').val() == '' && tab2==true){
				mensajeSis("El Cliente y Prospeto estan vacios");
				$('#prospectoID').focus();
				$('#nombreCte').val("");
				$('#nombreProspecto').val("");
				tab2 = false;
			}
		}
		if(isNaN($('#clienteID').val()) ){
			$('#clienteID').val("");
			$('#clienteID').focus();
			$('#nombreCte').val("");
			tab2 = false;
		}else{
			if(tab2 == false){
				$('#nombreProspecto').val("");
				consultaCliente(this.id);
		 	}
		}
	});
	
	$('#prospectoID').bind('keyup',function(e){
		lista('prospectoID', '1', '1', 'prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');
	});
	

	
	$('#prospectoID').blur(function() {
		var cliente = $('#clienteID').val();
		if(cliente == '0' || cliente == ''){
			if($('#prospectoID').val() == '0' || $('#prospectoID').val() == '' && tab2==true){
				mensajeSis("El Cliente y Prospeto estan vacios");
				$('#prospectoID').focus();
				$('#nombreProspecto').val("");
				$('#nombreCte').val("");
				tab2 = false;
			}
		}
		if(isNaN($('#prospectoID').val()) ){
			$('#prospectoID').val("");
			$('#prospectoID').focus();
			$('#nombreProspecto').val("");
			tab2 = false;
		} else if(tab2 == false){
				consultaProspecto(this.id);
		}
	});
	
	$('#linNegID').change(function() {
		inicializaValoresInputs();
		var prospecto = $('#prospectoID').asNumber();
		var cliente = $('#clienteID').asNumber();		
		if(cliente!=0){
			consultaCliente('clienteID');			
		}else{
			if(prospecto!=0){
				consultaProspecto('prospectoID');
			}
		}
	});


	$('#telCelular').setMask('phone-us');
	
	$('#etOcupacion').hide();
	$('#CampoOcupacion').hide();
	

	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			linNegID: { 
				required: true
			},
			extencionTrabajo: {
				number: true
			}
		},
		messages: {
			linNegID: {
				required: 'Especificar Linea'
			},
			extencionTrabajo:{
				number: 'Sólo Números(Campo opcional)'
			}
		
		}
	});
	
	//------------ Validaciones de Controles -------------------------------------
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '0' && numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(catTipoConsultaDatosSocioEco.principal,numCliente, { async: false, callback: function(cliente) {
				if(cliente!=null){
					listaPersBloqBean = consultaListaPersBloq(numCliente, esCliente, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(numCliente,'LPB',esCliente);
					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
					inicializaValoresInputs();
					inicializaParametrosClienProsp();
					dwr.util.setValues(cliente);			
					$('#nombreCte').val(cliente.nombreCompleto);
					$('#ocupacionCID').val(cliente.ocupacionID);
					$('#clienteID').val(cliente.numero);
					$('#cliID').val(numCliente);					
					$('#forma4ClienteID').val(numCliente);
					if($('#prospectoID').val() == '0' || $('#prospectoID').val() == ''){
						consultaDatosSocioecoGrid();
					}
					if(cliente.tipoPersona=='F' || cliente.tipoPersona=='A'){
						$('#etOcupacion').show();
						$('#CampoOcupacion').show();
						consultaOcupacionCliente('ocupacionCID');
						
					}else{
						$('#etOcupacion').hide();
						$('#CampoOcupacion').hide();
					}
					
					creaGridDependientesEconom(numCliente,$('#prospectoID').val());
					consultaDatosVivienda(cliente.numero,$('#prospectoID').val());
					if(cliente.estadoCivil=='CS' || cliente.estadoCivil=='CM' || cliente.estadoCivil=='CC' ||cliente.estadoCivil=='U'){						
						consultaDatosConyugue();						
					}else{
						$('#formaGenerica3').hide('slow');
					}

						if(cliente.esMenorEdad != "S"){
								inicializaValoresInputs();
								inicializaParametrosClienProsp();
								dwr.util.setValues(cliente);			
								$('#nombreCte').val(cliente.nombreCompleto);
								consultaProspectoCliente(cliente.numero);
								$('#clienteID').val(cliente.numero);
								$('#cliID').val(numCliente);
								$('#forma4ClienteID').val(numCliente);
								if($('#prospectoID').val() == '0' || $('#prospectoID').val() == ''){
									consultaDatosSocioecoGrid();
								}
								creaGridDependientesEconom(numCliente,$('#prospectoID').val());
								consultaDatosVivienda(cliente.numero,$('#prospectoID').val());
								if(cliente.estadoCivil=='CS' || cliente.estadoCivil=='CM' || cliente.estadoCivil=='CC' ||cliente.estadoCivil=='U'){
									consultaDatosConyugue();
								}else{
									$('#formaGenerica3').hide('slow');
								}
						}
						else{
								mensajeSis("El Cliente es Menor de Edad.");
								tab2 = false;
								$('#clienteID').focus();
								$('#clienteID').select();	
								$('#prospectoID').val('');	
								$('#nombreProspecto').val("");
						}	
					varEstatusCliente = cliente.estatus;
					if(cliente.estatus=='I'){
						mensajeSis('El Cliente Esta Inactivo'); 
						deshabilitaBoton('grabar', 'submit');
						deshabilitaBoton('grabarDSE', 'submit');
						deshabilitaBoton('grabarViv', 'submit');
						deshabilitaBoton('grabarCony', 'submit');
						
					}else{
						habilitaBoton('grabar', 'submit');
						habilitaBoton('grabarDSE', 'submit');
						habilitaBoton('grabarViv', 'submit');
						if(cliente.estadoCivil=='CS' || cliente.estadoCivil=='CM' || cliente.estadoCivil=='CC' ||cliente.estadoCivil=='U'){
						habilitaBoton('grabarCony', 'submit');}
					}
					}else{
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						$('#clienteID').focus();
						$('#clienteID').select();	
						$('#prospectoID').val('');	
						$('#nombreProspecto').val("");
						deshabilitaBoton('grabar', 'submit');
						deshabilitaBoton('grabarDSE', 'submit');
						deshabilitaBoton('grabarViv', 'submit');
						deshabilitaBoton('grabarCony', 'submit');
					}
				}else{
					var cte = $('#clienteID').val();
					if(cte != '0'){
						mensajeSis("Cliente No Valido");
						tab2 = false;
						$('#clienteID').focus();
						$('#clienteID').select();	
						$('#prospectoID').val('');	
						$('#nombreProspecto').val("");
						deshabilitaBoton('grabar', 'submit');
						deshabilitaBoton('grabarDSE', 'submit');
						deshabilitaBoton('grabarViv', 'submit');
						deshabilitaBoton('grabarCony', 'submit');
					}
				}    	 						
			}
		});
		} 
	}
	
	function consultaProspectoCliente(numCliente) {
		var tipConProspec = 10;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(tipConProspec,numCliente, { async: false, callback: function(cliente) {
				if(cliente!=null){ 			
					$('#prospectoID').val(cliente.prospectoID);	
					$('#nombreProspecto').val($('#nombreCte').val());				
					$('#ProspID').val(cliente.prospectoID);// EN sosDemograficos.js					
					$('#forma4ProspectoID').val(cliente.prospectoID);
				}else{
					$('#prospectoID').val('');	
					$('#nombreProspecto').val("No Existe Prospecto Relacionado");	
				} 						
			}
		});
		} 
	}
	
	function consultaTipoIdent() {
		var tipConP = 1;
		var numTipoIden =tipoIndenConyuge;
		setTimeout("$('#cajaLista').hide();", 200);		
			tiposIdentiServicio.consulta(tipConP,numTipoIden,function(identificacion) {
				if(identificacion!=null){							
					$('#tipoIdentiID').val(identificacion.tipoIdentiID);
					$('#numeroCaracteres').val(identificacion.numeroCaracteres);
				} 
			});
	}
	function consultaDatosSocioecoGrid(){
		var params = {};		
		params['tipoLista'] = catTipoConsultaDatosSocioEco.foranea;
		params['linNegID'] = $('#linNegID').val();
		params['clienteID'] = $('#clienteID').val();
		params['prospectoID'] = $('#prospectoID').val();
		params['tipoPersona'] = $('#tipoPersona').val();
				
		$.post("socioeconomicosCteGrid.htm", params, function(data){
			if(data.length >0) { 
				$('#gridDatosSocioeco').html(data); 
				$('#gridDatosSocioeco').show();
			
				agregaFormatoControles('gridDatosSocioeco');
				consultaInformacionsocioeconmomica();
				
			
				if($('#catSocioEID1').val() == undefined){
					mensajeSis("No Existen Datos Socioeconómicos Parametrizados para la Línea y Tipo de Persona Indicados.");					
				}
			}else{
				$('#Integrantes').html("");
				$('#Integrantes').show();
			}			
		});
	}
	// consulta cuantas filas tiene el grid de documentos
	function consultaFilas(){
		var totales=0;
		$('tr[name=renglons]').each(function() {
			totales++;
			
		});
		return totales;
	}
	


	function llenaCombolineasNegocio(){
		dwr.util.removeAllOptions('linNegID'); 
		lineaNegocioServicio.listaCombo(catTipoConsultaDatosSocioEco.foranea, function(lineasNegocio){		
			dwr.util.addOptions('linNegID', lineasNegocio, 'linNegID', 'linNegDescri');
		});
	}
		
	function guardarDetalle(){		  		
		var numDetalle = $('input[name=consecutivoID]').length;
		quitaFormatoControles('gridDatosSocioeco');
		$('#detalleSocioeconomicos').val("");
		for(var i = 1; i <= numDetalle; i++){
			if(i == 1){
				$('#detalleSocioeconomicos').val($('#detalleSocioeconomicos').val() +
				document.getElementById("socioEID"+i+"").value + ']' +
				document.getElementById("catSocioEID"+i+"").value + ']' +
				document.getElementById("monto"+i+"").value);
				
			}else{
				$('#detalleSocioeconomicos').val($('#detalleSocioeconomicos').val() + '[' +
				document.getElementById("socioEID"+i+"").value + ']' +
				document.getElementById("catSocioEID"+i+"").value + ']' +
				document.getElementById("monto"+i+"").value);			
			}	
		}
	}	
	
	function consultaInformacionsocioeconmomica(){
		var totalIngresos= 0.0;
		var totalEgresos= 0.0;
		var datosSocioEcoBean = { 
			'linNegID' :$('#linNegID').asNumber(),
			'clienteID' :$('#clienteID').asNumber(),
			'prospectoID' :$('#prospectoID').asNumber()
		};
		clidatsocioeServicio.listaCombo(datosSocioEcoBean,catTipoConsultaDatosSocioEco.infoDatosSocioe,  { async: false, callback: function(datosSocioeco){
			if(datosSocioeco.length == 0){
				calculaTotalesIngEgre();	
			}else{
				var fechaRegistro =  datosSocioeco[0].fechaRegistro;
				$('#fechaRegistro').val(fechaRegistro);
			}
   		  	for (var i = 0; i < datosSocioeco.length; i++){
   		  		var socioE= datosSocioeco[i].socioEID;
   		  		var monto= datosSocioeco[i].monto;
   		  		var catsocioid = datosSocioeco[i].catSocioEID;
   		  		var tipoDato = datosSocioeco[i].tipoDatoSocioe; 		
				var numDetalle = $('input[name=consecutivoID]').length;
				for(var j = 1; j <= numDetalle; j++){
					var catsocio = $('#catSocioEID'+j).val();
					if(catsocio == catsocioid){
						$('#socioEID'+j).val(socioE);
						$('#monto'+j).val(monto);
						$('#monto'+j).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						if(tipoDato == 'I'){
							var mont = $('#monto'+j).asNumber();
							totalIngresos= totalIngresos+mont;
							$('#totalIngresos').val(totalIngresos);
							$('#totalIngresos').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							$('#excedente').val(totalIngresos - totalEgresos);
							$('#excedente').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						}else{
							if(tipoDato == 'E'){
								var mont = $('#monto'+j).asNumber();
								totalEgresos= totalEgresos+mont;
								$('#totalEgresos').val(totalEgresos);
								$('#totalEgresos').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
								$('#excedente').val(totalIngresos - totalEgresos);
								$('#excedente').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							}	
						}
					}  
				}
   		  	}  		
		}});
	}
	
	function consultaProspecto(idControl) {
		var jqProspecto = eval("'#" + idControl + "'");
		var numProspecto = $(jqProspecto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProspecto != '0' && numProspecto != '' && !isNaN(numProspecto) && esTab){
			deshabilitaBoton('agrega', 'submit');
			habilitaBoton('modifica', 'submit');
			var prospectoBeanCon ={
			 	'prospectoID' : numProspecto 
			};		
			prospectosServicio.consulta(catTipoConsultaDatosSocioEco.principal,prospectoBeanCon, { async: false, callback: function(prospectos) {
				if(prospectos!=null){
					listaPersBloqBean = consultaListaPersBloq(numProspecto, esProspecto, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(numProspecto,'LPB',esProspecto);
					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
					if($('#clienteID').val() != prospectos.cliente){
						$('#clienteID').val('0');
						$('#nombreCte').val('');
					}
					if($('#clienteID').val() == '0' || $('#clienteID').val() == ''){
						inicializaValoresInputs();
						inicializaParametrosClienProsp();
						dwr.util.setValues(prospectos);
						$('#clienteID').val(prospectos.cliente);
						var nombre= prospectos.primerNombre+" "+prospectos.segundoNombre+" "+prospectos.tercerNombre
									+" "+prospectos.apellidoPaterno+" "+prospectos.apellidoMaterno;
						$('#nombreProspecto').val(nombre);
						consultaCliente('clienteID');
						consultaDatosSocioecoGrid();
						consultaDatosVivienda($('#clienteID').val(),$('#prospectoID').val());
						if(prospectos.estadoCivil=='CS' || prospectos.estadoCivil=='CM' || prospectos.estadoCivil=='CC'||prospectos.estadoCivil=='U'){
							consultaDatosConyugue();
						}else{
							$('#formaGenerica3').hide('slow');
						}
						$('#ProspID').val(numProspecto);
						$('#forma4ProspectoID').val(numProspecto);
						creaGridDependientesEconom( prospectos.cliente,numProspecto);//consulta dependientes
						if($('#clienteID').val() == ''){
							$('#nombreCte').val("No Existe Cliente Relacionado");	
						}
						$('#cliID').val($('#clienteID').val());/*RLAVIDA_ AJUSTE_ T_13174*/
					 	habilitaBoton('grabar', 'submit');
						habilitaBoton('grabarDSE', 'submit');
						habilitaBoton('grabarViv', 'submit');
						habilitaBoton('grabarCony', 'submit');
					}
					}else{
						tab2 = false;
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						deshabilitaBoton('grabar', 'submit');
						deshabilitaBoton('modifica', 'submit');
	   					deshabilitaBoton('agrega', 'submit');
						$('#prospectoID').focus();
						$('#prospectoID').select();
						$('#nombreProspecto').val("");	
						$('#clienteID').val("");
						$('#nombreCte').val("");	
					}
				}else{ 
					tab2 = false;
					mensajeSis("No Existe el Prospecto");
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('modifica', 'submit');
   					deshabilitaBoton('agrega', 'submit');
					$('#prospectoID').focus();
					$('#prospectoID').select();
					$('#nombreProspecto').val("");	
					$('#clienteID').val("");
					$('#nombreCte').val("");										
				}
			}
		});										
		}
	} 
		
	///********** VALIDACIONED DE DATOS SOCIODEMOGRÁFICOS
	//mas funciones en socDemograficos.js : agregaNuevoDetalle()
	function creaGridDependientesEconom(clienteID, prospectoID){
		var tipolistaPrincipal= {
			'principal': 1			
		};
		var datSocDemoBean = {
			'prospectoID': prospectoID,
			'clienteID':  clienteID
		};
		datSocDemogServicio.consulta(tipolistaPrincipal.principal,datSocDemoBean , { async: false, callback: function(data){ 
			if(data!=null){
				
				if(!$('#fechaIniTra').is(':hidden')){
					if(data.fechaIniTra != "" && data.fechaIniTra != "1900-01-01"){
						var antiguedadMes = "";
						var fechaActualSistema = parametroBean.fechaSucursal;
						
						antiguedadTra = restaFechas(data.fechaIniTra,fechaActualSistema);
						if(parseInt(antiguedadTra) <= 0) antiguedadTra = 1;
						
						$('#fechaIniTra').val(data.fechaIniTra);
						
						// verifico cuantos enteros son
						antiguedadMes = parseInt(antiguedadTra) / 30 ;
						if(parseInt(antiguedadMes) < 1) { 
							antiguedadMes = 0;
						}else{
							antiguedadMes = parseInt(antiguedadMes);
						}						
							
						
						$('#antiguedadLab').val(antiguedadMes);
					}else{
						$('#fechaIniTra').val('');
						$('#antiguedadLab').val('');
					}
				}else{
					$('#antiguedadLab').val(data.antiguedadLab);
				}					
				var jqGradoEscolar = eval("'#gradoEscolarID option[value="+ data.gradoEscolarID +"]'"); 	
				$(jqGradoEscolar).attr("selected","selected");
			} else {
				$('#antiguedadLab').val('');
				$('#fechaIniTra').val('');
				$('#gradoEscolarID').val('0');
			}
		}
	});
		datSocDemogServicio.listaDependEconom(tipolistaPrincipal.principal,datSocDemoBean , { async: false, callback: function(lisDepends){ 
			if(lisDepends!=null){
				limpiaFormaGridPantalla();
				for(var i=0;i<lisDepends.length;i++){
					agregaNuevoDetalleGridCon(); 
					var numFila= $('#numeroDetalle').val(); 
					var jqOpTipoRelacion = eval("'#tipoRelacion" + numFila +"'"); 	
					var jqPrimerNomb = eval("'#primerNomb" + numFila + "'");  
					var jqSegundNomb = eval("'#segundNomb" + numFila + "'"); 	 
					var jqTercerNomb = eval("'#tercerNomb" + numFila + "'");  	  
					var jqApePaterno = eval("'#apePaterno" + numFila + "'");  	  
					var jqApeMaterno = eval("'#apeMaterno" + numFila + "'");	  
					var jqEdades = eval("'#edades" + numFila + "'");	  
					var jqOcupaciones = eval("'#ocupaciones" + numFila + "'"); 
					$(jqOpTipoRelacion).val( lisDepends[i].tipoRel);
					consultaParentesco(numFila);
					$(jqPrimerNomb).val( lisDepends[i].primerNombre);
					$(jqSegundNomb).val( lisDepends[i].segundNombre);
					$(jqTercerNomb).val( lisDepends[i].tercerNombre);
					$(jqApePaterno).val( lisDepends[i].apellidoPaterno);
					$(jqApeMaterno).val( lisDepends[i].apellidoMaterno);
					$(jqEdades).val( lisDepends[i].edad);
					$(jqOcupaciones).val( lisDepends[i].ocupacion);
					consultaTrabajo(numFila);
				}
			}
		}
	});
	}
	  	
	function consultaDatosConyugue(){
		var tipolistaPrincipal= {
			'principal': 1			
		};
		var clienteID = $('#clienteID').val();
		var prospectoID = $('#prospectoID').val();
		var datSocConyugueBean = {
			'prospectoID': prospectoID,
			'clienteID':  clienteID
		};
		
		limpiaInputsForm('formaGenerica3');
		$('#formaGenerica3').show('slow');
		
		socDemoConyugServicio.consulta(tipolistaPrincipal.principal,datSocConyugueBean , { async: false, callback: function(conyugue){ 
			if(conyugue!=null){ 
				if(conyugue.clienteConyID!=null){
					listaPersBloqBean = consultaListaPersBloq(conyugue.clienteConyID, esCliente, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(conyugue.clienteConyID,'LPB',esCliente);
				}
				if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
				camposDatosConyugue(conyugue);
				var jQpaisNacimiento = eval("'#paisNacimiento'");
				if(conyugue.clienteConyID!=null)
				conyugeID=conyugue.clienteConyID;
								
				if(conyugue.ocupacionID!='0'){
					$('#ocupacionID').val(conyugue.ocupacionID);
					ocupacionID = conyugue.ocupacionID;
				}else{
					 $('#ocupacionID').val('');
					 ocupacionID = '';
				}
				if(	$('#ocupacionID').val()!='' && $('#ocupacionID').val()!='0'){
					consultaOcupacion('ocupacionID');
				}
								
				var clienteID = conyugue.clienteConyID;
				if(parseInt(clienteID)>0){
					$('#buscClienteID').val(conyugue.clienteConyID);
					deshabilitaControl('tipoIdentiID');
					deshabilitaControl('folioIdentificacion');
				}else{
					$('#buscClienteID').val('');
					habilitaControl('tipoIdentiID');
					habilitaControl('folioIdentificacion');
				}
				$('#pNombre').val(conyugue.primerNombre);						 
				$('#sNombre').val(conyugue.segundoNombre);
				$('#tNombre').val(conyugue.tercerNombre);

				if(conyugue.empresaLabora!=''){
					$('#empresaLabora').val(conyugue.empresaLabora);
				}else{
					$('#empresaLabora').val('');
				}
								
				$('#entFedID').val(conyugue.entFedID); 
				if ($('#entFedID').val()!='' && $('#entFedID').val()!='0') {
					consultaEstado('entFedID','entidadFedNombre');
				}
				$('#municipioID').val(conyugue.municipioID);
				if( $('#municipioID').val()!='' && $('#municipioID').val()!='0'){
					consultaMunicipio('municipioID');
				}
				$('#localidadID').val(conyugue.localidadID);
				if( $('#localidadID').val()!='' && $('#localidadID').val()!='0'){
					consultaLocalidad('localidadID');
				}
				$('#coloniaID').val(conyugue.coloniaID);
				
				if( $('#coloniaID').val()!='' && $('#coloniaID').val()!='0'){
					consultaColonias('coloniaID');
				}
				$('#aPaterno').val(conyugue.apellidoPaterno);
				$('#aMaterno').val(conyugue.apellidoMaterno);
				$('#colonia').val(conyugue.colonia);
				$('#calle').val(conyugue.calle);
				
				
				if(conyugue.numero != 0){
					$('#numero').val(conyugue.numero);
					
				}else{
					$('#numero').val("");
				}
				if(conyugue.interior != 0){
					$('#interior').val(conyugue.interior);
				}else{
					$('#interior').val("");
				}
				if(conyugue.piso != 0){
					$('#piso').val(conyugue.piso);
				}
				else{
					$('#piso').val("");
				}
				$('#nacionaID').val(conyugue.nacionaID);
				$(jQpaisNacimiento).val(conyugue.paisNacimiento);
								
				if(conyugue.fechaExpedicion !='1900-01-01'){
					$('#fechaExpedicion').val(conyugue.fechaExpedicion);
				}else{
					$('#fechaExpedicion').val('');
				}
				if(conyugue.fechaVencimiento !='1900-01-01'){
					$('#fechaVencimiento').val(conyugue.fechaVencimiento);
				}else{
					$('#fechaVencimiento').val('');
				}
				$('#telCelular').val(conyugue.telCelular);
				$('#tipoIdentiID').val(conyugue.tipoIdentiID);
				tipoIndenConyuge=conyugue.tipoIdentiID;
				consultaTipoIdent();
				$('#folioIdentificacion').val(conyugue.folioIdentificacion);
				$('#fechaRegistro').val(parametroBean.fechaAplicacion);	
				
				$('#telCelular').setMask('phone-us');		
				}else{
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
					camposDatosConyugue("");
				}
			}
			else{ 	
				camposDatosConyugue("");
			}
		}
	});
  	}
	  	
	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#entFedID').val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);
		if(numLocalidad != '' && !isNaN(numLocalidad)){
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad, { async: false, callback: function(localidad) {
				if(localidad!=null){
					$('#nombrelocalidad').val(localidad.nombreLocalidad);

					
				}else{
					mensajeSis("No Existe la Localidad");
					$('#nombrelocalidad').val("");
					$('#localidadID').val("");
					$('#localidadID').focus();
					$('#localidadID').select();
				}    	 						
			}
		});
		}
	}	
		
	function consultaDatosVivienda(numCliente,prospectoID){
	 	var tipolistaPrincipal= {
			'principal': 1			
		};
		var datSocConyugueBean = {
			'prospectoID': prospectoID,
			'clienteID':  numCliente
		};
		socDemoViviendaServicio.consulta(tipolistaPrincipal.principal,datSocConyugueBean , { async: false, callback: function(vivienda){ 
			if(vivienda!=null){
				
				$('#tipoViviendaID').val(vivienda.tipoViviendaID).selected = true;
				$('#valorVivienda').val(vivienda.valorVivienda);
				$('#tipoMaterialID').val(vivienda.tipoMaterialID).selected = true;
				$('#descripcion').val(vivienda.descripcion);
				$('#conDrenaje').val(vivienda.conDrenaje);
				$('#conPavimento').val(vivienda.conPavimento);
				$('#conGas').val(vivienda.conGas);								
				$('#conElectricidad').val(vivienda.conElectricidad);
				$('#conAgua').val(vivienda.conAgua);
				$('#tiempoHabitarDom').val(vivienda.tiempoHabitarDom);
				
				if($('#conDrenaje').val()=='S'){
					$('#drenajeSi').attr('checked','true');
				}else{
					$('#drenajeNo').attr('checked','true');
				}
				if($('#conPavimento').val()=='S'){
					$('#pavimentoSi').attr('checked','true');
				}else{
					$('#pavimentoNo').attr('checked','true');
				}
				if($('#conGas').val()=='S'){
					$('#gasSi').attr('checked','true');
				}else{
					$('#gasNo').attr('checked','true');
				}
				if($('#conElectricidad').val()=='S'){
					$('#electricidadSi').attr('checked','true');
				}else{
					$('#electricidadNo').attr('checked','true');
				}
				if($('#conAgua').val()=='S'){
					$('#aguaSi').attr('checked','true');
				}else{
					$('#aguaNo').attr('checked','true');
				}
				agregaFormatoControles('formaGenerica4');
			} else {
				$('#drenajeSi').attr('checked','true');
				$('#pavimentoSi').attr('checked','true');
				$('#gasSi').attr('checked','true');
				$('#electricidadSi').attr('checked','true');
				$('#aguaSi').attr('checked','true');
				llenaTipoComboTiposViviendaCli('tipoViviendaID');
				llenaTipoComboMatViviendaCli('tipoMaterialID');
				$('#descripcion').val('');
				$('#valorVivienda').val('');
				$('#tiempoHabitarDom').val('');
			}
		}
	});
  	}
	  	
	function llenaTipoComboTiposViviendaCli(idControl){
		var todos=0;
		var datSocDemogBean = {
	  		'tipoMaterialID':todos
		};	
		var tipoListaPrincipal=1;
		dwr.util.removeAllOptions('tipoViviendaID'); 
		socDemoViviendaServicio.comboTiposVivienda(tipoListaPrincipal,datSocDemogBean ,function(lisTiposViv){
			dwr.util.removeAllOptions('tipoViviendaID'); 
			dwr.util.addOptions(idControl, lisTiposViv, 'tipoViviendaID', 'descripVivienda');		
		});
	}
	  	
	function llenaTipoComboMatViviendaCli(idControl){
		var todos=0;
		var datSocDemogBean = {
	  		'tipoMaterialID':todos
		};	
		var tipoListaPrincipal=1;
		dwr.util.removeAllOptions('tipoMaterialID'); 
		socDemoViviendaServicio.comboMaterialVivienda(tipoListaPrincipal,datSocDemogBean ,function(lisMaterialViv){
			dwr.util.removeAllOptions('tipoMaterialID'); 
			dwr.util.addOptions(idControl, lisMaterialViv, 'tipoMaterialID', 'descripMaterial');
		});
	}

	///////////////////////consultas para conyugue/////
	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#entFedID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numMunicipio == '' || numMunicipio==0 || numEstado == '' || numEstado==0){
			if(numEstado == '' || numEstado==0 && numMunicipio!=0 &&  numMunicipio!=''){
				mensajeSis("No ha selecionado ningún estado.");
				$('#entFedID').focus();
			}
			$('#nombMunicipio').val('');
		}
		else	
			if(numMunicipio != '' && !isNaN(numMunicipio)){
				municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){							
						$('#nombMunicipio').val(municipio.nombre);
					}else{
						mensajeSis("No Existe el Municipio");
						 $(jqMunicipio).val('');
						$('#nombMunicipio').val('');
					}    	 						
				});
			}
	}

	function consultaOcupacion(idControl) {
		var jqOcupacion = eval("'#" + idControl + "'");
		var numOcupacion = $(jqOcupacion).val();
		var tipConForanea = 2;		
		setTimeout("$('#cajaLista').hide();", 200);		
		if (numOcupacion != 0 && numOcupacion != '' && !isNaN(numOcupacion) ) {
			ocupacionesServicio.consultaOcupacion(tipConForanea, numOcupacion, function(ocupacion) {
				if (ocupacion != null) {
					$('#nombreOcupacion').val(ocupacion.descripcion);
				} else {
					if(numOcupacion != 0){
						mensajeSis("No Existe la Ocupacion");
						$('#nombreOcupacion').val('');
					}
				}
			});
		}
	}
	
	function consultaEstado(idControl,nomEstado) { 
		var jqEstado = eval("'#" + idControl + "'");
		var jqNombEstado = eval("'#" + nomEstado + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado) ) {
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if (estado != null) {
					$(jqNombEstado).val(estado.nombre);
				} else {
					mensajeSis("No Existe el Estado");
					$(jqNombEstado).val('');
					$(jqEstado).val('');
				}
			});
		}
	}

	function validaNacionalidadCte(){
		var nacionalidad = $('#nacionaID').val();
		var pais= $('#paisNacimiento').val();
		var mexico='700';
		var nacdadMex='N';
		var nacdadExtr='E';
		if(nacionalidad==nacdadMex){
			if(pais!=mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País Debe ser México.");
				$('#paisNacimiento').val('');
				$('#nombPaisNacim').val('');
			}
		}
		if(nacionalidad==nacdadExtr){
			if(pais==mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País NO Debe ser México.");
				$('#paisNacimiento').val('');
				$('#nombPaisNacim').val('');
			}
		}
	}
	

	
	function inicializaParametrosClienProsp(){
		$('#forma3ClienteID').val('');
		$('#cliID').val('');
		$('#forma3ProspectoID').val('');
		$('#ProspID').val('');
		$('#forma4ClienteID').val('');
		$('#forma4ProspectoID').val('');
	}
	
	function funcionSetValoresConsolidacion(){
			esTab = true;
			$('#clienteID').val(var_consolidacion.clienteID);
			consultaCliente('clienteID');
    }
	
});// fin de document ready

// funcion para limpiar solo la formaGenerica
function limpiaFormaGenerica(){
	$('#nombreCte').val('');
	$('#fechaRegistro').val('');
	$('#nombreProspecto').val('');
	$('#montSoliciDeGrupal').val('');
	$('#excedente').val('');
	$('#primerNombre').val('');
	$('#segundoNombre').val('');
	$('#tercerNombre').val('');
	$('#apellidoPaterno').val('');
	$('#apellidoMaterno').val('');
	$('#fechaNacimiento').val('');
	$('#ocupacionCID').val('');
	$('#ocupacionC').val('');
	$('#tipoPersona').val('-1').selected = true;
	$('#RFC').val('');		
	$('#estadoCivil').val('-1').selected = true;
	$('#gridDatosSocioeco').html('');
	$('#gridDatosSocioeco').hide();
	$('#detalleSocioeconomicos').val('');
	deshabilitaBoton('grabar', 'submit');
	
}
function calculaTotalesIngEgre(){
	var totalIngresos= 0.0;
	var totalEgresos= 0.0;
	var numDetalle = $('input[name=consecutivoID]').length;
	if(numDetalle == '0' || varEstatusCliente == "I"){  
		deshabilitaBoton('grabar', 'submit');
	}else{
		habilitaBoton('grabar', 'submit');
	}
	for(var j = 1; j <= numDetalle; j++){
       	var catsocio = $('#catSocioEID'+j).val();
       	var tipoDato = $('#tipo'+j).val();
		var monto = $('#monto'+j).asNumber();
		if(monto== 0){
			$('#monto'+j).val('0.00');
		}	
		if(tipoDato == 'I'){	         	
			totalIngresos= totalIngresos+monto;
			$('#totalIngresos').val(totalIngresos);
			$('#totalIngresos').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			$('#excedente').val(totalIngresos - totalEgresos);
			$('#excedente').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		}else{
			if(tipoDato == 'E'){
				totalEgresos= totalEgresos+monto;
		        $('#totalEgresos').val(totalEgresos);
				$('#totalEgresos').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				$('#excedente').val(totalIngresos - totalEgresos);
			    $('#excedente').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			}	
		}
	}   
}
function consultaPais(idControl,etiqNombre) {
	var jqPais = eval("'#" + idControl + "'");
	var jqNombrePais = eval("'#" + etiqNombre + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais) && esTab) {
		paisesServicio.consultaPaises(conPais, numPais,	function(pais) {
			if (pais != null) {
				$(jqNombrePais).val(pais.nombre);
				validaNacionalidadCte();
			} else {
				mensajeSis("No Existe el Pais");
				$(jqPais).val('');
				$(jqNombrePais).val('');
			}
		});
	}
}
function consultaOcupacionCliente(idControl) {
	var jqOcupacion = eval("'#" + idControl + "'");
	var numOcupacion = $(jqOcupacion).val();
	var tipConForanea = 2;		
	setTimeout("$('#cajaLista').hide();", 200);		
	if (numOcupacion != 0 && numOcupacion != '' && !isNaN(numOcupacion) ) {
		ocupacionesServicio.consultaOcupacion(tipConForanea, numOcupacion, function(ocupacion) {
					if (ocupacion != null) {
						$('#ocupacionC').val(ocupacion.descripcion);	
					} else {
						if(numOcupacion != 0){
							mensajeSis("No Existe la Ocupacion");
							$('#ocupacionC').val('');
							$('#ocupacionCID').focus();
						}
					}
				});
	}else{
		$('#ocupacionCID').val('0');
		$('#ocupacionC').val('');
	}
}
	
function inicializaValoresInputs(){
	$('#fechaRegistro').val(parametroBean.fechaAplicacion);
	$('#excedente').val('0.00');
	$('#primerNombre').val('');
	$('#segundoNombre').val('');
	$('#tercerNombre').val('');
	$('#apellidoPaterno').val('');
	$('#apellidoMaterno').val('');
	$('#fechaNacimiento').val('');
	$('#tipoPersona').val('-1');
	$('#RFC').val('');
}
	
function exitoError(){
	tab2 = false;
	agregaFormatoControles('formaGenerica');	
}

function inicializaTabs(){
	tab2 = false;
}



function camposDatosConyugue(datos){ 
	var paisNacimiento = datos.paisNacimiento;
	var fechaIniTrabajo = datos.fechaIniTrabajo;
	var estadoID = datos.estadoID;
	var antiguedadAnio = datos.aniosAnti;
	var antiguedadMes = datos.mesesAnti;	
	var fecNacimiento = datos.fecNacimiento;
	var telEmpresa = datos.telEmpresa;
	var extencionTrabajo = datos.extencionTrabajo;
	var rfcConyugue = datos.rfcConyugue;
	var codPostal = datos.codPostal;
	var fechaActualSistema = parametroBean.fechaSucursal;
		
	
	$('#forma3ClienteID').val($("#clienteID").val()); // En DatSosConyugue
	$('#forma3ProspectoID').val($("#prospectoID").val());// En DatSosConyugue
	var tipoConsulta = 2;
	var bean = { 
			'empresaID'		: 1		
		};
	
	paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:  function(parametro) {
			if (parametro != null){	
				if(paisNacimiento == undefined) paisNacimiento= "";
				if(estadoID == undefined) estadoID= "";
				if(antiguedadAnio == undefined) antiguedadAnio= "";
				if(antiguedadMes == undefined) antiguedadMes= "";
				if(fecNacimiento == undefined) fecNacimiento= "";
				if(telEmpresa == undefined) telEmpresa= "";
				if(extencionTrabajo == undefined) extencionTrabajo= "";
				if(rfcConyugue == undefined) rfcConyugue= "";
				if(codPostal == undefined) codPostal= "";
				if(fechaIniTrabajo == undefined || fechaIniTrabajo == "1900-01-01") fechaIniTrabajo = ""; 
					$("#fila1").html('');
					$("#fila2").html('');
					$("#fila3").html('');
					$("#fila4").html('');
							
					if(parametro.valorParametro == "S"){
						
						$("#fila1").append('<td class="label" nowrap="nowrap"><label for="RFClbl">País de Nacimiento:</label></td>'
								+'<td nowrap="nowrap"><input id="paisNacimiento" name="paisNacimiento" size="10"  tabindex="21" onkeyup="listaPais(this)" onblur="consultaPais(this.id,' + "'nombPaisNacim'" +');" value="' + paisNacimiento + '"/>'
								+'<input id="nombPaisNacim" name="nombPaisNacim" size="40" readOnly="true" /></td><td class="separador"></td>'
								+'<td class="label"><label for="antiguedadTra">Fecha Inicio Trabajo Actual:</label></td>'
								+'<td><input type="text" id="fechaIniTrabajo" name="fechaIniTrabajo" size="15" esCalendario="true" tabindex="42" '
								+' onchange="calculaAntiguedadTrabajo(this); this.focus();" onblur="calculaAntiguedadTrabajo(this);" value="' + fechaIniTrabajo + '"/></td>');
						$("#fila2").append('<td class="label" nowrap="nowrap"><label for="RFClbl">Entidad Federativa:</label></td><td nowrap="nowrap">'
									+'<input id="estadoID" name="estadoID" size="10"  tabindex="22" onkeyup="listaEstados(this)" onblur="consultaEstado(this.id,' + "'nomEstado'" +');" value="' + estadoID + '" /><input id="nomEstado" name="nomEstado" size="40"  readOnly="true"/>'
								    + '</td><td class="separador"></td><td><label for="RFClbl">Antiguedad Años:</label></td><td nowrap="nowrap">'
					 				+'<input id="aniosAnti" name="aniosAnti" size="5" readonly="true" style="text-align: right" tabindex="42" value="'+ antiguedadAnio + '"/><label for="RFClbl">   Meses:</label>'
					 				+'<input id="mesesAnti" name="mesesAnti" size="5" readonly="true" style="text-align: right" tabindex="43" value="' + antiguedadMes + '" /></td>');
						$("#fila3").append('<td class="label" nowrap="nowrap"><label for="RFClbl">Fecha Nacimiento:</label></td><td>'
									+'<input id="fecNacimiento" name="fecNacimiento" size="20" esCalendario="true" onchange="this.focus();" onblur="validaFecNacimiento(this.value);" tabindex="23" value="' + fecNacimiento + '" /></td><td class="separador"></td>'  
									+'<td class="label" nowrap="nowrap"><label for="RFClbl">Teléfono Empresa:</label></td><td>'
									+'<input id="telEmpresa" name="telEmpresa" maxlength="10" size="15" onblur="validaTelefonoEmpresa(this.value);" tabindex="44" value="' + telEmpresa + '" /><label for="lblExt">Ext.:</label>'
									+'<input id="extencionTrabajo" name="extencionTrabajo" size="10" maxlength="6" onblur="validaExtencionTrabajo(this.value);" tabindex="45"  type="text" value="' + extencionTrabajo + '"/></td>');
						$("#fila4").append('<td class="label"><label for="RFClbl">RFC:</label></td><td><input id="rfcConyugue" name="rfcConyugue" size="20" maxlength="13" tabindex="24" value="' + rfcConyugue + '" />'
									+'<input type="button" id="generaRFC" value="Generar RFC"name="generaRFC" class="submit" onclick="generarRFC();" tabindex="25"/></td>'
									+'<td class="separador"></td><td class="label" nowrap="nowrap"><label for="RFClbl">Codigo Postal:</label></td><td>'
									+'<input id="codPostal" name="codPostal" size="15" maxlength="5" tabindex="46"  value="' + codPostal + '" /></td>');
						
						var jQtelEmpresa = eval("'#telEmpresa'");
						$(jQtelEmpresa).setMask('phone-us');
						
						consultaEstado('estadoID','nomEstado');
						consultaPais('paisNacimiento','nombPaisNacim');
													
					}else{
							$("#fila1").append('<td class="label" nowrap="nowrap"><label for="RFClbl">País de Nacimiento:</label></td>'
									+'<td nowrap="nowrap"><input id="paisNacimiento" name="paisNacimiento" size="10"  tabindex="21" onkeyup="listaPais(this)" onblur="consultaPais(this.id,' + "'nombPaisNacim'" +');" value="' + paisNacimiento + '"/>'
									+	'<input id="nombPaisNacim" name="nombPaisNacim" size="40" readOnly="true" /></td><td class="separador"></td>'  
									+'<td><label for="RFClbl">Antiguedad Años:</label></td><td nowrap="nowrap">'
					 				+	'<input id="aniosAnti" name="aniosAnti" size="5" onkeypress="return IsNumber(event)" onblur="validaAniosAntiguedad();" tabindex="42" value="'+ antiguedadAnio + '"/><label for="RFClbl">   Meses:</label>'
					 				+	'<input id="mesesAnti" name="mesesAnti" size="5" onkeypress="return IsNumber(event)" onblur="validaMesAntiguedad();" tabindex="43"  value="' + antiguedadMes + '" /></td>');
							$("#fila2").append('<td class="label" nowrap="nowrap"><label for="RFClbl">Entidad Federativa:</label></td><td nowrap="nowrap">'
										+'<input id="estadoID" name="estadoID" size="10"  tabindex="22"  onkeyup="listaEstados(this)" onblur="consultaEstado(this.id,' + "'nomEstado'" +');"  value="' + estadoID + '" /><input id="nomEstado" name="nomEstado" size="40"  readOnly="true"/>'
									   + '</td><td class="separador"></td><td class="label" nowrap="nowrap"><label for="RFClbl">Teléfono Empresa:</label></td><td>'
										+'<input id="telEmpresa" name="telEmpresa" maxlength="10" size="15" onblur="validaTelefonoEmpresa(this.value);" tabindex="44"  value="' + telEmpresa + '" /><label for="lblExt">Ext.:</label>'
										+'<input id="extencionTrabajo" name="extencionTrabajo" size="10" maxlength="6" onblur="validaExtencionTrabajo(this.value);" tabindex="45"  type="text"  value="' + extencionTrabajo + '"/></td>');
							$("#fila3").append('<td class="label" nowrap="nowrap"><label for="RFClbl">Fecha Nacimiento:</label></td><td>'
										+'<input id="fecNacimiento" name="fecNacimiento" size="20" esCalendario="true" onchange="this.focus();" onblur="validaFecNacimiento(this.value);" tabindex="23" value="' + fecNacimiento + '" /></td><td class="separador"></td>'  
									    +'<td class="label" nowrap="nowrap"><label for="RFClbl">Codigo Postal:</label></td><td>'
										+'<input id="codPostal" name="codPostal" size="15" maxlength="5" tabindex="46"  value="' + codPostal + '" /></td>');
							$("#fila4").append('<td class="label"><label for="RFClbl">RFC:</label></td><td><input id="rfcConyugue" name="rfcConyugue" size="20" maxlength="13" tabindex="24"  value="' + rfcConyugue + '"/>'
										+'<input type="button" id="generaRFC" value="Generar RFC"name="generaRFC" class="submit" onclick="generarRFC();" tabindex="25"/></td>'					
									    +'<td class="separador"></td><td class="label" nowrap="nowrap"></td><td></td>');
							var jQtelEmpresa = eval("'#telEmpresa'");
							$(jQtelEmpresa).setMask('phone-us');
							
							consultaEstado('estadoID','nomEstado');
							consultaPais('paisNacimiento','nombPaisNacim');
					}
			}
			else{
				$("#fila1").append('<td class="label" nowrap="nowrap"><label for="RFClbl">País de Nacimiento:</label></td>'
						+'<td nowrap="nowrap"><input id="paisNacimiento" name="paisNacimiento" size="10"  tabindex="21" onkeyup="listaPais(this)" onblur="consultaPais(this.id,' + "'nombPaisNacim'" +');" value="' + paisNacimiento + '"/>'
						+	'<input id="nombPaisNacim" name="nombPaisNacim" size="40" readOnly="true" /></td><td class="separador"></td>'  
						+'<td><label for="RFClbl">Antiguedad Años:</label></td><td nowrap="nowrap">'
		 				+	'<input id="aniosAnti" name="aniosAnti" size="5" onkeypress="return IsNumber(event)" onblur="validaAniosAntiguedad();" tabindex="42" value="'+ antiguedadAnio + '"/><label for="RFClbl">   Meses:</label>'
		 				+	'<input id="mesesAnti" name="mesesAnti" size="5" onkeypress="return IsNumber(event)" onblur="validaMesAntiguedad();" tabindex="43"  value="' + antiguedadMes + '" /></td>');
				$("#fila2").append('<td class="label" nowrap="nowrap"><label for="RFClbl">Entidad Federativa:</label></td><td nowrap="nowrap">'
							+'<input id="estadoID" name="estadoID" size="5"  tabindex="22"  onkeyup="listaEstados(this)" onblur="consultaEstado(this.id,' + "'nomEstado'" +');"  value="' + estadoID + '" /><input id="nomEstado" name="nomEstado" size="45"  readOnly="true"/>'
						   + '</td><td class="separador"></td><td class="label" nowrap="nowrap"><label for="RFClbl">Teléfono Empresa:</label></td><td>'
							+'<input id="telEmpresa" name="telEmpresa" maxlength="10" size="15" onblur="validaTelefonoEmpresa(this.value);" tabindex="44"  value="' + telEmpresa + '" /><label for="lblExt">Ext.:</label>'
							+'<input id="extencionTrabajo" name="extencionTrabajo" size="10" maxlength="6" onblur="validaExtencionTrabajo(this.value);" tabindex="45"  type="text"  value="' + extencionTrabajo + '"/></td>');
				$("#fila3").append('<td class="label" nowrap="nowrap"><label for="RFClbl">Fecha Nacimiento:</label></td><td>'
							+'<input id="fecNacimiento" name="fecNacimiento" size="20" esCalendario="true" onchange="this.focus();" onblur="validaFecNacimiento(this.value);" tabindex="23" value="' + fecNacimiento + '" /></td><td class="separador"></td>'  
						    +'<td class="label" nowrap="nowrap"><label for="RFClbl">Codigo Postal:</label></td><td>'
							+'<input id="codPostal" name="codPostal" size="15" maxlength="5" tabindex="46"  value="' + codPostal + '" /></td>');
				$("#fila4").append('<td class="label"><label for="RFClbl">RFC:</label></td><td><input id="rfcConyugue" name="rfcConyugue" size="20" maxlength="13" tabindex="24"  value="' + rfcConyugue + '"/>'
							+'<input type="button" id="generaRFC" value="Generar RFC"name="generaRFC" class="submit" onclick="generarRFC();" tabindex="25"/></td>'					
						    +'<td class="separador"></td><td class="label" nowrap="nowrap"></td><td></td>');
				var jQtelEmpresa = eval("'#telEmpresa'");
				$(jQtelEmpresa).setMask('phone-us');
				
				consultaEstado('estadoID','nomEstado');
				consultaPais('paisNacimiento','nombPaisNacim');
				
			}
			agregaFormatoControles('formaGenerica3');
	}
});
}

function limpiaInputsForm(idControl){
	var forma =  eval("'#" + idControl + "'");
	$(forma).find(':input').each( function(){	    		
		var control =  eval("'#" + this.id + "'");
		if(this.type != 'button' && this.type != 'submit' && this.type != 'hidden'){
			$(control).val("");
		}
	});
}


function camposDatosDemograficos(datos){
	var tipoConsulta = 2;
	var bean = { 
			'empresaID'		: 1		
		};
	
	paramGeneralesServicio.consulta(tipoConsulta, bean, function(parametro) {
			if (parametro != null){	
				if(parametro.valorParametro == "S"){
					$("#lblFechaIniTrabajo").show();
					$("#tdFechaIniTrabajo").show();
					$("#separador").show();
					$("#antiguedadLab").attr("readonly", true); 
				}else{
					$("#lblFechaIniTrabajo").hide();
					$("#tdFechaIniTrabajo").hide();
					$("#separador").hide();
					$("#antiguedadLab").attr("readonly", false); 
				}
			}else{
				$("#lblFechaIniTrabajo").hide();
				$("#tdFechaIniTrabajo").hide();
				$("#separador").hide();
				$("#antiguedadLab").attr("readonly", false); 
			}
			
	});
}

// Consulta Colonia y CP desde el campo en pantalla
	function consultaColonia(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();		
		var numEstado =  $('#entFedID').val();	
		var numMunicipio =	$('#municipioID').val();
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numColonia != '' && !isNaN(numColonia)){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
				if(colonia!=null){			
					$('#nombreColonia').val(colonia.asentamiento);
					$('#codPostal').val(colonia.codigoPostal);
					
				}else{
					mensajeSis("No Existe la Colonia");
					$('#nombreColonia').val("");
					$('#coloniaID').val("");
					$('#coloniaID').focus();
					$('#coloniaID').select();
				}    	 						
			});
		}else{
			$('#nombreColonia').val("");
		}
	}
	// Consulta Colonia desde consulta
	function consultaColonias(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();	
		var numEstado =  $('#entFedID').val();	
		var numMunicipio =	$('#municipioID').val();
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numColonia != '' && !isNaN(numColonia) ){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
				if(colonia!=null){			
					$('#nombreColonia').val(colonia.asentamiento);				
				}else{
					mensajeSis("No Existe la Colonia");
					$('#nombreColonia').val("");
					$('#coloniaID').val("");
					$('#coloniaID').focus();
					$('#coloniaID').select();
				}    	 						
			});
		}

}