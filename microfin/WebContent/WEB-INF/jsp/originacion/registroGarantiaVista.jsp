<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
	   <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>  
	   <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
	   <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	   <script type="text/javascript" src="dwr/interface/garantiaServicioScript.js"></script>
	   <script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
	   <script type="text/javascript" src="dwr/interface/notariaServicio.js"></script>
       <script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
	   <script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script> 
	   <script type="text/javascript" src="dwr/interface/garantesServicio.js"></script>
	   <script type="text/javascript" src="js/originacion/RegistroGarantias.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="garantiaBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">Registro de Garant&iacute;as</legend>
	<table border="0" width="100%">
		<tr> 
			<td>
				<table border="0">
					<tr> 
						<td class="label" nowrap="nowrap">
							<label for="garantiaID">Folio Garant&iacute;a:</label> </td>
						<td>
			         		<form:input type="text" autocomplete="off" id="garantiaID" name="garantiaID" path="garantiaID" size="11" tabindex="1" /> 
			     		</td>	
			     		<td class="separador"></td> 
						<td class="label"> 
			         		<label for="clienteID"><s:message code="safilocale.cliente"/>: </label> 
			     		</td> 
			     		<td  nowrap="nowrap"> 
			         		 <form:input type="text" autocomplete="off" id="clienteID" name="clienteID" path="clienteID" size="11" tabindex="2" />  
			         		 <input type = "text" id="clienteNombre" name="clienteNombre" path="clienteNombre" disabled="true" size="40" />   
			     		</td>
			     	</tr>
			     	<tr> 
			     		<td class="label"> 
			         		<label for="prospectoID">Prospecto: </label> 
			     		</td> 
			     		<td> 
			         		<form:input type="text" autocomplete="off" id="prospectoID" name="prospectoID" path="prospectoID" size="11" tabindex="3" /> 
			         		<input type="text" autocomplete="off" id="prospectoNombre" name="prospectoNombre" path="prospectoNombre" disabled="true" size="40"  />  
			         		<form:input type="hidden" value="0" id="avalID" name="avalID" path="avalID" size="40"  />   
			     		</td>
			     		<td class="separador"></td> 
			     		<td class="label"> 
			         		<label for="garanteNombre">Garante: </label> 
			     		</td> 
			     		<td> 
			         		 <input type="text" id="garanteID" name="garanteID" path="garanteID" tabindex="4" size="11" />  
			         		 <input type="text" autocomplete="off" id="garanteNombre" name="garanteNombre" path="garanteNombre" disabled="true"  onblur=" ponerMayusculas(this)" tabindex="4" size="40" maxlength="75"/>   
			     		</td>
			     	</tr> 
			    </table> 
     		</td>	
     	</tr>
     	<tr> 
			<td> 
         		<!-- Inicio de direccion del garante -->
				<div id="direccionGarante"> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
			  		<legend>Direcci&oacute;n de Garante</legend>
						<table border="0">
							<tr> 							
			     				<td class="label"> 
			         				<label for="estadoGarante">Estado: </label> 
			     				</td> 
			     				<td> 	         	 
			         		 		<input type="text" autocomplete="off" id="estadoGarante" name="estadoGarante" path="estadoGarante"   tabindex="5" size="10"  /> 
									<input type="text" autocomplete="off" id="estadoNombGarante" name="estadoNombGarante" path="estadoNombGarante" disabled="true" size="40"    />        
			     				</td>
			     		   		<td class="separador"></td> 
								<td class="label"> 
			         				<label for="municipioGarante">Municipio: </label> 
			     				</td> 
			     				<td> 	         	 
			         		 		<input type="text" autocomplete="off" id="municipioGarante" name="municipioGarante" path="municipioGarante"   tabindex="6" size="11"  /> 
									<input type="text" autocomplete="off" id="mpioNombreGarante" name="mpioNombreGarante" path="mpioNombreGarante" disabled="true" size="40"   />   
			     				</td>
			     			</tr>  	
			     			<tr>
			     				<td class="label"> 
							    	<label for="localidadIDGarante">Localidad: </label> 
							    </td> 
							    <td nowrap="nowrap"> 
							    	<input id="localidadIDGarante" name="localidadIDGarante" path="localidadIDGarante" tabindex="7" type="text" autocomplete="off" value="" size="10" > 
							    	<input type="text" autocomplete="off" id="nombrelocalidadGarante" name="nombrelocalidadGarante" size="40" disabled="true" onblur=" ponerMayusculas(this)" readonly="true">   
							    </td>
			     		   		<td class="separador"></td> 
			    				<td class="label"> 
			         				<label for="coloniaID">Colonia: </label> 
			     				</td> 
			     				<td> 
							    	<input id="coloniaID" name="coloniaID" path="coloniaID" tabindex="7" type="text" autocomplete="off" value="" size="11" > 
							    	<input type="text" autocomplete="off" id="coloniaGarante" name="coloniaGarante" path="coloniaGarante" disabled="true" onblur=" ponerMayusculas(this)" size="50" tabindex="8" maxlength="45"/>  
								</td>
			     			</tr>  
			     			<tr> 
								<td class="label"> 
			         				<label for="calleGarante">Calle: </label> 
			     				</td> 
			     				<td> 
			         	  			<input type="text" autocomplete="off" id="calleGarante" name="calleGarante" path="calleGarante"  onblur=" ponerMayusculas(this)" tabindex="9"  size="50" maxlength="70"/>   
			     				</td>
			     		   		<td class="separador"></td> 
			     				<td class="label" nowrap="nowrap"> 
			         				<label for="numIntGarante">N&uacute;mero Exterior: </label> 
			     				</td> 
			     				<td> 	         	 
			         		 		<input type="text" autocomplete="off" id="numIntGarante" name="numIntGarante" path="numIntGarante" tabindex="10" size="10" maxlength="10"  />  
			     				</td>
			     			</tr>  
						  	<tr> 
								<td class="label" nowrap="nowrap"> 
			         				<label for="numExtGarante">N&uacute;mero Interior: </label> 
			     				</td> 
			     				<td> 
			         	  			<input type="text" autocomplete="off" id="numExtGarante" name="numExtGarante" path="numExtGarante" size="10" tabindex="11"  maxlength="10"/>   
					     		</td>
				     		  	<td class="separador"></td> 
			    				<td class="label"> 
			         				<label for="codPostalGarante">C&oacute;digo Postal: </label> 
			     				</td> 
			     				<td> 
			         	  			<input type="text" autocomplete="off" id="codPostalGarante" name="codPostalGarante" path="codPostalGarante" size="10" tabindex="12" maxlength="10" />   
			     				</td>
			     			</tr>    
			     		</table>
			     	</fieldset>
				<br>
				</div> 
     		</td> 
     	</tr>
     	<tr> 
			<td> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
		   		<legend>Tipo Garant&iacute;a</legend>
					<table border="0">	
						<tr> 
							<td class="label"> 
					        	<label for="tipoGarantiaID">Tipo Garant&iacute;a: </label> 
					     	</td> 
							<td>
								<select id="tipoGarantiaID" name="tipoGarantiaID"  path="tipoGarantiaID"  tabindex="12" >
							    	<option value="">SELECCIONAR</option>   	
									<option value="2">MOBILIARIA</option> 
									<option value="3">INMOBILIARIA</option> 
									<option value="4">GUBERNAMENTAL</option> 
								</select>					
							</td>		     		
					     	<td class="separador"></td> 
							<td class="label"> 
					        	<label for="clasifGarantiaID">Clasificaci&oacute;n Garant&iacute;a: </label> 
					     	</td> 
							<td>
								<select id="clasifGarantiaID" name="clasifGarantiaID"  path="clasifGarantiaID"  tabindex="13" >
							    	<option value="">SELECCIONAR</option>   				
								</select>					
							</td>		
						</tr>	
						<tr>
							<td class="label" nowrap="nowrap"> 
					        	<label for="valorComercial">Valor Comercial: </label> 
					     	</td> 
					     	<td> 
					        	<form:input id="valorComercial" name="valorComercial" esMoneda="true" style="text-align: right;" path="valorComercial" size="14" tabindex="14"  autocomplete="off"/>  
					        </td>
					     	<td class="separador"></td> 
					     	<td class="label" nowrap="nowrap"> 
					        	<label for="numIdentificacion">N&uacute;mero de Identificaci&oacute;n:</label> 
					     	</td> 
					     	<td> 
					        	<form:input id="numIdentificacion" name="numIdentificacion" path="numIdentificacion" size="11"   tabindex="15" maxlength="45"  autocomplete="off"/>  
					        </td>	
					     </tr>	     	
					     <tr>
					     	<td class="label"> 
					        	<label for="observaciones">Observaciones: </label> 
					     	</td> 
					     	<td> 
								<textarea rows="2" cols="45" id="observaciones" name="observaciones"  onblur=" ponerMayusculas(this); limpiarCajaTexto(this.id);" path="observaciones"  tabindex="16" maxlength="1200" ></textarea>
							</td>
							<td></td>
						 	<td class="label"> 
				         		<label for="tipoDocumentoID">Tipo de Documento: </label> 
				     		</td>  
							<td>
								<select id="tipoDocumentoID" name="tipoDocumentoID"  path="tipoDocumentoID"  tabindex="17" >
							    	<option value="">SELECCIONAR</option>  
							    	<option value="12">FACTURA</option>   				
									<option value="13">TESTIMONIO NOTARIAL</option> 
									<option value="14">ACTA DE POSESIÓN</option> 
									<option value="15">RECIBO SIMPLE</option> 
									<option value="77">CONSTANCIA DE POSESI&Oacute;N</option> 
								</select>
							</td>	     	
						</tr>
					</table>
		   		</fieldset>
     		</td> 
     	</tr>
     	<tr> 
			<td> 
				<div id="contenedorParametros">	 </div> 
     		</td> 
     	</tr>
     	<tr> 
			<td> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
		   		<legend>Valuaci&oacute;n</legend>
					<table>
						<tr> 
							<td class="label" nowrap="nowrap"> 
				        		<label for="fechaValuacion">Fecha de la Valuaci&oacute;n: </label> 
				     		</td> 
				     		<td> 
				          		<form:input id="fechaValuacion" name="fechaValuacion"   path="fechaValuacion" esCalendario="true" size="11" tabindex="68" maxlength="10"  autocomplete="off"/> 
			     		  	</td>
				     		<td class="separador"></td> 
				     		<td class="label" nowrap="nowrap"> 
					        	<label for="numAvaluo">N&uacute;mero de Aval&uacute;o: </label> 
				     		</td> 
				     		<td> 
				         		<form:input id="numAvaluo" name="numAvaluo" path="numAvaluo" size="8" tabindex="69" maxlength="10"  autocomplete="off"/> 
				     		</td>
			 			</tr>  
		       			<tr> 
							<td class="label"> 
			         			<label for="nombreValuador">Nombre de Valuador:</label> 
			     			</td> 
			     			<td> 
			         			<form:input id="nombreValuador" name="nombreValuador" path="nombreValuador"  onblur=" ponerMayusculas(this)" size="62" tabindex="70" maxlength="100"  autocomplete="off"/>  
				     		</td>
							<td class="separador"></td> 
							
							<td class="label" nowrap="nowrap"> 
					        	<label for="montoAvaluo">Monto de Avaluo: </label> 
				     		</td> 
				     		<td> 
				         		<form:input id="montoAvaluo" name="montoAvaluo" path="montoAvaluo"  esMoneda="true" size="11" tabindex="71" maxlength="16"  autocomplete="off"/> 
				     		</td>
										     			
						</tr>  
						<tr> 
						
							<td class="label" nowrap="nowrap"> 
			         			<label for="verificada">Garant&iacute;a Verificada: </label> 
			     			</td> 
			     			<td> 
			         			<form:select id="verificada" name="verificada"  path="verificada"  tabindex="72">
						    		<form:option value="">SELECCIONAR</form:option>
						    		<form:option value="S">SI</form:option>   				
							 		<form:option value="N">NO</form:option> 							
								</form:select>		         		 
			     			</td>
							<td class="separador"></td> 
							<td class="label" nowrap="nowrap"> 
			         			<label for="fechaVerificacion">Fecha de Verificaci&oacute;n:</label> 
			     			</td> 
			     			<td> 
			          			<form:input id="fechaVerificacion" name="fechaVerificacion" path="fechaVerificacion" esCalendario="true" size="11" tabindex="73" maxlength="10"  autocomplete="off"/> 
			     			</td>
			     		   	
			     			
			 			</tr>     
			 			
			 			
			 			<tr>
			 				<td class="label" nowrap="nowrap"> 
			         			<label for="tipoGravemen">Estatus del Gravamen: </label> 
			     			</td> 
			     			<td> 
			       				<form:select id="tipoGravemen" name="tipoGravemen"  path="tipoGravemen"  tabindex="74">
			       					<form:option value="">SELECCIONAR</form:option>
									<form:option value="L">LIBRE</form:option>   				
								 	<form:option value="G">GRAVADO</form:option> 							
								</form:select>		         		 
				     		</td>
			 			
			 			</tr>
			 			
			 			
			 			       
		      			<tr id="trEstatusGrabado"> 
					    	<td class="label">
					    		<label for="lblgarantia">Fecha de <br> Gravamen:</label>
					    	</td> 
							<td>
								<input id="fechagravemen"   name="fechagravemen" path="fechagravemen" esCalendario="true" size="11" tabindex="75"  maxlength="10" autocomplete="off"/> 
							</td>
							<td class="separador"></td> 
							<td class="label">
								<label for="lblProspecto">Monto Gravamen: </label>
							</td> 
							<td>
								<input   id="montoGravemen" name="montoGravemen" value="0" esMoneda="true" path="montoGravemen" size="11" tabindex="76" autocomplete="off" />
							</td>
						</tr>          	
					    <tr  id="trNombreBenefi"> 
					    	<td class="label">
					    		<label for="lblgarantia">Nombre de <br> Beneficiario:</label>
					    	</td> 
							<td>
								<input id="nombBenefiGrav"   name="nombBenefiGrav" path="nombBenefiGrav"   onblur=" ponerMayusculas(this)" size="62" tabindex="77" maxlength="75" autocomplete="off" />
							</td>
						</tr>     
			 	   		<tr> 
		       		 		<td>  
								<form:input type="hidden" id="tipoInsCaptacion" value="N" name="tipoInsCaptacion"  path="tipoInsCaptacion" size="8" tabindex="78" />  
				         		<form:input type="hidden" id="montoAsignado" name="montoAsignado" value="0" esMoneda="true" path="montoAsignado" size="10" tabindex="79" />  
				         	    <form:input type="hidden" id="estatus" name="estatus" path="estatus" size="8" tabindex="80" /> 
				         		<form:input type="hidden" id="insCaptacionID" value="0" name="insCaptacionID"  path="insCaptacionID" size="8" tabindex="81" />  		
						 	</td>
			 			</tr>            
		      		</table>	
				</fieldset>
     		</td> 
     	</tr>
     	<tr> 
			<td style="text-align: right;"> 
				<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="82"  />
				<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="83"  />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
				<input type="hidden" id="varSafilocale" name="varSafilocale" value="<s:message code="safilocale.cliente"/>"/>
     		</td> 
     	</tr> 			
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>
