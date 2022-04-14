<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="bonificaFOGA"  value="${listaResultado[2]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>
	
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td align="left" colspan="5">
						<input type="button" id="agregar" class="submit" value="Agregar" tabindex="11" onclick="agregarFila();" onblur="setFocoGrid();"/>
					 	<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" size="10" />  	
					</td>
				</tr> 
		</table>
	<table id="miTabla"> 
		<c:choose>
				<c:when test="${tipoLista == '2'}">
			 		<tr>
						<td align="center">
							<label class="label">Clasificaci&oacute;n</label>	  	
						</td>
						<td align="center">
							<label class="label">Monto Inferior</label>	  	
						</td>
						<td align="center">
							<label class="label">Monto Superior</label>	  	
						</td>
						<td align="center">
							<label class="label">Porcentaje&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>	  	
						</td>
						
							<td align="center" id="encBonoFOGA">
								<label class="label">Bonificaci&oacute;n</label>	  	
							</td>
							<td align="center">									  	
							</td> 
					</tr>
									
						<c:forEach items="${listaResultado}" var="esquema" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
								<input type="hidden" id="consecutivoID${status.count}" value="${status.count}"/>	
								<input type="hidden" name="lEsquemaGarantiaLiqID" value="${esquema.esquemaGarantiaLiqID}"/>				
								<td align="center">
									<c:if test="${esquema.clasificacion == 'A'}">
										<select id="clasificacion${status.count}" name="lClasificacion">
											<option value="A">EXCELENTE</option>
											<option value="B">BUENA</option>
											<option value="C">REGULAR</option>
											<option value="N">NO ASIGNADA</option>
										</select>
									</c:if>
									<c:if test="${esquema.clasificacion == 'B'}">
										<select id="clasificacion${status.count}" name="lClasificacion">
											<option value="B">BUENA</option>
											<option value="A">EXCELENTE</option>
											<option value="C">REGULAR</option>
											<option value="N">NO ASIGNADA</option>
										</select>
									</c:if>
									<c:if test="${esquema.clasificacion == 'C'}">
										<select id="clasificacion${status.count}" name="lClasificacion">
											<option value="C">REGULAR</option>
											<option value="A">EXCELENTE</option>
											<option value="B">BUENA</option>
											<option value="N">NO ASIGNADA</option>
										</select>
									</c:if>
									<c:if test="${esquema.clasificacion == 'N'}">
										<select id="clasificacion${status.count}" name="lClasificacion">
											<option value="N">NO ASIGNADA</option>
											<option value="A">EXCELENTE</option>
											<option value="B">BUENA</option>
											<option value="C">REGULAR</option>											
										</select>
									</c:if>
								</td>
								<td align="center">
									<input type="text"  id="limiteInferior${status.count}" size="22"  value="${esquema.limiteInferior}" name="lLimiteInferior"  esMoneda="true" style="text-align:right;" onBlur="validarLimites(this.id,this.value)" onClick="this.focus()"/>
								</td>
								<td align="center">
									<input type="text" id="limiteSuperior${status.count}" size="22"  value="${esquema.limiteSuperior}" name="lLimiteSuperior" esMoneda="true" style="text-align:right;" onBlur="validarLimites(this.id,this.value)" onClick="this.focus()" />
								</td>
								<td align="center">
									<input type="text" id="porcentaje${status.count}" size="10"  value="${esquema.porcentaje}" name="lPorcentaje"  esMoneda="true"  style="text-align:right;" onBlur="validarPorcentaje(this.id,this.value)" onClick="this.focus()" />
									<label class="label">%</label>	  
								</td>
								

									<td class="bonoFOGA" align="center">
										<input type="text" id="bonificaFOGA${status.count}" size="10"  value="${esquema.porcBonificacionFOGA}" name="lBonificaFOGA"  esMoneda="true"  style="text-align:right;" onBlur="validarBonificacion(this.id,this.value)" onClick="this.focus()" />
										<label class="label">%</label>	  
									</td>
						
							  	<td align="center">
			                     <input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminarFila(this.id)" />							  	
			                     <input type="button" name="agrega" id="agrega${status.count}" class="btnAgrega"  onclick="agregarFila()"/>
							  	</td>
							</tr>
						 <c:set var="cont" value="${status.count}"/>
				
						</c:forEach>
				</c:when>
			</c:choose>								
	</table> 