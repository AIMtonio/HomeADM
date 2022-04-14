var opcionSelect = '';
var opcionDescri = '';
var comboTipoRelacion = [];

$(document).ready(function() {
	esTab = false;
	
	var catTipoTransaccion = { 
			'grabar'	: '1'
	};

	comboTipoAcredRel('','',function(lista){
		consultaAcreditadosRel();
	})
	
	/********** METODOS Y MANEJO DE EVENTOS ************/
	agregaFormatoControles('formaGenerica');
	
	$('#agregar').focus();

	
	 $(':text').focus(function() {	
		 	esTab = false;
		});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
				var mandar = verificarVacios(); 
				if(mandar != 1){
			       	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','','exito','fallo');
				}			 
			            	
       }
	});	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {				
		},
		messages: {				
		}		
	});
	
	$('#grabar').click(function() { 
		$('#tipoTransaccion').val(catTipoTransaccion.grabar);
	}); 
	
	$('#agregar').click(function() {		
		agregaNuevoParametro();
	});
		
}); // fin ready

// Función para Consultar acreditados relacionados
function consultaAcreditadosRel(){	
	bloquearPantallaCarga();
	var params = {};
	params['tipoLista'] = 1;
	$.post("acreditadoRelGridVista.htm", params, function(data){
		if(data.length >0) {
			$('#divGridAcreditados').html("");
			$('#divGridAcreditados').html(data);
			habilitaBoton('grabar', 'submit');	
			cosultasGrid();
		}else{				
			$('#divGridAcreditados').html("");
		}
		$('#contenedorForma').unblock(); // desbloquear
	});
	
}

//Función que verifica que los campos no esten vacios
function verificarVacios(){	
	var exito = 0;	
	var numFilas = consultaFilas();	
	
	for(var i = 1; i <= numFilas; i++){
		var jqClienteID = eval("'#clienteID" + i + "'");
		var jqEmpleadoID = eval("'#empleadoID" + i + "'");
		var jqTipoAcredRelID = eval("'#claveRelacionID" + i + "'");		
		
		if($(jqClienteID).val() == '' && $(jqEmpleadoID).val() == ''){
			mensajeSis('Especificar un Socio o Empleado');
			$(jqClienteID).focus();
			exito = 1;
			break;
		}else{
			if($(jqTipoAcredRelID).val() == ''){
				$('#descripcionClave'+i).focus();
				mensajeSis('Especificar Tipo de Acreditado Relacionado');
				exito = 1;
				break;
			}
		}	
	}
	return exito;
		
}

//funcion consulta el numero de filas
function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;		
	});
	return totales;
}

//funcion selecciona las opciones de los combos y realiza  consutas
function cosultasGrid(){
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var jqIdDato = eval("'#tipoAcredRel" + numero+ "'");
		var jqIdCombo = eval("'claveRelacionID" + numero+ "'");
		var jqClienteID = eval("'clienteID" + numero+ "'");
		var jqEmpleadoID = eval("'empleadoID" + numero+ "'");
		

		$('#claveRelacionID'+numero).val($(jqIdDato).val());
		$('#descripcionClave'+numero).val(comboTipoRelacion[$(jqIdDato).val()]);


		esTab=true;
		if($('#'+jqClienteID).asNumber() > 0){
			consultaCliente(jqClienteID);
		}
		if($('#'+jqEmpleadoID).asNumber() > 0){
			consultaEmpleado(jqEmpleadoID);
		}
		esTab=false;
	});		

	 $(':text').focus(function() {	
		 	esTab = false;
		});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
}

// agrega las calves de relaciones al combo
function comboTipoAcredRel(nombreCombo,seleccionado,funcionCallback){
	var tipoLista=1;

	acreditadoRelServicio.listaComboClaves(tipoLista, function(lista){

		/**
		 *
		 * LLenar el div de la tabla
		 *
		 */

		 var strTablaRel = `
			<table id="tablaListaSelect"  cellspacing="0" cellpadding="0" class="tablaLista"  width="550">
				<tbody>
				<tr id="tbl"><td  onclick="cargaValorRel('','SELECCIONAR')">SELECCIONAR</td></tr>
		 `;


		 for (var i = 0; i < lista.length; i++) {
		 	strTablaRel += `<tr id="tbl`+lista[i].claveRelacionID+`" onclick="cargaValorRel(`+lista[i].claveRelacionID+`,'`+lista[i].descripcion+`')"><td>`+lista[i].descripcion+`</td></tr>`;
			comboTipoRelacion[lista[i].claveRelacionID] =lista[i].descripcion;
		 }
		
		strTablaRel += `
				</tbody>
			</table>
		 `;

		 $('#cajaTipoRelacion').html(strTablaRel);



		 $('#tablaListaSelect td').hover(
		       function(){ $(this).addClass('hoverTbl') },
		       function(){
		        $('.hoverTbl').removeClass('hoverTbl');
		    }
		)


		 funcionCallback(lista);
	});	

}	


function cargaValorRel(idOpcion,descripcion){

	$('#'+opcionSelect).val(idOpcion);
	$('#'+opcionDescri).val(descripcion);

	var opcionLista = idOpcion;

	$('.hoverTbl').removeClass('hoverTbl');
	
	$('#cajaTipoRelacion').hide();
}

function muestraListaRelacion(campoID,campoDes){

	if($('#cajaTipoRelacion').is(":visible")){
		$('#cajaTipoRelacion').hide(100);
		return false;
	}

	var jqElemento = "#cajaTipoRelacion";
	var position = $('#'+campoDes).position();
	opcionSelect = campoID;
	opcionDescri = campoDes;

	var opcionLista = $('#'+campoID).val();

	
	$('#cajaTipoRelacion').css({
		position : 'absolute',
		collision : "fit flip",
        left: position.left+"px",
        top: (position.top+48)+"px"
		});

	$('#cajaTipoRelacion').show(100);
	$('#tbl'+opcionLista).addClass('hoverTbl');

	var selected = '#tbl'+opcionLista;
    var ubicaOptionList = $(selected).position();

    

    if(ubicaOptionList!=null){
			$('#cajaTipoRelacion').scrollTop( ubicaOptionList.top );
    }


}


function ocultaLista(){
	setTimeout(function(){
		$('#cajaTipoRelacion').hide(100);
	},100)
	
}

// Función para agregar nuevas Filas en el grid
function agregaNuevoParametro(){ 
	
	var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
	var nuevaFila = parseInt(numeroFila) + 1;					
	var tds = '<tr id="renglons' + nuevaFila + '" name="renglons">';
	
	tds += '<td><input type="hidden" id="consecutivo'+nuevaFila+'" name="consecutivo" size="4"  value="'+nuevaFila+'" />';
	tds += '	<input type="text" id="clienteID'+nuevaFila+'" name="lisClienteID" size="13" tabindex="'+nuevaFila+'" maxlength = "10" autocomplete="off" onKeyUp="listaClientes(this.id);" onblur="consultaCliente(this.id);"/></td>';			
	tds += '<td><input type="text" id="empleadoID'+nuevaFila+'" name="lisEmpleadoID" size="13" tabindex="'+nuevaFila+'" maxlength = "10" autocomplete="off" onKeyUp="listaEmpleados(this.id);" onblur="consultaEmpleado(this.id);"/></td>';	
	tds += '<td><input type="text" id="nombre'+nuevaFila+'" name="lisNombre" size="45" tabindex="'+nuevaFila+'" onblur="ponerMayusculas(this)" autocomplete="off" readOnly="true" disabled="true"/></td>';	
	tds += '<td><input type="text" id="puesto'+nuevaFila+'" name="lisPuesto" size="45" tabindex="'+nuevaFila+'" onblur=" ponerMayusculas(this)" autocomplete="off" readOnly="true" disabled="true"/></td>';		
	tds += '<td><input type="hidden" id="tipoAcredRel'+nuevaFila+'" name="tipoAcredRel" size="10"/>  ';																	


	tds += `	<input type="hidden" id="claveRelacionID`+nuevaFila+`" name="lisClaveRelacionID" size="10"/>
				<textarea id="descripcionClave`+nuevaFila+`" name="descripcionClave" 
				onclick="muestraListaRelacion('claveRelacionID`+nuevaFila+`','descripcionClave`+nuevaFila+`')"  
				cols="80" rows="3" readonly="" style="background: #ddd; width: 510px" tabindex='${nuevaFila}'">SELECCIONAR</textarea>`;


	tds += '<td><input type="button" name="eliminar" id="'+nuevaFila +'" class="btnElimina" onclick="eliminarParametro(this.id)"  tabindex="'+nuevaFila+'" /></td>';
	tds += '<td><input type="button" name="agregar" id="agregar'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoParametro()" tabindex="'+nuevaFila+'" /></td>';
	tds += '</tr>';	   	   
	
	$("#miTabla").append(tds);
	
	var comboNuevo = 'claveRelacionID'+nuevaFila; 
	var seleccionado ="";

	 $(':text').focus(function() {	
		 	esTab = false;
		});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	

	$('#clienteID'+nuevaFila).focus();
	return false;
																														
}

// Función para eliminar Filas en el grid	
function eliminarParametro(control){
	var numeroID = control;
	
	var jqRenglon = eval("'#renglons" + numeroID + "'");
	var jqNumero = eval("'#consecutivo" + numeroID + "'");
	var jqClienteID = eval("'#clienteID" + numeroID + "'");		
	var jqEmpleadoID = eval("'#empleadoID" + numeroID + "'");
	var jqNombre=eval("'#nombre" + numeroID + "'");
	var jqPuesto =eval("'#puesto" + numeroID + "'");
	var jqTipoAcredRel =eval("'#tipoAcredRel" + numeroID + "'");
	var jqClaveRelacionID=eval("'#claveRelacionID" + numeroID + "'");

	var jqDescripClaveID=eval("'#descripcionClave" + numeroID + "'");

	
	var jqAgregar=eval("'#agregar" + numeroID + "'");
	var jqEliminar = eval("'#" + numeroID + "'");

	// se elimina la fila seleccionada
	$(jqRenglon).remove();
	$(jqNumero).remove();
	$(jqClienteID).remove();
	$(jqEmpleadoID).remove();
	$(jqNombre).remove();
	$(jqPuesto).remove();
	$(jqTipoAcredRel).remove();
	$(jqClaveRelacionID).remove();

	$(jqAgregar).remove();
	$(jqEliminar).remove();
	$(jqDescripClaveID).remove();

	//Reordenamiento de Controles

	var contador = 1 ;
	var numero= 0;
	$('tr[name=renglons]').each(function() {	
		numero= this.id.substr(8,this.id.length);
		var jqRenglon1 = eval("'#renglons" + numero + "'");
		var jqNumero1 = eval("'#consecutivo" + numero + "'");
		var jqClienteID1 = eval("'#clienteID" + numero + "'");		
		var jqEmpleadoID1 = eval("'#empleadoID" + numero + "'");
		var jqNombre1 =eval("'#nombre" + numero + "'");
		var jqPuesto1 =eval("'#puesto" + numero + "'");
		var jqTipoAcredRel1 =eval("'#tipoAcredRel" + numero + "'");
		var jqClaveRelacionID1 =eval("'#claveRelacionID" + numero + "'");
		var jqDescripClaveID1 =eval("'#descripcionClave" + numero + "'");
		
		var jqAgregar1 =eval("'#agregar" + numero + "'");
		var jqEliminar1  = eval("'#" + numero + "'");

		$(jqRenglon1).attr('id','renglons'+contador);
		$(jqNumero1).attr('id','consecutivo'+contador);
		$(jqClienteID1).attr('id','clienteID'+contador);
		$(jqEmpleadoID1).attr('id','empleadoID'+contador);
		$(jqNombre1).attr('id','nombre'+contador);
		$(jqPuesto1).attr('id','puesto'+contador);
		$(jqTipoAcredRel1).attr('id','tipoAcredRel'+contador);
		$(jqClaveRelacionID1).attr('id','claveRelacionID'+contador);
		$(jqDescripClaveID1).attr('id','descripcionClave'+contador);
		
		$(jqAgregar1).attr('id','agregar'+contador);		
		$(jqEliminar1).attr('id',contador);


		// reordenamiento indeces

		document.getElementById("clienteID"+contador).tabIndex = contador;
		document.getElementById("empleadoID"+contador).tabIndex = contador;
		document.getElementById("nombre"+contador).tabIndex = contador;
		document.getElementById("puesto"+contador).tabIndex = contador;
		document.getElementById("tipoAcredRel"+contador).tabIndex = contador;
		document.getElementById("claveRelacionID"+contador).tabIndex = contador;
		document.getElementById("agregar"+contador).tabIndex = contador;
		document.getElementById(contador).tabIndex = contador;
		
		contador = parseInt(contador + 1);	
		
	});
	
}

function listaClientes(idControl){
	lista(idControl, '3', '9', 'nombreCompleto',$('#'+idControl).val(), 'listaCliente.htm');
}

//Funcion que consulta el nombre del cliente 
function consultaCliente(idControl) {
	
	if(esTab){
		if(validarGridCliente(idControl) != false){
			var numero= idControl.substr(9,idControl.length);
			var idEmpledo = eval("'#empleadoID" + numero+ "'");		
			var idNombre = eval("'#nombre" + numero+ "'");		
			var idPuesto = eval("'#puesto" + numero+ "'");		
			var jqCliente = eval("'#" + idControl + "'");
			
			var numCliente = $(jqCliente).val();	
			var tipConForanea = 1;	
			setTimeout("$('#cajaLista').hide();", 200);	

			
			if(numCliente != '' && !isNaN(numCliente)  && numCliente>0){
				clienteServicio.consulta(tipConForanea,numCliente,{ async: false, callback:function(cliente) {
					if(cliente!=null && cliente.estatus == 'A'){	
						$(idNombre).val(cliente.nombreCompleto);	
						$(idEmpledo).val('');
						$(idPuesto).val('');			
					}else{
						$(jqCliente).val('');
						$(idNombre).val('');
						$(idEmpledo).val('');
						$(idPuesto).val('');
						$(jqCliente).focus();
						$(jqCliente).select();	
						mensajeSis("No Existe el Socio");
					}    	 						
				}
				});
			}else{
				if(isNaN(numCliente)){
					$(jqCliente).val('');
					$(idNombre).val('');
					$(idEmpledo).val('');
					$(idPuesto).val('');
					$(jqCliente).focus();
					$(jqCliente).select();	
					mensajeSis("No Existe el Socio");			
				}else{
					if(numCliente =='' || numCliente == 0){
						$(jqCliente).val('');
					}
				}
				
			}
		}		
	}
	
}

function listaEmpleados(idControl){
	var camposLista = new Array(); 
		camposLista[0] = "nombreCompleto";
    var parametrosLista = new Array(); 
    	parametrosLista[0] = $('#'+idControl).val();
    	listaAlfanumerica(idControl, '3', '1', camposLista, parametrosLista, 'listaEmpleados.htm');
}

function consultaEmpleado(idEmpleado) {
	
	if(esTab){
		if(validarGridEmpleado(idEmpleado) != false){
			var numero= idEmpleado.substr(10,idEmpleado.length);
			var idCliente = eval("'#clienteID" + numero+ "'");
			var idNombre = eval("'#nombre" + numero+ "'");		
			var idPuesto = eval("'#puesto" + numero+ "'");	
			var jqEmpleado = eval("'#" + idEmpleado + "'");	

			var numEmpleado = $(jqEmpleado).val();	
			setTimeout("$('#cajaLista').hide();", 200);
			
				if (numEmpleado != '' && !isNaN(numEmpleado) && numEmpleado > 0 ) {
					var conPrincipal = 1;
					var empleadoBeanCon = {
							'empleadoID' : numEmpleado
					};

					empleadosServicio.consulta(conPrincipal,empleadoBeanCon, { async: false, callback:function(empleados) {
						if (empleados != null) {
							$(idNombre).val(empleados.nombreCompleto);
							$(idCliente).val("");
							var clavePuesto = empleados.clavePuestoID;
							consultaPuesto(clavePuesto,idPuesto);
									
						}else{
							$(jqEmpleado).val('');
							$(idNombre).val('');
							$(idPuesto).val('');
							$(idCliente).val("");
							$(jqEmpleado).focus();
							$(jqEmpleado).select();
							mensajeSis("No Existe el Empleado");
						}
					}
					});

				}else{
					if(isNaN(numEmpleado)){
						$(jqEmpleado).val('');
						$(idNombre).val('');
						$(idPuesto).val('');
						$(idCliente).val("");
						$(jqEmpleado).focus();
						$(jqEmpleado).select();
						mensajeSis("No Existe el Empleado");
					}else{
						if(numEmpleado == '' || numEmpleado == 0){
							$(jqEmpleado).val('');
						}
					}			
				}
		}		
	}
		
}

// funcion consultar puesto del empleado
function consultaPuesto(clavePuesto,idPuesto) {
	setTimeout("$('#cajaLista').hide();", 200);
	var consultaPuestos = 1;
	var PuestoBeanCon = {
		'clavePuestoID' : clavePuesto
	};

	if (clavePuesto != '') {
		puestosServicio.consulta(consultaPuestos,PuestoBeanCon, { async: false, callback:function(puestos) {
			if (puestos != null) {
				$(idPuesto).val(puestos.descripcion);
			} else {
					mensajeSis("No Existe el Puesto");
					$(idPuesto).val('');
			}
		}});
	}else{
		mensajeSis("No Existe el Puesto");
		$(idPuesto).val('');
		
	}
}

//funcion valida que no se repita el cliente en el grid
function validarGridCliente(control){	
	var jqClienteID = eval("'#" +control+"'");
	numCliSelec = control.substr(9,control.length);
	var clienteID = $(jqClienteID).asNumber();

	var idEmpleado = eval("'#empleadoID" + numCliSelec+ "'");
	var idNombre = eval("'#nombre" + numCliSelec+ "'");		
	var idPuesto = eval("'#puesto" + numCliSelec+ "'");	
	
	$('tr[name=renglons]').each(function() {	
		numero= this.id.substr(8,this.id.length);		
		var jqRenglonCli = eval("'#clienteID" + numero + "'");

		if(clienteID == $(jqRenglonCli).asNumber() && numCliSelec != numero && clienteID > 0 &&  $(jqRenglonCli).asNumber() > 0){
				mensajeSis('El Número de Socio ya está Relacionado');
				$(jqClienteID).val('');
				$(idEmpleado).val('');
				$(idNombre).val('');
				$(idPuesto).val('');
				$(jqClienteID).focus();
				$(jqClienteID).select();
			return false;
		}		
	});
}

//funcion valida que no se repita el empleado en el grid
function validarGridEmpleado(control){	
	var jqEmpleadoID = eval("'#" +control+"'");
	numEmpSelec = control.substr(10,control.length);
	var empleadoID = $(jqEmpleadoID).asNumber();

	var idCliente = eval("'#clienteID" + numEmpSelec+ "'");
	var idNombre = eval("'#nombre" + numEmpSelec+ "'");		
	var idPuesto = eval("'#puesto" + numEmpSelec+ "'");	
	
	$('tr[name=renglons]').each(function() {	
		numero= this.id.substr(8,this.id.length);		
		var jqRenglonEmp = eval("'#empleadoID" + numero + "'");

		if(empleadoID == $(jqRenglonEmp).asNumber() && numEmpSelec != numero && empleadoID > 0 &&  $(jqRenglonEmp).asNumber() > 0){
				mensajeSis('El Número de Empleado ya está Relacionado');
				$(jqEmpleadoID).val('');
				$(idCliente).val('');
				$(idNombre).val('');
				$(idPuesto).val('');
				$(jqEmpleadoID).focus();
				$(jqEmpleadoID).select();
			return false;
		}		
	});
}

//funcion que bloquea la pantalla mientras se cargan los datos
function bloquearPantallaCarga() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message : $('#mensaje'),
		css : {
			border : 'none',
			background : 'none'
		}
	});

}

function exito(){

	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert); 

			consultaAcreditadosRel();
			$('#agregar').focus();					
		}
        }, 50);
	}
}

function fallo(){
	
}