<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
  <body>
	<br>
	<c:set var="ciclo" value="1"/>
	
		<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<legend>Distribución por Centros de Costo</legend>			
			<table id="tablaProrrateo" border="0" cellsPacing="10">
				<tbody>
					<tr>
						<td class="label" colspan="2">
							<label for="cenCostoID">Centro de Costo: </label>
						</td>
						<td class="label" colspan="2">
							<label for="nombreCentro">Nombre: </label>
						</td>
						<td class="separador"/>
						<td class="label">
							<label for="porcentajePro">Porcentaje: </label>
						</td>
					</tr>					
					<c:set var="numRows" scope="session" value="${fn:length(prorrateoContable)}"/>
					<c:if test="${numRows == 0}">
						<tr id="fila${status.count}" name="fila">
							<td nowrap class="label" colspan="12" align="center">																			
								<label><b>No se encontraron coincidencias.</b></label>
							</td>
						</tr>
					</c:if>
					<c:forEach items="${prorrateoContable}" var="prorrateo" varStatus="status">
						<tr id="fila${status.count}" name="fila">
								<td colspan="2">
									<input type="text" id="cenCostoID${status.count}" name="cenCostoID" 
														value="${prorrateo.centroCostoID}" readOnly="readOnly" 
														style="text-align: center" size="12"/>
								</td>
								<td colspan="2">
									<input type="text" id="nombreCentro${status.count}" name="nombreCentro" 
														value="${prorrateo.descripcion}" readOnly="readOnly" size="20"/>
								</td>
								<td class="separador"/>								
								<td>
									<input type="text" id="porcentajePro${status.count}" name="porcentajePro" 
														value="${prorrateo.porcentaje}" size="8"  style="text-align: right"
														tabindex="${status.count+4}" readOnly="readOnly" class="PP"/>
														<label>%</label>
								</td>								
						</tr>
					</c:forEach>
					<c:if test="${numRows > 0}">
						<tr>
							<td class="separador"/>
							<td class="separador"/>
							<td class="separador"/>
							<td class="separador"/>						
							<td class="label">
									<label for="sumatoria">SUMATORIA: </label> 
							</td>	
							<td align=center>
									<input type="text" id="sumatoria" name="sumatoria" value="" readOnly='readOnly' 
											style="text-align: right" size="8"/><label>%</label>
							</td>
						</tr>
					</c:if>										
				</tbody>						
			</table>
		</fieldset>		
	
  </body>
</html>
<script type="text/javascript">
validaParticipantes();	
function validaParticipantes(){
	var total=0;
	$('input[name=porcentajePro]').each(function(){
		var ID=this.id.substring(13);			
		var evalJQ=eval("'#"+this.id+"'");
		var valorJQ=$(evalJQ).val();
		
		// evaluar campo participa
		var evalParticipa = eval("'#participaPro"+ID+"'");			
		// 	evaluar campo porcentaje
		var evalPorcen = eval("'#porcentajePro"+ID+"'");
		
		if(valorJQ>0){				
			$(evalParticipa).attr('checked','checked');
			total=parseFloat(total.toFixed(2))+parseFloat($(evalPorcen).asNumber());
		}else{
			$(evalParticipa).attr('checked',false);
		}
	});	
	$('#sumatoria').val(total.toFixed(2));
}


</script>