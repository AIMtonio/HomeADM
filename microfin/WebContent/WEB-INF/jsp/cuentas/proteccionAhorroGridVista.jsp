<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<br/>

<!--<c:set var="listaResultado"  value="${listaResultado}"/>-->

<c:set var="tipoLista"  	value="${listaResultado[0]}"/>
<c:set var="listaResultado" 	value="${listaResultado[1]}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Cuentas</legend>			
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="lblTipoDocumento">Número de Cuenta</label> 
						</td>
						<td class="label"> 
					   	<label for="lblDocumento">Tipo</label> 
						</td>
				  		<td class="label"> 
							<label for="lblComentarios">Saldo</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblComentarios">Saldo Protección</label> 
				  		</td>
				  			
				  			
					</tr>					
					<c:forEach items="${listaResultado}" var="proteccionAhorro" varStatus="estado">
						<tr id="renglons${estado.count}" name="renglons">
							<td>
								<input type="hidden" id="consecutivo${estado.count}" name="consecutivo" size="6" value="${estado.count}" />														
								<input type="text" id="cuentaAhorro${estado.count}" name="cuentaAhorro" size="15" 
										value="${proteccionAhorro.cuentaAhoID}" readOnly="true"  disabled="disabled"/>   								
						  	</td> 
						 
						  	<td> 
								<input type="text" id="descripcionCta${estado.count}" name="descripcionCta" size="30" 
										value="${proteccionAhorro.descripcionTipoCta}" readOnly="true"  disabled="disabled" />														 							
						  	</td> 	
						  	<td> 
								<input type="text" id="saldoCta${estado.count}" name="saldoCta" size="15" value="${proteccionAhorro.saldo}" 
									readOnly="true"  disabled="disabled" style="text-align: right" esMoneda="true"/>
						  	</td> 	
						  	 <td> 								
						  	 		<c:if test = "${tipoLista == 1 }">																			  	  	  	                					
										<input type="text" id="saldoProteccion${estado.count}" name="saldoProteccion" size="15" 
											style="text-align: right" esMoneda="true" value="${proteccionAhorro.monAplicaCuenta}" 
												onblur="calculaProteccionCuenta(this.id)"  />
									</c:if>	
									<c:if test = "${tipoLista ==  2 }">																					  	  	  	                					
										<input type="text" id="saldoProteccion${estado.count}" name="saldoProteccion" size="15" 
											style="text-align: right" esMoneda="true" value="0.00" onblur="calculaProteccionCuenta(this.id)"
												onfocus="validaFocoInputMoneda(this.id);"  />
									</c:if>																																																																			
							</td> 							  				
						</tr>
																							
					</c:forEach>
					<tr>
						<td class="label"> 
						</td>
						<td class="label"> 
							<label for="lbltotal">Total</label>
				  		</td>
				  		<td class="label"> 
				  		
					  		 <input type="text" id="totalCuentas" name="totalCuentas" size="15" readOnly="true"  disabled="disabled" 
					  		 	tyle="text-align: right" esMoneda="true" style="text-align: right"/>
				  		</td>
				  		<td class="label"> 							
							 <input type="text" id="monAplicaCuenta" name="monAplicaCuenta" size="15" readOnly="true" disabled="disabled"  
							 	tyle="text-align: right" esMoneda="true" style="text-align: right"/>
				  		</td>
				  			
				  			
					</tr>
				</tbody>
				<tr align="right">
					<td class="label" colspan="5"> 
				   	<br>
			     	</td>
				</tr>
			</table>
																				
			 <input type="hidden" value="0" name="numeroDocumento" id="numeroDocumento" />
	
	
	</fieldset>