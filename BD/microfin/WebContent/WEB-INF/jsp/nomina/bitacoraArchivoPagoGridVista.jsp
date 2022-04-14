<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="reporteBitacora"  value="${listaPaginada.pageList}"/>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		   <legend>Notificaci&oacute;n de Errores en la Carga</legend>	 
			<table  width="100%"> 		
					<tr id="encabezadoLista">
						<td align="center">Folio Carga</td> 
						<td align="center">Cr&eacute;dito</td> 
						<td align="center"> Empresa N&oacute;mina</td>
						<td align="center"> Descripci&oacute;n</td> 
						
					</tr>					
				<c:forEach items="${reporteBitacora}" var="bitacoraArchivo" varStatus="status">
					<tr>
						<td> 
							<label for="consecutivo" id="consecutivo${status.count}"  name="consecutivo" size="11" >
								${bitacoraArchivo.folioCargaID}
							</label>  
						</td> 
						<td> 
							<label for="credito" id="credito${status.count}"  name="credito" size="1" >
								${bitacoraArchivo.creditoID}
							</label>  
						</td> 
					  	<td> 
							<label for="institucion" id="institucion${status.count}"  name="institucion" size="16" >
								${bitacoraArchivo.institNominaID}
							</label>  
					  	</td> 
			     		<td> 
		     				<label for="descripcion" id="descripcion${status.count}" name="descripcion" size="50">
		     					${bitacoraArchivo.descripcionError}
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
	
<div id="gridBitacoraCargaArchivo" style="display: none;">
		
</div>	
	
<script type="text/javascript">
function consultaBitacora(pageValor){
	var params = {};
	params['tipoLista'] =  1;
	params['folioCargaID'] = $('#folioCargaID').val();	
	params['page'] = pageValor ;
	$.post("bitacoraArchivoPagoGrid.htm", params, function(data){		
	
		if(data.length >0) {
			$('#gridBitacoraCargaArchivo').html(data);
			$('#gridBitacoraCargaArchivo').show();

		}else{
			$('#gridBitacoraCargaArchivo').html("");
			$('#gridBitacoraCargaArchivo').show(); 
		}
	});
	
}
   
</script>