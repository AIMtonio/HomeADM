<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="rolUsuario" value="${listaResultado[0]}" />  
<c:set var="rolTesoreria" value="${listaResultado[1]}" /> 
<c:set var="rolTesoreriaAdmin" value="${listaResultado[2]}" /> 
<c:set var="listaResultado" value="${listaResultado[3]}"/>

<tr>
	<td></td>
	 <td><label>C.Costos</label></td>
    <td><label>No. Factura</label></td>
    <td colspan = "2"><label>Tipo Gasto</label></td>
	<td colspan = "2"><label>Proveedor</label></td>
	<td><label>Concepto/Observaciones</label></td>	
    <td><label>Monto<br>Disponible</label></td>
    <td><label>Monto<br>Solicitado</label></td>
    <td><label>Monto Fuera<br>de Presupuesto</label></td>
    <td><label>Monto<br>Autorizado</label></td>
    <td><label>Tipo Desembolso</label></td>
    <td><label>Estatus</label></td>
</tr>
						
<c:forEach items="${listaResultado}" var="preSuc" varStatus="status">
	<tr id="renglon${status.count}" name="renglon">
		<td>
	    	<input type="text" id="numero${status.count}"	name="numero" path="numero" size="2" autocomplete="off" value="${status.count}" tabindex="1" disabled="true" />
   	     	<input type="hidden" id="detReqGasID${status.count}"	name="ldetReqGasID" path="ldetReqGasID"  value="${preSuc.detReqGasID}"  />
   	  	</td>
   	  	<td> 
   	  		<input type="text" name="lcentroCostoID"	id="centroCostoID${status.count}" path="centroCostosID" size="8" value="${preSuc.centroCostoID}"  tabindex="1" readOnly="true" />
	 	</td>
	  	<td> 
   	  		<input type="text" name="lnoFactura"	id="noFactura${status.count}" path="noFactura" size="4" value="${preSuc.noFactura}"  tabindex="1" readOnly="true" />
	 	</td>
   	   	<td> 
   	   		<input type="text" name="ltipoGastoID"	id="tipoGastoID${status.count}" path="tipoGastoID" size="3" value="${preSuc.tipoGastoID}"  tabindex="1" readOnly="true" />
   	   	</td>
		<td> 
        	<input type="text" name="descripcionTG" id="descripcionTG${status.count}" path="descripcionTG" size="25"	autocomplete="off" tabindex="1" disabled="true"/>						  
	 	</td>
		<td> 
   	  		<input type="text" name="lproveedor"	id="proveedorID${status.count}" path="proveedorID" size="3" value="${preSuc.proveedorID}"  tabindex="1" readOnly="true" />
   	  	</td>
		<td> 
   	  		<input type="text" name="descProveedor"	id="descProveedor${status.count}" size="25"  disabled="true"/>
	 	</td>
     	<td> 
     		<textarea rows="2" cols="20" name="lobservaciones" id="observaciones${status.count}" path="observaciones" size="30" maxlength= "50"	onBlur=" ponerMayusculas(this)" autocomplete="off"  readOnly="true" >${preSuc.observaciones}</textarea>
     	</td>
	  	<td> 
   			<input type="text" name="lpartidaPre" id="partidaPre${status.count}" style="text-align:right;" esMoneda="true" path="partidaPre"  value="${preSuc.partPresupuesto}"  size="13"	autocomplete="off"  readOnly="true"  onkeyPress="return Validador(event);" />
			<input type="hidden" name="lpartidaPreID" id="partidaPreID${status.count}" value="${preSuc.partidaPreID}" size="13"	 />		
        	<input type="hidden" name="totalDisponible"	id="totalDisponible${status.count}" esMoneda="true" path="totalDisponible" value="${preSuc.partPresupuesto + preSuc.montoAutorizado}" />	
	    	<input type="hidden" name="lclaveDispMov" id="claveDispMov${status.count}" path="claveDispMov" value="${preSuc.claveDispMov}" size="13"	 />	
		</td>
		<td>
			<c:if test="${preSuc.estatus == 'P'}">
				<input type="text" name="lmontoPre"	id="montoPre${status.count}" style="text-align:right;" esMoneda="true" path="montoPre"  value="${preSuc.montPresupuest}"  size="13"autocomplete="off" readOnly="true"  onkeyPress="return Validador(event);" />
	     	</c:if>
    		<c:if test="${preSuc.estatus != 'P'}">
				<input type="text" name="lmontoPre"	id="montoPre${status.count}" style="text-align:right;" esMoneda="true" path="montoPre"  value="${preSuc.montPresupuest}"  size="13"autocomplete="off" readOnly="true" />
     		</c:if>
		</td> 
		<td>
			<input type="text" name="lnoPresupuestado"	id="noPresupuestado${status.count}" style="text-align:right;" esMoneda="true"  value="${preSuc.noPresupuestado}"  path="noPresupuestado" size="13"	autocomplete="off" readOnly="true"  />
		</td>
		<td>
			<c:choose>	
				<c:when test="${rolUsuario!=rolTesoreria && rolUsuario!=rolTesoreriaAdmin}"> <!--  -->	
				
	            	<input type="text" name="lmonAutorizado"id="monAutorizado${status.count}" style="text-align:right;" esMoneda="true" value="${preSuc.montoAutorizado}" path="monAutorizado" size="13"	autocomplete="off" readOnly="true"  />
               	</c:when>
               	<c:when test="${rolUsuario==rolTesoreria}"><!--  -->	
                	<c:if test="${preSuc.estatus=='P' && preSuc.noPresupuestado <= 0.00}">
		           		<input type="text" name="lmonAutorizado" id="monAutorizado${status.count}" style="text-align:right;" esMoneda="true" value="${preSuc.montoAutorizado}" path="monAutorizado" size="13"	autocomplete="off"  onkeyPress="return Validador(event);" onBlur="editarAutorizado('${status.count}')"  />
               		</c:if>
               		<c:if test="${preSuc.estatus=='P' && preSuc.noPresupuestado > 0.00}">
                		<input type="text" name="lmonAutorizado" id="monAutorizado${status.count}" style="text-align:right;" esMoneda="true" value="${preSuc.montoAutorizado}" path="monAutorizado" size="13"	autocomplete="off" readOnly="true"  />
               		</c:if>
                 	<c:if test="${preSuc.estatus!='P'}">
                 		<input type="text" name="lmonAutorizado" id="monAutorizado${status.count}" style="text-align:right;" esMoneda="true" value="${preSuc.montoAutorizado}" path="monAutorizado" size="13"	autocomplete="off" readOnly="true"   />
                 	</c:if>
              	</c:when>
	           	<c:when test="${rolUsuario==rolTesoreriaAdmin}"><!--  -->	
                	<c:if test="${preSuc.estatus=='P'}">
		           		<input type="text" name="lmonAutorizado" id="monAutorizado${status.count}" style="text-align:right;" esMoneda="true" value="${preSuc.montoAutorizado}" path="monAutorizado" size="13" autocomplete="off"  onkeyPress="return Validador(event);" onBlur="editarAutorizado('${status.count}')"/>
               		</c:if>
                 	<c:if test="${preSuc.estatus!='P'}">
                 		<input type="text" name="lmonAutorizado"id="monAutorizado${status.count}" style="text-align:right;" esMoneda="true" value="${preSuc.montoAutorizado}" path="monAutorizado" size="13"	autocomplete="off" readOnly="true"  />
                 	</c:if>
               </c:when>
      		</c:choose> 
		</td>
		<td>
  			<c:if test="${preSuc.tipoDeposito =='C'}">
				<select  id="tipoDeposito${status.count}"   name="ltipoDeposito" path="tipoDeposito" onchange="validaTipoDesembolso('${status.count}')">
					<option value="C" selected="selected">Cheque</option> 	 
		 	       	<option value="S">SPEI</option>
		 	       	<option value="B">Banca Electrónica</option>
		 	       	<option value="T">Tarjeta Empresarial</option>
		       	</select>
	       	
    		</c:if> 
			<c:if test="${preSuc.tipoDeposito=='S'}">
				<select  id="tipoDeposito${status.count}"   name="ltipoDeposito" path="tipoDeposito" onchange="validaTipoDesembolso('${status.count}')">
					<option value="C" >Cheque</option> 	 
		 	       	<option value="S" selected="selected">SPEI</option>
		 	       	<option value="B">Banca Electrónica</option>
		 	       	<option value="T">Tarjeta Empresarial</option>
		       	</select>
   			</c:if> 
			<c:if test="${preSuc.tipoDeposito=='B'}">
				<select  id="tipoDeposito${status.count}"   name="ltipoDeposito" path="tipoDeposito" onchange="validaTipoDesembolso('${status.count}')">
					<option value="C" >Cheque</option> 	 
		 	       	<option value="S" >SPEI</option>
		 	       	<option value="B" selected="selected">Banca Electrónica</option>
		 	       	<option value="T">Tarjeta Empresarial</option>
		       	</select>   			
		    </c:if> 
			<c:if test="${preSuc.tipoDeposito=='T'}">
				<select  id="tipoDeposito${status.count}"   name="ltipoDeposito" path="tipoDeposito" onchange="validaTipoDesembolso('${status.count}')">
					<option value="C" >Cheque</option> 	 
		 	       	<option value="S" >SPEI</option>
		 	       	<option value="B" >Banca Electrónica</option>
		 	       	<option value="T" selected="selected">Tarjeta Empresarial</option>
		       	</select>
   			</c:if> 
           
   		</td>
		<td>
 			<c:choose>	
				<c:when test="${rolUsuario!=rolTesoreria && rolUsuario!=rolTesoreriaAdmin}"><!--  -->	
 					<input type="hidden" name="lstatus" id="status${status.count}" path="status" value="${preSuc.estatus}"  size="11"	autocomplete="off" readOnly="true"  />
 					<c:if test="${preSuc.estatus =='A'}">
 						<input type="text" name="status" id="statusVista${status.count}" path="status" value="Aprobado" size="11"	autocomplete="off" readOnly="true"  />
     				</c:if> 
					<c:if test="${preSuc.estatus=='P'}">
 						<input type="text" name="status" id="statusVista${status.count}" path="status" value="Pendiente" size="11"	autocomplete="off" readOnly="true"  />
     				</c:if> 
					<c:if test="${preSuc.estatus=='C'}">
 						<input type="text" name="status" id="statusVista${status.count}" path="status" value="Cancelado" size="11"	autocomplete="off" readOnly="true"  />
     				</c:if> 
				</c:when>
               	<c:when test="${rolUsuario==rolTesoreria}"><!--  -->	 
     				<c:if test="${preSuc.estatus =='A'}">        
						<input type="hidden" name="lstatus" id="status${status.count}" path="status" value="${preSuc.estatus}"  size="11"	autocomplete="off" readOnly="true"  />
 						<input type="text" name="status" id="statusVista${status.count}" path="status" value="Aprobado" size="11"	autocomplete="off" readOnly="true"  />                    
     				</c:if> 
     				<c:if test="${preSuc.estatus =='C'}">        
 						<input type="hidden" name="lstatus" id="status${status.count}" path="status" value="${preSuc.estatus}"  size="11"	autocomplete="off" readOnly="true"  />
   						<input type="text" name="status" id="statusVista${status.count}" path="status" value="Cancelado" size="11"	autocomplete="off" readOnly="true"  />                    
     				</c:if> 
     				<c:if test="${preSuc.estatus=='P'  && preSuc.noPresupuestado <= 0.00}">
                    	<select  id="status${status.count}"   name="lstatus" path="status" onchange="validaAprobacion('${status.count}')">
					    	<option value="P">Pendiente</option> 	 
				 	       	<option value="A">Aprobado</option>
				 	       	<option value="C">Cancelado</option>
				       	</select>
     				</c:if> 
     				<c:if test="${preSuc.estatus=='P'  && preSuc.noPresupuestado > 0.00}">
						<input type="hidden" name="lstatus" id="status${status.count}" path="status" value="${preSuc.estatus}"  size="11"	autocomplete="off" readOnly="true"  />
   						<input type="text" name="status" id="statusVista${status.count}" path="status" value="Pendiente" size="11"	autocomplete="off" readOnly="true"  />                    
 					</c:if>        
               	</c:when>
                <c:when test="${rolUsuario==rolTesoreriaAdmin}"><!--  -->	 
	     			<c:if test="${preSuc.estatus =='A'}">        
						<input type="hidden" name="lstatus" id="status${status.count}" path="status" value="${preSuc.estatus}"  size="11"	autocomplete="off" readOnly="true"  />
 						<input type="text" name="status" id="statusVista${status.count}" path="status" value="Aprobado" size="11"	autocomplete="off" readOnly="true"  />                    
     				</c:if> 
     				<c:if test="${preSuc.estatus =='C'}">        
 						<input type="hidden" name="lstatus" id="status${status.count}" path="status" value="${preSuc.estatus}"  size="11"	autocomplete="off" readOnly="true"  />
   						<input type="text" name="status" id="statusVista${status.count}" path="status" value="Cancelado" size="11"	autocomplete="off" readOnly="true"  />                    
     				</c:if> 
	     			<c:if test="${preSuc.estatus=='P'}">
                    	<select  id="status${status.count}"   name="lstatus" path="status" onchange="validaAprobacion('${status.count}')">
					    	<option value="P">Pendiente</option> 	 
				 	        <option value="A">Aprobado</option>
				 	        <option value="C">Cancelado</option>
				      	</select>
     				</c:if> 
      			</c:when>  
   			</c:choose>
   		</td> 
   	</tr>   		
	<c:set var="cont" value="${status.count}"/>
</c:forEach>
<input type="hidden" value="${cont}" name="numeroGrids" id="numeroGrids" />

						 
