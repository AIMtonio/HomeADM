<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="listaResultado" value="${listaResultado[0]}"/>

<div id="tableCon">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">             
		<legend>Movimientos No Identificados </legend>	
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%"> 
			<tr align="center">
		 		<td class="label"> 
					<label for="lblNumero">Número</label> 
				</td>
				<td class="label"> 
			   		<label for="lblNumero">Número de <br> cuenta</label> 
				</td>
	     		<td class="label"> 
	         		<label for="lblCuenta">Fecha </label> 
	     		</td>  
				<td class="label"> 
					<label for="lblClienteID">Referencia de Registro</label> 
		  		</td>
		  		<td class="label"> 
	         		<label for="lblNombreCte">Descripción</label> 
	     		</td> 
				   
	     		<td class="label"> 
	         		<label for="lblTipoMov">Monto</label> 
	     		</td>  
	     		<td class="label"> 
	         		<label for="lblMonto">Pendiente <br> Aplicar</label> 
	     		</td> 
	     		<td class="label"> 
	         		<label for="lblClabe">Tipo <br>Depósito</label> 
	     		</td> 
	     		  <td class="label"> 
	         		<label for="lblClabe">Tipo <br>Moneda</label> 
	     		</td> 
	     		<td class="label"> 
	         		<label for="lblReferen">Tipo Canal</label> 
	     		</td> 
	     		<td class="label"> 
	         		<label for="lblNombreBen">Referencia por<br>Confirmar</label> 
	     		</td> 
			   	<td class="label" > 
	         		<label for="lblFfechaEnvio">Estatus</label> 
		     	</td>  	
			</tr>
			
			<c:forEach items="${listaResultado}" var="movsInter" varStatus="status">
			<tr id="renglon${status.count}" name="renglon">
				<td class="label"> 
					<label size="3" style="color:black;"> ${status.count}</label> 
                    <input type="hidden" id="folioCargaID${status.count}" name="lfolioCargaID" value="${movsInter.folioCargaID}" />       							  	
				</td>
				<td class="label" style="display:none"> 
					<input type="text" id="numeroMov${status.count}"  name="lnumeroMov" size="5"  value="${movsInter.numeroMov}" /> 
            	</td>
				<td class="label"> 
					<input  type="hidden" id="lblcuentaAhoID${status.count}" />
					<input type="hidden" id="cuentaAhoID${status.count}"  name="lcuentaAhoID" size="13"  value="" /> 
            	</td> 
				<td class="label"> 
					<label size="13"  style="color:black;" >${movsInter.fechaValor}   </label> 
					<input type="hidden" id="fechaValor${status.count}"  name="lfechaMov" size="13"  value="${movsInter.fechaValor}" /> 
              	</td> 
				<td align="center"  class="label">
					<label  style="color:black;" >${movsInter.referenciaMov}</label>
					<input type="hidden" id="referenciaMov${status.count}" name="lreferenciaMov" value="${movsInter.referenciaMov}" autocomplete="off" />
				</td>
				<td class="label"> 
					<textarea rows="1" cols="20" id="descripcionMov${status.count}"  name="ldescripcionMov" maxlength="145" style="color:black;" >${movsInter.descripcionMov}</textarea>
					<input type="hidden" id="natMovimiento${status.count}"  name="lnatMovimiento" size="10"  value="${movsInter.natMovimiento}" /> 
				</td> 
				<td align="right" class="label"> 
					<label id="etiMontoMov${status.count}" size="10" esMoneda="true" style="color:black;">${movsInter.montoMov}</label> 
					<input type="hidden" id="montoMov${status.count}" name="lmontoMov" size="10" value="${movsInter.montoMov}" /> 
				</td>       
				<td align="right" class="label"> 
					<label id="etiMontoPen${status.count}"  size="10" esMoneda="true" style="color:black;">${movsInter.montoPendApli}</label> 
					<input type="hidden" id="montoPendApli${status.count}" name="lmontoPendApli" size="10" value="${movsInter.montoPendApli}"   /> 
				</td>
			  	<td align="center" class="label"> 
  					<c:choose>
  				    	<c:when test="${movsInter.tipoDeposito == 'T'}">
  				       		<label size="10" style="color:black;">Otro tipo</label>
							<input type="hidden"id="tipoDeposito${status.count}" name="ltipoDeposito" size="10" value="T"   /> 
  				    	</c:when>
  				     	<c:when test="${movsInter.tipoDeposito == 'E'}">
							<label size="10" style="color:black;">Efectivo</label>
							<input type="hidden" id="tipoDeposito${status.count}" name="ltipoDeposito"  size="10" value="E"   /> 			  				     
  				     	</c:when>
  					</c:choose>
				</td>	
    			<td class="label">	 
                	<label  style="color:black;" >${movsInter.descrMoneda}</label> 
					<input type="hidden" id="tipoMoneda${status.count}" name="ltipoMoneda"  size="10" value="${movsInter.tipoMoneda}"   /> 			  				     
            	</td>								
				<td class="label"> 
					<c:choose>
						<c:when test="${movsInter.tipoCanal == '1'}">
       						<select id="tipoCanal${status.count}" name="ltipoCanal"  >
       							<option selected="selected" value="1">Pago Crédito</option>
 							  	<option value="2"><s:message code="safilocale.ctaAhorro"/></option>
       							<option value="3">Número <s:message code="safilocale.cliente"/></option>
       						</select> 
 						</c:when>
						<c:when test="${movsInter.tipoCanal == '2'}">
 							<select id="tipoCanal${status.count}" name="ltipoCanal"  >
       							<option value="1">Pago Credito</option>
 							  	<option selected="selected" value="2"><s:message code="safilocale.ctaAhorro"/></option>
       							<option value="3">Numero <s:message code="safilocale.cliente"/></option>
 	      					</select>
 						</c:when>
 						
 						<c:when test="${movsInter.tipoCanal == '3'}">
 							<select id="tipoCanal${status.count}" name="ltipoCanal"  >
       							<option  value="1">Pago Crédito</option>
 							  	<option  value="2"><s:message code="safilocale.ctaAhorro"/></option>
       							<option selected="selected" value="3">Número <s:message code="safilocale.cliente"/></option>
 							</select>
 						</c:when>
					</c:choose>
				</td> 
				<td class="label"> 
					<input type="text" id="rerefenConfirmar${status.count}" name="lrerefenConfirmar" size="12" value="" onChange="cambiaReferencia()" onBlur="valiaPLB('rerefenConfirmar${status.count}','${movsInter.referenciaMov}','referenciaMov${status.count}','tipoCanal${status.count}')"  maxlength="35"  /> 
				</td>
				<td class="label"> 
                	<input type="checkbox" id="estatus${status.count}" name="estatus" checked="checked" onclick="cambiaStatus('estatus${status.count}', 'estatusHidden${status.count}'), habilitaLimpiar(this.id)" /> 
					<input type="hidden" id="estatusHidden${status.count}" name="lestatus" value="C" />							  
				</td>
			</tr>
			<c:set var="cont" value="${status.count}"/>
   			</c:forEach>
		</table> 
     	<input type="hidden" value="${cont}" name="numeroDetalle" id="numeroDetalle" />
    </fieldset>
</div>
