<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="reporteBitacora"  value="${listaPaginada.pageList}"/>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Bitácora de Carga de Lote de Tarjetas</legend>	
			<table border="0" cellpadding="0" cellspacing="0" width="100%"> 		
					<tr id="encabezadoLista">
						<td align="center">Consecutivo</td> 	
						<td align="center"> No.Tarjeta</td>
						<td align="center"> Motivo Fallo</td> 
					</tr>					
				<c:forEach items="${reporteBitacora}" var="bitacoraLote" varStatus="status">
					<tr>
						<td> 
							<label for="consecutivo" id="consecutivo${status.count}"  name="consecutivo" size="11" >
								${bitacoraLote.consecutivoBit}
							</label>  
						</td> 
					  	<td> 
							<label for="tarjeta" id="tarjeta${status.count}"  name="tarjeta" size="16" >
								${bitacoraLote.numTarjeta}
							</label>  
					  	</td> 
			     		<td> 
		     				<label for="motivoFallo" id="motivoFallo${status.count}" name="motivoFallo" size="50">
		     					${bitacoraLote.motivoFallo}
		     				</label>
			     		</td> 
					</tr>
				</c:forEach>
			</table>
			<c:if test="${!listaPaginada.firstPage}">
				 <input onclick="consultaBitacora('previous')" type="button" value="" class="btnAnterior" />
			</c:if>
			<c:if test="${!listaPaginada.lastPage}">
				 <input onclick="consultaBitacora('next')" type="button" value="" class="btnSiguiente" />
			</c:if>		
		</fieldset>
	
<div id="gridBitacoraCargaLote" style="display: none;">
		
</div>	
	
<script type="text/javascript">
function consultaBitacora(pageValor){
	var params = {};
	params['tipoLista'] =  1;
	params['bitCargaID'] = $('#bitCargaID').val();	
	params['page'] = pageValor ;
	$.post("bitacoraCargaLoteGridVista.htm", params, function(data){		
	
		if(data.length >0) {
			$('#gridBitacoraCargaLote').html(data);
			$('#gridBitacoraCargaLote').show();

		}else{
			$('#gridBitacoraCargaLote').html("");
			$('#gridBitacoraCargaLote').show(); 
		}
	});
	
}

   
</script>