$(document).ready(function() {
	parametros = consultaParametrosSession();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	$('#producCreditoID').focus();
	var catTipoTranDiasPasoVencido = { 
			'altaLista'			: 1,		
		};

	//------------ Validaciones de Controles -------------------------------------
	
	$.validator.setDefaults({
	    submitHandler: function(event) {    	  
	  	  grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','producCreditoID');
	  	  
	    }
	 });
	$('#producCreditoID').change(function() {		
		consultaDiasPasoVencidoPorFrecuencia();
	});
	
	//--------- validaciones de la Forma----------

	$('#formaGenerica').validate({
		rules: {
			producCreditoID: 'required'				
		},		
		messages: {
			producCreditoID: 'Especifique producto de credito',		
		}		
	});
	

	function consultaDiasPasoVencidoPorFrecuencia(){			
		var productoID=$('#producCreditoID').val();
		var params = {};
		params['tipoLista'] = 1;
		params['producCreditoID'] = productoID;
		
		$.post("diasPasoVencidoGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#divDiasPasoVencido').html(data);
				$('#fieldsetDiasPasoVencido').show();
				$('#divDiasPasoVencido').show();
				
				if(consultaFilas() > 0){
					habilitaBoton('grabar');
				}else{
					deshabilitaBoton('grabar');
				}
				
				seleccionaFrecuencia ();
				$('#grabar').click(function() {			
					$('#tipoTransaccion').val(catTipoTranDiasPasoVencido.altaLista);
				});
				
			}else{				
				$('#divDiasPasoVencido').html("");
				$('#fieldsetDiasPasoVencido').hide();
				$('#divDiasPasoVencido').hide(); 
			}
		});
	}
	function seleccionaFrecuencia (){	
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jsFrecuencia = eval("'frecuencias" + numero+ "'");	
			var valorFrecuencia= document.getElementById(jsFrecuencia).value;	
			$('#frecuencia'+numero+' option[value='+ valorFrecuencia +']').attr('selected','true');	
		});
		
	}
	consultaProductosCredito();	
	function consultaProductosCredito() {			
		dwr.util.removeAllOptions('producCreditoID'); 		
		dwr.util.addOptions('producCreditoID', {0:'SELECCIONAR'});						     
		productosCreditoServicio.listaCombo(16, function(producto){
		dwr.util.addOptions('producCreditoID', producto, 'producCreditoID', 'descripcion');
		});
	}
	
});// cerrar


function agregarDiasPasoVencido(){	
	var numeroFila=consultaFilas();
	
	var nuevaFila = parseInt(numeroFila) + 1;					
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	 	 	  
		if(numeroFila == 0){
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
			tds += '<input  id="frecuencias'+nuevaFila+'" name="frecuencias"  size="6"  value="" autocomplete="off"  type="hidden" />';								
			tds += '<select type="select" id="frecuencia'+nuevaFila+'" name="lfrecuencia" onBlur="verificaSeleccionado(this.id)" >';
			tds += '<option value="">SELECCIONAR</option>';
			tds += '<option value="S">SEMANAL</option>	>';
			tds += '<option value="D">DECENAL</option>	>';
			tds += '<option value="C">CATORCENAL</option>';	
			tds += '<option value="Q">QUINCENAL</option>';
			tds += '<option value="M">MENSUAL</option>';
			tds += '<option value="B">BIMESTRAL</option>';
			tds += '<option value="T">TRIMESTRAL</option>';
			tds += '<option value="R">TETRAMESTRAL</option>';
			tds += '<option value="E">SEMESTRAL</option>';		
			tds += '<option value="A">ANUAL</option>';
			tds += '<option value="P">PERIODO</option>';
			tds += '<option value="U">PAGO ÚNICO</option>';
			tds += '<option value="L">LIBRE</option>';
			tds += '<option value="I">PAGO ÚNICO/INT. PERIODICO</option>';
			tds += '</select></td>';
			
			tds += '<td><input  id="diasPasoVencido'+nuevaFila+'" name="ldiasPasoVencido"  size="10"  autocomplete="off"  type="text" onkeyPress="return Validador(event);"/></td>';			
		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+valor+'" autocomplete="off"  type="hidden"/>';
			tds += '<input  id="frecuencias'+nuevaFila+'" name="frecuencias"  size="6"  value="" autocomplete="off"  type="hidden" />';								
			tds += '<select type="select" id="frecuencia'+nuevaFila+'" name="lfrecuencia" onBlur="verificaSeleccionado(this.id)" >';
			tds += '<option value="">SELECCIONAR</option>';
			tds += '<option value="S">SEMANAL</option>	>';
			tds += '<option value="D">DECENAL</option>	>';
			tds += '<option value="C">CATORCENAL</option>';	
			tds += '<option value="Q">QUINCENAL</option>';
			tds += '<option value="M">MENSUAL</option>';
			tds += '<option value="B">BIMESTRAL</option>';
			tds += '<option value="T">TRIMESTRAL</option>';
			tds += '<option value="R">TETRAMESTRAL</option>';
			tds += '<option value="E">SEMESTRAL</option>';		
			tds += '<option value="A">ANUAL</option>';
			tds += '<option value="P">PERIODO</option>';
			tds += '<option value="U">PAGO ÚNICO</option>';
			tds += '<option value="L">LIBRE</option>';
			tds += '<option value="I">PAGO ÚNICO/INT. PERIODICO</option>';
			tds += '</select></td>';				
			tds += '<td><input  id="diasPasoVencido'+nuevaFila+'" name="ldiasPasoVencido"  size="10"  autocomplete="off"  type="text" onkeyPress="return Validador(event);" /></td>';			
		}
		tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarDiasPasoVencido(this.id)"/>';
		tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarDiasPasoVencido()"/></td>';
		tds += '</tr>';	   	   
		 
		$("#miTabla").append(tds);
		habilitaBoton('grabar');
		return false;		
	}
	
//consulta cuantas filas tiene el grid de documentos
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;		
	});
	return totales;
}

function verificaSeleccionado(idCampo){
	var nuevaFrecuencia=$('#'+idCampo).val();
	
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdFrecuencias = eval("'frecuencia" + numero+ "'");
		var valorFrecuencias=$('#'+jqIdFrecuencias).val();
		if(jqIdFrecuencias != idCampo){
			if(valorFrecuencias == nuevaFrecuencia){
				mensajeSis("La Frecuencia se repite para el Producto de Crédito indicado ");
				$('#'+idCampo).val("");
				$('#'+idCampo).focus();
			}
		}
	});
	
}
	
function eliminarDiasPasoVencido(control){	
	var contador = 0 ;
	var numeroID = control;
	
	var jqRenglon = eval("'#renglon" + numeroID + "'");
	var jqNumero = eval("'#consecutivoID" + numeroID + "'");
	var jqFrecuencias = eval("'#frecuencias" + numeroID + "'");		
	var jqFrecuencia = eval("'#frecuencia" + numeroID + "'");
	var jqDiasPaso=eval("'#diasPasoVencido" + numeroID + "'");
	var jqAgrega=eval("'#agrega" + numeroID + "'");
	var jqElimina = eval("'#" + numeroID + "'");

	// se elimina la fila seleccionada
	$(jqNumero).remove();
	$(jqFrecuencias).remove();
	$(jqFrecuencia).remove();
	$(jqElimina).remove();
	$(jqDiasPaso).remove();
	$(jqAgrega).remove();
	$(jqRenglon).remove();
	//$(jqAgrega).remove();

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglon]').each(function() {		
		numero= this.id.substr(7,this.id.length);
		var jqRenglon1 = eval("'#renglon"+numero+"'");
		var jqNumero1 = eval("'#consecutivoID"+numero+"'");
		var jqFrecuencias1 = eval("'#frecuencias"+numero+"'");		
		var jqFrecuencia1= eval("'#frecuencia"+numero+"'");
		var jqDiasPaso1=eval("'#diasPasoVencido"+ numero+"'");
		var jqAgrega1=eval("'#agrega"+ numero+"'");
		var jqElimina1 = eval("'#"+numero+ "'");
	
		$(jqNumero1).attr('id','consecutivoID'+contador);
		$(jqFrecuencias1).attr('id','frecuencias'+contador);
		$(jqFrecuencia1).attr('id','frecuencia'+contador);
		$(jqDiasPaso1).attr('id','diasPasoVencido'+contador);
		$(jqAgrega1).attr('id','agrega'+contador);
		$(jqElimina1).attr('id',contador);
		$(jqRenglon1).attr('id','renglon'+ contador);
		contador = parseInt(contador + 1);	
		
	});
	
}




function Validador(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {

		if (key==8|| key == 46)	{ 
			return true;
		}
		else
			mensajeSis("sólo números");
		return false;
	}
}

	
	
	

// -- FUNCIONES ---------------------- 
