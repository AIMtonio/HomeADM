<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="reporteMovimientos"  value="${listaPaginada.pageList}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend>Movimientos</legend>	
	<table border="0" cellpadding="0" cellspacing="0" width="100%"> 		
		<tr id="encabezadoLista">
			<td colspan="2"  align="center">Fecha</td> 	
			<td colspan="2"  align="center">Descripci&oacute;n</td>
			<td colspan="2"  align="">Tipo</td> 
			<td colspan="2"  align="center">Referencia</td> 
			<td colspan="2"  align="center">Monto</td> 
			<td colspan="2"  align="center">Saldo</td> 
		</tr>
		<c:forEach items="${reporteMovimientos}" var="reporteMovimientosC" varStatus="status">
		<tr>
			<td nowrap="nowrap"> 
				<label for="fecha" id="fecha${status.count}"  name="fecha" size="20" >
					${reporteMovimientosC.fecha}
				</label>  
			</td>
			<td class="separador"></td>  
			<td> 
				<c:choose>
		     		<c:when test="${reporteMovimientosC.natMovimiento == 'A'}">
		     			<c:set var="naturaleza" value="ABONO"/>
				    </c:when>
		     		<c:when test="${reporteMovimientosC.natMovimiento == 'C'}">
		     			<c:set var="naturaleza" value="CARGO"/>
				   	</c:when>
				</c:choose>
				<label for="descripcionMov${status.count}" id="descripcionMov${status.count}" name="descripcionMov" size="50"
				  	onclick="consultaDesMovimientos('${reporteMovimientosC.fecha}',
									  				'${reporteMovimientosC.descripcionMov}',
									  				'${naturaleza}',
									  				'${reporteMovimientosC.referenciaMov}',
									  				'${reporteMovimientosC.cantidadMov}',
									  				'${reporteMovimientosC.saldo}');"
					style="text-decoration:underline;color:#7d7d7d;">
					<c:set var="string" value="${reporteMovimientosC.descripcionMov}"/>${fn:substring(string,0,50)}
				</label>
			</td>
			<td class="separador"></td>  
			<td> 
    			<label for="natMovimiento" id="natMovimiento${status.count}" name="natMovimiento" size="10">
    				${naturaleza}
    			</label>
     		</td>
     	    <td class="separador"></td>  
     		<td > 				     									
				<label for="referenciaMov" id="referenciaMov${status.count}" name="referenciaMov" size="25">
					${reporteMovimientosC.referenciaMov}
				</label>
    		</td>
    		<td class="separador"></td>  
  			<td align="right"> 
      			<label for="cantidadMov" id="cantidadMov${status.count}" name="cantidadMov" size="15">
      				${reporteMovimientosC.cantidadMov}
      			</label>
  			</td> 
  		  	<td class="separador"></td> 	
  			<td  align="right"> 	
  				<label for="saldo"  id="saldo${status.count}" name="saldo" size="15">
  					${reporteMovimientosC.saldo}
  				</label>
  			</td> 
		</tr>
		</c:forEach>
	</table>
	
	<c:if test="${!listaPaginada.firstPage}">
		 <input onclick="consultaMovimientos('previous')" type="button" value="" class="btnAnterior" />
	</c:if>
	<c:if test="${!listaPaginada.lastPage}">
		 <input onclick="consultaMovimientos('next')" type="button" value="" class="btnSiguiente" />
	</c:if>		
</fieldset>
	
<div id="desMovimiento" style="display: none;">
	<div id="elementoListaDes"/>		
</div>	
	
<script type="text/javascript">
function consultaMovimientos(pageValor){
	var params = {};
	params['tipoLista'] =  $('#tipoListaMovs').val();
	params['cuentaAhoID'] = $('#cuentaAhoID').val();
	params['anio'] = $('#anio').val();
	params['mes'] = $('#mes').val(); 
	params['page'] = pageValor ;

	$.post("gridReporteMovimientos.htm", params, function(data){
		if(data.length >0) {
			$('#gridReporteMovimientos').html(data);
			$('#gridReporteMovimientos').show();
			$('#imprimir').show(); 
		}else{
			$('#gridReporteMovimientos').html("");
			$('#gridReporteMovimientos').show(); 
		}
	});
	agregaFormatoControles('formaGenerica');
	
}

   
</script>

	
		
		


        
