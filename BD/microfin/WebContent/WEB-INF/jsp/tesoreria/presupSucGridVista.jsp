	<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="rolUsuario" value="${listaResultado[0]}" /> 
<c:set var="rolTesoreria" value="${listaResultado[1]}" /> 
<c:set var="rolTesoreriaAdmin" value="${listaResultado[2]}" /> 	
<c:set var="listaResultado" value="${listaResultado[3]}"/>

<div id="tableCon">
	<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%"> 
		<tr align="center">
			<td class="label" align="center"> 
				<label for="lblNumero"></label> 
			</td>
     		<td class="label" align="center"> 
         		<label for="lblConcepto">Concepto</label> 
     		</td>  
			<td class="label" align="center"> 
				<label for="lbldescripcion">Descripci&oacute;n</label> 
	  		</td>
	  		<td class="label" align="center"> 
         		<label for="lblEstatus">Estatus</label> 
     		</td> 
			<td class="label" align="center"> 
         		<label for="lblMonto">Monto</label> 
     		</td>    
     		 <td class="label" align="center"> 
         		<label for="lblObservaciones">Observaciones</label> 
     		</td> 
		</tr>
		<c:forEach items="${listaResultado}" var="preSuc" varStatus="status">
		<tr id="renglon${status.count}" name="renglon">
			<td class="label" align="center"> 
				<input id="consecutivoID${status.count}" style="border: none;"  name="consecutivoID" size="3"  value="${status.count}" autocomplete="off" readOnly="true"/> 
                <input type="hidden" id="folioID${status.count}" name="folioID" value="${preSuc.folioID}" />       							  	
			</td>
			<td class="label" align="center"> 
				<input id="concept${status.count}" name="concept" size="50" value="concepto" readOnly="true"/> 									
				<input type="hidden" id="concepto${status.count}"  name="concepto" size="13"  value="${preSuc.gridConcepto}" readOnly="true"/>
			</td> 
			<td class="label" align="center">
				<input id="descripcion${status.count}" name="descripcion" size="50"  value="${preSuc.gridDescripcion}"  onkeyup="aMays(event, this)" onblur="aMays(event, this)" readOnly="true"/>
			</td>
			<c:choose>	
				<c:when test="${rolUsuario==rolTesoreria || rolUsuario==rolTesoreriaAdmin }">	<!--  -->
					<c:if test="${preSuc.gridEstatus== 'A' && preSuc.gridMonto!=preSuc.montoDispon}">
						<td class="label" align="center">   
							<input id="estatusDes${status.count}" name="estatusDes" value="AUTORIZADO" size="13" align="right" readOnly="true"/> 
				         	<input type="hidden" id="estatus${status.count}" name="estatus" value="${preSuc.gridEstatus}" />
			     		</td>	
		     		</c:if>
					<c:if test="${preSuc.gridEstatus== 'A' && preSuc.gridMonto==preSuc.montoDispon}">
					  	<td class="label" align="center">   
			             	<select  id="estatus${status.count}" name="estatus" path="estatus"  onchange="consultaExistenMovsAutorizados('${status.count}');  " >
				           		<option value="S">SOLICITADO</option>
			 	              	<option selected="true" value="A">AUTORIZADO</option>
			 	          	  	<option value="C">CANCELADO</option>
				         	</select>
				         </td>
					</c:if>
		     		<c:if test="${preSuc.gridEstatus== 'S' }">
				  		<td class="label" align="center">   
		            		 <select  id="estatus${status.count}" name="estatus" path="estatus" onchange="consultaExistenMovsAutorizados('${status.count}');"  >
			           			<option value="S">SOLICITADO</option>
		 	             		<option value="A">AUTORIZADO</option>
		 	          	  		<option value="C">CANCELADO</option>
			         		</select>
						</td>	
					</c:if>
				    <c:if test="${preSuc.gridEstatus== 'C' && preSuc.gridMonto!=preSuc.montoDispon}">
						<td class="label" align="center">   
				        	<input id="estatusDes${status.count}" name="estatusDes" value="Cancelado" size="13" align="right" readOnly="true"/>
				         	<input type="hidden" id="estatus${status.count}" name="estatus" value="${preSuc.gridEstatus}" /> 
				     	</td>
				     </c:if>
				     <c:if test="${preSuc.gridEstatus== 'C' && preSuc.gridMonto==preSuc.montoDispon}">
 						<td class="label" align="center">   
				        	<select  id="estatus${status.count}" name="estatus" path="estatus"  onchange="consultaExistenMovsAutorizados('${status.count}');" >
					        	<option value="S">SOLICITADO</option>
				 	            <option value="A">AUTORIZADO</option>
				 	          	<option selected="true"  value="C">CANCELADO</option>
					      	</select>
					   	</td>		
					</c:if>
				</c:when>							
                <c:when test="${rolUsuario!=rolTesoreria}"> <!--  -->
					<c:if test="${preSuc.gridEstatus== 'A'}">
						<td class="label" align="center">   
				         	<input id="estatusDes${status.count}" name="estatusDes" value="Autorizado" size="13" align="right" readOnly="true"/> 
				         	<input type="hidden" id="estatus${status.count}" name="estatus" value="${preSuc.gridEstatus}" />
				        </td>	
				     </c:if>
				     <c:if test="${preSuc.gridEstatus== 'S'}">
						<td class="label" align="center">   
				        	<input id="estatusDes${status.count}" name="estatusDes" value="Solicitado" size="13" align="right" readOnly="true"/>
				         	<input type="hidden" id="estatus${status.count}" name="estatus" value="${preSuc.gridEstatus}" /> 
				     	</td>	
				     </c:if>
				     <c:if test="${preSuc.gridEstatus== 'C'}">
						<td class="label" align="center">   
				        	<input id="estatusDes${status.count}" name="estatusDes" value="Cancelado" size="13" align="right" readOnly="true"/>
				         	<input type="hidden" id="estatus${status.count}" name="estatus" value="${preSuc.gridEstatus}" /> 
				     	</td>
				     </c:if>
                </c:when>
			</c:choose> 
			<c:choose>	
				<c:when test="${(rolUsuario==rolTesoreria || rolUsuario==rolTesoreriaAdmin) && preSuc.gridEstatus== 'S'}"><!--  -->	
					<td class="label" align="center"> 							  	
						<input id="monto${status.count}" name="monto" size="10" esMoneda="true" value="${preSuc.gridMonto}" onkeyPress="return Validador(event);" onBlur="consultaExistenMovsAutorizados('${status.count}');"  /> 
					</td>
					<td class="label" align="center">
						<input id="observaciones${status.count}" name="lobservaciones" size="50"  value="${preSuc.observaciones}"  onkeyup="aMays(event, this)" onblur="aMays(event, this)" />							  	   
					</td>
				</c:when>
				<c:when test="${ (rolUsuario==rolTesoreria || rolUsuario==rolTesoreriaAdmin) && preSuc.gridEstatus!= 'S'}">	<!--  -->
					<td class="label" align="center"> 							  	
						<input id="monto${status.count}" name="monto" size="10" esMoneda="true" value="${preSuc.gridMonto}"   readOnly="true"   /> 
					</td>
					<td class="label" align="center">
						<input id="observaciones${status.count}" name="lobservaciones" size="50"  value="${preSuc.observaciones}"  onkeyup="aMays(event, this)" onblur="aMays(event, this)" readOnly="true" />							  	   
					</td>
				</c:when>				
				<c:when test="${rolUsuario!=rolTesoreria && rolUsuario!=rolTesoreriaAdmin}">	<!--  -->
					<td class="label" align="center"> 							  	
						<input id="monto${status.count}" name="monto" size="10" esMoneda="true" value="${preSuc.gridMonto}" onBlur="validMonto('${status.count}')" onkeyPress="return Validador(event);" readOnly="true" /> 
					</td>
					<td class="label" align="center">
						<input id="observaciones${status.count}" name="lobservaciones" size="50"  value="${preSuc.observaciones}"  onkeyup="aMays(event, this)" onblur="aMays(event, this)" readOnly="true" />							  	   
					</td>
				</c:when>
			</c:choose>					
			<td align="center">
				<c:if test="${preSuc.gridEstatus== 'S'}">
					<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaDetalle(this)" />		
				</c:if>
				<c:if test="${preSuc.gridEstatus!= 'S'}">
                	<input type="hidden" name="elimina" id="${status.count}" class="btnElimina" />							  	
                </c:if>                    							  	
			</td>
		</tr>
		<c:set var="cont" value="${status.count}"/>
   	</c:forEach>
</table> 
<input type="hidden" value="${cont}" name="numeroDetalle" id="numeroDetalle" />
     
</div>	