<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<br>

<c:set var="listaResultado"  value="${listaResultado}"/> 
<form id="gridAvales" name="gridAvales">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Avales</legend>	
		<input type="button" id="agregaAval" value="Agregar" class="botonGral" />
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="550 px">
				<tbody>	
					<tr>
					<td class="label"> 
					   	<label for="lblconsecutivo"></label> 
						</td>
						<td class="label"> 
					   	<label for="lblAval">Aval</label> 
						</td>
						<td class="label"> 
							<label for="lblCliente">No. <s:message code="safilocale.cliente"/></label> 
							<input id="valCliente" name="valCliente" size="10" type="hidden" value="<s:message code="safilocale.cliente"/>" />
				  		</td>
				  		<td class="label"> 
							<label for="lblProspecto">Prospecto</label> 
				  		</td>
						<td class="label"> 
							<label for="lblNombre">Nombre</label> 
				  		</td>
						<td class="label"> 
							<label for="lblTiempoConocido">Tiempo de Conocerlo (en años)</label> 
				  		</td>
						<td class="label"> 
							<label for="lblParentesco">Parentesco</label> 
				  		</td>
				  		<td></td>
							</tr>
					
					<c:forEach items="${listaResultado}" var="avales" varStatus="status">
						<tr id="renglonA${status.count}" name="renglonA">
							<td> 
								<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"  
										value="${status.count}" readOnly="true" disabled="true" type="hidden"/> 
						  	</td> 
						  	<td> 
								<input id="avalID${status.count}" name="avalID" size="11" 
										   value="${avales.avalID}" readOnly="true"/> 
						  	</td> 
						  		<td> 
								<input id="clienteID${status.count}" name="clienteID" size="11" 
										   value="${avales.clienteID}" readOnly="true"/> 
						  	</td>
						  			<td> 
								<input id="prospectoID${status.count}" name="prospectoID" size="11" 
										   value="${avales.prospectoID}" readOnly="true"/> 
						  	</td>
						  	<td> 
						  	<input id="nombre${status.count}" name="nombre" size="38" 
										 value="${avales.nombre}" readOnly="true" readOnly="true"/> </td> 
							<td>
							<input id="tiempoConocido${status.count}" name="tiempoConocido" size="11" maxlength="5"
										 value="${avales.tiempoConocido}" onkeypress="return validaSoloNumero(event,this);"/> </td> 
							<td nowrap="nowrap">
								<input id="parentescoID${status.count}" name="parentescoID" size="8" maxlength="10" value="${avales.parentescoID}" onKeyUp="listaParentescos(this.id);" onblur="consultaParentesco(this.id);"/>
								<input id="nombreParentesco${status.count}" name="nombreParentesco" size="30" value="${avales.nombreParentesco}" readOnly="true" readOnly="true"/>
							</td> 
							<td> 
						  		<input type="button" name="elimina" id="${status.count}" value="" class="btnElimina" onclick="eliminaDetalle(this)"/> 
								<input type="button" name="agrega" id="agrega${status.count}" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/>
						  	</td> 
						  	<td> 
						  		<input  type="hidden" id="estatusSolicitud${status.count}" name="estatusSolicitud" size="50" 
										 value="${avales.estatusSolicitud}" readOnly="true" /> 
							</td> 
						  	
				     	</tr>
					</c:forEach>
				</tbody>
			</table>
			<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
		</fieldset>
	
</form>


<script type="text/javascript">

$("#numeroDetalle").val($('input[name=consecutivoID]').length);

function eliminaDetalle(control){
   	if(estaAutorizado=='S'){
   		var contador = 0 ;
   		var numeroID = control.id;
   		
   		var jqRenglon = eval("'#renglonA" + numeroID + "'");
   		$(jqRenglon).remove();


   		//Reordenamiento de Controles
   		contador = 1;
   		var numero= 0;
   		$('tr[name=renglonA]').each(function() {		
   			numero= this.id.substr(8,this.id.length);
   			var jqRenglon = eval("'#renglonA"+numero+"'");
   			var jqNumero = eval("'#consecutivoID"+numero+"'");
   			var jqAvalID = eval("'#avalID" + numero + "'");
   			var jqClienteID = eval("'#clienteID" + numero + "'");
   			var jqProspectoID = eval("'#prospectoID" + numero + "'");
   			var jqNombre = eval("'#nombre" + numero + "'");
   			var jqTiempoConocido = eval("'#tiempoConocido" + numero + "'");
   			var jqParentescoID = eval("'#parentescoID" + numero + "'");
   			var jqNombreParentesco = eval("'#nombreParentesco" + numero + "'");
   			var jqEstatusSolicitud = eval("'#estatusSolicitud" + numero + "'");
   			var jqAgrega=eval("'#agrega"+ numero+"'");
   			var jqElimina = eval("'#"+numero+ "'");
   			
   			$(jqNumero).attr('id','consecutivoID'+contador);
   			$(jqAvalID).attr('id','avalID'+contador);
   			$(jqClienteID).attr('id','clienteID'+contador);
   			$(jqProspectoID).attr('id','prospectoID'+contador);
   			$(jqNombre).attr('id','nombre'+contador);
   			$(jqTiempoConocido).attr('id','tiempoConocido'+contador);
   			$(jqParentescoID).attr('id','parentescoID'+contador);
   			$(jqNombreParentesco).attr('id','nombreParentesco'+contador);
   			$(jqEstatusSolicitud).attr('id','estatusSolicitud'+contador);
   			$(jqAgrega).attr('id','agrega'+contador);
   			$(jqElimina).attr('id',contador);
   			$(jqRenglon).attr('id','renglonA'+ contador);
   			contador = parseInt(contador + 1);	
   			
   		});
	}
}


function agregaNuevoDetalle(){

   	if(estaAutorizado=='S'){
   		var numeroFila=consultaFilas();
   		var nuevaFila = parseInt(numeroFila) + 1;		

   		var tds = '<tr id="renglonA' + nuevaFila + '" name="renglonA">';
   		
   		tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="3" disabled="true" type="hidden" value="1" autocomplete="off" /></td>';
   		tds += '<td><input id="avalID'+nuevaFila+'" name="avalID" size="11" value="" autocomplete="off" onKeyUp="listaAvales(this.id);" onblur="consultaAvalGrid(this.id,2);"/></td> ';
   		tds += '<td><input id="clienteID'+nuevaFila+'" name="clienteID" size="11"  value="" autocomplete="off" onKeyUp="listaClientes(this.id);" onblur="consultaAvalGrid(this.id,3);"/></td> ';
   		tds += '<td><input id="prospectoID'+nuevaFila+'" name="prospectoID" size="11"  value="" autocomplete="off" onKeyUp="listaProspectos(this.id);" onblur="consultaAvalGrid(this.id,4);"/></td> ';
   		tds += '<td><input id="nombre'+nuevaFila+'" name="nombreEmpleado" size="38"  readOnly="true" value="" /></td>';
   		tds += '<td><input id="tiempoConocido'+nuevaFila+'" name="tiempoConocido" size="11" maxlength="5" value="" autocomplete="off" onkeypress="return validaSoloNumero(event,this);"/></td>';
   		tds += '<td nowrap="nowrap"><input id="parentescoID'+nuevaFila+'" name="parentescoID" size="8" maxlength="10" value="" autocomplete="off" onKeyUp="listaParentescos(this.id);" onblur="consultaParentesco(this.id);"/> ';
   		tds += '	<input id="nombreParentesco'+nuevaFila+'" name="nombreParentesco" size="30"  readOnly="true" value="" /></td>';
   		tds += '<td><input  type="hidden" id="estatusSolicitud'+nuevaFila+'" name="estatusSolicitud" size="50"  readOnly="true" value="" /></td>';
   		tds += '<td><input type="button" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaDetalle(this)"/> ';
   		tds += '<input type="button" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
   	   	tds += '</tr>';

   	   	$("#miTabla").append(tds);
		habilitaBoton('agregaAval', 'submit');
		habilitaBoton('grabar', 'submit');
	} else if(estaAutorizado=='N'){
		deshabilitaBoton('agregaAval', 'submit');
		deshabilitaBoton('grabar', 'submit');
    }
	
	return false;		
}


		
$("#agregaAval").click(function() {
	agregaNuevoDetalle();
	});

function agregaFormato(idControl){
	var jControl = eval("'#" + idControl + "'"); 
	
 	$(jControl).bind('keyup',function(){
		$(jControl).formatCurrency({
					colorize: true,
					positiveFormat: '%n', 
					roundToDecimalPlace: -1
					});
	});
	$(jControl).blur(function() {
			$(jControl).formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
			});
	});
	$(jControl).formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});			
}

/*    cuenta las filas de la tabla del grid       */
function consultaFilas(){
	var totales=0;
	$('tr[name=renglonA]').each(function() {
		totales++;		
	});
	return totales;
}

</script>
		
