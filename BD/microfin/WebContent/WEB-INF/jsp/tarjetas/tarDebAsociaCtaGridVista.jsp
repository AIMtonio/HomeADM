<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="listaTarjetas"  value="${listaPaginada.pageList}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend>Tarjetas Relacionadas a la Cuenta</legend>	
	<table border="0" cellpadding="0" cellspacing="0" width="100%"> 		
		<tr id="encabezadoLista">
			<td >Tarjetahabiente</td> 	
			<td >Relaci&oacute;n</td>
			<td >Estatus</td> 
		</tr>
		<c:forEach items="${listaTarjetas}" var="listaTarDeb" varStatus="status">
		<tr>
			<td> 
				<label for="nombreTarjeta" id="nombreTarjeta${status.count}"  name="nombreTarjeta" size="45" >
					${listaTarDeb.nombreTarjeta}
				</label>  
			</td> 
			<td> 
    			<label for="relacion" id="relacion${status.count}" name="relacion" size="10">
    				${listaTarDeb.relacion}
    			</label>
     		</td> 
     		<td> 				     									
				<label for="estatus" id="estatus${status.count}" name="estatus" size="30">
					${listaTarDeb.estatus}
				</label>
    		</td> 
		</tr>
		</c:forEach>
	</table>
	<c:if test="${!listaPaginada.firstPage}">
		 <input onclick="consultaTarjetasCta('previous')" type="button" value="" class="btnAnterior" />
	</c:if>
	<c:if test="${!listaPaginada.lastPage}">
		 <input onclick="consultaTarjetasCta('next')" type="button" value="" class="btnSiguiente" />
	</c:if>		
</fieldset>
	
<div id="listaTarDebito" style="display: none;">
	<div id="elementoListaDes"/>		
</div>	
	
<script type="text/javascript">
function consultaTarjetasCta(pageValor){
	var params = {};
	params['tipoLista'] =16;
	params['cuentaAhoID'] = $('#cuentaAhoID').val();
	params['page'] = pageValor ;

	$.post("gridTarDebConsulta.htm", params, function(data){
		if(data.length >0) {
			$('#gridTarDebConsulta').html(data);
			$('#gridTarDebConsulta').show();
		}else{
			$('#gridTarDebConsulta').html("");
			$('#gridTarDebConsulta').show(); 
		}
	});
	agregaFormatoControles('formaGenerica');
	
}
</script>

	
		
		


        
