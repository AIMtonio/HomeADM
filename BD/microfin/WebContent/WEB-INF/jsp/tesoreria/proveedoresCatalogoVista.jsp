<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	  	<script type="text/javascript" src="dwr/interface/proveedoresServicio.js"></script> 
	  	<script type="text/javascript" src="dwr/interface/tipoProvServicio.js"></script> 
	  	<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
	  	<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/tesoreria/proveedores.js"></script>  
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="proveedores">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Proveedores</legend>
			<br> 		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Proveedor</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">
									<label for="1"></label>
									<label for="proveedorID">Proveedor: </label>
								</td>
								<td>
									<form:input id="proveedorID" name="proveedorID" path="proveedorID" size="5" tabindex="1"  />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblTipoProveedor">Tipo Proveedor:</label>
								</td>
								<td>
									<form:input id="tipoProveedorID" name="tipoProveedorID" path="tipoProveedorID" size="5" tabindex="2"  />
									<textarea id="desTipoProveedor" name="desTipoProveedor" cols =70 rows=3 tabindex="3" readonly="true"></textarea>						
								</td>
							</tr>
							<tr>
														
								<td class="label"> 
	        						<label for="lblTipoTercero">Tipo de Tercero: </label> 
								</td>
								<td> 
				        			<form:select id="tipoTerceroID" name="tipoTerceroID" path="tipoTerceroID" tabindex="4">
									<form:option value="">SELECCIONAR</form:option>
									</form:select> 
			     				</td>								
							  	<td class="separador"></td>
							  	<td class="label"> 
	        						<label for="lblTipoOperacion">Tipo de Operacion: </label> 
								</td>
								<td> 
				        			<form:select id="tipoOperacionID" name="tipoOperacionID" path="tipoOperacionID" tabindex="5">
									<form:option value="">SELECCIONAR</form:option>
									</form:select> 
			     				</td>								
							</tr>
						</table>
					</fieldset>
					</td>
				</tr>
				<tr>
					<td><br></td>
				</tr>
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">	
						<legend >Contacto</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">	
							<br>
							<tr>
								<td class="label"> 
									<label for="tipoPersona">Tipo Persona: </label> 
								</td>
								<td class="label"> 
									<form:radiobutton id="tipoPersona" name="tipoPersona" path="tipoPersona" value="F" tabindex="6" checked="checked" />
									<label for="tipoPersona">F&iacute;sica</label>
									<form:radiobutton id="tipoPersona2" name="tipoPersona2" path="tipoPersona" value="M" tabindex="7"/>
									<label for="tipoPersona2">Moral</label>	
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="primerNombre">Primer Nombre:</label>
								</td>
								<td>
									<form:input id="primerNombre" name="primerNombre" path="primerNombre" tabindex="8" size="25" onBlur=" ponerMayusculas(this)"/>
								</td>		
								<td class="separador"></td>
								<td class="label">
									<label for="segundoNombre">Segundo Nombre: </label>
								</td>
								<td>
									<form:input id="segundoNombre" name="segundoNombre" path="segundoNombre" size="25" tabindex="9" onBlur=" ponerMayusculas(this)"/>
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="apellidoPaterno">Apellido Paterno:</label>
								</td>
								<td>
									<form:input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" size="25" tabindex="10" onBlur=" ponerMayusculas(this)"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="apellidoMaterno">Apellido Materno:</label>
								</td>
								<td>
									<form:input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" size="25" tabindex="11" onBlur=" ponerMayusculas(this)"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="fechaNacimiento"> Fecha de Nacimiento:</label>
								</td>
								<td>
									<form:input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="25" tabindex="12" />	
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="CURP">CURP:</label>
								</td>
								<td>
									<form:input id="CURP" name="CURP" path="CURP" tabindex="13" size="25" onBlur=" ponerMayusculas(this)" maxlength="18"/>
								</td>		
							</tr>
							<tr>
								<td class="label">
									<label for="paisNacimiento">Pa&iacute;s de Nacimiento:</label>
								</td>
								<td>
									<form:input id="paisNacimiento" name="paisNacimiento" path="paisNacimiento" size="6" tabindex="14" maxlength="20"/>
									<input type="text" id="paisNac" name="paisNac" size="35" disabled="true" readOnly="true"
										onBlur=" ponerMayusculas(this)"/>
								</td>
								<td class="separador"></td>
								<td class="label"> 
							    	<label for="estadoNacimiento">Entidad Federativa:</label> 
							    </td> 
							    <td> 
							       <form:input id="estadoNacimiento" name="estadoNacimiento" path="estadoNacimiento" size="6" tabindex="15" maxlength="20"/> 
							       <input type="text" id="nombreEstado" name="nombreEstado" size="35" disabled ="true" readOnly="true"/> 
							    </td>
							</tr>
							<tr>
								<td class="label">
									<label id="RFCpf" for="RFCpf"> RFC:</label>
									<label id="RFCrl" for="RFCrl" style="display:none"> RFC: </label>
								</td>
								<td>
									<form:input id="RFC" name="RFC" path="RFC" tabindex="16" size="25"	onBlur=" ponerMayusculas(this)" maxlength="13"/>
									<input type ="button" id="generar" name="generar" value="Generar" class="submit"  tabindex="16"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblCorreo">Correo:</label>
								</td>
								<td>
									<form:input id="correo" name="correo" path="correo" tabindex="17" size="25"	maxlength="50"/>
								</td>
								
							</tr>
							<tr class="residenciaDIOT" style="display:none">
								<td class="label"> 
									<label for="lblpaisResidencia" id="lblpaisResidencia">Pa&iacute;s de Residencia:</label>
								</td>
								<td>
									<form:input id="paisResidencia" name="paisResidencia" path="paisResidencia" size="5" tabindex="17"/>
									<input type="text" id="descPaisResidencia" name="descPaisResidencia" size="30" tabindex="18" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>			
								<td class="separador"></td>					
							    <td class="label"> 
							    	<label for="lblNacionalidad" id="lblNacionalidad">Nacionalidad:</label> 
							    </td>
							   	<td>
					         		<form:input id="nacionalidad" name="nacionalidad" path="nacionalidad" size="15" disabled="disabled" readonly="true"/>
							    </td>	
								
							</tr>
							<tr>
								<td class="label"> 
							    	<label for="lblTelefono">Tel&eacute;fono:</label> 
							    </td>
							   	<td>
					         		<form:input id="telefono" name="telefono" path="telefono" size="15" tabindex="20" maxlength="10"/>
					         		<label for="lblExt">Ext.:</label>
					         		<form:input id="extTelefonoPart" name="extTelefonoPart" path="extTelefonoPart" size="10" tabindex="21" 
					         			maxlength="6"/>		         	
							    </td>
							    <td class="separador"></td>
							   	<td class="label"> 
							    	<label for="lblTelefonoCel">Tel&eacute;fono Celular:</label> 
							    </td>
							   	<td>
					         		<form:input id="telefonoCelular" name="telefonoCelular" path="telefonoCelular" size="15" tabindex="22" maxlength="10"/>		         	
							    </td>
							</tr>
							<tr class="residenciaDIOT" style="display:none">
								<td class="label"> 
							    	<label for="lblIDFiscal" id="lblIDFiscal">N&uacute;mero de ID Fiscal:</label> 
							    </td>
							   	<td>
					         		<form:input id="idFiscal" name="idFiscal" path="idFiscal" size="40" tabindex="23" onkeypress="validaCaracteresNumFiscal(this,this.id)" maxlength="40"/>					         		         	
							    </td>		   	
							   
							</tr>
						</table>
						</fieldset>
					</td>
				</tr>
				<tr>
					<td> <br></td>
				</tr>
				<tr>
					<td>
						<div id="personaMoral"  style="display:none">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">		
						<legend>Persona Moral</legend>
						<br>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">
									<label for="razonSocial">Raz&oacute;n Social:</label>
								</td>
								<td >
									<form:input id="razonSocial" name="razonSocial" path="razonSocial" size="50" tabindex="24" onBlur=" ponerMayusculas(this)" onkeypress="validaCaracteres(this,this.id)"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="RFCpm">RFC:</label>
								</td>
								<td>
									<form:input id="RFCpm" name="RFCpm" path="RFCpm" tabindex="25" onBlur=" ponerMayusculas(this)" maxlength="12"/>
								</td>
							</tr>				 
						</table>
						</fieldset>
					</div>
					</td>
				</tr>
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Tipo de Pago</legend>
							<table border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td><br>	
										<table border="0" cellpadding="0" cellspacing="0" width="100%">
											<tr>
												<td class="label"> 
													  <label for="tipoPago">Tipo de Pago:</label>
													 
													<form:select id="tipoPago" name="tipoPago" path="tipoPago"  tabindex="26" >
														<form:option value="">SELECCIONAR</form:option>
														<form:option value="C">CHEQUE</form:option>
														<form:option value="S">SPEI</form:option>
														<form:option value="B">BANCA ELECTRÓNICA</form:option>
														<form:option value="T">TARJETA EMPRESARIAL</form:option>
													</form:select>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<br>
										<div id="tipoPagoSpei"  style="display:none">
											<fieldset class="ui-widget ui-widget-content ui-corner-all">		
											<legend>SPEI</legend>
											<br>
											<table border="0" cellpadding="0" cellspacing="0" width="100%">
												<tr>
													<td class="label">
														<label for="institucion">Instituci&oacute;n:</label>
													</td>
													<td >
														<form:input id="institucionID" name="institucionID" path="institucionID" size="10" tabindex="27" />
														<input type="text" id="descripcion" name="descripcion" size="60" tabindex="28" disabled="true"/> 
													</td>			
												</tr>
												<tr>
													<td class="label">
														<label for="cuentaClave">Cuenta Clabe:</label>
													</td>
													<td>
														<form:input id="cuentaClave" name="cuentaClave" path="cuentaClave" size="25" tabindex="29" maxlength="28"/>
													</td>
												</tr>				 
											</table>
											</fieldset>
										</div>
									</td>
								</tr>
								<tr>
									<td> <br></td>
								</tr>
								<tr>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
										<td class="label"> 
								    		<label for="lblcuentaCompleta">Cuenta Contable (CxP):</label> 
								    	</td>
								   		<td>
						         			<form:input id="cuentaCompleta" name="cuentaCompleta" path="cuentaCompleta" size="25" tabindex="30" 
						         				maxlength="25"/>		         	
						         			<input id="descripcionCuenta" name="descripcionCuenta" size="75" disabled="disabled" readonly="true"
						         				tabindex="31"  type="text" >
								     	</td>
								     	<td class="separador"></td>
										<td class="label">
											<label for="lblEstatus">Estatus:</label>
										</td>
										<td>
											<form:input id="estatus" name="estatus" path="estatus" tabindex="-1" size="10"	disabled="disabled" readonly="true"/>
										</td>
										<tr>
										<td class="label"> 
								    		<label for="lblcuentaAnticipo">Cuenta Contable Anticipos:</label> 
								    	</td>
								   		<td>
						         			<form:input id="cuentaAnticipo" name="cuentaAnticipo" path="cuentaAnticipo" size="25" tabindex="33" 
						         				maxlength="25"/>		         	
						         			<input id="descripCuentaAnticipo" name="descripCuentaAnticipo" size="75" disabled="disabled" readonly="true"
						         				tabindex="34"  type="text" >
								     	</td>
								     	</tr>
								     </table>
								</tr>
							</table>
							<br>
							<table align="right">
								<tr>
									<td align="right">
										<input type="submit" id="agrega" name="agrega" class="submit" 
											 value="Agregar" tabindex="35" />
										<input type="submit" id="modifica" name="modifica" class="submit" 
											 value="Modificar" tabindex="36" />
										<input type="submit" id="elimina" name="elimina" class="submit" 
											 value="Eliminar" tabindex="37" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>						
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
			</table>
			</fieldset>
		</form:form>
	</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>