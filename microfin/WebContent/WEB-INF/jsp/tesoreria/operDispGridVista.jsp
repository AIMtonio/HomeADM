<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>


<c:set var="listaResultado" value="${listaResultado[0]}"/>

<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%"> 
	 <tr align="center">
		   <td class="label"> 
		   		<label for="lblNumero">N&uacute;mero</label> 
			</td>
	    		<td class="label"> 
	        		<label for="lblCuenta">Cuenta Cargo</label> 
	    		</td>  
			<td class="label"> 
				<label for="lblClienteID">Nombre1 <s:message code="safilocale.cliente"/></label> 
	  		</td>
	  		<td class="label"> 
	        		<label for="lblNombreCte">Deeescripci&uacute;n</label> 
	    		</td> 
			<td class="label"> 
	        		<label for="lblReferencia">Referencia</label> 
	    		</td>    
	    		<td class="label"> 
	        		<label for="lblTipoMov">Forma Pago</label> 
	    		</td>  
	    		<td class="label"> 
	        		<label for="lblMonto">Monto</label> 
	    		</td> 
	    		<td class="label"> 
	        		<label for="lblClabe">Cuenta CLABE <br> Número de Cheque</label> 
	    		</td> 
	    		<td class="label"> 
	        		<label for="lblNombreBen">Nombre del<br>Beneficiario</label> 
	    		</td> 
		    	
	    		<td class="label"> 
	        		<label for="lblRFC">RFC</label> 
	    		</td>     	
	    		
	    		<td class="label" nowrap="nowrap">
	    			<label for="lblVacio">Eliminar/Agregar</label>
	    		</td> 
		</tr>
	
	<c:forEach items="${listaResultado}" var="movsInter" varStatus="status">
	<tr id="renglon${status.count}" name="renglon">
		<td> 
			<input id="consecutivoID${status.count}" name="consecutivoID" size="3"  value="${status.count}"  autocomplete="off" /> 
			<input type="hidden" id="tipoMov${status.count}" name="tipoMov"  value="${movsInter.gridTipoMov}" />   
	        <input type="hidden" id="claveDispMov${status.count}" name="claveDispMov" value="${movsInter.claveDispersion}" />       							  	
	  	</td>
		<td> 
			<input id="cuentaAhoID${status.count}"  name="cuentaAhoID" size="13"  value="${movsInter.gridCuentaAhoID}" 
	                    autocomplete="off" onKeyUp="obtenerCuenta('cuentaAhoID${status.count}');" onblur="maestroCuentasDescripcion('cuentaAhoID${status.count}','nombreCte${status.count}','clienteID${status.count}', 'saldo${status.count}');"									
			/> 
	                    <input type="hidden" id="saldo${status.count}" name="saldo" readonly="true" />							  	
	  	</td> 
	  	<td>
	  	   <input type="text" id="nombreCte${status.count}" name="nombreCte" value="" autocomplete="off" disabled="true"/>
	  	   <input type="hidden" id="clienteID${status.count}" name="clienteID" readonly="true"/>
	  	</td>
		<td> 
			<input id="descripcion${status.count}"  name="descripcion" size="10"  value="${movsInter.gridDescripcion}" /> 
	  	</td> 
	  	<td> 
			<input id="referencia${status.count}" name="referencia" size="10" value="${movsInter.gridReferencia}" /> 
	  	</td> 
	 	
	  	<td>
	  	<c:choose>
		  	  <c:when test="${movsInter.gridFormaPago == '1'}">
	  			<select id="formaPago${status.count}" name="formaPago" onchange="validaTipoMov('formaPago${status.count}', 'nombreBenefi${status.count}','fechaEnvio${status.count}','tipoMov${status.count}');" >
					<option selected="true"  value="1">SPEI</option>
					<option value="2">CHEQUE</option>
				</select>
	  		 </c:when>
	  		 
			 <c:when test="${movsInter.gridFormaPago == '2'}">
	  			<select id="formaPago${status.count}" name="formaPago" onchange="validaTipoMov('formaPago${status.count}', 'nombreBenefi${status.count}','fechaEnvio${status.count}','tipoMov${status.count}');" >
					<option value="1">SPEI</option>
					<option selected="true" value="2">CHEQUE</option>
				</select>
	  		 </c:when>	
	    </c:choose>		 	  		 
	  	</td>
	  	
	  	 
	   <td> 
			<input id="monto${status.count}" name="monto" size="10" value="${movsInter.gridMonto}"  /> 
	  	</td>
			   <td> 
			<input id="cuentaClabe${status.count}" name="cuentaClabe" size="19" maxlength="18" value="${movsInter.gridCuentaClabe}"  /> 
	  	</td>
	  	<td>
	        <input type="text" id="nombreBenefi${status.count}" name="nombreBenefi" value="${movsInter.gridNombreBenefi}"  readOnly="true" /> 
	  	</td>		
			                                  
					   <td> 
			<input id="rfc${status.count}" name="rfc" size="12" value="${movsInter.gridRFC}" /> 
	  	</td>
			   <td align="center"> 
	                  <input type="checkbox" id="estatus${status.count}" name="estatus${status.count}" CHECKED onClick="cambiaStatus('${status.count}')" /> 
	                  <input type="hidden" id="estatusHidden${status.count}" name="estatus" value="P" />							  
	  	</td>
	  	<td align="center">
	                 <input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaDetalle(this)"/>							  	
	                 <input type="button" name="agrega" id="agrega${status.count}" class="btnAgrega" onclick="agregaNuevoDetalle()"/>							  	
	  	</td>
	</tr>
	<c:set var="cont" value="${status.count}"/>
	
	</c:forEach>						
</table> 
     <input type="hidden" value="${cont}" name="numeroDetalle" id="numeroDetalle" />

  

