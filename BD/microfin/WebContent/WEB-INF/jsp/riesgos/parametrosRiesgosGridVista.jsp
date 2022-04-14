<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="gridPorcentaje" name="gridPorcentaje">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Porcentajes</legend>	
			<table id="miTabla" border="0"  width="100%">
				<c:choose>
					<c:when test="${tipoLista == '2'}">
						<tr>
							<td class="label" align="left">
						   	<label for="consecutivo">No.</label> 
							</td>
							<td class="label" align="left">
						   		<label for="descripcion">Descripci&oacute;n</label> 
							</td>	
							<td class="label" align="left">
						   		<label for="porcentaje">Valor</label> 
							</td>	  		
						</tr>					
						<c:forEach items="${listaResultado}" var="riesgo" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
								<c:if test="${riesgo.dinamico == 'N'}">
								<td>
									<input type="text" id="consecutivoID${status.count}" name="consecutivoID" size="4" value="${status.count}" readOnly="true" />
								</td>
								<td>
									<input type="text" id="descripcion${status.count}" name="ldescripcion" size="40" value="${riesgo.descripcion}" readOnly="true"  />
								</td>
								<td>
									<input type="text" id="porcentaje${status.count}" name="lporcentaje" size="7" value="${riesgo.porcentaje}"  onkeyPress="return validador(event);" 
									onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" tabindex = "1"  style="text-align:right" />
									<label>%</label>
								</td>
								</c:if>	
								<c:if test="${riesgo.paramRiesgosID == '6'}">
								<td>
									<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="4" />
									<input type="text" id="estadoID${status.count}" name="estadoID" size="4" onkeypress="listaEstados(this.id)" onblur="consultaEstado(this.id)" value="${riesgo.referenciaID}"/>
								</td>
								<td>
									<input type="text" id="descripcion${status.count}" name="ldescripcion" size="40" value="${riesgo.descripcion}" readOnly="true" />
								</td>
								<td>
									<input type="text" id="porcentaje${status.count}" name="lporcentaje" size="7" value="${riesgo.porcentaje}"  onkeyPress="return validador(event);" 
									onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" style="text-align:right" />
									<label>%</label>
								</td>
								</c:if>	
								<c:if test="${riesgo.paramRiesgosID == '15'}">
								<td>
									<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="4" />
									<input type="text" id="producCreditoID${status.count}" name="producCreditoID" size="4" onkeypress="listaProductos(this.id)" onblur="consultaProducto(this.id)" value="${riesgo.referenciaID}"/>
								</td>
								<td>
									<input type="text" id="descripcion${status.count}" name="ldescripcion" size="40" value="${riesgo.descripcion}" readOnly="true" />
								</td>
								<td>
									<input type="text" id="porcentaje${status.count}" name="lporcentaje" size="7" value="${riesgo.porcentaje}"  onkeyPress="return validador(event);" 
									onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" style="text-align:right" />
									<label>%</label>
								</td>
								</c:if>	
								<c:if test="${riesgo.paramRiesgosID == '17'}">
								<td>
									<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="4" />
									<input type="text" id="sucursalID${status.count}" name="sucursalID" size="4" onkeypress="listaSucursal(this.id)" onblur="consultaSucursal(this.id)" value="${riesgo.referenciaID}"/>
								</td>
								<td>
									<input type="text" id="descripcion${status.count}" name="ldescripcion" size="40" value="${riesgo.descripcion}" readOnly="true" />
								</td>
								<td>
									<input type="text" id="porcentaje${status.count}" name="lporcentaje" size="7" value="${riesgo.porcentaje}"  onkeyPress="return validador(event);" 
									onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" style="text-align:right" />
									<label>%</label>
								</td>
								</c:if>
								<td>
									<input type="hidden" id="referencia${status.count}" name="lreferencia" size="4" value="${riesgo.referenciaID}" />
								</td>
								<c:if test="${riesgo.dinamico == 'S'}">
							  	<td> 
									<input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarParametro(this.id)" />			
									<input type="button" name="agregar" id="agregar${status.count}" value="" class="btnAgrega" onclick="agregaNuevoParametro()" />
							  	</td> 
							  	</c:if>					
							</tr>
					</c:forEach>
				</c:when>
				<c:when test="${tipoLista == '3'}">
					<tr>
						<td class="label" align="left">
					   	<label for="consecutivo">No.</label> 
						</td>
						<td class="label" align="left">
					   		<label for="descripcion">Descripci&oacute;n</label> 
						</td>	
						<td class="label" align="left">
					   		<label for="porcentaje">Valor</label> 
						</td>	  		
					</tr>					
					<c:forEach items="${listaResultado}" var="riesgo" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="text" id="consecutivoID${status.count}" name="consecutivoID" size="4" value="${status.count}" readOnly="true" />
							</td>
							<c:if test="${riesgo.dinamico == 'N'}">
							<td>
								<input type="text" id="descripcion${status.count}" name="ldescripcion" size="40" value="${riesgo.descripcion}" readOnly="true"  />
							</td>
							</c:if>	
							<td>
								<input type="text" id="porcentaje${status.count}" name="lporcentaje" size="7" value="${riesgo.porcentaje}" onkeyPress="return validador(event);" 
								onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" tabindex = "1" style="text-align:right"/>
								<label>%</label>
							</td>
							<td>
								<input type="hidden" id="referencia${status.count}" name="lreferencia" size="4" value="${status.count}" />
							</td>				
						</tr>
					</c:forEach>
				</c:when>
				<c:when test="${tipoLista == '4'}">
					<tr>
						<td class="label" align="left">
					   	<label for="consecutivo">No.</label> 
						</td>
						<td class="label" align="left">
					   		<label for="descripcion">Descripci&oacute;n</label> 
						</td>	
						<td class="label" align="left">
					   		<label for="porcentaje">Valor</label> 
						</td>	  		
					</tr>					
					<c:forEach items="${listaResultado}" var="riesgo" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="text" id="consecutivoID${status.count}" name="consecutivoID" size="4" value="${status.count}" readOnly="true" />
							</td>
							<c:if test="${riesgo.dinamico == 'N'}">
							<td>
								<input type="text" id="descripcion${status.count}" name="ldescripcion" size="40" value="${riesgo.descripcion}" readOnly="true"   />
							</td>
							</c:if>	
							<td>
								<input type="text" id="porcentaje${status.count}" name="lporcentaje" size="7" value="${riesgo.porcentaje}"  onkeyPress="return validador(event);" 
								onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" tabindex = "1"  style="text-align:right" />
								<label>%</label>
							</td>
							<td>
								<input type="hidden" id="referencia${status.count}" name="lreferencia" size="4" value="${status.count}" />
							</td>				
						</tr>
					</c:forEach>
				</c:when>
				<c:when test="${tipoLista == '5'}">
					<tr>
						<td class="label" align="left">
					   	<label for="consecutivo">No.</label> 
						</td>
						<td class="label" align="left">
					   		<label for="descripcion">Descripci&oacute;n</label> 
						</td>	
						<td class="label" align="left">
					   		<label for="porcentaje">Valor</label> 
						</td>	  		
					</tr>					
					<c:forEach items="${listaResultado}" var="riesgo" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="text" id="consecutivoID${status.count}" name="consecutivoID" size="4" value="${status.count}" readOnly="true" />
							</td>
							<c:if test="${riesgo.dinamico == 'N'}">
							<td>
								<input type="text" id="descripcion${status.count}" name="ldescripcion" size="40" value="${riesgo.descripcion}" readOnly="true"   />
							</td>
							</c:if>	
							<td>
								<input type="text" id="porcentaje${status.count}" name="lporcentaje" size="7" value="${riesgo.porcentaje}"  onkeyPress="return validador(event);" 
								onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" tabindex = "1" style="text-align:right"/>
								<label>%</label>
							</td>
							<td>
								<input type="hidden" id="referencia${status.count}" name="lreferencia" size="4" value="${status.count}" />
							</td>				
						</tr>
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>	

