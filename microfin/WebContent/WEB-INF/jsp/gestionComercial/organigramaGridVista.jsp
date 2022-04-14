<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="listaResultado"  value="${listaResultado[0]}"/>
<c:set var="requiereCtaContaBean" value="${listaResultado[1]}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend>Dependencias</legend>	
	<input type="button" id="agregaDependencia" value="Agregar" class="botonGral" tabindex="5"/>
		<table id="miTabla">
			<tbody>	
				<tr>
					<td class="label"> 
				   		<label for="lblpuestoHijo">Empleado</label> 
					</td>
					<td class="label"> 
						<label for="lblNombre">Nombre</label> 
			  		</td>
					<td class="label"> 
						<label for="lblPuesto">Puesto</label> 
			  		</td>
					<td class="label"> 
						<label for="centroCostos">Centro de Costos</label> 
			  		</td>	
					<td class="label"> 
						<label id="lblCuentaConta" for="cuenta">Cuenta</label> 
			  		</td>	
				</tr>					
				<c:forEach items="${listaResultado}" var="dependencias" varStatus="status">
				<tr id="renglon${status.count}" name="renglon">
					<td> 
						<input type="hidden" id="consecutivoID${status.count}"  name="consecutivoID" size="8"  value="${status.count}" readOnly="true" disabled="true"/> 
						<input type="hidden" id="requiereCtaConta${status.count}"  name="lisRequiereCtaConta" size="8"  value="${dependencias.requiereCtaConta}" readOnly="true" disabled="true"/> 
				  	
						<input type="text" id="puestoHijoID${status.count}" name="lisPuestoHijoID" size="8" value="${dependencias.puestoHijoID}" readOnly="true" tabindex="${status.count + 5}"/> 
				  	</td> 
				  	<td> 
				  		<input type="text" id="nombreEmpleado${status.count}" name="nombreEmpleado" size="37" value="${dependencias.nombreEmpleado}" readOnly="true" disabled="true"/>								
				  	</td> 
				  	<td> 
						<input type="text" id="descripcionPuesto${status.count}" name="descripcionPuesto" size="24" value="${dependencias.descripcionPuesto}" readOnly="true" disabled="true"/> 
				  	</td> 							  		
	 				<td>
      		 			<input type="text" id="centroCostoID${status.count}" name="centroCostoID" size="8" value="${dependencias.centroCostoID}" tabindex="${status.count + 5}" autocomplete="off" maxlength="30" onkeypress="listaCentroCostoGrid(this.id);" onblur="consultaCentroCostosGrid(this.id);"/>
      		 			<input type="text" id="descripcionCenCos${status.count}" name="descripcionCenCos" size="27" value="${dependencias.descripcionCenCos}" disabled="true" readOnly="true"/>
					</td>
	 				<td>
   		 				<input type="text" id="ctaContable${status.count}" name="lisCtaContable" size="12" value="${dependencias.ctaContable}" tabindex="${status.count + 5}" autocomplete="off" maxlength="50" onkeypress="listaCtaContableGrid(this.id);" onblur="consultaCtaContableGrid(this.id);"/>
  		 				<input type="text" id="descripcionCtaCon${status.count}" name="lisDescripcionCtaCon" size="28" value="${dependencias.descripcionCtaCon}" disabled="true" readOnly="true"/>
					</td>
				  	<td> 
				  		<input type="button" name="elimina" id="${status.count}" value="" class="btnElimina" onclick="eliminaDetalle(this)" tabindex="${status.count + 5}"/> 
					</td> 
				  	<td> 
						<input type="button" name="agrega" id="agrega${status.count}" value="" class="btnAgrega" onclick="agregaNuevoDetalle()" tabindex="${status.count + 5}"/>
				  	</td> 
		     	</tr>
			</c:forEach>
		</tbody>
	</table>
	<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
</fieldset>
	
<script type="text/javascript">



agregaFormatoControles('gridOrganigrama');

$("#numeroDetalle").val($('input[name=consecutivoID]').length);	

function validaDigitos(e){
	if(e.which!=0 && (e.which<48 || e.which>57)){
		return false;
		}
}
$('#gridOrganigrama').validate({
	rules: {
		consecutivoID: { 
			minlength: 1
		}
	},
	messages: { 			
	 	consecutivoID: {
			minlength: 'Al menos un Caracter'
		}
	}		
});	

function eliminaDetalle(control){	
	var numeroID = control.id;
	var jqTr = eval("'#renglon" + numeroID + "'");
	$(jqTr).remove();
	var antesFila = parseInt(numeroID) - 1;
   	$("#puestoHijoID"+antesFila).focus();
}

function maximoConsecutivo(){
	var maxconsecutivo = 0;
	$('input[name=consecutivoID]').each(function() {
		var jqConsecutivo = eval("'#" + this.id + "'");			
		var consecutivo = $(jqConsecutivo).asNumber();
		if(parseInt(consecutivo) > parseInt(maxconsecutivo)){
			maxconsecutivo = parseInt(consecutivo);
		}
	});
	return parseInt(maxconsecutivo);
} 

function agregaNuevoDetalle(){
	var numeroFila = maximoConsecutivo();
	var nuevaFila = parseInt(numeroFila) + 1;			
   	var index = nuevaFila + 5;
   	
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
   	tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="3"  type="hidden" disabled="true" value="'+nuevaFila+'" autocomplete="off"/>';
	tds += '    <input type="text" id="puestoHijoID'+nuevaFila+'" name="lisPuestoHijoID" size="8" value="" autocomplete="off" onkeypress="listaEmpleados(this.id);" onblur="consultaEmpleadoGrid(this.id,\'nombreEmpleado'+nuevaFila+'\',\'descripcionPuesto'+nuevaFila+'\');" tabindex="'+index+'"/></td>';
	tds += '<td><input type="text" id="nombreEmpleado'+nuevaFila+'" name="nombreEmpleado" size="37"  disabled="true" value="" autocomplete="off"/></td>';
	tds += '<td><input type="text" id="descripcionPuesto'+nuevaFila+'" name="descripcionPuesto" size="24" disabled="true" value="" autocomplete="off"/></td>';
	tds += '<td><input type="text" id="centroCostoID'+nuevaFila+'" name="centroCostoID" size="8" value="" tabindex="'+index+'" autocomplete="off" maxlength="30" onkeypress="listaCentroCostoGrid(this.id);" onblur="consultaCentroCostosGrid(this.id);"/>';
	tds += '	<input type="text" id="descripcionCenCos'+nuevaFila+'" name="descripcionCenCos" size="27" value="" disabled="true" readOnly="true"/></td>';
	if($('#ctaContaSI').is(':checked')){	
		tds += '<td><input type="text" id="ctaContable'+nuevaFila+'" name="lisCtaContable" size="12" value="" tabindex="'+index+'" autocomplete="off" maxlength="50" onkeypress="listaCtaContableGrid(this.id);" onblur="consultaCtaContableGrid(this.id);"/>';
		tds += '	<input type="text" id="descripcionCtaCon'+nuevaFila+'" name="lisDescripcionCtaCon" size="28" value="" disabled="true" readOnly="true"/></td>';	
	}else{	
		tds += '<td><input type="text" id="ctaContable'+nuevaFila+'" name="lisCtaContable" size="12" value="" tabindex="'+index+'" autocomplete="off" maxlength="50" onkeypress="listaCtaContableGrid(this.id);" onblur="consultaCtaContableGrid(this.id);" style="display: none;"/>';
		tds += '	<input type="text" id="descripcionCtaCon'+nuevaFila+'" name="lisDescripcionCtaCon" size="28" value="" disabled="true" readOnly="true" style="display: none;"/></td>';	
	}
	tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaDetalle(this)" tabindex="'+index+'"/></td>';
	tds += '<td><input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()" tabindex="'+index+'"/></td>';
	tds += '</tr>';
   
   	$("#miTabla").append(tds);
   	agregaFormatoControles('formaGenerica');
   	$("#puestoHijoID"+nuevaFila).focus();	
}

		
$("#agregaDependencia").click(function() {
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
		
		