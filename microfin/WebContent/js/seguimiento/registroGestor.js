$(document).ready(function() {
	
	esTab = true;
	//Definicion de Constantes y Enums
	var catTransaccionGestor = {  
  		'altaCliente':'1',
  		'altaSucursal':'2',
  		'altaZona':'3',
  		'altaPromotor':'4'
  	};

	var catTipoConsultaGestor = {
		'cliente':1
	};
	var catConTiposGestion ={
		'principal'	: 1,
		'foranea'	: 2 
	};
	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	$('#gridSucursal').hide();
	$('#gridZona').hide();
	$('#gridPromotor').hide();
	$('#gestorID').focus();
	deshabilitaBoton('agrega', 'submit');
	agregaFormatoControles('formaGenerica');
	
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
	      submitHandler: function(event) { 
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','gestorID', 
	    			  'funcionExito','funcionError');
	      }
	});

	$('#tipoAmbito1').click(function(){
		$("#tableZonaGeografica").html("");
		$("#tableGestorSucursal").html("");
		$("#tableGestorPromotor").html("");
		$('#gridSucursal').hide(500);
		$('#gridZona').hide(500);
		$('#gridPromotor').hide(500);
		habilitaBoton('agrega', 'submit');
	});
	
	$('#tipoAmbito2').click(function(){
		$("#tableZonaGeografica").html("");
		$("#tableGestorPromotor").html("");
		$('#gridZona').hide(500);
		$('#gridSucursal').show(500);
		$('#gridPromotor').hide(500);
	});
	
	$('#tipoAmbito3').click(function(){
		$("#tableGestorSucursal").html("");
		$("#tableGestorPromotor").html("");
		$('#gridZona').show(500);
		$('#gridSucursal').hide(500);
		$('#gridPromotor').hide(500);
	});
	
	$('#tipoAmbito4').click(function(){
		$("#tableGestorSucursal").html("");
		$("#tableZonaGeografica").html("");
		$('#gridZona').hide(500);
		$('#gridSucursal').hide(500);
		$('#gridPromotor').show(500);
	});
	
	$('#agrega').click(function(){
		if((document.getElementById("numSucursal").value) <= 0 && ($('#tipoAmbito2').is(':checked'))) {
			alert("Agregar Sucursal");
			$('#agregaSucursal').focus();
			event.preventDefault();
		}
		else {
			if(($('#tipoAmbito2').is(':checked'))){
				$('#tipoTransaccion').val(catTransaccionGestor.altaSucursal);
			}
		}	
		if(($('#tipoAmbito1').is(':checked'))){
			$('#tipoTransaccion').val(catTransaccionGestor.altaCliente);
		}
		if((document.getElementById("numZona").value) <= 0 && ($('#tipoAmbito3').is(':checked'))) {
			alert("Agregar Zona Geográfica");
			$('#agregaZona').focus();
			event.preventDefault();
		}
		else {
			if(($('#tipoAmbito3').is(':checked'))){
				$('#tipoTransaccion').val(catTransaccionGestor.altaZona);
		}
		}
		if((document.getElementById("numPromotor").value) <= 0 && ($('#tipoAmbito4').is(':checked'))) {
			alert("Agregar Promotor");
			$('#agregaPromotor').focus();
			event.preventDefault();
		}
		else {
			if(($('#tipoAmbito4').is(':checked')))
			$('#tipoTransaccion').val(catTransaccionGestor.altaPromotor);
		}
	});
	
	$('#gestorID').bind('keyup',function(e){
	   lista('gestorID', '2', '4', 'nombreCompleto', $('#gestorID').val(), 'listaUsuarios.htm');
	});

	$('#gestorID').blur(function(){
		consultaGestor(this.id);
	});	

	$('#tipoGestionID').bind('keyup',function(e){
		   lista('tipoGestionID', '2', '1', 'tipoGestionID', $('#tipoGestionID').val(), 'listaTipoGestion.htm');
	});
	
	
	$('#tipoGestionID').blur(function() {
		consultaTipoGestionID(this.id);
	});

	$('#supervisorID').bind('keyup',function(e){
		   lista('supervisorID', '2', '10', 'nombreCompleto', $('#supervisorID').val(), 'listaUsuarios.htm');
	});
	
	$('#supervisorID').blur(function(){
		validaTipoGestor(this.id);
		consultaSupervisor(this.id);
	});	
	
	$('#numSucursal').val(0);
	$('#numZona').val(0);
	$('#numPromotor').val(0);
	// ------------ Validaciones de la Forma
	
	$('#formaGenerica').validate({
		rules : {
			gestorID: {
				required : true,
			},
			tipoGestionID: {
				required : true,
			},
			supervisorID: {
				required : true,
			}
		},
		messages : {
			gestorID:{
				required: 'Especifique el Gestor.',
			},
			tipoGestionID:{
				required: 'Especifique el Tipo Gestión.',
			},
			supervisorID:{
				required: 'Especifique el Supervisor.',
			}
		}
	});
	
	
	// ------------ Validaciones de Controles-------------------------------------
	function validaTipoGestor(idControl) {
		var ambitoCliente = 1;
		var ambitoSucursal = 2;
		var ambitoZona = 3;
		var ambitoPromotor = 4;
		var jqSupervisor  = eval("'#" + idControl + "'");
		var numSupervisor = $(jqSupervisor).val();
		var TipoGestorCon = {
			'gestorID': $('#gestorID').val(),
			'tipoGestionID'	: $('#tipoGestionID').val(),
			'supervisorID'	: numSupervisor,
		};
		setTimeout("$('#cajaLista').hide();", 200);
			if(numSupervisor != '' && !isNaN(numSupervisor)){
				registroGestorServicio.consulta(catTipoConsultaGestor.cliente, TipoGestorCon,function(tipoGestor){
				if(tipoGestor !=null){
					if(tipoGestor.tipoAmbito == ambitoCliente){
						$('#gridSucursal').hide();
						$('#gridZona').hide();
						$('#gridPromotor').hide();
						$("#tableZonaGeografica").html("");
			    		$("#tableGestorSucursal").html("");
			    		$("#tableGestorPromotor").html("");
						$('#tipoAmbito1').attr('checked',true);
						$('#tipoAmbito2').attr('checked',false);
						$('#tipoAmbito3').attr('checked',false);
						$('#tipoAmbito4').attr('checked',false);
						habilitaBoton('agrega', 'submit');
					}
					else if(tipoGestor.tipoAmbito == ambitoSucursal){
						$('#supervisorID').val(tipoGestor.supervisorID);
						$('#nombreSupervisor').val(tipoGestor.nombreSupervisor);
						$('#gridSucursal').show();
						$('#gridZona').hide();
						$('#gridPromotor').hide();
						$("#tableZonaGeografica").html("");
			    		$("#tableGestorSucursal").html("");
			    		$("#tableGestorPromotor").html("");
			    		
						$('#tipoAmbito1').attr('checked',false);
						$('#tipoAmbito2').attr('checked',true);
						$('#tipoAmbito3').attr('checked',false);
						$('#tipoAmbito4').attr('checked',false);
						habilitaBoton('agrega', 'submit');
						consultaGridSucursal();
					}
					else if(tipoGestor.tipoAmbito == ambitoZona){
						$('#supervisorID').val(tipoGestor.supervisorID);
						$('#nombreSupervisor').val(tipoGestor.nombreSupervisor);
						$('#gridSucursal').hide();
						$('#gridZona').show();
						$('#gridPromotor').hide();
						
						$("#tableZonaGeografica").html("");
			    		$("#tableGestorSucursal").html("");
			    		$("#tableGestorPromotor").html("");
						
						$('#tipoAmbito1').attr('checked',false);
						$('#tipoAmbito2').attr('checked',false);
						$('#tipoAmbito3').attr('checked',true);
						$('#tipoAmbito4').attr('checked',false);
						habilitaBoton('agrega', 'submit');
						consultaGridZona();
						
					}
					else if(tipoGestor.tipoAmbito == ambitoPromotor){
						$('#supervisorID').val(tipoGestor.supervisorID);
						$('#nombreSupervisor').val(tipoGestor.nombreSupervisor);
						$('#gridSucursal').hide();
						$('#gridZona').hide();
						$('#gridPromotor').show();
						
						$("#tableZonaGeografica").html("");
			    		$("#tableGestorSucursal").html("");
			    		$("#tableGestorPromotor").html("");

						$('#tipoAmbito1').attr('checked',false);
						$('#tipoAmbito2').attr('checked',false);
						$('#tipoAmbito3').attr('checked',false);
						$('#tipoAmbito4').attr('checked',true);
						habilitaBoton('agrega', 'submit');
						consultaGridPromotor();
					}
					else {
						$('#gestorID').val(tipoGestor.gestorID);
						$('#nombreGestor').val(tipoGestor.nombreCompleto);		
						$('#tipoGestionID').val(tipoGestor.tipoGestionID);
						$('#nombreTipoGestion').val(tipoGestor.nombreTipoGestion);
						$('#supervisorID').val(tipoGestor.supervisorID);
						$('#nombreSupervisor').val(tipoGestor.nombreSupervisor);
						$('#tipoAmbito').val(tipoGestor.tipoAmbito);
						habilitaBoton('agrega', 'submit');
						agregaFormatoControles('formaGenerica');
						}
					}
					else  {	
			            $('#gridSucursal').hide();
			        	$('#gridZona').hide();
			        	$('#gridPromotor').hide();
			        	$("#tableZonaGeografica").html("");
			    		$("#tableGestorSucursal").html("");
			    		$("#tableGestorPromotor").html("");
			    		$('#tipoAmbito1').attr('checked',false);
						$('#tipoAmbito2').attr('checked',false);
						$('#tipoAmbito3').attr('checked',false);
						$('#tipoAmbito4').attr('checked',false);
						deshabilitaBoton('agrega', 'submit');
						}
		
					});																	 				
				}
			}

	//funcion que consulta el Gestor
	function consultaGestor(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();
		var gestor = 12;
		var usuarioBeanCon = {  
				'usuarioID':numUsuario 
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario)){
			usuarioServicio.consulta(gestor,usuarioBeanCon,function(usuario) {  
				if(usuario!=null){
					$('#gestorID').val(usuario.usuarioID);
					$('#nombreGestor').val(usuario.nombreCompleto);			
				}else{ 
					alert("El Usuario Seleccionado No es Gestor");
					$('#gestorID').val('');
					$('#gestorID').focus();
					$('#nombreGestor').val('');
					$('#tipoGestionID').val('');
					$('#nombreTipoGestion').val('');
					$('#tipoAmbito').val('');
		            $('#gridSucursal').hide();
		        	$('#gridZona').hide();
		        	$("#tableZonaGeografica").html("");
		    		$("#tableGestorSucursal").html("");
		    		$("#tableGestorPromotor").html("");
		    		$('#tipoAmbito1').attr('checked',false);
					$('#tipoAmbito2').attr('checked',false);
					$('#tipoAmbito3').attr('checked',false);
					$('#tipoAmbito4').attr('checked',false);
					deshabilitaBoton('agrega','submit');
					
				}    						
			});
		}
		else{
			$('#gestorID').val("");
			$('#nombreGestor').val('');
		}
	}
	
	//funcion que consulta el Supervisor
	function consultaSupervisor(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();
		var supervisor = 13;
		var usuarioBeanCon = {  
				'usuarioID':numUsuario 
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario)){
			usuarioServicio.consulta(supervisor,usuarioBeanCon,function(usuario) {  
				if(usuario!=null){
					$('#supervisorID').val(usuario.usuarioID);
					$('#nombreSupervisor').val(usuario.nombreCompleto);	
					validaSupervisor();
				}else{ 
					alert("El Usuario Seleccionado No es Supervisor");
					$('#supervisorID').val('');
					$('#supervisorID').focus();
					$('#nombreSupervisor').val('');		
				}    						
			});
		}
		else{
			$('#supervisorID').val("");
			$('#nombreSupervisor').val('');
		}
	}
	
	//funcion que valida que el Supervisor no sea el mismo que el Gestor
	function validaSupervisor(){
		var supervisorID = $('#supervisorID').val();
		var gestorID = $('#gestorID').val();
		if(supervisorID==gestorID){
			alert("El Supervisor Seleccionado No puede ser igual al Gestor");
			$('#supervisorID').focus();
			$('#supervisorID').val('');
			$('#nombreSupervisor').val('');
		}
	}
	
	//funcion que consulta sucursal del gestor
	function consultaGridSucursal(){
		var gestor = $('#gestorID').val();
		var tipoGestor = $('#tipoGestionID').val();
		var numCon = 2;
		var gestorBeanCon  = {
				'gestorID' : gestor,
				'tipoGestionID' : tipoGestor
		};
		registroGestorServicio.listaConsulta(numCon, gestorBeanCon,function(sucursal) {
			if (sucursal != null){
				var tds = '';
				for (var i = 0; i < sucursal.length; i++){
					tds += '<tr id="renglonSucursal'+i+'" name="renglonSucursal">';
					tds += '<td><input  id="consecutivoID'+i+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
					tds += '<input id="sucursal'+i+'" name="sucursal"  size="6"  value="" autocomplete="off"  type="hidden" />';								
					tds += '<input type="text" id="sucursalID'+i+'" name="lsucursalID" value="'+sucursal[i].sucursalID +'" size="11" onkeypress="listaSucursal(this.id)" onblur="validaSucursalGestor(this.id)"/></td>';
					tds += '<td><input  id="descripcion'+i+'" name="ldescripcion"  size="62" value="'+sucursal[i].descripcion+'" readOnly="true" type="text" /></td>';	
					tds += '<td><input type="button" name="eliminar" id="'+i +'" value="" class="btnElimina" onclick="eliminaSucursal(this)"/>';
	    			tds += '<input type="button" name="agregaSucursal" id="'+i +'" class="btnAgrega" onclick="agregarGestorSucursal()"/></td>';
					tds += '<tr>';
				}
				document.getElementById("numSucursal").value = sucursal.length;
				$("#tableGestorSucursal").html("");
	    		$("#tableGestorSucursal").append(tds);
	    	}
			});
		}
	
	
	//funcion que consulta zona del gestor
	function consultaGridZona(){
		var gestor = $('#gestorID').val();
		var tipoGestor = $('#tipoGestionID').val();
		var numCon = 3;
		var gestorBeanCon  = {
				'gestorID' : gestor,
				'tipoGestionID' : tipoGestor
		};
		registroGestorServicio.listaConsulta(numCon, gestorBeanCon,function(zona) {
			if (zona != null){
				var tds = '';
				for (var i = 0; i < zona.length; i++){
					tds += '<tr id="renglonZona'+i+'" name="renglonZona">';
					tds += '<td><input  id="consecutivoID'+i+'" name="consecutivoID"  size="6"  tabindex="" value="1" autocomplete="off"  type="hidden" />';
					tds += '<input id="zona'+i+'" name="zona"  size="6"  tabindex="" value="" autocomplete="off"  type="hidden" />';								
					tds += '<input type="text" id="estadoID'+i+'" name="lestadoID" size="8" tabindex="" value="'+zona[i].estadoID +'" onkeypress="listaEstado(this.id)" onblur="validaEstado(this.id)"/></td>';
					tds += '<td><input  id="descripcionEst'+i+'" name="ldescripcionEst"  size="30" tabindex="" value="'+zona[i].descripcionEst +'" disabled="true" readOnly="true" type="text" /></td>';
					tds += '<td><input type="text" id="municipioID'+i+'" name="lmunicipioID" size="8" tabindex="" value="'+zona[i].municipioID +'" onkeypress="listaMunicipio(this.id)" onblur="validaMunicipio(this.id)"/></td>';
					tds += '<td><input  id="descripcionMun'+i+'" name="ldescripcionMun"  size="30" tabindex="" value="'+zona[i].descripcionMun +'"  disabled="true" readOnly="true" type="text" /></td>';
					tds += '<td><input type="text" id="localidadID'+i+'" name="llocalidadID" size="8" tabindex="" value="'+zona[i].localidadID +'" onkeypress="listaLocalidad(this.id)" onblur="validaLocalidad(this.id)"/></td>';
					tds += '<td><input  id="descripcionLoc'+i+'" name="ldescripcionLoc"  size="30" tabindex="" value="'+zona[i].descripcionLoc +'"  disabled="true" readOnly="true" type="text" /></td>';
					tds += '<td><input type="text" id="coloniaID'+i+'" name="lcoloniaID" size="8" tabindex="" value="'+zona[i].coloniaID +'" onkeypress="listaColonia(this.id)" onblur="validaColonia(this.id)"/></td>';
					tds += '<td><input  id="descripcionCol'+i+'" name="ldescripcionCol"  size="30" tabindex="" value="'+zona[i].descripcionCol +'"  disabled="true" readOnly="true" type="text" /></td>';
					tds += '<td><input type="button" name="eliminar" id="'+i +'" value="" class="btnElimina" onclick="eliminaZona(this)"/>';
	    			tds += '<input type="button" name="agregarZona" id="'+i +'" class="btnAgrega" onclick="agregarGestorZona()"/></td>';
					tds += '<tr>';
				}
				document.getElementById("numZona").value = zona.length;
				$("#tableZonaGeografica").html("");
	    		$("#tableZonaGeografica").append(tds);
	    	}
			});
		}
	
	//funcion que consulta promotor del gestor
	function consultaGridPromotor(){
		var gestor = $('#gestorID').val();
		var tipoGestor = $('#tipoGestionID').val();
		var numCon = 4;
		var promotorBeanCon  = {
				'gestorID' : gestor,
				'tipoGestionID' : tipoGestor
		};
		registroGestorServicio.listaConsulta(numCon, promotorBeanCon,function(promotor) {
			if (promotor != null){
				var tds = '';
				for (var i = 0; i < promotor.length; i++){
					tds += '<tr id="renglonPromotor'+i+'" name="renglonPromotor">';
					tds += '<td><input  id="consecutivoID'+i+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
					tds += '<input id="promotor'+i+'" name="promotor"  size="6"  value="" autocomplete="off"  type="hidden" />';								
					tds += '<input type="text" id="promotorID'+i+'" name="lpromotorID" value="'+promotor[i].promotorID +'" size="11" onkeypress="listaPromotor(this.id)" onblur="validaPromotorGestor(this.id)"/></td>';
					tds += '<td><input  id="descripcionProm'+i+'" name="ldescripcionProm"  size="62" value="'+promotor[i].descripcionProm +'" readOnly="true" type="text" /></td>';	
					tds += '<td><input type="button" name="eliminar" id="'+i +'" value="" class="btnElimina" onclick="eliminaPromotor(this)"/>';
	    			tds += '<input type="button" name="agregaPromotor" id="'+i +'" class="btnAgrega" onclick="agregarGestorPromotor()"/></td>';
					tds += '<tr>';
				}
				document.getElementById("numPromotor").value = promotor.length;
				$("#tableGestorPromotor").html("");
	    		$("#tableGestorPromotor").append(tds);
	    	}
			});
		}
	
	//funcion para consultar el Tipo de Gestor
	function consultaTipoGestionID(idControl) {
		var jqTipoGestor = eval("'#" + idControl + "'");
		var tipoGestor = $(jqTipoGestor).val();
		var tipoGestorCon = {
				'tipoGestionID':tipoGestor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoGestor != '' && !isNaN(tipoGestor) && esTab){
			catTiposGestionServicio.consulta(catConTiposGestion.foranea, tipoGestorCon,function(gestor) {
				if (gestor != null) {
					$('#nombreTipoGestion').val(gestor.descripcion);
				} else {
					alert("El Número de Tipo Gestión No Existe");
					$('#tipoGestionID').val('');
					$('#tipoGestionID').focus();
					$('#nombreTipoGestion').val('');
					$('#gridSucursal').hide();
		        	$('#gridZona').hide();
		        	$("#tableZonaGeografica").html("");
		    		$("#tableGestorSucursal").html("");
		    		$("#tableGestorPromotor").html("");
		    		$('#tipoAmbito1').attr('checked',false);
					$('#tipoAmbito2').attr('checked',false);
					$('#tipoAmbito3').attr('checked',false);
					$('#tipoAmbito4').attr('checked',false);
					deshabilitaBoton('agrega','submit');
				}
			});
		}else{
			$('#tipoGestionID').val("");
			$('#nombreTipoGestion').val('');
		}
	}
	
	});//	FIN VALIDACIONES DE REPORTES

	// funcion para agregar filas de sucursales
	function agregarGestorSucursal(){	
		var numeroFila = document.getElementById("numSucursal").value;
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = "";
			tds += '<tr id="renglonSucursal' + nuevaFila + '" name="renglonSucursal">';
		if(numeroFila == 0){
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
			tds += '<input id="sucursal'+nuevaFila+'" name="sucursal"  size="6"  value="" autocomplete="off"  type="hidden" />';								
			tds += '<input type="text" id="sucursalID'+nuevaFila+'" name="lsucursalID" size="11" onkeypress="listaSucursal(this.id)" onblur="validaSucursalGestor(this.id)" /></td>';
			tds += '<td><input  id="descripcion'+nuevaFila+'" name="ldescripcion"  size="62" value="" readOnly="true" type="text" /></td>';	
		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="'+valor+'"autocomplete="off"  type="hidden" />';
			tds += '<input id="sucursal'+nuevaFila+'" name="sucursal"  size="6"  value="" autocomplete="off" type="hidden" />';								
			tds += '<input type="text" id="sucursalID'+nuevaFila+'" name="lsucursalID" size="11" onkeypress="listaSucursal(this.id)" onblur="validaSucursalGestor(this.id)" /></td>';
			tds += '<td><input  id="descripcion'+nuevaFila+'" name="ldescripcion"  size="62" value="" readOnly="true" type="text" /></td>';	
		}
			tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaSucursal(this)"/>';
			tds += '<input type="button" name="agregaSucursal" id="'+nuevaFila +'" class="btnAgrega" onclick="agregarGestorSucursal()"/></td>';
			tds += '</tr>';
			document.getElementById("numSucursal").value = nuevaFila;
			habilitaBoton('agrega','submit');
			$("#tableGestorSucursal").append(tds);
			return false;

		}
		//funcion para eliminar la Sucursal
	function eliminaSucursal(control){
		var numeroID = control.id;
		var jqTr = eval("'#renglonSucursal"+ numeroID +"'");
		$(jqTr).remove();
		//Reordenamiento de Controles 
		$('#numSucursal').val($('#numSucursal').val()-1);
		var numFilas= consultaFilaSucursal();
		if (numFilas <1){
			deshabilitaBoton('agrega','submit');
		}
		else
			{
			habilitaBoton('agrega','submit');
			}
		
		}
	 //funcion que consulta filas de sucursal
	 function consultaFilaSucursal(){
			var totales=0;
			$('tr[name=renglonSucursal]').each(function() {
				totales++;		
			});
			return totales;
		}

	//funcion para agregar filas de zona geografica
	function agregarGestorZona(){	
		var numeroFila = document.getElementById("numZona").value;
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = '<tr id="renglonZona' + nuevaFila + '" name="renglonZona">';
		
		if(numeroFila == 0){
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
			tds += '<input id="zona'+nuevaFila+'" name="zona"  size="6"  value="" autocomplete="off"  type="hidden" />';								
			tds += '<input type="text" id="estadoID'+nuevaFila+'" name="lestadoID" size="8" onkeypress="listaEstado(this.id)" onblur="validaEstado(this.id)" /></td>';
			tds += '<td><input  id="descripcionEst'+nuevaFila+'" name="ldescripcionEst"  size="30" value="" disabled="true" readOnly="true" type="text" /></td>';
			tds += '<td><input type="text" id="municipioID'+nuevaFila+'" name="lmunicipioID" size="8"  onkeypress="listaMunicipio(this.id)" onblur="validaMunicipio(this.id)" /></td>';
			tds += '<td><input  id="descripcionMun'+nuevaFila+'" name="ldescripcionMun"  size="30" value="" disabled="true" readOnly="true" type="text" /></td>';
			tds += '<td><input type="text" id="localidadID'+nuevaFila+'" name="llocalidadID" size="8" onkeypress="listaLocalidad(this.id)" onblur="validaLocalidad(this.id)" /></td>';
			tds += '<td><input  id="descripcionLoc'+nuevaFila+'" name="ldescripcionLoc"  size="30"  value="" disabled="true" readOnly="true" type="text" /></td>';
			tds += '<td><input type="text" id="coloniaID'+nuevaFila+'" name="lcoloniaID" size="8" onkeypress="listaColonia(this.id)" onblur="validaColonia(this.id)" /></td>';
			tds += '<td><input  id="descripcionCol'+nuevaFila+'" name="ldescripcionCol"  size="30"  value="" disabled="true" readOnly="true" type="text" /></td>';

		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6" value="'+valor+'"autocomplete="off"  type="hidden" />';
			tds += '<input id="zona'+nuevaFila+'" name="zona"  size="6"  value="" autocomplete="off"  type="hidden" />';								
			tds += '<input type="text" id="estadoID'+nuevaFila+'" name="lestadoID" size="8" nkeypress="listaEstado(this.id)" onblur="validaEstado(this.id)" /></td>';
			tds += '<td><input  id="descripcionEst'+nuevaFila+'" name="ldescripcionEst"  size="30" tabindex="" value="" disabled="true" readOnly="true" type="text" /></td>';
			tds += '<td><input type="text" id="municipioID'+nuevaFila+'" name="lmunicipioID" size="8" onkeypress="listaMunicipio(this.id)" onblur="validaMunicipio(this.id)" /></td>';
			tds += '<td><input  id="descripcionMun'+nuevaFila+'" name="ldescripcionMun"  size="30" value="" disabled="true" readOnly="true" type="text" /></td>';
			tds += '<td><input type="text" id="localidadID'+nuevaFila+'" name="llocalidadID" size="8" onkeypress="listaLocalidad(this.id)" onblur="validaLocalidad(this.id)"/></td>';
			tds += '<td><input  id="descripcionLoc'+nuevaFila+'" name="ldescripcionLoc"  size="30"  value="" disabled="true" readOnly="true" type="text" /></td>';
			tds += '<td><input type="text" id="coloniaID'+nuevaFila+'" name="lcoloniaID" size="8"  onkeypress="listaColonia(this.id)" onblur="validaColonia(this.id)" /></td>';
			tds += '<td><input  id="descripcionCol'+nuevaFila+'" name="ldescripcionCol"  size="30"  value="" disabled="true" readOnly="true" type="text" /></td>';
		}
			tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaZona(this)"/>';
			tds += '<input type="button" name="agregarZona" id="'+nuevaFila +'" class="btnAgrega" onclick="agregarGestorZona()"/></td>';
			tds += '</tr>';
			document.getElementById("numZona").value = nuevaFila;
			habilitaBoton('agrega','submit');
			$("#tableZonaGeografica").append(tds);
			return false;
			
		}
	//funcion para eliminar Zona Geografica
	function eliminaZona(control){
		var numeroID = control.id;
		var jqTr = eval("'#renglonZona"+ numeroID +"'");
		$(jqTr).remove();
		//Reordenamiento de Controles 
		$('#numZona').val($('#numZona').val()-1);
		var numFilas= consultaFilaZona();
		if (numFilas <1){
			deshabilitaBoton('agrega','submit');
		}
		else
			{
			habilitaBoton('agrega','submit');
			}
		}
	
	 //funcion que consulta filas de zona geografica
	 function consultaFilaZona(){
			var totales=0;
			$('tr[name=renglonZona]').each(function() {
				totales++;		
			});
			return totales;
		}
	// funcion para agregar filas de promotores
	function agregarGestorPromotor(){	
		var numeroFila = document.getElementById("numPromotor").value;
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = "";
			tds += '<tr id="renglonPromotor' + nuevaFila + '" name="renglonPromotor">';
		if(numeroFila == 0){
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
			tds += '<input id="promotor'+nuevaFila+'" name="promotor"  size="6"  value="" autocomplete="off"  type="hidden" />';								
			tds += '<input type="text" id="promotorID'+nuevaFila+'" name="lpromotorID" size="11" onkeypress="listaPromotor(this.id)" onblur="validaPromotorGestor(this.id)" /></td>';
			tds += '<td><input  id="descripcionProm'+nuevaFila+'" name="ldescripcionProm"  size="62" value="" readOnly="true" type="text" /></td>';			
		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="'+valor+'"autocomplete="off"  type="hidden" />';
			tds += '<input id="promotor'+nuevaFila+'" name="promotor"  size="6"  value="" autocomplete="off"  type="hidden" />';								
			tds += '<input type="text" id="promotorID'+nuevaFila+'" name="lpromotorID" size="11" onkeypress="listaPromotor(this.id)" onblur="validaPromotorGestor(this.id)" /></td>';
			tds += '<td><input  id="descripcionProm'+nuevaFila+'" name="ldescripcionProm"  size="62" value="" readOnly="true" type="text" /></td>';			
		}
			tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaPromotor(this)"/>';
			tds += '<input type="button" name="agregaPromotor" id="'+nuevaFila +'" class="btnAgrega" onclick="agregarGestorPromotor()"/></td>';
			tds += '</tr>';
			document.getElementById("numPromotor").value = nuevaFila;
			habilitaBoton('agrega','submit');
			$("#tableGestorPromotor").append(tds);
			return false;
			
		}
	//funcion para eliminar el Promotor	
	function eliminaPromotor(control){
		var numeroID = control.id;
		var jqTr = eval("'#renglonPromotor"+ numeroID +"'");
		$(jqTr).remove();
		//Reordenamiento de Controles 
		$('#numPromotor').val($('#numPromotor').val()-1);
		var numFilas= consultaFilaPromotor();
		if (numFilas <1){
			deshabilitaBoton('agrega','submit');
		}
		else
			{
			habilitaBoton('agrega','submit');
			}
		}

	
	 //funcion que consulta filas de zona geografica
	 function consultaFilaPromotor(){
			var totales=0;
			$('tr[name=renglonPromotor]').each(function() {
				totales++;		
			});
			return totales;
		}
	 
	// funcion para listar las sucursales
	function listaSucursal(idControl){
		var jq = eval("'#" + idControl + "'");
		$(jq).bind('keyup',function(e){
			var jqControl = eval("'#" + this.id + "'");
			var num = $(jqControl).val();
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreSucurs"; 			
			parametrosLista[0] = num;
			
			lista(idControl, '1', '1', camposLista, parametrosLista, 'listaSucursales.htm');
		});
	}
	
   // funcion para consultar las sucursales
	function validaSucursalGestor(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");	
		var jqSucursalDes = eval("'#descripcion" + idControl.substr(10) + "'");	
		var numSucursal = $(jqSucursal).val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
			if(verificaSeleccionadoSucursal(idControl) == 0){
				sucursalesServicio.consultaSucursal(tipConPrincipal,numSucursal,function(suc) {
				if(suc!=null){
						$(jqSucursalDes).val(suc.nombreSucurs);		
					}else{
						alert("La Sucursal Seleccionada No Existe");
						$(jqSucursal).val("");
						$(jqSucursal).focus();
						$(jqSucursalDes).val("");
						}
					});
			}
			}else {
				$(jqSucursalDes).val("");
		}
	}

	//funcion que verifica una sucursal ya existente
	function verificaSeleccionadoSucursal(idCampo){
		var contador = 0;
		var nuevaSucursal=$('#'+idCampo).val();
		var numeroNuevo= idCampo.substr(10,idCampo.length);
		var jqDescripcion = eval("'descripcion" + numeroNuevo+ "'");
		$('tr[name=renglonSucursal]').each(function() {
			var numero= this.id.substr(15,this.id.length);
			var jqIdSucursal = eval("'sucursalID" + numero+ "'");
			
			var valorSucursal = $('#'+jqIdSucursal).val();
			if(jqIdSucursal != idCampo){
				if(valorSucursal == nuevaSucursal  && valorSucursal >0){
					alert("La Sucursal ya se encuentra Seleccionada");
					$('#'+idCampo).focus();
					$('#'+idCampo).val("");
					$('#'+jqDescripcion).val("");
					contador = contador+1;
				}		
			}
		});		
		return contador;
	}

  // funcion para listar los estados
	function listaEstado(idControl){
		var jqControl = eval("'#" + idControl+ "'");
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombre";
		parametrosLista[0] = $(jqControl).val();
		if($(jqControl).val() != ''){
			listaAlfanumerica(idControl, '2', '1', camposLista,parametrosLista,'listaEstados.htm');
		}
	}

	// funcion para consultar la descripcion del estado  
	function validaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var jqEstadoDes = eval("'#descripcionEst" + idControl.substr(8) + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if (numEstado != '' && !isNaN(numEstado) && esTab) {
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if (estado != null) {
					if(estado.estadoID == 0){
						$(jqEstadoDes).val("TODOS");
					}else{
					$(jqEstadoDes).val(estado.nombre);
					}
				} else {
					alert("No Existe el Estado");
					$(jqEstado).val("");
					$(jqEstado).focus();
					$(jqEstadoDes).val("");
				}
			});
			}else {
				$(jqEstadoDes).val("");	
			}
		}
	
	//funcion para listar los municipios
	function listaMunicipio(idControl){
		var jqControl = eval("'#" + idControl+ "'");
		var jqEstadoID = eval("'#estadoID" + idControl.substr(11) + "'");
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		parametrosLista[0] = $(jqEstadoID).val();
		parametrosLista[1] = $(jqControl).val();
		if($(jqControl).val() != ''){
			listaAlfanumerica(idControl, '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
		}
	}	
	
	//funcion para consultar la descripcion del municipio  
	function validaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var jqestadoID =  eval("'#estadoID" + idControl.substr(11) + "'");	
		var jqMunicipioDes = eval("'#descripcionMun" + idControl.substr(11) + "'");	
		var numEstado = $(jqestadoID).val();
		var numMunicipio = $(jqMunicipio).val();	
		var tipConForanea = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if (numMunicipio != '' && !isNaN(numMunicipio) && esTab) {
			if(numMunicipio==0){
				$(jqMunicipioDes).val("TODOS");
			}else{
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
				if (municipio != null) {
					$(jqMunicipioDes).val(municipio.nombre);	
				} else {
					alert("No Existe el Municipio");
					$(jqMunicipio).val("");
					$(jqMunicipio).focus();
					$(jqMunicipioDes).val("");
				}
			});
			}
			}else {
				$(jqMunicipioDes).val("");	
		}
	}
	
	
	//funcion para listar localidades de la republica
	function listaLocalidad(idControl){
		var jqControl = eval("'#" + idControl+ "'");
		var jqEstadoID = eval("'#estadoID" + idControl.substr(11) + "'");
		var jqMunicipioID = eval("'#municipioID" + idControl.substr(11) + "'");
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";
		parametrosLista[0] = $(jqEstadoID).val();
		parametrosLista[1] = $(jqMunicipioID).val();
		parametrosLista[2] = $(jqControl).val();
		if($(jqControl).val() != ''){
			listaAlfanumerica(idControl, '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
		}
	}
	
	// funcion para consultar la descripcion de la localidad 
	function validaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var jqLocalidadDes = eval("'#descripcionLoc" + idControl.substr(11) + "'");
		var jqMunicipioID = eval("'#municipioID" + idControl.substr(11) + "'");
		var jqEstadoID = eval("'#estadoID" + idControl.substr(11) + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$(jqMunicipioID).val();
		var numEstado =  $(jqEstadoID).val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if(numLocalidad != '' && !isNaN(numLocalidad) && esTab){
			if(numLocalidad==0){
				$(jqLocalidadDes).val("TODOS");
			}else{
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
				if (localidad != null) {
						$(jqLocalidadDes).val(localidad.nombreLocalidad);
				} else {
					alert("No Existe la Localidad");
					$(jqLocalidad).val("");
					$(jqLocalidad).focus();
					$(jqLocalidadDes).val("");
				}
			});
			}
		}else {
			$(jqLocalidadDes).val("");	
		}
	}
	
	//funcion para listar colonias de la republica
	function listaColonia(idControl){
		var jqControl = eval("'#" + idControl+ "'");
		var jqEstadoID = eval("'#estadoID" + idControl.substr(9) + "'");
		var jqMunicipioID = eval("'#municipioID" + idControl.substr(9) + "'");
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "asentamiento";
		parametrosLista[0] = $(jqEstadoID).val();
		parametrosLista[1] = $(jqMunicipioID).val();
		parametrosLista[2] = $(jqControl).val();
		if($(jqControl).val() != ''){
			listaAlfanumerica(idControl, '2', '1', camposLista, parametrosLista,'listaColonias.htm');
		}
	}
	
	// funcion para consultar la descripcion de la colonia
	function validaColonia(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var jqColoniaDes = eval("'#descripcionCol" + idControl.substr(9) + "'");
		var jqMunicipioID = eval("'#municipioID" + idControl.substr(9) + "'");
		var jqEstadoID = eval("'#estadoID" + idControl.substr(9) + "'");
		
		var numColonia = $(jqColonia).val();
		var numMunicipio =	$(jqMunicipioID).val();
		var numEstado =  $(jqEstadoID).val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if(numColonia != '' && !isNaN(numColonia) && esTab){
			if(numColonia==0){
				$(jqColoniaDes).val("TODOS");
			}else{
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
				if (colonia != null) {
						$(jqColoniaDes).val(colonia.asentamiento);
				} else {
					alert("No Existe la Colonia");
					$(jqColonia).val("");
					$(jqColonia).focus();
					$(jqColoniaDes).val("");
				}
			});
			}
		}else {
			$(jqColoniaDes).val("");	
		}
	}
	
	// funcion para listar los Promotores
	function listaPromotor(idControl){
		var jq = eval("'#" + idControl + "'");
		$(jq).bind('keyup',function(e){
			var jqControl = eval("'#" + this.id + "'");
			var num = $(jqControl).val();
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombrePromotor"; 			
			parametrosLista[0] = num;
			
			lista(idControl, '1', '1', camposLista, parametrosLista, 'listaPromotores.htm');
		});
	}
	
	// funcion para consultar las sucursales
	function validaPromotorGestor(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");	
		var jqPromotorDes = eval("'#descripcionProm" + idControl.substr(10) + "'");	
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		var promotorBean = {
			'promotorID':numPromotor
		};
		if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
			if(verificaSeleccionadoPromotor(idControl) == 0){
			promotoresServicio.consulta(tipConForanea,promotorBean,function(promotor) {
				if(promotor!=null){
						$(jqPromotorDes).val(promotor.nombrePromotor);
					}else{
						alert("El Promotor Seleccionado No Existe");
						$(jqPromotor).val("");
						$(jqPromotor).focus();
						$(jqPromotorDes).val("");
						}
					});	
			}
			}else {
				
				$(jqPromotorDes).val("");
		}
	}
	
	//funcion que verifica una sucursal ya existente
	function verificaSeleccionadoPromotor(idCampo){
		var contador = 0;
		var nuevoPromotor=$('#'+idCampo).val();
		var numeroNuevo= idCampo.substr(10,idCampo.length);
		var jqDescripcion = eval("'descripcionProm" + numeroNuevo+ "'");
		$('tr[name=renglonPromotor]').each(function() {
			var numero= this.id.substr(15,this.id.length);
			var jqIdSucursal = eval("'promotorID" + numero+ "'");
			
			var valorSucursal = $('#'+jqIdSucursal).val();
			if(jqIdSucursal != idCampo){
				if(valorSucursal == nuevoPromotor  && valorSucursal >0){
					alert("El Promotor ya se encuentra Seleccionado");
					$('#'+idCampo).focus();
					$('#'+idCampo).val("");
					$('#'+jqDescripcion).val("");
					contador = contador+1;
				}		
			}
		});		
		return contador;
	}
	
	function funcionExito(){
		$('#tipoGestionID').val('');
		$('#nombreGestor').val('');
		$('#tipoGestionID').val('');
		$('#nombreTipoGestion').val('');
		$('#supervisorID').val('');
		$('#nombreSupervisor').val('');
		$('#tipoAmbito1').attr('checked',false);
		$('#tipoAmbito2').attr('checked',false);
		$('#tipoAmbito3').attr('checked',false);
		$('#tipoAmbito4').attr('checked',false);
		$('#gridZona').hide(500);
		$('#gridSucursal').hide(500);
		$('#gridPromotor').hide(500);
		$("#tableZonaGeografica").html("");
		$("#tableGestorSucursal").html("");
		$("#tableGestorPromotor").html("");
		deshabilitaBoton('agrega', 'submit');
	}
	
	function funcionError(){
		$('#gestorID').focus();
		habilitaBoton('agrega', 'submit');
	}