<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudTarDebServicio.js"></script>
		<script type="text/javascript" src="js/tarjetas/solicitudTarDeb.js"></script>
	</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solicitudTarDeb">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud de Tarjeta Nominativa</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label">
		    			<label for=lblfolio>Folio:</label>
					</td>
		    		<td>
		    			<form:input type="text" id="folio" name="folio" path="folio" tabindex="1" size="7"/>
		    			<label for=lblstatus>Estatus:</label>
		    			<input type="text" id="status" name="status"  readOnly ="true"  disabled="true" size="18""/>
		   			</td>
		   			<td class="separador"></td>
		   			<td class="label">
		    			<label for=lblfecha>Fecha:</label>
					</td>
		    		<td>
		    			<input type="text" id="fechaSolicitud" name="fechaSolicitud"  readOnly ="true"  disabled="true" size="15"/>
		   			</td>
				</tr>
				<tr>
					<td class="separador"></td>
					<td colspan= "5"  class="label">
		    			<input type="radio" id="tarjetaNueva" name="opcRadio" tabindex="2" />
						<label for="nueva">Tarjeta Nueva </label>&nbsp;&nbsp;
						<input type="radio" id="tarjetaRep" name="opcRadio" tabindex="3"/>
						<label for="reposicion">Reposición</label>
					</td>
				</tr>
				<tr class="nueva" style="display:none;">
					<td class="label">
		    			<label for=lblcorporativo>Corporativo (Contrato):</label>
					</td>
		   			<td colspan="5"  >
			   			<form:input  type="text" id="corpRelacionado" name="corpRelacionado" path="corpRelacionadoID" size="15" tabindex="4"/>
				    	<input type="text" id="nombre" name="nombre" size="50" type="text" readonly="true" disabled="true"/>
					</td>
				</tr>
				<tr class="reposicion" style="display:none;">
					<td>
						<label for=lblNumero>Número de Tarjeta:</label>
					</td>
					<td>
						<input type="text" id="numeroTar" name="numeroTar" path="tarjetaID" size="20" tabindex="5" />
					</td>
				</tr>
		 		<tr>
		   			<td class="label">
		    			<label for=lblcliente>Tarjetahabiente:</label>
					</td>
		   			<td  colspan="5" >
			   			<form:input type="text" id="clienteID" name="clienteID"  path="clienteID" size="15" tabindex="6"	  />
						<input type="text" id="nombreCliente" name="nombreCliente"   size="50"   readonly="true" disabled="true"  />
					</td>
		 		</tr>
		 	 	<tr>
		   			<td class="label">
		    			<label for=lblcuenta>Número de Cuenta:</label>
					</td>
		   			<td colspan="7">
			   			<form:input id="cuentaAhoID" name="cuentaAhoID"  path="cuentaAhoID" size="15" tabindex="7"  />
				 		<input type="text" id="tipoCuenta" name="tipoCuenta" size="30"  readonly="true"  disabled="true"  />
					</td>
		 		</tr>
				<tr class="nueva" style="display:none;">
					<td class="label">
		    			<label for=lbltarjeta>Tipo de Tarjeta:</label>
					</td>
		   			<td colspan="7">
			   			<form:input type="text" id="tipoTarjetaDebID" name="tipoTarjetaDebID" path="tarjetaTipo" size="10" tabindex="8"  />
						<input type="text" id="descripcionTarjeta" name="descripcionTarjeta" size="30"  readonly="true"  disabled="true"  />
					</td>
		 		</tr>
		  		<tr>
		   			<td class="label">
		    			<label for=lblNombreTarjeta>Nombre de Tarjeta:</label>
					</td>
		   			<td>
			   			<form:input type="text" id="nombreClienteTar" name="nombreClienteTar" path="nombreTarjeta" size="45" tabindex="9" readonly="true" disabled="true" maxlenght="45"	onblur="ponerMayusculas(this);" />
					</td>
		 		</tr>
				<tr>
			    	<td class="label">
						<label for="lblrelTar">Relación Tarjeta:</label>
		    		</td>
	 				<td>
		       			<form:select id="relTar" name="relTar" path="relacion" tabindex="10" >
							<form:option value="T">Titular</form:option>
			   				<form:option value="A">Adicional</form:option>
						</form:select>
		    		</td>
  		   		</tr>
		   		<tr>
		   			<td class="label">
		    			<label for=lblcosto>Costo:</label>
					</td>
		   			<td>
				   		<form:input type="text" id="costo" name="costo"  path="costo" size="15" tabindex="11" esMoneda="true" readonly="true" disabled="true" />
					</td>
				</tr>
			</table>
			<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="solicitar" name="solicitar" class="submit" value="Solicitar" tabindex="13"/>
						<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabindex="14"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			    		<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
					</td>
				</tr>
			</table>
			<!-- Campos Ocultos -->
			<input type="hidden" id="estatus" name="estatus" size="15" path="estatus" tabindex="12" />
		</fieldset>
	</form:form>
</div>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>