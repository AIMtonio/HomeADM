$(document).ready(function() {

	esTab = true;
	
	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	//Definicion de Constantes y Enums  
	var tipoTransaccion = {  
			'grabar':'1'
	};

	//------------ Msetodos y Manejo de Eventos -----------------------------------------
	
	//deshabilitaBoton('grabar', 'submit');
	habilitaBoton('agregarMotivo','submit');
	$("#agregarMotivo").focus();
	agregaFormatoControles('formaGenerica');
	consultaMotivosCancelacion();


	$.validator.setDefaults({
		submitHandler: function(event) {
			var envia = guardarParametros();
			if(envia!=2){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','motivoID',
			'funcionExito','funcionError');
			}
			else{
				alert("Faltan Datos");
			}
		}
	});	

	
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.grabar);
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
  	
	$('#formaGenerica').validate({

		rules: {

		},		
		messages: {		

		}		
	});
});


	//------------ Validaciones de Controles -------------------------------------
	function consultaMotivosCancelacion(){	
		var params = {};
		params['tipoLista'] = 1;

		$.post("motivoCancelacionChequesGrid.htm", params, function(data){
			if(data.length >0) {
				$('#divMotivosCancelacion').html(data);
				$('#divMotivosCancelacion').show();
				if(consultaFilas() > 0){
					habilitaBoton('grabar');
				}else{
					deshabilitaBoton('grabar');
				}
			}else{	
				$('#divMotivosCancelacion').html("");
				$('#divMotivosCancelacion').hide();
				
				}
			});
		}
	
	function agregarMotivos(){
		// var numeroFila = ($('#miTabla >tbody >tr').length ) -1;
		var numeroFila=consultaFilas();
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		if(numeroFila == 0){
			tds += '<td align="center"><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" type="hidden"/>';
			tds += '<input type="text" id="motivoID'+nuevaFila+'" name="lmotivoID"  size="10"  value="1" readOnly="true"/></td>';								
			tds += '<td align="center"><textarea id="descripcion'+nuevaFila+'" name="ldescripcion" autocomplete="off" maxlength="200" cols=45 rows=2 value="" style="overflow:auto;resize:none" onkeyup="aMays(event, this)" onBlur="verificaDescripcion(this.id);cambiarTextoMayusculas();"></textarea></td>';
			tds += '<td align="center"><select id="estatus'+nuevaFila+'" name="lestatus"  value="A" style="width:110px">';
			tds += '<option value="">SELECCIONAR</option><option selected value="A">ACTIVO</option></select></td>';
			
		} else{    		
			var valorMotivo = parseInt(document.getElementById("motivoID"+numeroFila+"").value) + 1;
			var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
			tds += '<td align="center"><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="'+valor+'" type="hidden"/>';
			tds += '<input type="text" id="motivoID'+nuevaFila+'" name="lmotivoID"  size="10"  value="'+valorMotivo+'" readOnly="true"/></td>';								
			tds += '<td align="center"><textarea id="descripcion'+nuevaFila+'" name="ldescripcion" autocomplete="off" maxlength="200" cols=45 rows=2 value="" style="overflow:auto;resize:none" onkeyup="aMays(event, this)" onBlur="verificaDescripcion(this.id);cambiarTextoMayusculas();"></textarea></td>';
			tds += '<td align="center"><select id="estatus'+nuevaFila+'" name="lestatus" value="A" style="width:110px">';
			tds += '<option value="">SELECCIONAR</option><option selected value="A">ACTIVO</option></select></td>';
			}
			tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarMotivos(this.id)"/>';
			tds += '	 <input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarMotivos()"/></td>';
			tds += '</tr>';	   
					
			$("#miTabla").append(tds);
			habilitaBoton('grabar');
			
			var jqRenglon= eval("'#descripcion" + nuevaFila + "'");
			$(jqRenglon).focus();
			return false;	
			
			
		}

	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;		
		});
		return totales;
	}
	
	
	function eliminarMotivos(control){	
		var contador = 0 ;
		var numeroID = control;
		
		var jqRenglon = eval("'#renglon" + numeroID + "'");
		var jqNumero = eval("'#consecutivoID" + numeroID + "'");	
		var jqMotivoID = eval("'#motivoID" + numeroID + "'");
		var jqDescripcion=eval("'#descripcion" + numeroID + "'");
		var jqEstatus = eval("'#estatus" + numeroID + "'");
		var jqAgrega=eval("'#agrega" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");
		var jqBotonElimina = eval("'"+numeroID+ "'");
		var valorMotivo = $(jqMotivoID).val();
		
		// Consulta para que no permita eliminar motivo si ya existen registros que dependan de este
		
		var conCancelaciones = 2;
		var cancelacionesBeanCon = {
	 		 	'motivoID' : valorMotivo
		};
		if (valorMotivo != '' && !isNaN(valorMotivo)) {
			motivoCancelacionChequesServicio.consultaMotivos(conCancelaciones,cancelacionesBeanCon,function(cancelaciones){
				if (cancelaciones != null) {
					if(cancelaciones.numCancela !=0){
						alert(" El Motivo no puede ser Eliminado por tener Cancelaciones Asociadas.");
						deshabilitaControl(jqBotonElimina);
					}
					else{
						// se elimina la fila seleccionada
						$(jqNumero).remove();
						$(jqMotivoID).remove();
						$(jqElimina).remove();
						$(jqDescripcion).remove();
						$(jqEstatus).remove();
						$(jqAgrega).remove();
						$(jqRenglon).remove();
					
						//Reordenamiento de Controles
						contador = 1;
						var numero= 0;
						$('tr[name=renglon]').each(function() {		
							numero= this.id.substr(7,this.id.length);
							var jqRenglon1 = eval("'#renglon"+numero+"'");
							var jqNumero1 = eval("'#consecutivoID"+numero+"'");
							var jqMotivoID1= eval("'#motivoID"+numero+"'");
							var jqDescripcion1=eval("'#descripcion"+ numero+"'");
							var jqEstatus1=eval("'#estatus"+ numero+"'");
							var jqAgrega1=eval("'#agrega"+ numero+"'");
							var jqElimina1 = eval("'#"+numero+ "'");
						
							$(jqNumero1).attr('id','consecutivoID'+contador);
							$(jqMotivoID1).attr('id','motivoID'+contador);
							$(jqDescripcion1).attr('id','descripcion'+contador);
							$(jqEstatus1).attr('id','estatus'+contador);
							$(jqAgrega1).attr('id','agrega'+contador);
							$(jqElimina1).attr('id',contador);
							$(jqRenglon1).attr('id','renglon'+ contador);
							contador = parseInt(contador + 1);	
							
						});
					}

				}
				
			});
		}	
	}


	
	
	// Función para validar que no exista campos vacios al grabar lo motivos de cancelacion
	function guardarParametros(){		
		var mandar = verificarvacios();
		if(mandar!=1){   		  		
		var numCodigo = $('input[name=consecutivoID]').length;
		$('#datosGrid').val("");
		for(var i = 1; i <= numCodigo; i++){
			if(i == 1){
				$('#datosGrid').val($('#datosGrid').val() +
						document.getElementById("motivoID"+i+"").value + ']' +
						document.getElementById("descripcion"+i+"").value + ']' +
						document.getElementById("estatus"+i+"").value);
				return 1;
			}else{
				$('#datosGrid').val($('#datosGrid').val() + '[' +
						document.getElementById("motivoID"+i+"").value + ']' +
						document.getElementById("descripcion"+i+"").value + ']' +
						document.getElementById("estatus"+i+"").value);	
				return 1;
				}	
			}
		}
		else{
		return 2;
		}
	}
	
	function verificarvacios(){
		quitaFormatoControles('datosGrid');
		var numCodig = $('input[name=consecutivoID]').length;
		
		$('#divMotivosCancelacion').val("");
		for(var i = 1; i <= numCodig; i++){
			var idmotivoID = document.getElementById("motivoID"+i+"").value;
			if (idmotivoID ==""){
				document.getElementById("motivoID"+i+"").focus();
				$(idmotivoID).addClass("error");
				return 1;
			}
			var iddescripcion = document.getElementById("descripcion"+i+"").value;
			if (iddescripcion ==""){
				document.getElementById("descripcion"+i+"").focus();
				$(iddescripcion).addClass("error");
				return 1;
			}
			var idestatus = document.getElementById("estatus"+i+"").value;
			if (idestatus ==""){
				document.getElementById("estatus"+i+"").focus();
				$(idestatus).addClass("error");
				return 1;
			}
		}
	}
	
	

	// Funcion para que una descripcion no se capture dos veces
	// el mismo orden no se capture dos veces
	function verificaDescripcion(idDescripcion){
		var contador = 0;
		var nuevaDescripcion=$('#'+idDescripcion).val();
		var id= idDescripcion.substr(11,idDescripcion.length);
			$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqNuevaDescripcion = eval("'descripcion" + numero+ "'");		
			var valorDescripcion = $('#'+jqNuevaDescripcion).val();
			
			if(id != numero && valorDescripcion !='' ){
				if((valorDescripcion == nuevaDescripcion)){
					alert("La Descripción ya fue Capturada");
					$('#'+idDescripcion).focus();
					$('#'+idDescripcion).val("");
					contador = contador+1;
				}
			}
		});
		return contador;
	}
	
	
 	//funcion que llama a poner mayusculas para seguir con el estandar
 	function cambiarTextoMayusculas(){
		setTimeout("$('#cajaLista').hide();", 200);
		$('input[name=descripcion]').each(function() {		
			ponerMayusculas(this);
			console.log("entra a cambiar mayusculas");
		});
 		
 	}
 	
 	function aMays(e, elemento) {
 		tecla=(document.all) ? e.keyCode : e.which; 
 		 elemento.value = elemento.value.toUpperCase();
 		}
	
	function funcionExito (){
		 $('#agregarMotivo').focus();
		deshabilitaBoton('grabar','submit');
		consultaMotivosCancelacion();

	}
	
	function funcionError(){
		$('#agregarMotivo').focus();
		deshabilitaBoton('grabar','submit');
	}
	
	

	
