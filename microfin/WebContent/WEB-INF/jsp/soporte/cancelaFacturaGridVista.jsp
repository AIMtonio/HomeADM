<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>

	</head>
	<body>
		</br>
		<c:set var="ciclo" value="1"/>
		<form id="gridCancelaFactura" name="gridCancelaFactura">		
			<fieldset class="ui-widget ui-widget-content ui-corner-all">	
					<legend>Folios Fiscales</legend>			
			<table id="miTabla" border="0">
				<tbody>
					<tr>
						<td class="label">
							<label for="lbNo">No.</label>
						</td>						
						<td class="label">
							<label for="lbfolioFiscal">Folio Fiscal</label>
						</td>				
						<td class="label">
							<label for="lbFerchaEmision">Fecha Emisión</label>
						</td>																
						<td class="label">
							<label for="lbRFCEmisor">RFC Emisor</label>
						</td>
						<td class="label">
							<label for="lbRazonSocialEmisor">Razón Social del Emisor</label>
						</td>
						<td class="label">
							<label for="lbRFCReceptor">RFC Receptor</label>
						</td>
						<td class="label">
							<label for="lbRazonSocialReceptor">Razón Social del Receptor</label>
						</td>
						<td class="label">
							<label for="lbTotal">Total</label>
						</td>
						<td class="label">
							<label for="lbEstatus">Estatus</label> 
						</td>
						<td class="label">
							<label for="lbMotivoCancelacion">Motivo de Cancelación</label>
						</td> 
					</tr>
					<c:set var="numRows" scope="session" value="${fn:length(cancelaFacturaList)}"/>
					<c:if test="${numRows == 0}">
   					<tr id="renglon${status.count}" name="renglon">
						<td nowrap class="label" colspan="12" align="center">																			
							<label><b>No se encontraron coincidencias.</b></label>
						</td>
						</tr>
					</c:if>
					<c:forEach items="${cancelaFacturaList}" var="cancelaFactura" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td nowrap>
							<input type="text" size="1" name="facturaID" id="facturaID${status.count}" value="${cancelaFactura.numeroFiscal}" readOnly="true"/>
						</td>
						<td>
							<input type="text" size="50" name="folioFiscal" id="folioFiscal${status.count}" value="${cancelaFactura.folioFiscal}" readOnly="true" />
						</td>
						<td>
							<input type="text" size="10" name="fechaEmision" id="fechaEmision${status.count}" value="${cancelaFactura.fechaEmision}" readOnly="true"/>
						</td>
						<td>
							<input type="text" size="16" name="rfcEmisor" id="rfcEmisor${status.count}" value="${cancelaFactura.rfcEmisor}" readOnly="true"/>
						</td>
						<td>
							<input type="text" size="16" name="razonSocialEmisor" id="razonSocialEmisor${status.count}" value="${cancelaFactura.razonSocialEmisor}" readOnly="true" />
						</td>
						<td>
							<input type="text" size="16" name="rfcReceptor" id="rfcReceptor${status.count}" value="${cancelaFactura.rfcReceptor}" readOnly="true"/>
						</td>
						<td>
							<input type="text" size="16" name="razonSocialReceptor" id="razonSocialReceptor${status.count}" value="${cancelaFactura.razonSocialReceptor}" readOnly="true"/>
						</td>
						<td>
							<input type="text" size="10" name="total" id="total${status.count}" value="${cancelaFactura.totalFactura}" readOnly="true" />
						</td>
						<td>
							<input type="text"	size="9" name="estatusGrid" id="estatusGrid${status.count}" value="${cancelaFactura.estatus}" disabled="true"/>
						</td>
						<td>
							<textarea name="motivo" id="motivo${status.count}" rows="2" cols="10" tabindex="9" onblur="ponerMayusculas(this)" maxlength="200">${cancelaFactura.motivo}</textarea>
						</td>
						<td>
							<input type="button" name="cancelarCFDI" id="cancelarCFDI${status.count}" class="btnCancela" tabindex="10" onClick="cancelaFolio(this)" />
						</td>
						<td>
							<input type="button" name="cancela${status.count}" id="cancela${status.count}" class="submit" value="Ver CFDI" tabindex="11" onclick="verCFDI(this.id);"></textarea>
							<input type="hidden" id="clienteID${status.count}" name="clienteID${status.count}" value="${cancelaFactura.cliente}" />
							<input type="hidden" id="periodo${status.count}" name="periodo${status.count}" value="${cancelaFactura.periodo}" />
							<input type="hidden" id="sucursalO${status.count}" name="sucursalO${status.count}" value="${cancelaFactura.sucursalCliente}" />
						</td>
					</tr>
				</c:forEach> 					
				</tbody>
			</table>
			</fieldset>
		</form>
	</body>
</html>
<script type="text/javascript">
	$('input[name=total]').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
	});

	function cancelaFolio(control){
		var ID=control.id.substring("12");
		var jqIDFolio=eval("'#facturaID"+ID+"'");
		var jqFolio=eval("'#folioFiscal"+ID+"'");
		var jqMotivo=eval("'#motivo"+ID+"'");
		var valorFolioID=$(jqIDFolio).val();
		var valorFolio=$(jqFolio).val();
		var valorMotivo=$(jqMotivo).val();
		var inicializaforma=false;
		if(valorMotivo!=""){
			var cancelaFacturaBean= {
					'numeroFiscal': valorFolioID,
					'folioFiscal':valorFolio,
					'motivo': valorMotivo 				
			};
			
			$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
			$('#contenedorForma').block({
				message: $('#mensaje'),
				css: {border:		'none',
					background:	'none'}
			});
			$.post("cancelaFactura.htm", cancelaFacturaBean, function(data){
				if(data.length >0) {
					$('#mensaje').html(data);
					var exitoTransaccion = $('#numeroMensaje').val();
					resultadoTransaccion = exitoTransaccion; 
					if (exitoTransaccion == 0){						
						$('#gridCancelaFactura').hide();		
					}
					
				}
			});
		}else{
			alert("Especifique el Motivo de Cancelación");
			$(jqMotivo).focus();
		}	
	}
	
	function verCFDI(control){
		var id = control.substring("7");
		var jqPeriodo=eval("'#periodo" +id + "'");
		var jqSucursalO=eval("'#sucursalO" +id + "'");
		var jqClienteID=eval("'#clienteID" +id + "'");
		var valorPeriodo=$(jqPeriodo).val();
		var valorSucursalO=$(jqSucursalO).val();
		var valorClienteID=$(jqClienteID).val();
	
		window.open('edoCtaVerCFDI.htm?periodo='+ valorPeriodo +
						'&sucursalCliente='+valorSucursalO+'&cliente='+valorClienteID, '_blank');
	}
</script>