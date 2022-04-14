<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

	<head>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasTransferServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	    <script type="text/javascript" src="js/cliente/cuentasDestino.js"></script>
	</head>

	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica"    method="POST" commandName="cuentas">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				  <legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Destino </legend>
					 <fieldset class="ui-widget ui-widget-content ui-corner-all">
						<table border="0"  width="100%">
							<tr>
								<td class="label">
							         	<label for="lblclienteID"><s:message code="safilocale.cliente"/>: </label>
							      </td>
							      <td class="label">
										<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="13" tabindex="1"  />
										<input type="text" id="nombreCliente" name="nombreCliente"  size="50" tabindex="2" disabled="true"/>
							    </td>
							    	 <td class="separador"></td>
								<td class="label">
									<label for="tipoCuentaI">Tipo Cuenta:</label></td>
								<td class="label">
									<form:radiobutton id="tipoCuentaI" name="tipoCuenta" path="tipoCuenta" value="I" tabindex="3" checked="checked"/>
									<label for="tipoCuentaI">Interna</label>
									<form:radiobutton id="tipoCuentaE" name="tipoCuenta" path="tipoCuenta" value="E" tabindex="3"/>
									<label for="tipoCuentaE">Externa</label>
								</td>
							</tr>

							<tr>
						       <td class="label">
						         <label for="lblnumero">Número: </label>
						        </td>
						       <td class="label">
							     <form:input type="text" id="cuentaTranID" name="cuentaTranID" path="cuentaTranID" size="13" tabindex="5"  />
						    	 </td>
						    	 <td class="separador"></td>
						       <td class="label" nowrap="nowrap">
							        <label for="lblfechaRegistro">Fecha Registro: </label>
							   	</td>
						      	<td class="label">
						      		<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="10" tabindex="6" disabled="true" />
						     	</td>
						  </tr>
						  <tr>
						    <td class="label">
						         <label for="lblnumero">Estatus: </label>
						      </td>
						      <td class="label">
							  	<form:input type="text" id="estatus" name="estatus" path="estatus" size="13" tabindex="7" disabled="true"  />
						   </td>
						</tr>
						</table>
					</fieldset>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all"style="display:none" id="fexterna">
					   <legend >Externa</legend>
						 <table border="0" width="100%">
						  <tr>
							   <td class="label">
							        <label for="lblBanco">Banco: </label>
			        	       </td>
						      	<td class="label">
						      		<form:input type="text" id="institucionID" name="institucionID" path="institucionID" size="10" tabindex="7" />
						      	    <input type="hidden"  id="institucion" name="institucion" size="10"/>

						      		<input type="text" id="nombreInstitucion" name="nombreInstitucion"  size="50" tabindex="8" disabled="true"/>
						        </td>
					      </tr>

					      	  <tr>
							<td class="label">
						         	<label for="lblTipoCuentaSpei">Tipo Cuenta Spei: </label>
						      	 </td>
						      <td class="label">
						      <form:select id="tipoCuentaSpei" name="tipoCuentaSpei" path="tipoCuentaSpei" tabindex="8">
						      			<form:option value="">SELECCIONAR</form:option>
										<form:option value="40">CLABE INTERBANCARIA</form:option>
										<form:option value="3">TARJETA DE DEBITO </form:option>
			     						<form:option value="10">NUMERO DE CELULAR </form:option>

								</form:select>
						     </td>
							    <td class="separador"></td>
						        <td class="label">
						         	<label for="lblclabe">Cuenta: </label>
						      	</td>
						      	<td class="label">
								    <form:input type="text" id="clabe" name="clabe" path="clabe" size="22" tabindex="9"  maxlength="18" />
						        </td>
					      </tr>

					   	  <tr>
					   		<td class="label">
							   <label for="lblBeneficiario">Beneficiario: </label>
							   	</td>
						      	<td class="label">
						      		<form:input type="text" id="beneficiario" name="beneficiario" path="beneficiario" size="45" tabindex="10" maxlength="40" onBlur=" ponerMayusculas(this)"/>
						     	</td>
						     	 <td class="separador"></td>
						    	 <td class="label">
						         	<label for="lblAlias">Alias: </label>
						      	 </td>
						      <td class="label">
									<form:input id="alias" type="text" name="alias" path="alias" size="25" tabindex="11" maxlength="20" onBlur=" ponerMayusculas(this)" />
						     </td>
					   	 </tr>

						<tr>
							<td class="label">
								<label for="lblBeneficiarioRFC">RFC ó CURP: </label>
							</td>
							<td class="label">
								<form:input type="text" id="beneficiarioRFC" name="beneficiarioRFC" path="beneficiarioRFC" size="25" tabindex="12" maxlength="18" onBlur=" ponerMayusculas(this)"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="esPrincipalNo">Es Principal:</label></td>
							<td class="label">
								<form:radiobutton id="esPrincipalSi" name="esPrincipal" path="esPrincipal" value="S" tabindex="13"/>
								<label for="esPrincipalSi">Si</label>
								<form:radiobutton id="esPrincipalNo" name="esPrincipal" path="esPrincipal" value="N" tabindex="13" checked="checked"/>
								<label for="esPrincipalNo">No</label>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="aplicaPara">Aplica Para: </label>
							</td>
							<td>
								<form:select id="aplicaPara" name="aplicaPara" path="aplicaPara" tabindex="13">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="S">CUENTA</form:option>
									<form:option value="C">CREDITO </form:option>
									<form:option value="A">AMBAS</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label domiciliacion" >
								<label for="lblEstatusDomicilio">Estatus Domiciliaci&oacute;n: </label>
							</td>
							<td class="domiciliacion">
								<form:select id="estatusDomicilio" name="estatusDomicilio" path="estatusDomicilio" tabindex="14">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="N">NO AFILIADA</form:option>
									<form:option value="A">AFILIADA </form:option>
									<form:option value="B">BAJA</form:option>
								</form:select>
							</td>

						</tr>
						</table>
					</fieldset>

					<fieldset class="ui-widget ui-widget-content ui-corner-all" style="display:none" id="finterna">
						<legend >Interna</legend>  <table border="0" width="100%">
						    <tr>
								<td class="label"><label for="lblCuentaAhoID">Cuenta:</label></td>
								<td>
								   <input id="cuentaAhoIDCa" name="cuentaAhoIDCa"  iniForma="false" size="13" tabindex="14" type="text" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="lblCuentaAhoID">Tipo Cuenta: </label>
								</td>
								<td>
								    <input id="tipoCuentaCa" name="tipoCuentaCa"   size="25" tabindex="15" type="text" readOnly="true" iniForma="false" disabled="true" />
								</td>
							</tr>
						    <tr>
								 <td class="label" nowrap="nowrap"><label for="lblNombreClienteca"><s:message code="safilocale.cliente"/> Destino:</label></td>
								 <td><input id="numClienteCa" name="numClienteCa" size="13" type="text" readOnly="true"	iniForma="false" disabled="true" tabindex="16" />
								 <input id="nombreClienteCa" name="nombreClienteCa" size="50"type="text" readOnly="true" iniForma="false" disabled="true" tabindex="17" /></td>
						   </tr>
					</table>
					</fieldset>

			 <table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="agregar" name="agregar" class="submit" tabindex="18" value="Agregar"/>
								<input type="submit" id="modificar" name="modificar" class="submit" tabindex="19" value="Modificar"/>
								<input type="submit" id="baja" name="baja" class="submit" tabindex="20" value="Cancelar"/>
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="0"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"  value="0" />
							</td>

						</tr>
				  </table>
				</fieldset>

			</form:form>
	     </div>
	    	<div id="cargando" style="display: none;">
	    </div>
	    <div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
	    </div>
	    <div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
	</body>
     <div id="mensaje" style="display: none;"/>
</html>
