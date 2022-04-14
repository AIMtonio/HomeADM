<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>

</head>
<body>
</br>

<c:set var="listaResultado"  value="${listaResultado}"/> 

<form id="gridObligados" name="gridObligados">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Obligados Solidarios</legend>	
		<input type="button" id="agregaObligado" value="Agregar" class="botonGral"/>
			<table id="miTabla" border="0" width="550 px">
				<tbody>	
					<tr>
					<td class="label"> 
					   	<label for="lblconsecutivo"></label> 
						</td>
						<td class="label"> 
					   	<label for="lblObligado">Obligado Solidario</label> 
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
					
					<c:forEach items="${listaResultado}" var="obligados" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"  
										value="${status.count}" readOnly="true" disabled="true" type="hidden"/> 
						  	</td> 
						  	<td> 
								<input id="obligadoID${status.count}" name="obligadoID" size="8" 
										   value="${obligados.obligadoID}" readOnly="true"/> 
						  	</td> 
						  		<td> 
								<input id="clienteID${status.count}" name="clienteID" size="8" 
										   value="${obligados.clienteID}" readOnly="true" /> 
						  	</td>
						  	<td> 
								<input id="prospectoID${status.count}" name="prospectoID" size="8" 
										   value="${obligados.prospectoID}" readOnly="true" /> 
						  	</td>
						  	<td> 
						  	<input id="nombre${status.count}" name="nombre" size="50" 
										 value="${obligados.nombre}" readOnly="true" /> </td> 
							<td>
							<input id="tiempoConocido${status.count}" name="tiempoConocido" size="11" maxlength="5"
										 value="${obligados.tiempoConocido}" onkeypress="return validaSoloNumero(event,this);"/> </td> 
							<td nowrap="nowrap">
								<input id="parentescoID${status.count}" name="parentescoID" size="8" maxlength="10" value="${obligados.parentescoID}" onKeyUp="listaParentescos(this.id);" onblur="consultaParentesco(this.id);"/>
								<input id="nombreParentesco${status.count}" name="nombreParentesco" size="30" value="${obligados.nombreParentesco}" readOnly="true" readOnly="true"/>
							</td>
                                                        <td> 
						  		<input type="button" name="elimina" id="${status.count}" value="" class="btnElimina" onclick="eliminaDetalle(this)"/> 
								<input type="button" name="agrega" id="agrega${status.count}" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/>
						  	</td> 
						  
							<td> 
						  		<input  type="hidden" id="estatusSolicitud${status.count}" name="estatusSolicitud" size="50" 
										 value="${obligados.estatusSolicitud}" readOnly="true"/> 
							</td> 
						  
						  
						  
				     	</tr>
					</c:forEach>
				</tbody>
			</table>
			<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
		</fieldset>
	
</form>

</body>
</html>

<script type="text/javascript">

$("#numeroDetalle").val($('input[name=consecutivoID]').length);

function eliminaDetalle(control){
   	if(estaAutorizado=='S'){
		var contador = 0 ;
		var numeroID = control.id;
		
		var jqRenglon = eval("'#renglon" + numeroID + "'");
		$(jqRenglon).remove();
	
	
		//Reordenamiento de Controles
		contador = 1;
		var numero= 0;
		$('tr[name=renglon]').each(function() {		
			numero= this.id.substr(7,this.id.length);
			var jqRenglon = eval("'#renglon"+numero+"'");
			var jqNumero = eval("'#consecutivoID"+numero+"'");
			var jqObligadoID = eval("'#obligadoID" + numero + "'");
			var jqClienteID = eval("'#clienteID" + numero + "'");
			var jqProspectoID = eval("'#prospectoID" + numero + "'");
			var jqNombre = eval("'#nombre" + numero + "'");
			var jqTiempoConocido = eval("'#tiempoConocido" + numero + "'");
   			var jqParentescoID = eval("'#parentescoID" + numero + "'");
   			var jqNombreParentesco = eval("'#nombreParentesco" + numero + "'");
			var jqAgrega=eval("'#agrega"+ numero+"'");
			var jqElimina = eval("'#"+numero+ "'");
		
			$(jqNumero).attr('id','consecutivoID'+contador);
			$(jqObligadoID).attr('id','obligadoID'+contador);
			$(jqClienteID).attr('id','clienteID'+contador);
			$(jqProspectoID).attr('id','prospectoID'+contador);
			$(jqNombre).attr('id','nombre'+contador);
			$(jqTiempoConocido).attr('id','tiempoConocido'+contador);
   			$(jqParentescoID).attr('id','parentescoID'+contador);
   			$(jqNombreParentesco).attr('id','nombreParentesco'+contador);
			$(jqAgrega).attr('id','agrega'+contador);
			$(jqElimina).attr('id',contador);
			$(jqRenglon).attr('id','renglon'+ contador);
			contador = parseInt(contador + 1);	
			
		});
   	}
}


function agregaNuevoDetalle(){
   	if(estaAutorizado=='S'){
		var numeroFila=consultaFilas();
		var nuevaFila = parseInt(numeroFila) + 1;		
	
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	  
		
		tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="3" disabled="true" type="hidden" value="1" autocomplete="off" /></td>';
		tds += '<td><input id="obligadoID'+nuevaFila+'" name="obligadoID" size="8" value="" autocomplete="off" onKeyUp="listaObligados(\'obligadoID'+nuevaFila+'\');" onblur="consultaObligadoGrid(this.id,2);"/></td> ';
		tds += '<td><input id="clienteID'+nuevaFila+'" name="clienteID" size="8"  value="" autocomplete="off" onKeyUp="listaClientes(\'clienteID'+nuevaFila+'\');" onblur="consultaObligadoGrid(this.id,3);"/></td> ';
		tds += '<td><input id="prospectoID'+nuevaFila+'" name="prospectoID" size="8"  value="" autocomplete="off" onKeyUp="listaProspectos(\'prospectoID'+nuevaFila+'\');" onblur="consultaObligadoGrid(this.id,4);"/></td> ';
		tds += '<td><input id="nombre'+nuevaFila+'" name="nombreEmpleado" size="50"  readOnly="true" value="" /></td>';
		tds += '<td><input id="tiempoConocido'+nuevaFila+'" name="tiempoConocido" size="11" maxlength="5" value="" autocomplete="off" onkeypress="return validaSoloNumero(event,this);"/></td>';
   		tds += '<td nowrap="nowrap"><input id="parentescoID'+nuevaFila+'" name="parentescoID" size="8" maxlength="10" value="" autocomplete="off" onKeyUp="listaParentescos(this.id);" onblur="consultaParentesco(this.id);"/> ';
   		tds += '	<input id="nombreParentesco'+nuevaFila+'" name="nombreParentesco" size="30"  readOnly="true" value="" /></td>';
		tds += '<td><input type="button" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaDetalle(this)"/> ';
		tds += '<input type="button" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
	   	tds += '</tr>';
	
	   	$("#miTabla").append(tds);
		habilitaBoton('agregaObligado', 'submit');
		habilitaBoton('grabar', 'submit');
	} else if(estaAutorizado=='N'){
		deshabilitaBoton('agregaObligado', 'submit');
		deshabilitaBoton('grabar', 'submit');
	}

	return false;		
}

		
$("#agregaObligado").click(function() {
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


</script>
		

