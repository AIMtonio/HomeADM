<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>

	
  
</head>
<body>

<br></br>

<c:set var="listaResultado"  value="${listaResultado}"/>

	   
		<legend></legend>
		<input type="button" id="agregaEsquema" value="Agregar" class="botonGral" tabIndex="2" onClick="agregaNuevoDetalle()"/>			
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> <label for="lblgarantia">Tipo Dispersi&oacute;n: </label> </td> 
		     			<td class="label"> <label for="lblgarantia">Beneficiario: </label> 	</td> 
		     			<td class="label"> <label for="lblgarantia">Cuenta: </label> </td> 		     		
				   		<td class="label"> <label for="lblgarantia">Monto: </label> </td> 		  
				  		
					</tr>
					
					 	<c:set var="total" value="0"/>			
						<c:forEach items="${listaResultado}" var="instruccionDispercion" varStatus="status">
							<c:set var="modificarLineas"  value="${instruccionDispercion.permiteModificar}"/>
							<tr id="renglon${status.count}" name="renglon">
								<td>
									<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID"  size="6" 
											value="${status.count}" />		
															
															
									<select id="dispersionID${status.count}" name="dispersionID" path="dispersionID" tabindex="${status.count}6" type="text" onchange="ValidaTipoDispercion(this)" ${modificarLineas != '1' ? 'readOnly="true" disabled ' : ''}>
									<option value="" ${instruccionDispercion.tipoDispersion ==   '' 			? 'selected' : ''}>SELECCIONAR</option>
									<option value="N" ${instruccionDispercion.tipoDispersion ==  'N'        ? 'selected' : ''}>NO APLICA</option>
									<option value="S" ${instruccionDispercion.tipoDispersion ==  'S' 		? 'selected' : ''}>SPEI</option>
									<option value="C" ${instruccionDispercion.tipoDispersion ==  'C' 		? 'selected' : ''}>CHEQUE</option>
									<option value="O" ${instruccionDispercion.tipoDispersion ==  'O' 		? 'selected' : ''}>ORDEN DE PAGO</option>
									<option value="E" ${instruccionDispercion.tipoDispersion ==  'E' 		? 'selected' : ''}>EFECTIVO</option>
									<option value="T" ${instruccionDispercion.tipoDispersion ==  'T' 		? 'selected' : ''}>TRANSFERENCIA SANTANDER</option></select>
	 									

	 							</td> 
	 							<td>
									<input  type="text" id="beneficiarioID${status.count}" name="beneficiarioID" cols="50" tabindex="${status.count}7" maxlength="250"
											value="${instruccionDispercion.beneficiario}"   ${modificarLineas != '1'   ? 'readOnly="true" disabled ' : ''} 
											onblur="upperCaseBeneficiario(this)"
											${instruccionDispercion.tipoDispersion == 'S'   ? 'class="validaBeneficiario beneficiarioclass"' : ''} ${instruccionDispercion.tipoDispersion == 'T'   ? 'class="validaBeneficiario"' : ''} 
											/> 
								</td> 
							  	<td> 
								
									<input type="text" id="cuentaID${status.count}" name="cuentaID" cols="50" tabindex="${status.count}8" maxlength="20"
											value="${instruccionDispercion.cuenta}"  ${modificarLineas != '1' ? 'readOnly="true" disabled ' : ''}   
											${instruccionDispercion.tipoDispersion == 'S'   ? 'readOnly="true" disabled ' : ''} ${instruccionDispercion.tipoDispersion == 'T'   ? 'readOnly="true" disabled ' : ''} 
											style='text-align:right;'/>  
							  	</td> 
							  	<td> 
							  		<input type="text" id="montoAsignado${status.count}" name="lmontoAsignado"  cols="50" tabindex="${status.count}9"
											value="${instruccionDispercion.montoDispersion}"  ${modificarLineas != '1' ? 'readOnly="true" disabled ' : ''} esMoneda="true" style='text-align:right;' onblur="funcionIsNumeric(this.id);" />
									<c:set var="total" value="${total + instruccionDispercion.montoDispersion}" /> 	
									<input type="hidden" id="permiteModificar${status.count}" name="permiteModificar" size="15" 
											value="${instruccionDispercion.permiteModificar}"  ${modificarLineas != '1' ? 'readOnly="true" disabled ' : ''}  style='text-align:right;' />			  
								</td> 
							  	<td align="center"> 
							  		<c:if test="${modificarLineas == '1'}">
								  		<input type="button" name="elimina"   tabindex="${status.count}9+1" id="${status.count}"  value=""  class="btnElimina" onclick="eliminarInstruccionDispersion(this)" /><input type="button" name="agregaE" tabindex="${status.count}9+2" id="agregaE${status.count}" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"  />
							  		</c:if>
							  	</td> 					
							</tr>
							
						</c:forEach>
						
				</tbody>
			</table>
			<table  border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>			
						<td style="width:29%;"></td>
						<td style="width:22%;"></td>
						<td style="width:22%;" align="right"> <label for="lblgarantia">Total: </label> </td>
						<td><input type="text" id="totalAsignado" name="totalAsignado" esMoneda="true" readOnly="true"  style="text-align:right;" value="${total}"  path="totalAsignado" /></td>
									
					</tr>
					</tbody>
					<tr align="right">
						<td class="label" colspan="5"> 
					   	<br></br>
				     	</td>
					</tr>
			</table>
			 	 <input type="hidden" value="0" name="numeroEsquema" id="numeroEsquema" />
			  	<input type="hidden" value="0" name="solicitudID" id="solicitudID" />	
			  	<input type="hidden" value="${total}" name="totalGrabado" id="totalGrabado" />		
			 <input type="hidden" id="datosGridInstruccion" name="datosGridInstruccion" size="100" />
			 <input type="hidden" id="datosGridBajaInstruccion" name="datosGridBajaInstruccion" size="100" />
		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>					
					<td align="right">
						<input type="submit" id="autorizarInstruccion" name="autorizarInstruccion" class="submit" value="Autorizar" tabindex="1000001"/>
						<input type="submit" id="grabarInstruccion" name="grabarInstruccion" class="submit" value="Guardar" tabindex="100000"/>	
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0"/>		
					</td>			
				</tr>						
		 	</table>	
			
			
		
	


</body>
</html>