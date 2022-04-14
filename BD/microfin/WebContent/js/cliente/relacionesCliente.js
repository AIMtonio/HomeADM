$(document).ready(function() {
	esTab = false;
	var contEmp = 0;
	var contParen = 0;	
	var contCli = 0; 
	
	//Definicion de Constantes y Enums  
	var catTipoTransaccionRelacion = {
  		'agrega':'1',
  		'modifica':'2'	
  	};
	
	var catTipoConsultaRelacion = {
  		'principal'	:	1,
  		'foranea'	:	2
	};	
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica'); 
	deshabilitaBoton('grabar', 'submit');
	$('#clienteID').focus();
   
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
			if (contCli != 0){
				mensajeSis("El "+$('#varSafilocale').val()+" no puede ser seleccionado como parentesco");
				limpiaGrid();
			}else 
				if (contEmp == 0 || contParen == 0){
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID','funcionExito','funcionError');					
				}else{
					verificarVacios();
					limpiaGrid();
				}
		}
	});
	
	$('#grabar').click(function() {
		validaFormGrid();
		$('#tipoTransaccion').val(catTipoTransaccionRelacion.agrega);
		creaRelacionesCliente();
	});
	
	$('#clienteID').blur(function() {
		if(esTab){
			consultaCliente(this.id); 			
		}
	});

	$('#parentescoID').blur(function() {
		consultaParentesco(this.id);
	});

	$('#clienteID').bind('keyup',function(e){
		listaAlfanumerica('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});

	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '19', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({				
		rules: {			
			clienteID: {
				required: true,
				minlength: 1
			}
		},
		
		messages: {
			clienteID: {
				required: 'Especifique '+$('#varSafilocale').val(),
				minlength: 'Al menos 1 Carácter'
			}			
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		

		if(numCliente != '' && !isNaN(numCliente) && numCliente>0){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero)	;						
					$('#nombreCliente').val(cliente.nombreCompleto);	
					 if (cliente.estatus=='I'){
							mensajeSis("El "+$('#varSafilocale').val()+" se encuentra Inactivo");
							$('#clienteID').val('');
							$('#nombreCliente').val('');
							$('#clienteID').focus();
							$('#clienteID').select();
							deshabilitaBoton('grabar','submit');
							$('#gridRelaciones').html("");
							$('#gridRelaciones').hide();
					 }else{
						 consultaRelaciones();
					 }
				}else{
					clienteexiste = 1;
					mensajeSis("No Existe el "+$('#varSafilocale').val());
					$('#clienteID').val('');
					$('#nombreCliente').val('');
					$('#clienteID').focus();
					$('#clienteID').select();
					deshabilitaBoton('grabar','submit');
					$('#gridRelaciones').html("");
					$('#gridRelaciones').hide();
				}    	 						
			});
		}else{
			if(isNaN(numCliente)){
				mensajeSis("No Existe el "+$('#varSafilocale').val());
				$('#clienteID').val('');
				$('#nombreCliente').val('');
				$('#clienteID').focus();
				$('#clienteID').select();
				deshabilitaBoton('grabar','submit');
				$('#gridRelaciones').html("");
				$('#gridRelaciones').hide();
			}else{
				if(numCliente =='' || numCliente == 0){
					$('#clienteID').val('');
				}
			}
			
		}		
	}	
		
	function consultaRelaciones(){
		var numCliente = $('#clienteID').val();
		
		if (numCliente != '' && !isNaN(numCliente) ){
			var params = {};
			params['tipoLista'] = 3;
			params['clienteID'] = numCliente; 
			
			$.post("gridRelacionesClientes.htm", params, function(data){
				if(data.length >0) {
					$('#gridRelaciones').html(data);
					$('#gridRelaciones').show();
					habilitaBoton('grabar', 'submit');
					if ($('#numeroRelaciones').val() == 0){
						deshabilitaBoton('grabar','submit');						
					}
				}else{
					$('#gridRelaciones').html("");
					$('#gridRelaciones').show();
					deshabilitaBoton('grabar','submit');
				}
			});
		}else{
			$('#gridRelaciones').hide();
			$('#gridRelaciones').html('');
			deshabilitaBoton('grabar','submit');
		}
	}
	
	function creaRelacionesCliente(){
		var contador = 1;
		$('#lisEmpleados').val("");
		$('#lisClientes').val("");
		$('#lisParentesco').val("");
				
		$('input[name=idEmpleado]').each(function() {
			if (this.value == '') this.value = 0;
			if (contador != 1){
				$('#lisEmpleados').val($('#lisEmpleados').val() + ','  + this.value);
			}else{
				$('#lisEmpleados').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=idCliente]').each(function() {
			if (this.value == '') this.value = 0;
			if (contador != 1){
				$('#lisClientes').val($('#lisClientes').val() + ','  + this.value);
			}else{
				$('#lisClientes').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=parentescoID]').each(function() {
			if (contador != 1){
				$('#lisParentesco').val($('#lisParentesco').val() + ','  + this.value);
			}else{
				$('#lisParentesco').val(this.value);
			}
			contador = contador + 1;
		});
	}

	function validaFormGrid(){
		var idCliente = document.getElementById('clienteID').value;
		contCli = 0;		
		$('input[name=idCliente]').each(function () {
			if (idCliente == this.value){
				contCli++;
			}
		});
		contEmp = 0;
		$('input[name=idEmpleado]').each(function () {
			if (isEmpty(this.value)){
				contEmp++;
			}
		});
		contParen = 0;
		$('input[name=parentescoID]').each(function () {
			if (isEmpty(this.value)){
				contParen++;
			}
		});
	}

	
	function isEmpty(obj) {
   	if (typeof obj == 'undefined' || obj === null || obj === '') return true;
    	if (typeof obj == 'number' && isNaN(obj)) return true;
    	if (obj instanceof Date && isNaN(Number(obj))) return true;
    	return false;
	}

});

function consultaEmpleado(idControl) {
	var jqEmpleado = eval("'#empleado" + idControl + "'");
	var numEmpleado = $(jqEmpleado).val();
	setTimeout("$('#cajaLista').hide();", 200);
	var EmpleadoBeanCon = {
		'empleadoID' : numEmpleado
	};
	var catTipoConsultaEmpleados = {
		'principal' : 1
	};
	esTab= true;
	if (numEmpleado != '' && !isNaN(numEmpleado) && esTab) {
		empleadosServicio.consulta(catTipoConsultaEmpleados.principal,	EmpleadoBeanCon, function(empleados) {
			if (empleados != null) {
				$('#nombre'+idControl).val(empleados.nombreCompleto);
				$('#puesto'+idControl).val(empleados.clavePuestoID);			
				esTab = true;
				consultaPuesto(idControl);
			} else {
				mensajeSis("No Existe el Empleado");
				$(jqEmpleado).focus();
			}
		});
	}
}

function consultaParentesco(idControl) {
	var jqParentesco = eval("'#parentesco" + idControl + "'");
	var numParentesco = $(jqParentesco).val();				
	var tipConPrincipal = 3;
	setTimeout("$('#cajaLista').hide();", 200);
	var ParentescoBean = {
		'parentescoID' : numParentesco
	};
	if(numParentesco != '' && !isNaN(numParentesco)){
		parentescosServicio.consultaParentesco(tipConPrincipal,ParentescoBean,function(parentesco) {
			if(parentesco!=null){
				$('#descParen'+idControl).val(parentesco.descripcion);
				$('#tipoRelacion'+idControl).val(parentesco.tipo);
				$('#grado'+idControl).val(parentesco.grado);
				$('#linea'+idControl).val(parentesco.linea);
			}else{
				mensajeSis("No Existe el Parentesco");
				$(jqParentesco).focus();
			}
		});
	}
}

function consultaPuesto(idControl) {
	var jqPuesto = eval("'#puesto" + idControl + "'");
	var numPuesto = $(jqPuesto).val();
	var conPuesto=1;
	setTimeout("$('#cajaLista').hide();", 200);
	var PuestoBeanCon = {
			'clavePuestoID' : numPuesto
	};
	if (numPuesto != '' && esTab) {
		puestosServicio.consulta(conPuesto,PuestoBeanCon, function(puestos) {
			if (puestos != null) {
				$('#descPuesto'+idControl).val(puestos.descripcion);
			}
		});
	}
}

//Función que verifica que los campos no esten vacios
function verificarVacios(){	
	
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqCliente = eval("'#cliente" + numero + "'");
		var jqEmpleado = eval("'#empleado" + numero + "'");
		var jqParantesco = eval("'#parentesco" + numero+ "'");

		if($(jqCliente).asNumber() == 0 && $(jqEmpleado).asNumber() == 0){
			mensajeSis('Especificar un '+$('#varSafilocale').val()+' o Empleado');
			$(jqCliente).focus();
			return false;
		}else{
			if($(jqParantesco).val() == ''){
				$(jqParantesco).focus();
				mensajeSis('Especificar Parentesco');
				return false;
			}
		}
	});		
}

function consultaClienteRel(idControl) {
		var jqCliente = eval("'#cliente" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){							
					$('#nombre'+idControl).val(cliente.nombreCompleto);															
				}else{
					clienteexiste = 1;
					mensajeSis("No Existe el "+$('#varSafilocale').val());
				}    	 						
			});
		}
}	

function limpiaGrid() {
	$('input[name=idCliente]').each(function () {
		if (this.value == 0){
			$(this).val('');
		}
	});	
	$('input[name=idEmpleado]').each(function () {
		if (this.value == 0){
			$(this).val('');
		}
	});
}


//Función de éxito en la transación
function funcionExito(){

	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert); 
			
			$('#gridRelaciones').html("");
			$('#gridRelaciones').hide();
			$('#clienteID').focus();
			deshabilitaBoton('grabar', 'submit');
		}
      }, 50);
	}
	
	
}

//función de error en la transacción
function funcionError(){
	
}