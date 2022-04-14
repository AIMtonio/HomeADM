<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<br></br>

<c:set var="listaResultado"  value="${listaPaginada.pageList}"/>

<div id="formaGenerica3" class="formaGenerica3">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Movimientos</legend>	
	
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="60%">
				<tbody>	
					<tr>	
						<td class="label"> 
					   	<label for="lblFecha">No. Amortizaci&oacute;n</label> 
						</td>					
						<td class="label"> 
					   	<label for="lblFecha">Fecha Inicio</label> 
						</td>
						<td class="label"> 
							<label for="lblCR">Descripci&oacute;n</label> 
				  		</td>	
						<td class="label"> 
							<label for="lblCuenta">Tipo</label> 
				  		</td>
				  		<td class="label"> 
			         	<label for="lblReferencia">Naturaleza</label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblDescripcion">Cantidad</label> 
			     		</td> 
			     		  
					</tr>
					
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							 
							 <td> 
								<input id="amortiCreID${status.count}"  name="amortiCreID" size="12"  
										value="${amortizacion.amortiCreID}" readOnly="true" disabled="true"/> 
						  	</td> 
							<td> 
								<input id="fechaOperacion${status.count}"  name="fechaOperacion" size="12"  
										value="${amortizacion.fechaOperacion}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input id1="descripcion${status.count}" name="descripcion" size="35" 
										value="${amortizacion.descripcion}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input id="tipoMovCreID${status.count}" name="tipoMovCreID" size="38" 
										value="${amortizacion.tipoMovCreID}" readOnly="true" disabled="true"/> 
						  	</td>
							<c:if test="${amortizacion.natMovimiento == 'C'}">
						  	<td>   
				         	<input id="natMovimiento${status.count}" name="natMovimiento" size="8" align="right"
				         			value="CARGO" readOnly="true" disabled="true"/> 
				     		</td>
						  	</c:if> 
						  	<c:if test="${amortizacion.natMovimiento == 'A'}">
						  	<td>   
				         	<input id="natMovimiento${status.count}" name="natMovimiento" size="8" align="right"
				         			value="ABONO" readOnly="true" disabled="true"/> 
				     		</td>
						  	</c:if> 
						  	<td> 
								<input style="text-align:right" id="cantidad${status.count}" name="cantidad" size="15" 
										value="${amortizacion.cantidad}" readOnly="true" disabled="true" esMoneda="true"/> 
						  	</td> 
				     						         	 
						</tr>
					</c:forEach>
				</tbody>
				
			</table>						
			<c:if test="${!listaPaginada.firstPage}">
				 <input onclick="consultaGridMovimientosCredito('previous')" type="button" value="" class="btnAnterior" />
			</c:if>
			<c:if test="${!listaPaginada.lastPage}">
				 <input onclick="consultaGridMovimientosCredito('next')" type="button" value="" class="btnSiguiente" />
			</c:if>			
		</fieldset>
</div>


<script type="text/javascript">
function consultaGridMovimientosCredito(pageValor){
	var params = {};
	params['creditoID'] = $('#creditoID').val();		
	params['tipoLista'] = 1;
	params['page'] = pageValor ;
	
	$('#gridAmortizacion').hide();
	$.post("creditoConsulMovsGridVista.htm", params, function(data){		
			if(data.length >0) {
				$('#gridMovimientos').html(data);
				$('#gridMovimientos').show(); 
				agregaFormatoControles('formaGenerica3');
			}else{
				$('#gridMovimientos').html("");
				$('#gridMovimientos').show();
			}
	});
	agregaFormatoControles('gridDetalle');
}
</script>
