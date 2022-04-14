<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>	     
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="js/tesoreria/ctaNostroRegistroVista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Alta de Cuenta Bancaria</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentaNostro">         
					<table border="0"  width="88%">
						<tr>
							<td class="label" nowrap> 
								<label for="lblinstitucionID">Instituci&oacute;n:</label> 
							</td>
						    <td>
						    	<table>
						    		<tr>
						    			<td nowrap>
						    				<form:input type="text" id="institucionID" name="institucionID" path="institucionID" size="11" tabindex="1"  autocomplete="off"/>		
										</td>
										<td nowrap>	
											<input type="text"  id="nombreInstitucion" name="nombreInstitucion" size="50" tabindex="2" disabled="true" readonly="true">
						    			</td>
						    		</tr>
						    	</table> 
							</td>
						</tr>
						<tr>	
							<td class="label" nowrap>
					    		<label for="lblnumCtaAhorro"></label>
					    	</td> 
							<td nowrap>
								<form:input type="hidden" id="" name="cuentaAhoID" path="cuentaAhoID" readOnly="true" size="38" tabindex="3" /> 			
							</td>
						</tr>  						 
						<tr>  
							<td class="label" nowrap> 
						    	<label for="lblNumCtaBancaria">Cuenta Bancaria:</label> 
							</td>
						    <td nowrap>
								<form:input type="text" id="numCtaInstit" name="numCtaInstit" path="numCtaInstit" size="38" tabindex="4" maxlength="18" autocomplete="off"  /> 
								<form:input type="hidden" id="estatus" name="estatus" path="estatus" size="6"   /> 		         	
				           	</td>
						</tr>
						<tr>  
							<td class="label" nowrap>
						    	<label for="lblnumCtaClabe">Cuenta Clabe:</label> 
							</td>
						    <td nowrap>
								<form:input  type="text"  id="cuentaClabe" name="cuentaClabe" path="cuentaClabe" size="38" tabindex="5" maxlength="18" autocomplete="off" /> 			
							</td>
						</tr>
	                   	<tr>  
							<td class="label" nowrap> 
						    	<label for="lblSaldo">Saldo:</label> 
							</td>
						    <td nowrap>
								<form:input type="text"  id="saldo" esMoneda="true" name="saldo" path="saldo" size="38" tabindex="6" maxlength="18" autocomplete="off"/> 			
							</td>   
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>							 		
						</tr>	
						<tr>
							<td class="label" nowrap>
							<label>Sobregirar Saldo:</label>
							</td>
							
							<td nowrap>
								<form:radiobutton id="sobregirarSaldo" name="sobregirarSaldo" path="sobregirarSaldo" value="S" tabindex="7" />
								<label for="si">Si</label>
								<form:radiobutton id="sobregirarSaldo2" name="sobregirarSaldo2" path="sobregirarSaldo" value="N" tabindex="8" />
								<label for="no">No</label>
							</td>
						</tr>
						<tr id="proteccionOrdenPago">
							<td class="label" nowrap>
							<label>Protecci&oacute;n Orden de Pago:</label>
							</td>
							
							<td nowrap>
								<form:radiobutton id="protecOrdenPago" name="protecOrdenPago" path="protecOrdenPago" value="S" tabindex="9" />
								<label for="si">Si</label>
								<form:radiobutton id="protecOrdenPago2" name="protecOrdenPago2" path="protecOrdenPago" value="N" tabindex="10" checked="true"/>
								<label for="no">No</label>
							</td>
						</tr>
						<tr>	
							<td class="label" nowrap> 
						    	<label for="lblchequera">Chequera:</label> 
							</td>
						    <td>   
						    	<table>
						    		<tr>
						    			<td nowrap>
						          			<form:select id="chequera" name="chequera" path="chequera" tabindex="11" >
						          				<form:option value="">SELECCIONAR</form:option> 
						          				<form:option value="S">Si</form:option>
					 	          				<form:option value="N">No</form:option>
						          			</form:select>
				                   		</td>
				                   		<td></td>
				                   		<td nowrap>
						          			<label for="lblnumCtaClabe">Cuenta Principal:</label> 
	                         				<input type="checkbox" id="checkPrincipal" name="checkPrincipal" tabindex="12" /> 
	 				             		 	<form:input type="hidden" id="principal" name="principal" path="principal" size="3" maxlength="1" value="N" />			
					                  	</td>
									</tr>
								</table>	     
							</td>
						</tr>
						<tr id="oculta">
							<td class="label" nowrap> 
					    		<label id="lbltipoChequera">Tipo Chequera:</label> 
							</td>
							<td nowrap>
			          			<form:select id="tipoChequera" name="tipoChequera" path="tipoChequera" tabindex="13" >
			          				<form:option value="">SELECCIONAR</form:option> 
			          				<form:option value="P">PROFORMA</form:option>
		 	          				<form:option value="E">CHEQUERA</form:option>
		 	          				<form:option value="A">AMBAS</form:option>
			          			</form:select>
			             	</td>
						</tr>
					</table>	
					<div id="divDatosChequera" style="display: none;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend >Datos Chequera Proforma</legend>						
							<table>
								<tr>
									<td class="label">
										<label for="lblfolioUtilizar">&Uacute;ltimo N&uacute;mero de Cheque que se Utiliz&oacute;: </label>
									</td>
									<td>
										<form:input type="text"  id="folioUtilizar" name="folioUtilizar" path="folioUtilizar" size="12" tabindex="14" maxlength="19" autocomplete="off"/>
									</td>						
								</tr>	
								<tr>
									<td class="label">
										<label for="lblrutaCheque">Formato de Impresi&oacute;n de Cheque: </label>
									</td>
									<td>
										<form:input type="text"  id="rutaCheque" name="rutaCheque" path="rutaCheque" size="40" tabindex="15" maxlength="100" autocomplete="off"/>
									</td>						
								</tr>					
							</table>
						</fieldset>
						<br>
					</div>
					<div id="divDatosChequeraEstandar" style="display: none;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend >Datos Chequera Est&aacute;ndar</legend>						
							<table>
								<tr>
									<td class="label">
										<label for="folioUtilizarEstan">&Uacute;ltimo N&uacute;mero de Cheque que se Utiliz&oacute;: </label>
									</td>
									<td>
										<form:input type="text"  id="folioUtilizarEstan" name="folioUtilizarEstan" path="folioUtilizarEstan" size="12" tabindex="16" maxlength="19" autocomplete="off"/>
									</td>						
								</tr>	
								<tr>
									<td class="label">
										<label for="rutaChequeEstan">Formato de Impresi&oacute;n de Cheque: </label>
									</td>
									<td>
										<form:input type="text"  id="rutaChequeEstan" name="rutaChequeEstan" path="rutaChequeEstan" size="40" tabindex="17" maxlength="100" autocomplete="off"/>
									</td>						
								</tr>					
							</table>
						</fieldset>
						<br>
					</div>
					<table  border="0" cellpadding="0" cellspacing="4"> 
	                   	<tr>
	                    	<td class="label" nowrap>
	                      		<label for="lblnombreSucursal">Sucursal:</label>
	                     	</td> 
	                     	<td nowrap>
						    	<form:input type="text"  id="sucursalInstit" name="sucursalInstit" path="sucursalInstit" size="67" tabindex="18" onBlur="ponerMayusculas(this)"
						    				maxlength="50"/> 	
	                     	</td>
	                   	</tr>
	                   	<!-- Inicio campos convenio -->
	                   	<tr>
	                    	<td class="label" nowrap>
	                      		<label for="lblnumConvenio">No. Convenio:</label>
	                     	</td> 
	                     	<td nowrap>
						    	<form:input type="text"  id="numConvenio" name="numConvenio" path="numConvenio" size="30" tabindex="19" onBlur="ponerMayusculas(this)"
						    				maxlength="30"/>
	                     	</td>
	                   	</tr>
	                   	<tr>
	                    	<td class="label" nowrap>
	                      		<label for="lblnumConvenio">Descripci&oacute;n de Convenio:</label>
	                     	</td> 
	                     	<td nowrap>
						    	<form:input type="text"  id="descConvenio" name="descConvenio" path="descConvenio" size="67" tabindex="20" onBlur="ponerMayusculas(this)"
						    				maxlength="100"/>
	                     	</td>
	                   	</tr>
	                   	<!-- Fin campos convenio -->
						<tr>
							<td class="label" nowrap> 
						    	<label for="lblcentroCostosID">Centro de Costos:</label> 
						    </td>
							<td nowrap> 
								<form:input type="text"  id="centroCostoID" name="centroCostoID" path="centroCostoID" size="11" tabindex="21" autocomplete="off" />		         	
				         		<input type="text"  id="nombreCentroCostos" name="nombreCentroCostos" size="50" tabindex="22" disabled="true" readonly="true">
						    </td> 
							<td class="separador"></td> 
						</tr> 
						<tr>
							<td class="label" nowrap> 
						    	<label for="lblcuentaCompleta">Cuenta Contable:</label> 
						    </td>
						    <td nowrap> 
				         		<form:input type="text"  id="cuentaCompletaID" name="cuentaCompletaID" path="cuentaCompletaID" size="25" tabindex="23" maxlength="25" autocomplete="off" />		         	
				         		<input type="text" id="descripcion" name="descripcion" size="80" tabindex="24" disabled="true" readonly="true">
						    </td>					    				    			     		
						</tr>
						
						<tr id="trAlgClaveRetiro">
							<td class="label" nowrap="nowrap">
								<label for="algClaveRetiro">Algoritmo de Clave de Retiro:</label> 
							</td>
							<td nowrap="nowrap">
								<form:select id="algClaveRetiro" name="algClaveRetiro" path="algClaveRetiro" tabindex="25" >
			          				<form:option value="M">MANUAL</form:option> 
		 	          				<form:option value="A">AUTOMATICO</form:option>
			          			</form:select>
							</td>
						</tr>
						<tr id="trVigClaveRetiro">
							<td class="label" nowrap="nowrap">
								<label for="vigClaveRetiro">D&iacute;as Vigencia Clave de Retiro:</label> 
							</td>
							<td nowrap="nowrap">
								<form:input type="text"  id="vigClaveRetiro" name="vigClaveRetiro" path="vigClaveRetiro" size="5" tabindex="26" maxlength="2" autocomplete="off" />
								<label > d&iacute;as</label>
							</td>
						</tr>
						 
					</table>
               		<br>
					<table border="0" cellpadding="0" cellspacing="0" width="842px" align="right">  
						<tr>
							<td align="right">
						    	<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="26"/>
								<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="27"/>
								<input type="submit" id="cancelar" name="cancelar" class="submit"  value="Cancelar" tabindex="28"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							</td>
						</tr>
					</table>
		 		</form:form> 
			</fieldset>
		</div>
		<div id="cargando" style="display: none;">	
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		<div id="mensaje" style="display: none;"> </div>
		<div id="ContenedorAyuda" style="display: none;">
		<div id="elementoLista"/>
		</div>	
	</body>
</html>
