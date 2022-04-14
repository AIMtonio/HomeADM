<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

		<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td align="left" colspan="5">
						<input type="button" id="agregar" class="submit" value="Agregar" tabindex="4" onclick="agregarFila();" onblur="setFocoGrid();" />
					 		
					</td>
				</tr> 
		</table>

	<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="70%"> 
		<c:choose>
				<c:when test="${tipoLista == '2'}">
			 		<tr>
						<td align="center">
							<label class="label">Tipo de Pago</label>	  	
						</td>
						<td align="center">
							<label class="label">Factor R/S</label>	  	
						</td>
						<td align="center">
							<label class="label">Porcentaje de Descuento</label>	  	
						</td>
						<td align="center">
							<label class="label">Monto P&oacute;liza</label>	  	
						</td>
						<td align="center">									  	
						</td>     	
					</tr>
									
				 <c:forEach items="${listaResultado}" var="esquema" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
								<input type="hidden" id="consecutivoID${status.count}" value="${status.count}"/>	
								<input type="hidden" id="lesquemaSeguroID" name="lesquemaSeguroID" value="${esquema.esquemaSeguroID}"/>				
								<td align="center">
									<c:if test="${esquema.tipoPagoSeguro == 'A'}">
										<select id="tipoPagoSeguro${status.count}" name="ltipoPagoSeguro" onblur="validaTipPago();" >
											<option value="A">ADELANTADO</option>
											<option value="F">FINANCIAMIENTO</option>
											<option value="C">DEDUCCION</option>
											<option value="O">OTRO</option>
											<option value="">SELECCIONAR</option>
											
											
										</select>
									</c:if>
									<c:if test="${esquema.tipoPagoSeguro == 'F'}">
										<select id="tipoPagoSeguro${status.count}" name="ltipoPagoSeguro" onblur="validaTipPago();" >
											<option value="F">FINANCIAMIENTO</option>
											<option value="A">ADELANTADO</option>
											<option value="C">DEDUCCION</option>
											<option value="O">OTRO</option>
											<option value="">SELECCIONAR</option>
											
											
										</select>
									</c:if>
									<c:if test="${esquema.tipoPagoSeguro == 'D'}">
										<select id="tipoPagoSeguro${status.count}" name="ltipoPagoSeguro" onblur="validaTipPago();" >
											<option value="D">DEDUCCION</option>
											<option value="A">ADELANTADO</option>
											<option value="F">FINANCIAMIENTO</option>
											<option value="O">OTRO</option>
											<option value="">SELECCIONAR</option>
											
										</select>
									</c:if>
									
									<c:if test="${esquema.tipoPagoSeguro == 'O'}">
										<select id="tipoPagoSeguro${status.count}" name="ltipoPagoSeguro" onblur="validaTipPago();" >
											<option value="O">OTRO</option>
											<option value="D">DEDUCCION</option>
											<option value="A">ADELANTADO</option>
											<option value="F">FINANCIAMIENTO</option>
											<option value="">SELECCIONAR</option>
											
										</select>
									</c:if>
								
								</td>
								<td align="center">
									<input type="text"  id="factorRiesgoSeguro${status.count}" size="22"  value="${esquema.factorRiesgoSeguro}" name="lfactorRiesgoSeguro" seisDecimales="true"  style="text-align:right;" onClick="this.focus()"   onblur="validaFactorRiesgo();" />
								</td>
								<td align="center">
									<input type="text" id="descuentoSeguro${status.count}" size="22"  value="${esquema.descuentoSeguro}" name="ldescuentoSeguro" esMoneda="true" style="text-align:right;"  onClick="this.focus()" onblur="validaDescuento();" />
									<label id ="porciento${status.count}" class="label">%</label>	  
								</td>
								<td align="center">
									<input type="text" id="montoPolSegVida${status.count}" size="10"  value="${esquema.montoPolSegVida}" name="lmontoPolSegVida"  esMoneda="true"  style="text-align:right;"  onClick="this.focus()" onblur="validaMontoPoliza();" />
								</td>
								
							  	<td align="center">
			                     <input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminarFila(this.id, ${esquema.esquemaSeguroID});" />							  	
			                     <input type="button" name="agrega" id="agrega${status.count}" class="btnAgrega"  onclick="agregarFila(); deshabilarBoton();"/>
							  	</td>
							</tr>
						 <c:set var="cont" value="${status.count}"/>
				
						</c:forEach>
				</c:when>
			</c:choose>			 		
	</table> 



