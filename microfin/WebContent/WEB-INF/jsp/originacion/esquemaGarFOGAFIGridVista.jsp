<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="bonificaFOGAFI"  value="${listaResultado[2]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

		<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td align="left" colspan="5">
						<input type="button" id="agregarFOGAFI" class="submit" value="Agregar" tabindex="4" onclick="agregarFilaFOGAFI();" onblur="setFocoGrid();"/>
					 	<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" size="10" />  	
					</td>
				</tr> 
		</table>
	<table id="miTablaFOGAFI"> 
		<c:choose>
				<c:when test="${tipoLista == '4'}">
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

							<td align="center" id="encBonoFOGAFI">
								<label class="label">Bonificaci&oacute;n</label>	  	
							</td>
							<td align="center">									  	
							</td> 

					</tr>
									
						<c:forEach items="${listaResultado}" var="esquema" varStatus="status">
							<tr id="renglonFOGAFI${status.count}" name="renglonFOGAFI">
								<input type="hidden" id="consecutivoID${status.count}" value="${status.count}"/>	
								<input type="hidden" name="lEsqGarFOGAFIID" value="${esquema.esquemaGarFOGAFIID}"/>				
								<td align="center">
									<c:if test="${esquema.clasificacionFOGAFI == 'A'}">
										<select id="clasificacionFOGAFI${status.count}" name="lClasificacionFOGAFI">
											<option value="A">EXCELENTE</option>
											<option value="B">BUENA</option>
											<option value="C">REGULAR</option>
											<option value="N">NO ASIGNADA</option>
										</select>
									</c:if>
									<c:if test="${esquema.clasificacionFOGAFI == 'B'}">
										<select id="clasificacionFOGAFI${status.count}" name="lClasificacionFOGAFI">
											<option value="B">BUENA</option>
											<option value="A">EXCELENTE</option>
											<option value="C">REGULAR</option>
											<option value="N">NO ASIGNADA</option>
										</select>
									</c:if>
									<c:if test="${esquema.clasificacionFOGAFI == 'C'}">
										<select id="clasificacionFOGAFI${status.count}" name="lClasificacionFOGAFI">
											<option value="C">REGULAR</option>
											<option value="A">EXCELENTE</option>
											<option value="B">BUENA</option>
											<option value="N">NO ASIGNADA</option>
										</select>
									</c:if>
									<c:if test="${esquema.clasificacionFOGAFI == 'N'}">
										<select id="clasificacionFOGAFI${status.count}" name="lClasificacionFOGAFI">
											<option value="N">NO ASIGNADA</option>
											<option value="A">EXCELENTE</option>
											<option value="B">BUENA</option>
											<option value="C">REGULAR</option>											
										</select>
									</c:if>
								</td>
								<td align="center">
									<input type="text"  id="limiteInferiorFOGAFI${status.count}" size="22"  value="${esquema.limiteInferiorFOGAFI}" name="lLimiteInferiorFOGAFI"  esMoneda="true" style="text-align:right;" onBlur="validarLimitesFOGAFI(this.id,this.value)" onClick="this.focus()"/>
								</td>
								<td align="center">
									<input type="text" id="limiteSuperiorFOGAFI${status.count}" size="22"  value="${esquema.limiteSuperiorFOGAFI}" name="lLimiteSuperiorFOGAFI" esMoneda="true" style="text-align:right;" onBlur="validarLimitesFOGAFI(this.id,this.value)" onClick="this.focus()" />
								</td>
								<td align="center">
									<input type="text" id="porcentajeFOGAFI${status.count}" size="10"  value="${esquema.porcentajeFOGAFI}" name="lPorcentajeFOGAFI"  esMoneda="true"  style="text-align:right;" onBlur="validarPorcentajeFOGAFI(this.id,this.value)" onClick="this.focus()" />
									<label class="label">%</label>	  
								</td>
								

									<td class="bonoFOGAFI" align="center">
										<input type="text" id="bonificaFOGAFI${status.count}" size="10"  value="${esquema.porcBonificacionFOGAFI}" name="lBonificaFOGAFI"  esMoneda="true"  style="text-align:right;" onBlur="validarBonificacionFOGAFI(this.id,this.value)" onClick="this.focus()" />
										<label class="label">%</label>	  
									</td>
					
							  	<td align="center">
			                     <input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminarFilaFOGAFI(this.id)" />							  	
			                     <input type="button" name="agregarFOGAFI" id="agregarFOGAFI${status.count}" class="btnAgrega"  onclick="agregarFilaFOGAFI()"/>
							  	</td>
							</tr>
						 <c:set var="cont" value="${status.count}"/>
				
						</c:forEach>
				</c:when>
			</c:choose>	

						
	</table> 