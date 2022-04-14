<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
</head>
<body>
<c:set var="listaResultado"  value="${listaPaginada.pageList}"/>
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Calendario de Fechas</legend>
		<form id="gridCalendario" name="gridCalendario">
			
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
						   	<label for="lblNumero">N&uacute;mero SMS</label>
							</td>
							<td class="label">
						   	<label for="lblNumero">Fecha de Env&iacute;o</label>
							</td>
						</tr>
						
						<c:forEach items="${listaResultado}" var="fechas" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
								<td> 
									<input id="envioID${status.count}"  name="envioID" size="4"  
											value="${fechas.envioID}" readOnly="true" disabled="true"/> 
							  	</td> 
								<td> 
									<input id="fechaInicio${status.count}"  name="fechaInicio" size="20"  
											value="${fechas.fechaRespuesta}" readOnly="true" disabled="true"/> 
							  	</td> 
							  		</tr>
							
							<c:set var="cuotas" value="${status.count}"/>
							<c:set var="numTransaccion" value="${fechas.numTransaccion}"/>
						</c:forEach>
						<tr>			
							<table colspan="5" align="right">
								<tr>
									<td align="right">
										<input id="cuotas" name="cuotas" size="10" align="right"  type = "hidden"
							         value="${cuotas}" readOnly="true" disabled="true" />	
							         <input id="numTransaccion" name="numTransaccion" size="10" align="right"  type = "hidden"
							         value="${numTransaccion}" readOnly="true" disabled="true" />
									</td>
								</tr>
							</table> 
						</tr>
			</table>
				<c:if test="${!listaPaginada.firstPage}">
					 <input onclick="conSimulaFechasTemp('previous')" type="button" value="" class="btnAnterior" />
				</c:if>
				<c:if test="${!listaPaginada.lastPage}">
					 <input onclick="conSimulaFechasTemp('next')" type="button" value="" class="btnSiguiente" />
				</c:if>		
					
		</fieldset>
	</form>
	<script type="text/javascript">
			//mostrar el grid de amortizaciones temporales	
		function conSimulaFechasTemp(pageValor){
			var varCamp = $('#campaniaID').val()
	 		var periodicidad = $('#periodicidad').val()
	 		var fechaInicio = $('#fechaInicio').val()
	 		var fechaFin = $('#fechaFin').val()
			var params = {};
			
			params['campaniaID'] = varCamp;
			params['periodicidad'] = periodicidad;
			params['fechaInicio'] = fechaInicio;
			params['fechaFin'] = fechaFin;
			params['page'] = pageValor ; 
		
		$.post("envioMasivoGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#gridCalendarioSMS').html(data); 
				$('#gridCalendarioSMS').show();
			}else{
				$('#gridCalendarioSMS').html("");
				$('#gridCalendarioSMS').show();
			}
		});
	} 		
	</script>


</body>
</html>