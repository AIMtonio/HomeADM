var tabButton=18;
$(document).ready(function() {
	
	$('#grupoID').focus();
	
	esTab = true;
	
	var  Enum_Tra_Grupos  = {
		 'alta' :'1',
		'modifica':'2'
	};
	var  Enum_Tra_IntGrupos  = {
		 'alta' :'1',
		'modifica':'2'
	};
	
	var parametroBean = consultaParametrosSession();
	var sucursal=parametroBean.sucursal;
	$('#sucursalID').val(parametroBean.sucursal);

//---------------Metodos y manejo de eventos ----------------
	deshabilitaBoton('modifica', 'submit'); 
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('grabar', 'submit');
	

	agregaFormatoControles('formaGenerica');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#agregaI').click(function() {		
		agregaCliente();
		habilitaBoton('grabar', 'submit');
		
	});
	$('#grupoID').blur(function() {
  		validaGrupo(this.id);
	});
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(Enum_Tra_Grupos.alta);
		$('#tipoTransaccionGrid').val('0');
	});
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(Enum_Tra_Grupos.modifica);
		$('#tipoTransaccionGrid').val('0');
	});
	$('#grabar').click(function() {		
		
			$('#tipoTransaccion').val('0');
			$('#tipoTransaccionGrid').val(Enum_Tra_IntGrupos.alta);
		
	
		
	});
	$('#promotorID').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorID').val();
		parametrosLista[1] = parametroBean.sucursal;  
		lista('promotorID', '1', '2',camposLista, parametrosLista, 'listaPromotores.htm');
	});
	$('#promotorID').blur(function() {
		consultaPromotor(this.id);
	});
	$('#estadoID').bind('keyup',function(e) {
		lista('estadoID', '2', '1', 'nombre',$('#estadoID').val(),'listaEstados.htm');
	});

	$('#estadoID').blur(function() {
		consultaEstado(this.id);
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
	
	$('#municipioID').blur(function() {
  		consultaMunicipio(this.id);
	});
	$('#grupoID').bind('keyup',function(e) { 
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreGrupo";
		camposLista[1] = "sucursal";
		parametrosLista[0] = $('#grupoID').val();
		parametrosLista[1] = parametroBean.sucursal;  
		
		lista('grupoID', '2', '1', camposLista, parametrosLista, 'listaGruposNosolidarios.htm');
});
	$.validator.setDefaults({
		submitHandler : function(event) {
			
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','grupoID',
					'limpiaFormulario','error');	
			}
	});

//-------------Validaciones de la Forma ---------------------	
	$('#formaGenerica').validate({
		rules : {
			promotorID : {
				required : true
			},
			horaReunion : {
				maxlength :8
			},
			ahoObligatorio : {
				number : true,
				maxlength : 18
			},
			costoAusencia : {
				number : true,
				maxlength : 18
			},
			moraCredito : {
				number : true,
				maxlength : 18
			},
			ahorroCompro : {
				number : true,
				maxlength : 18
			},
			nombreGrupo :{
				required : true
			},
			estadoID :{
				required : true
			},
			municipioID :{
				required : function() {return $('#estadoID').val() > 0;}
			}
			
		},
	
		messages : {
			promotorID : {
				required : 'Especifique el Promotor',
			},
			horaReunion : {
				maxlength : 'Solo 8 Caracteres'
			},
			ahoObligatorio : {
				number : 'Solo Números',
				maxlength : 'Máximo 12 digitos'
			},
			costoAusencia : {
				number : 'Solo Números',
				maxlength : 'Máximo 12 digitos'
			},
			moraCredito : {
				number : 'Solo Números',
				maxlength : 'Máximo 12 digitos'
			},
			ahorroCompro : {
				number :'Solo Números',
				maxlength : 18
			},
			nombreGrupo :{
				required : 'Especifique Nombre de Grupo'
			},
			municipioID :{
				required : 'Especifique Municipio'
			},
			estadoID :{
				required : 'Especifique Estado'
			}
		
	
		}
	});
	
	
//-------------Funciones-------------------------------------	
	function validaGrupo(idControl) {
		setTimeout("$('#cajaLista').hide();", 200);
		var tamGrid=$('#numIntegrantes').val();
	
		var jqGrupo = eval("'#" + idControl + "'");
		var numGrupo = $(jqGrupo).val();
	
		if(numGrupo != '' && !isNaN(numGrupo) && esTab){
			if(numGrupo == '0'){
				limpiaFormulario();
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				$('#gridIntegrantes').hide(500);
			} else {
				var tipoConsulta=1;
				var gruposNosolidariosBean = {
					'grupoID'	:numGrupo
				};
				gruposNosolidarios.consulta(tipoConsulta,gruposNosolidariosBean, function(grupo){
					if(grupo != null){
						esTab=true;
						if(grupo.sucursalID == parametroBean.sucursal){
						dwr.util.setValues(grupo);
						if($('#municipioID').val() == '0'){
							$('#municipioID').val('');
						}
						consultaPromotor('promotorID');
						consultaEstado('estadoID');
						if(grupo.estadoID > 0){
							consultaMunicipio('municipioID');
						}
						
						deshabilitaBoton('agrega', 'submit');		
						habilitaBoton('modifica', 'submit');
						$('#gridIntegrantes').show(500);
						deshabilitaBoton('grabar', 'submit');
						consultaGridIntegrantes();
						agregaFormatoControles('formaGenerica');
						}else{
							mensajeSis ('El Grupo No Pertenece a la Sucursal');
							$('#gridIntegrantes').hide(500);
							limpiaFormulario();
							$('#grupoID').val('');
							$('#grupoID').focus();
						}
						 
					}else{	
						mensajeSis('El Grupo No Existe');
						limpiaFormulario();
						$('#grupoID').val('');
						$('#grupoID').focus();
	
					}
				});
				
			}
		}else{
			if (numGrupo == ""){
				limpiaFormulario();
			}
		}
	}
	function consultaPromotor(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
			promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {
					if(promotor.estatus != 'A'){
						mensajeSis("El promotor debe de estar Activo");
						 $(jqPromotor).val("");
						 $(jqPromotor).focus();
						 $('#nombrePromotor').val("");
					}else{
						
						parametroBean = consultaParametrosSession();
						if(promotor.sucursalID != parametroBean.sucursal){
							mensajeSis("El promotor debe de pertenecer a la sucursal: "+parametroBean.nombreSucursal);
							$(jqPromotor).val("");
							 $('#nombrePromotor').val("");
							 $(jqPromotor).focus();
						}else{
							$('#nombrePromotor').val(promotor.nombrePromotor);
						}
						
					}					
				} else {
					mensajeSis("No Existe el Promotor");
					 $('#nombrePromotor').val("");
					 $('#promotorID').val('');
					 $('#promotorID').focus();
				}
			});
		}else{
			$('#nombrePromotor').val("");
		}
	}
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numEstado != '' && !isNaN(numEstado) && esTab) {
		
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
								if (estado != null) {
									$('#nombreEstado').val(estado.nombre);
								} else {
									mensajeSis("No Existe el Estado");
									$('#estadoID').focus();
									$('#estadoID').val('');
									$('#nombreEstado').val('');
								}
							});
		}else{
			$('#nombreEstado').val('');
		}
	  
	}
	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
			
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
				if(municipio!=null){							
					$('#nombreMunicipio').val(municipio.nombre);
				}else{
					mensajeSis("No Existe el Municipio");
					$('#municipioID').focus();
					$('#municipioID').val('');
					$('#nombreMunicipio').val('');
				}    	 						
			});
		}else{
			$('#nombreMunicipio').val('');
		}
	}	


	function consultaGridIntegrantes(){
		var grupoID = $('#grupoID').val();
		var numCon = 1;
		var tds='';
		
		var integrantesBeanCon  = {
				'grupoID' : grupoID,
		};

		while(consultaFilas() >0){
			eliminaCliente(consultaFilas());
		}
	
		integraGrupoNosolServicio.lista(numCon, integrantesBeanCon,function(integrante) {
			if (integrante != null || !integrante.isEmpty()){				
									
					for (var i = 0; i < integrante.length; i++){
						habilitaBoton('grabar', 'submit');
					tds += '<tr id="renglon' +i+ '" name="renglon">';
					tds += '<td><input  id="consecutivoID'+i+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
					tds += '<input id="cliente'+i+'" name="cliente"  size="6"  value="" autocomplete="off"  type="hidden" />';								
					tds += '<input type="text" id="clienteID'+i+'" name="lclientes" value="'+integrante[i].clienteID +'"  size="11" tabindex="'+(tabButton = tabButton+1)+')" onKeyUp="listaClientes(\'clienteID'+i+'\');" onblur="consultaCliente('+i+');" /></td>';
					tds += '<td><input  id="nombreCompleto'+i+'" name="nombreCompleto"   size="30" value="'+integrante[i].nombreCompleto+'" readOnly="true" type="text" /></td>';			
					tds += '<td><input  id="menor'+i+'" name="menor"  size="3" value="'+integrante[i].esMenorEdad+'"  readOnly="true" type="text" /></td>';			
					tds += '<td><input  id="estatusC'+i+'" name="estatusC"  size="8" value="'+integrante[i].estatus+'" readOnly="true" type="text" /></td>';			
					tds += '<td><select id="tipoIntegrante'+i+'" name="ltipoIntegrante"  tabindex="'+(tabButton = tabButton+1)+'" onblur="validaTipoInt('+i+');"  ><option value="" selected="true">SELECCIONAR'+
							'<option value="1" >L&Iacute;DER </option> <option value="2">TESORERO </option><option value="3">VOCAL </option>' +
							'<option value="4">INTEGRANTE </option></select></td>';			
					tds += '<td><input  id="ahorros'+i+'" name="ahorros"  esMoneda="true" style="text-align:right;" size="20" value="'+integrante[i].ahorro+'" readOnly="true" type="text" /></td>';			
					tds += '<td><input  id="exigibleDia'+i+'" name="exigibleDia" esMoneda="true"  style="text-align:right;" size="20" value="'+integrante[i].exigibleDia+'" readOnly="true" type="text" /></td>';		
					tds += '<td><input  id="totalDia'+i+'" name="totalDia"  esMoneda="true" style="text-align:right;" size="20" value="'+integrante[i].totalDia+'" readOnly="true" type="text" /></td>';
					tds += '<td nowrap="nowrap"><input type="button" name="eliminar" id="'+i +'" value="" tabindex="'+(tabButton = tabButton+1)+'" class="btnElimina" onclick="eliminaCliente(this.id)"/>';
					tds += '<input type="button" name="agrega" id="agrega'+i +'" value=""   tabindex="'+(tabButton = tabButton+1)+'" class="btnAgrega"  onclick="agregaCliente()""/></td>';
					tds += '</tr>';	
					 $('#grabar').attr('tabindex',tabButton+1);
					 $('#numIntegrantes').val(i+1);
					 agregaFormatoControles('formaGenerica');
					
					}
		    	 $("#tablaCliente").append(tds);
		    	 
		    	 for (var i = 0; i < integrante.length; i++){
					 var tipoInt=integrante[i].tipoIntegrante;
					 $('#tipoIntegrante'+i).val(tipoInt);
		    	 }
	    	}else{
	    		deshabilitaBoton('grabar', 'submit');
	    	}
			});
		}
});

function limpiaFormulario(){
	while(consultaFilas() >0){
		eliminaCliente(consultaFilas());
	}

	$('#nombreGrupo').val('');
	$('#numIntegrantes').val('');
	$('#promotorID').val('');
	$('#nombrePromotor').val('');
	$('#estadoID').val('');
	$('#nombreEstado').val('');
	$('#municipioID').val('');
	$('#nombreMunicipio').val('');
	$('#ubicacion').val('');
	$('#lugarReunion').val('');
	$('#diaReunion').val('');
	$('#horaReunion').val('');
	$('#ahoObligatorio').val('');
	$('#plazoCredito').val('');
	$('#costoAusencia').val('');
	$('#ahorroCompro').val('');
	$('#moraCredito').val('');
	$('#gridIntegrantes').hide(500);
	deshabilitaBoton('modifica', 'submit'); 
	deshabilitaBoton('agrega', 'submit');
	
	
}

function error(){
	agregaFormatoControles('formaGenerica');
}


function agregaCliente(){	
	$('#gridIntegrantes').show(500);
	var numeroFila = consultaFilas();
	var nuevaFila = parseInt(numeroFila) + 1;	
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	
	  
	if(numeroFila == 0){
		tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
		tds += '<input id="cliente'+nuevaFila+'" name="cliente"  size="6"  value="" autocomplete="off"  type="hidden" />';								
		tds += '<input type="text" id="clienteID'+nuevaFila+'" name="lclientes" size="11" tabindex="'+(tabButton = tabButton+1)+'" onKeyUp="listaClientes(\'clienteID'+nuevaFila+'\');" onblur="consultaCliente('+nuevaFila+');" /></td>';
		tds += '<td><input  id="nombreCompleto'+nuevaFila+'" name="nombreCompleto"   size="30" value="" readOnly="true" type="text" /></td>';			
		tds += '<td><input  id="menor'+nuevaFila+'" name="menor"  size="2" value=""  readOnly="true" type="text" /></td>';			
		tds += '<td><input  id="estatusC'+nuevaFila+'" name="estatusC"  size="8" value="" readOnly="true" type="text" /></td>';			
		tds += '<td><select id="tipoIntegrante'+nuevaFila+'" name="ltipoIntegrante"  tabindex="'+(tabButton = tabButton+1)+'" onblur="validaTipoInt('+nuevaFila+');"  ><option value="" selected="true">SELECCIONAR </option>'+
				'<option value="1" >L&Iacute;DER </option> <option value="2">TESORERO </option><option value="3">VOCAL </option>' +
				'<option value="4">INTEGRANTE </option></select></td>';			
		tds += '<td><input  id="ahorros'+nuevaFila+'" name="ahorros"  esMoneda="true" style="text-align:right;" size="20" value="" readOnly="true" type="text" /></td>';			
		tds += '<td><input  id="exigibleDia'+nuevaFila+'" name="exigibleDia" esMoneda="true"  style="text-align:right;" size="20" value="" readOnly="true" type="text" /></td>';		
		tds += '<td><input  id="totalDia'+nuevaFila+'" name="totalDia"  esMoneda="true" style="text-align:right;" size="20" value="" readOnly="true" type="text" /></td>';
		tds += '<td nowrap="nowrap"><input type="button" name="eliminar" id="'+nuevaFila +'" value="" tabindex="'+(tabButton = tabButton+1)+'" class="btnElimina" onclick="eliminaCliente(this.id)"/>';
		tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value=""   tabindex="'+(tabButton = tabButton+1)+'" class="btnAgrega"  onclick="agregaCliente()""/></td>';
		tds += '</tr>';	
		 $('#grabar').attr('tabindex',tabButton+1);
		 $('#numIntegrantes').val(nuevaFila);
	} else{
		var contador = 1;
		    $('input[name=consecutivoID]').each(function() {		
			contador = contador + 1;	
		  });
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
			tds += '<input id="cliente'+nuevaFila+'" name="cliente"  size="6"  value="" autocomplete="off"  type="hidden" />';								
			tds += '<input type="text" id="clienteID'+nuevaFila+'" name="lclientes" size="11"  tabindex="'+(tabButton = tabButton+1)+'" onblur="consultaCliente('+nuevaFila+');" onKeyUp="listaClientes(\'clienteID'+nuevaFila+'\');"  /></td>';
			tds += '<td><input  id="nombreCompleto'+nuevaFila+'" name="nombreCompleto"  size="30" value="" readOnly="true" type="text" /></td>';			
			tds += '<td><input  id="menor'+nuevaFila+'" name="menor"  size="2" value="" readOnly="true" type="text" /></td>';			
			tds += '<td><input  id="estatusC'+nuevaFila+'" name="estatusC"  size="8" value="" readOnly="true" type="text" /></td>';			
			tds += '<td><select id="tipoIntegrante'+nuevaFila+'" name="ltipoIntegrante"  tabindex="'+(tabButton = tabButton+1)+'" onblur="validaTipoInt('+nuevaFila+');" ><option value="" selected="true">SELECCIONAR </option>'+
			'<option value="1" >LÍDER </option> <option value="2">TESORERO </option><option value="3">VOCAL </option>' +
			'<option value="4">INTEGRANTE </option></select></td>';					
			tds += '<td><input  id="ahorros'+nuevaFila+'" name="ahorros" esMoneda="true" style="text-align:right;"   size="20" value="" readOnly="true" type="text" /></td>';			
			tds += '<td><input  id="exigibleDia'+nuevaFila+'" name="exigibleDia" esMoneda="true" style="text-align:right;"  size="20" value="" readOnly="true" type="text" /></td>';		
			tds += '<td><input  id="totalDia'+nuevaFila+'" name="totalDia" esMoneda="true" style="text-align:right;"  size="20" value="" readOnly="true" type="text" /></td>';
			tds += '<td nowrap="nowrap"><input type="button" name="eliminar" id="'+nuevaFila +'" value=""  tabindex="'+(tabButton = tabButton+1)+'" class="btnElimina" onclick="eliminaCliente(this.id)"/>';
			tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value=""  tabindex="'+(tabButton = tabButton+1)+'" class="btnAgrega"  onclick="agregaCliente()""/></td>';
			tds += '</tr>';	
			 $('#grabar').attr('tabindex',tabButton+1);
			 $('#numIntegrantes').val(nuevaFila);
			
			}
		   	   
		$("#tablaCliente").append(tds);
		return false;		
 }
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;		
	});
	return totales;

}

function eliminaCliente(control){
	
	var contador = 0 ;
	var numeroID = control;

	var jqRenglon = eval("'#renglon" + numeroID + "'");
	var jqNumero = eval("'#consecutivoID" + numeroID + "'");
	var jqCliente = eval("'#cliente" + numeroID + "'");		
	var jqClienteID = eval("'#clienteID" + numeroID + "'");
	var jqNombreCompleto=eval("'#nombreCompleto" + numeroID + "'");
	var jqMenor=eval("'#menor" + numeroID + "'");
	var jqEstatus=eval("'#estatusC" + numeroID + "'");
	var jqTipoIntegrante=eval("'#tipoIntegrante" + numeroID + "'");
	var jqAhorros=eval("'#ahorros" + numeroID + "'");
	var jqExigibleDia=eval("'#exigibleDia" + numeroID + "'");
	var jqTotalDia=eval("'#totalDia" + numeroID + "'");
	var jqAgrega=eval("'#agrega" + numeroID + "'");
	var jqElimina = eval("'#" + numeroID + "'");
	
	

	// se elimina la fila seleccionada
	$(jqNumero).remove();
	$(jqCliente).remove();
	$(jqClienteID).remove();
	$(jqNombreCompleto).remove();
	$(jqMenor).remove();
	$(jqEstatus).remove();
	$(jqTipoIntegrante).remove();
	$(jqAhorros).remove();
	$(jqExigibleDia).remove();
	$(jqTotalDia).remove();
	$(jqAgrega).remove();
	$(jqRenglon).remove();
	$(jqElimina).remove();
	
	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglon]').each(function() {		
		numero= this.id.substr(7,this.id.length);
		var jqRenglon = eval("'#renglon" + numero + "'");
		var jqNumero = eval("'#consecutivoID" + numero + "'");
		var jqCliente = eval("'#cliente" + numero + "'");		
		var jqClienteID = eval("'#clienteID" + numero + "'");
		var jqNombreCompleto=eval("'#nombreCompleto" + numero + "'");
		var jqMenor=eval("'#menor" + numero + "'");
		var jqEstatus=eval("'#estatusC" + numero + "'");
		var jqTipoIntegrante=eval("'#tipoIntegrante" + numero + "'");
		var jqAhorros=eval("'#ahorros" + numero + "'");
		var jqExigibleDia=eval("'#exigibleDia" + numero + "'");
		var jqTotalDia=eval("'#totalDia" + numero + "'");
		var jqAgrega=eval("'#agrega" + numero + "'");
		var jqElimina = eval("'#" + numero + "'");
		
		
		$(jqNumero).attr('id','consecutivoID'+contador);
		$(jqCliente).attr('id','cliente'+contador);
		$(jqClienteID).attr('id','clienteID'+contador);
		$(jqNombreCompleto).attr('id','nombreCompleto'+contador);
		$(jqMenor).attr('id','menor'+contador);
		$(jqEstatus).attr('id','estatusC'+contador);
		$(jqTipoIntegrante).attr('id','tipoIntegrante'+ contador);
		$(jqExigibleDia).attr('id','exigibleDia'+ contador);
		$(jqTotalDia).attr('id','totalDia'+ contador);
		$(jqAgrega).attr('id','agrega'+ contador);
		$(jqRenglon).attr('id','renglon'+ contador);
		$(jqElimina).attr('id', contador);
		$(jqAhorros).attr('id','ahorros'+ contador);
		$('#numIntegrantes').val(contador);
		contador = parseInt(contador + 1);				
	});
	

}

function listaClientes(idControl){
	var valorControl=document.getElementById(idControl).value;
	
	lista(idControl, '3', '1', 'nombreCompleto',valorControl, 'listaCliente.htm');
}

function consultaCliente(numero){
	var exisCiente=buscaCliente(numero);
	
		if(exisCiente == 'N'){
			if($('#clienteID'+numero).val() != ''){
			var clienteID=$('#clienteID'+numero).val();
			var tipoCon = 18;
			if(clienteID != '' && !isNaN(clienteID))
			clienteServicio.consulta(tipoCon,clienteID,{ async: false, callback:function(cliente) {
				
				if (cliente != null) {
					if(cliente.sucursalOrigen == parametroBean.sucursal){
						if(cliente.estatus == 'A'){
							$('#nombreCompleto'+numero).val(cliente.nombreCompleto);
						
						if(cliente.esMenorEdad =='S'){
							$('#menor'+numero).val('SI');
							$('#tipoIntegrante'+numero).val('4');
							$('#tipoIntegrante'+numero).attr('readonly', true);
						
							
						}else{
							$('#menor'+numero).val('NO');
						}
							
						$('#estatusC'+numero).val('ACTIVO');
						consultaSaldos(clienteID, numero);
						
						}
						else{
							
							mensajeSis('El '+ $('#lblCliente').val()+ ' Esta Inactivo');
							$('#nombreCompleto'+numero).val('');
							$('#menor'+numero).val('');
							$('#estatusC'+numero).val('');
							$('#ahorros'+numero).val('');
							$('#exigibleDia'+numero).val('');
							$('#totalDia'+numero).val('');
							$('#tipoIntegrante'+numero).val('');
							
							$('#clienteID'+numero).val('');
							$('#clienteID'+numero).focus();
						}
				}else{
					mensajeSis('El ' + $('#lblCliente').val()+' No Pertenece a la Sucursal');
					$('#clienteID'+numero).val('');
					$('#clienteID'+numero).focus();
					$('#nombreCompleto'+numero).val('');
					$('#menor'+numero).val('');
					$('#estatusC'+numero).val('');
					$('#ahorros'+numero).val('');
					$('#exigibleDia'+numero).val('');
					$('#totalDia'+numero).val('');
					$('#tipoIntegrante'+numero).val('');
					
				
				}
			}else{
				mensajeSis('El ' +$('#lblCliente').val()+' No Existe');
				$('#nombreCompleto'+numero).val('');
				$('#menor'+numero).val('');
				$('#estatusC'+numero).val('');
				$('#ahorros'+numero).val('');
				$('#exigibleDia'+numero).val('');
				$('#totalDia'+numero).val('');
				$('#tipoIntegrante'+numero).val('');
				$('#clienteID'+numero).val('');
				$('#clienteID'+numero).focus();
			}
			}
				});
			}
	}else{
			if(exisCiente == 'S'){
				mensajeSis('El '+$('#lblCliente').val()+' ya Pertenece al Grupo');
				$('#clienteID'+numero).val('');
				$('#clienteID'+numero).focus();
			}
	}
}

function consultaClienteGrid(clienteID,i,tipoInt){
			var tipoCon = 18;
			
			clienteServicio.consulta(tipoCon,clienteID,function(cliente) {
				if (cliente != null) {
					$('#nombreCompleto'+i).val(cliente.nombreCompleto);
					$('#tipoIntegrante'+i).val(tipoInt);
					if(cliente.esMenorEdad =='N')	
						$('#menor'+i).val('NO');
					if(cliente.esMenorEdad =='S'){
						$('#menor'+i).val('SI');
					}
					if(cliente.estatus == 'A'){
					$('#estatusC'+i).val('ACTIVO');
					}
					if(cliente.estatus == 'I'){
						$('#estatusC'+i).val('INACTIVO');
						}
					consultaSaldos(clienteID, i);
					 agregaFormatoControles('formaGenerica');
				}
			});
}

	

function consultaSaldos(clienteID,numero){
	var tipoConI=2;
	var integraGrupoNosolBean={
			'clienteID':clienteID
		};
	integraGrupoNosolServicio.consulta(tipoConI,integraGrupoNosolBean, function(datos){
		if(datos != null){
		
			$('#ahorros'+numero).val(datos.ahorro);
			$('#exigibleDia'+numero).val(datos.exigibleDia);
			$('#totalDia'+numero).val(datos.totalDia);
			agregaFormatoControles('formaGenerica');
		}
		
	}); 
	
}

function validaTipoInt(numero){
	
	var exisTeso='N';
	var exisPres='N';
	var exisVocal='N';
	var tipo="";
	if($('#tipoIntegrante'+numero).val() != ''){
	var tipoInte=$('#tipoIntegrante'+numero).val();
	var filasTot=consultaFilas();
    
	if($('#clienteID'+numero).val() != '' && $('#nombreCompleto'+numero).val() != ''){
	
	if($('#menor'+numero).val()=='SI'){
		if($('#tipoIntegrante'+numero).val()!= 4){
			if($('#tipoIntegrante'+numero).val()== 1)
				tipo="LÍDER";
			if($('#tipoIntegrante'+numero).val()== 2)
				tipo="TESORERO";
			if($('#tipoIntegrante'+numero).val()== 3)
				tipo="VOCAL";
			$('#tipoIntegrante'+numero).val('4');
			mensajeSis('Un Menor No Puede Ser '+ tipo+' del Grupo');
			$('#tipoIntegrante'+numero).focus();
		}
	}else{
	if(tipoInte== 1)
		 for(var i=0; i<=filasTot; i++ ){
			 if($('#tipoIntegrante'+i).val()== 1){
				 if(i != numero){	 
				 exisPres='S';
				 }
			 }
		 }
	if(tipoInte== 2)
		 for(var i=0; i<=filasTot; i++ ){
			
			 if($('#tipoIntegrante'+i).val()== 2){
				 if(i != numero)
				 exisTeso='S';
			 }
		 }
	if(tipoInte== 3)
		 for(var i=0; i<=filasTot; i++ ){
			
			 if($('#tipoIntegrante'+i).val()== 3){
				 if(i != numero)
				 exisVocal='S';
			 }
		 }
	if(exisPres=='S'){
		mensajeSis('El Grupo ya Tiene un Líder');
		$('#tipoIntegrante'+numero).focus();
	}
	if(exisTeso=='S'){
		mensajeSis('El Grupo ya Tiene un Tesorero');
		$('#tipoIntegrante'+numero).focus();
		}
	if(exisVocal=='S'){
		mensajeSis('El Grupo ya Tiene un Vocal');
		$('#tipoIntegrante'+numero).focus();
		}
	}}else{
		if($('#tipoIntegrante'+numero).val()!= ''){
		mensajeSis('Primero debe de Elegir un '+$('#lblCliente').val());
		$('#tipoIntegrante'+numero).val('');
		$('#clienteID'+numero).focus();
		}
	}
	}
	
 
 
}

function validaCampos(){
	var filasTot=consultaFilas();
	
	 for(var i=0; i<=filasTot; i++ ){
		  if($('#clienteID'+i).val()==""){
			 mensajeSis('Se Requiere un '+$('#lblCliente').val());
		 	$('#clienteID'+i).focus();
		 	ban=1;
		 }else
			 ban=0;
		 if($('#tipoIntegrante'+i).val()== "" && ban==0){
			 mensajeSis('Seleccione un tipo de Integrante');
		 		$('#tipoIntegrante'+i).focus();
		 		ban=1;
		 }else
			 ban=0;
	 }
	  if(ban=0)
		  return true;
		  else
			  return false;
	
}

function buscaCliente(numero){
	if($('#clienteID'+numero).val() != ''){
	var existClient='N';
	var clienteID =$('#clienteID'+numero).val();
	var filasTot=consultaFilas();
		 for(var i=0; i<=filasTot; i++ ){

			 if($('#clienteID'+i).val() !=''&& $('#clienteID'+i).val() == clienteID)
				 if(i != numero){	
					 existClient='S';
				}
		 }
	}

	return existClient;
}





