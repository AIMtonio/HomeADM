
esTab = false;
var numero = 0;
var vacios = false;
$(document).ready(function() {
	
	 agregaFormatoControles('formaGenerica');
	 creaTabla();
	 deshabilitaBoton('exportar','submit');
	 
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
			vacios = validaVacios();
			if(!vacios){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','garantiaID','funcionExito','funcionError');
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
		
		
		$('#grabar').click(function(){
			$('#tipoTransaccion').val('1');
		});

		$('#exportar').click(function(){
			exportar();
		});

});// fin del document ready






function creaTabla(){
	$("#gridCancelacion").html("");
	var tabla = '<table id="tbRefOrden" border="0">';
		tabla +=		'<tr>';
		tabla +=			'<td style="width: 10px">';
		tabla +=				'<input type="button" class="submit" value="Agregar" id="btnAgregar" tabindex="1" onclick="agregaDetalle()"/>';
		tabla +=			'</td>';
		tabla +=		'</tr>';
		tabla +=		'<tr>';
		tabla +=			'<td nowrap="nowrap">';
		tabla +=				'<label>Solicitud Cred. </label>';
		tabla +=			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td nowrap="nowrap">';
		tabla +=				'<label>Num. Cr&eacute;dito </label>';
		tabla +=			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td nowrap="nowrap">';
		tabla +=				'<label>Referencia</label>';
		tabla +=			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td>';
		tabla +=				'<label>Estatus</label>';
		tabla += 			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td>';
		tabla +=				'<label>Nombre del Cliente</label>';
		tabla +=			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td nowrap="nowrap">';
		tabla +=				'<label>Monto </label>';
		tabla += 			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td nowrap="nowrap">';
		tabla += 			'</td>';
		tabla += 		'</tr>';
		tabla +=		'<tr id="renglon1" name="renglon">';
		tabla +=			'<td nowrap="nowrap">';
		tabla +=				'<input type="text" id="solicitudCreditoID1" tabindex="1" name="solicitudCreditoID" size="15" maxlength="10" onkeyup="listasSolicitud(this)" onblur="validaDispersionSol(this.id)" autocomplete="off"/>';
		tabla += 			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td>';
		tabla +=				'<input type="text" id="creditoID1"  name="creditoID" size="15" disabled="disabled" readonly="readonly"/>';
		tabla += 			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td>';
		tabla +=				'<input type="text" id="referencia1" tabindex="2" name="referencia" size="25" onkeyup="listaReferencia(this)" onblur="validaDispersionRef(this.id)" autocomplete="off"/>';
		tabla += 			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td>';
		tabla +=				'<input type="text" id="estatus1" name="estatus" size="15"  maxlength="5" disabled="disabled" readonly="readonly"/>';
		tabla += 			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td>';
		tabla +=				'<input type="text" id="nombreCliente1"  name="nombreCliente" size="35" disabled="disabled" readonly="readonly"/>';
		tabla += 			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td>';
		tabla +=				'<input type="text" id="monto1"  name="monto" size="15" disabled="disabled" esmoneda="true" style="text-align: right;" readonly="readonly"/>';
		tabla += 			'</td>';
		tabla +=			'<td></td>';
		tabla +=			'<td nowrap="nowrap">';
		tabla +=				'<input type="button" id="agrega1" name="agrega" class="btnAgrega" onclick="agregaDetalle(this.id)" tabindex="3"/>';
		tabla +=				'<input type="button" id="1" name="elimina" class="btnElimina" onclick="eliminaDetalle(this)" tabindex="4"/>';
		tabla +=			'</td>';
		tabla +=			'<td>';
		tabla +=				'<input type="hidden" id="folioDispersion1" name="lisFolioDispersion"/>';
		tabla +=				'<input type="hidden" id="claveDisMov1"  name="lisClaveDisMov"/>';
		tabla +=			'</td>';
		tabla +=		'</tr>';
		tabla +='</table>';
		$("#gridCancelacion").append(tabla);
		$('#solicitudCreditoID1').focus();
		agregaFormatoControles('formaGenerica');
		$('#monto1').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	
};

//FUNCION AGREGA FILA EN EL GRID DE GARANTIAS
function agregaDetalle(){

	var numeroFila = 0;
	var tabindex = 4;
	vacios = validaVacios();
	
	if(!vacios){
		$('tr[name=renglon]').each(function() {
			numeroFila++;
		});
		var nuevaFila = parseInt(numeroFila) + 1;
		var inicia = parseInt(tabindex)* parseInt(nuevaFila);
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	
		tds +=			'<td nowrap="nowrap">';
		tds +=				'<input type="text" id="solicitudCreditoID'+nuevaFila+'"  name="solicitudCreditoID" size="15" maxlength="10" onkeyup="listasSolicitud(this)" onblur="validaDispersionSol(this.id)" autocomplete="off"/>';
		tds += 			'</td>';
		tds +=			'<td></td>';
		tds +=			'<td>';
		tds +=				'<input type="text" id="creditoID'+nuevaFila+'"  name="creditoID" size="15" disabled="disabled" readonly="readonly"/>';
		tds += 			'</td>';
		tds +=			'<td></td>';
		tds +=			'<td>';
		tds +=				'<input type="text" id="referencia'+nuevaFila+'"  name="referencia" size="25" onkeyup="listaReferencia(this)" onblur="validaDispersionRef(this.id)" autocomplete="off"/>';
		tds += 			'</td>';
		tds +=			'<td></td>';
		tds +=			'<td>';
		tds +=				'<input type="text" id="estatus'+nuevaFila+'"  name="estatus" size="15"  maxlength="5" disabled="disabled" readonly="readonly"/>';
		tds += 			'</td>';
		tds +=			'<td></td>';
		tds +=			'<td>';
		tds +=				'<input type="text" id="nombreCliente'+nuevaFila+'"  name="nombreCliente" size="35" disabled="disabled" readonly="readonly"/>';
		tds += 			'</td>';
		tds +=			'<td></td>';
		tds +=			'<td>';
		tds +=				'<input type="text" id="monto'+nuevaFila+'"  name="monto" esmoneda="true" size="15" disabled="disabled" style="text-align: right;" readonly="readonly"/>';
		tds += 			'</td>';
		tds +=			'<td></td>';
		tds +=			'<td nowrap="nowrap">';
		tds +=				'<input type="button" id="agrega'+nuevaFila+'" name="agrega" class="btnAgrega" onclick="agregaDetalle(this.id)" />';
		tds +=				'<input type="button" id="'+nuevaFila+'" name="elimina" class="btnElimina" onclick="eliminaDetalle(this)" />';
		tds +=			'</td>';
		tds +=			'<td>';
		tds +=				'<input type="hidden" id="folioDispersion'+nuevaFila+'" name="lisFolioDispersion"/>';
		tds +=				'<input type="hidden" id="claveDisMov'+nuevaFila+'"  name="lisClaveDisMov"/>';
		tds +=			'</td>';
		tds += '</tr>';
		
		//document.getElementById("numeroDetalle").value = nuevaFila;
		$("#tbRefOrden").append(tds);
		$('#solicitudCreditoID'+nuevaFila).focus();
		agregaFormatoControles('formaGenerica');
		$('#monto'+nuevaFila).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	}
		

	

}

function eliminaDetalle(control){
	var numeroID = control.id;
	var jqTr = eval("'#renglon" + numeroID + "'");


	var jqSolicitudCreditoID = eval("'#solicitudCreditoID" + numeroID + "'");
	var jqCreditoID = eval("'#creditoID" + numeroID + "'");
	var jqReferencia = eval("'#referencia" + numeroID + "'");
	var jqEstatus = eval("'#estatus" + numeroID + "'");
	var jqNombreCliente = eval("'#nombreCliente" + numeroID + "'");
	var jqMonto = eval("'#monto" + numeroID + "'");
	var jqFolioDispersion = eval("'#folioDispersion" + numeroID + "'");
	var jqClaveDisMov = eval("'#claveDisMov" + numeroID + "'");

	var jqElimina = eval("'#" + numeroID + "'");
	var jqAgrega = eval("'#agrega" + numeroID + "'");


	$(jqSolicitudCreditoID).remove();
	$(jqCreditoID).remove();
	$(jqReferencia).remove();
	$(jqEstatus).remove();
	$(jqNombreCliente).remove();
	$(jqMonto).remove();
	$(jqFolioDispersion).remove();
	$(jqClaveDisMov).remove();

	$(jqElimina).remove();
	$(jqAgrega).remove();
	$(jqTr).remove();

	//Reordenamiento de Controles
	var contador = 1;
	$('input[name=solicitudCreditoID]').each(function() {
		var jqCicInf = eval("'#" + this.id + "'");
		$(jqCicInf).attr("id", "solicitudCreditoID" + contador);
		//$(jqCicInf).attr("tabindex",)
		contador = contador + 1;
	});
	contador=1;
	$('input[name=creditoID]').each(function() {
		var jqCicInf = eval("'#" + this.id + "'");

		$(jqCicInf).attr("id", "creditoID" + contador);
		contador = contador + 1;
	});

	//Reordenamiento de Controles
	contador = 1;
	$('input[name=referencia]').each(function() {
		var jqCicSup = eval("'#" + this.id + "'");
		$(jqCicSup).unbind();
		$(jqCicSup).attr("id", "referencia" + contador);
		//listaDescripcion("descripcion" + contador);
		contador = contador + 1;
	});


	//Reordenamiento de Controles
	contador = 1;
	$('input[name=estatus]').each(function() {
		var jqCicSup = eval("'#" + this.id + "'");
		$(jqCicSup).unbind();
		$(jqCicSup).attr("id", "estatus" + contador);
		contador = contador + 1;
	});

	//Reordenamiento de Controles
	contador = 1;
	$('input[name=nombreCliente]').each(function() {
		var jqCicSup = eval("'#" + this.id + "'");
		$(jqCicSup).unbind();
		$(jqCicSup).attr("id", "nombreCliente" + contador);
		contador = contador + 1;
	});

	//Reordenamiento de Controles
	contador = 1;
	$('input[name=monto]').each(function() {
		var jqCicSup = eval("'#" + this.id + "'");
		$(jqCicSup).unbind();
		$(jqCicSup).attr("id", "monto" + contador);
		contador = contador + 1;
	});
	
	//Reordenamiento de Controles
	contador = 1;
	$('input[name=folioDispersion]').each(function() {
		var jqCicSup = eval("'#" + this.id + "'");
		$(jqCicSup).unbind();
		$(jqCicSup).attr("id", "folioDispersion" + contador);
		contador = contador + 1;
	});
	
	//Reordenamiento de Controles
	contador = 1;
	$('input[name=claveDisMov]').each(function() {
		var jqCicSup = eval("'#" + this.id + "'");
		$(jqCicSup).unbind();
		$(jqCicSup).attr("id", "claveDisMov" + contador);
		contador = contador + 1;
	});
	
	
	//Reordenamiento de Controles
	contador = 1;
	$('input[name=agrega]').each(function() {
		var jqAgrega = eval("'#" + this.id + "'");
		$(jqAgrega).attr("id", "agrega" + contador);
		contador = contador + 1;
	});

	//Reordenamiento de Controles
	contador = 1;
	$('input[name=elimina]').each(function() {
		var jqCicElim = eval("'#" + this.id + "'");
		$(jqCicElim).attr("id", contador);
		contador = contador + 1;
	});

	//Reordenamiento de Controles
	contador = 1;
	$('tr[name=renglon]').each(function() {
		var jqCicTr = eval("'#" + this.id + "'");
		$(jqCicTr).attr("id", "renglon" + contador);
		contador = contador + 1;
	});
}


function listasSolicitud(control){
	//var numero = control.id.substring(11); 
	var jqSolicitudID = eval("'#"+control.id+"'");
	
	var camposLista = new Array();
    var tipoLista='3';
    var parametrosLista = new Array();
    camposLista[0]	=	"nombreCompleto";   
    parametrosLista[0]	=	$(jqSolicitudID).val();
    listaAlfanumerica(control.id,'0',tipoLista,camposLista,parametrosLista,'dispersionListaVista.htm');
}

function listaReferencia(control){
	var jqReferencia = eval("'#"+control.id+"'");
	 var camposLista = new Array();
	    var tipoLista='4';
	    var parametrosLista = new Array();
	    camposLista[0]	=	"referenciaDisp";		
	    parametrosLista[0]	=	$(jqReferencia).val();

	    listaAlfanumerica(control.id,'0',tipoLista,camposLista,parametrosLista,'dispersionListaVista.htm');
}


function validaDispersionSol(idControl){
	setTimeout("$('#cajaLista').hide();",200);
	if(esTab){
		var 	jqFolio		=	eval("'#"+idControl+"'");
		var 	valFolio	=	$(jqFolio).val();
		var numero = idControl.substr(18);
		var 	DispersionBeanCta	=	{
			'solicitudCreditoID'	: 	valFolio,
			'referenciaDisp'	: 	''
		};
		
		if(valFolio!="" && valFolio!=null){
			operDispersionServicio.consultaMovs(1,DispersionBeanCta,function(dispersiones){
	
				if(dispersiones 	!=	null){
					$('#solicitudCreditoID'+numero).val(dispersiones.solicitudCreditoID);
					$('#creditoID'+numero).val(dispersiones.creditoID);
					$('#referencia'+numero).val(dispersiones.cuentaDestino);
					$('#estatus'+numero).val(dispersiones.estatusDisp);
					$('#nombreCliente'+numero).val(dispersiones.nombreCompleto);
					$('#monto'+numero).val(dispersiones.montoDisp);
					$('#folioDispersion'+numero).val(dispersiones.dispersionID);
					$('#claveDisMov'+numero).val(dispersiones.claveDispMovID);
				}else{
					mensajeSis('No existe el la solicitud');
				}
			});
		}else{
			limpiaCampos(numero);
		}
		
	}
}

function validaDispersionRef(idControl){
	setTimeout("$('#cajaLista').hide();",200);
	if(esTab){
		var 	jqFolio		=	eval("'#"+idControl+"'");
		var 	valFolio	=	$(jqFolio).val();
		var numero = idControl.substr(10);
		var 	DispersionBeanCta	=	{
			'solicitudCreditoID'	: 	'',
			'referenciaDisp'	: 	valFolio
		};
		if(valFolio!="" && valFolio!=null){
			operDispersionServicio.consultaMovs(2,DispersionBeanCta,function(dispersiones){
				if(dispersiones 	!=	null){
					$('#solicitudCreditoID'+numero).val(dispersiones.solicitudCreditoID);
					$('#creditoID'+numero).val(dispersiones.creditoID);
					$('#referencia'+numero).val(dispersiones.cuentaDestino);
					$('#estatus'+numero).val(dispersiones.estatusDisp);
					$('#nombreCliente'+numero).val(dispersiones.nombreCompleto);
					$('#monto'+numero).val(dispersiones.montoDisp);
					$('#folioDispersion'+numero).val(dispersiones.dispersionID);
					$('#claveDisMov'+numero).val(dispersiones.claveDispMovID);
				}else{
					mensajeSis('No existe el la referencia');
				}
			});
		}else{
			limpiaCampos(numero);
		}
	}
}



//FUNCION DE EXITO
function funcionExito(){
	$('#numTransaccion').val($('#consecutivo').val());
	habilitaBoton('exportar','submit');
	deshabilitaBoton('grabar','submit');

}

// FUNCION DE ERROR
function funcionError(){
	deshabilitaBoton('exportar','submit');
}

function exportar(){
	var paginaArchOtros ='generaArchText.htm?nombreArch='+"BajaPagoDirectos"+
	 '&tipoArchivo='+"3"+
	 '&institucionID='+0+
	 '&numTransaccion='+$('#numTransaccion').val()+
	 '&extension='+".txt";
	window.open(paginaArchOtros,'_blank');
	habilitaBoton('grabar','submit');
	deshabilitaBoton('exportar','submit');
	creaTabla();
}

function limpiaCampos(numFila){
	$('#solicitudCreditoID'+numFila).val("");
	$('#creditoID'+numFila).val("");
	$('#referencia'+numFila).val("");
	$('#estatus'+numFila).val("");
	$('#nombreCliente'+numFila).val("");
	$('#monto'+numFila).val("");
	$('#folioDispersion'+numFila).val("");
	$('#claveDisMov'+numFila).val("");
}

function validaVacios() {
	var exito = false;
	var contador = 0;

	$('input[name=solicitudCreditoID]').each(function() {
		numero= this.id.substr(18,this.id.length);
		var nombreCli= $('#nombreCliente'+numero).val();
		if(nombreCli == ""){
			mensajeSis("Existen Campos vacios");
			$('#solicitudCreditoID'+numero).focus();
			$('#solicitudCreditoID'+numero).select();
			$('#solicitudCreditoID'+numero).addClass("error");
			contador++;		
		}

	});

	if(contador>0){
		exito = true;
	}
	return exito;
}

function verificarVaciosDG(){

	var numDetalle = $('select[name=ltipoBien]').length;
	for ( var i = 1; i <= numDetalle; i++) {
		var TipoBien = $('#tipoBien'+i).val(); 			//Tipo Bien

		if (TipoBien == "") {
			$('#tipoBien'+i).select();
			$('#tipoBien'+i).focus();
			$('#tipoBien'+i).addClass("error");
			i = numDetalle;
			return 1;
		}
	}
}