<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/usuarioServicios.js"></script>
	   	<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/revisionRemesasServicio.js"></script>
		<script type="text/javascript" src="js/pld/revisionRemesas.js"></script>
	</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="revisionRemesasBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Revisi&oacute;n Remesas</legend>
			<table>
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="lblRemesaFolioID">Referencia:</label>
	      			</td>
	 				<td nowrap="nowrap">
       		 			<input type="text" id="remesaFolioID" name="remesaFolioID" size="50" maxlength="50" tabindex="1" autocomplete="off"/>
					</td>
					<td class="separador"></td>
					<td class="label" nowrap="nowrap">
						<label for="lblRemesadora">Remesadora:</label>
	      			</td>
	 				<td nowrap="nowrap">
		         		<form:input type="text" id="remesadora" name="remesadora" path="remesadora" size="50" disabled="true" readonly="true" />
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="lblClienteID">Cliente:</label>
	      			</td>
	 				<td nowrap="nowrap">
		         		<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" disabled="true" readonly="true"/>
		         	   	<input type="text" id="nombreCliente" name="nombreCliente" size="50" disabled="true" readonly="true">
					</td>
					<td class="separador"></td>
					<td class="label" nowrap="nowrap">
						<label for="lblUsuarioServicioID">Usuario Servicio:</label>
	      			</td>
	 				<td nowrap="nowrap">
		         		<form:input type="text" id="usuarioServicioID" name="usuarioServicioID" path="usuarioServicioID" size="12" disabled="true" readonly="true"/>
		         	   	<input type="text" id="nombreUsuario" name="nombreUsuario" size="50" disabled="true" readonly="true">
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap">
		         		<label for="lblMonto">Monto:</label>
					</td>
		     		<td nowrap="nowrap">
		         	 		<form:input type="text" id="monto" name="monto" path="monto" size="18" esMoneda="true" readonly="true" style="text-align: right;" />
		     		</td>
		     		<td class="separador"></td>
		     		<td class="label" nowrap="nowrap">
		        		<label for="lblDireccion">Direcci&oacute;n:</label>
		     		</td>
		     		<td nowrap="nowrap">
				   		<form:textarea id="direccion" name="direccion" path="direccion" maxlength="500" rows="4" cols="50" onBlur="ponerMayusculas(this);" disabled="true" readonly="true"/>
					</td>
	 			</tr>
	 			<tr>
					<td class="label" nowrap="nowrap">
						<label for="lblMotivoRevision">Motivo Revisi&oacute;n:</label>
	      			</td>
	 				 <td colspan="4">
		         		<form:textarea id="motivoRevision" name="motivoRevision" path="motivoRevision" maxlength="500" rows="4" cols="50" onBlur="ponerMayusculas(this);" disabled="true" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="lblFormaPago">Forma Pago:</label>
	      			</td>
	 				<td nowrap="nowrap">
		         	   	<form:radiobutton id="formaPagoR" name="formaPago" path="formaPago" disabled="true"/>
							<label for="lblFormaPagoR">Efectivo</label>
						<form:radiobutton id="formaPagoA" name="formaPago" path="formaPago" disabled="true" />
							<label for="lblFormaPagoS">Abono Cuenta</label>
						<form:radiobutton id="formaPagoS" name="formaPago" path="formaPago" disabled="true" />
							<label for="lblFormaPagoS">SPEI</label>
					</td>
					<td class="separador"></td>
		     		<td class="label" nowrap="nowrap">
		        		<label for="lblIdentificacion">Identificaci&oacute;n:</label>
		     		</td>
		     		<td nowrap="nowrap">
		         	   <form:input type="text" id="identificacion" name="identificacion" path="identificacion" size="50" disabled="true" readonly="true" />
					</td>
	 			</tr>
	 			<tr>
					<td class="label" nowrap="nowrap">
						<label for="lblPermiteOperacion">Permite Operaci&oacute;n::</label>
	      			</td>
	 				<td nowrap="nowrap">
		         	   	<form:radiobutton id="permiteOperacionS" name="permiteOperacion" path="permiteOperacion" value="S" tabindex="2"  />
							<label for="lblPermiteOperacionS">SI</label>
						<form:radiobutton id="permiteOperacionN" name="permiteOperacion" path="permiteOperacion" value="N" tabindex="3" />
							<label for="lblPermiteOperacionN">NO</label>
					</td>
					<td class="separador"></td>
		     		<td class="label" nowrap="nowrap">
		        		<label for="lblComentario">Comentario:</label>
		     		</td>
		     		<td nowrap="nowrap">
				   		<form:textarea id="comentario" name="comentario" path="comentario" maxlength="1000" rows="4" cols="50"  onBlur="ponerMayusculas(this);" tabindex="4" />
					</td>
	 			</tr>
			</table>
			<br>
			<div id="gridRevRemesasCheckList" style="display: none;"></div>
			<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" tabindex="100" value="Grabar" />
						<input type="button" id="expediente" name="expediente" class="submit" tabindex="103" value="Expediente" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						<input type="hidden" id="formaPago" name="formaPago" />
						<input type="hidden" id="estatus" name="estatus" />
					</td>
				</tr>
				<tr>
					<td>
						<div id="imagenCre" style="overflow: scroll; width: 1350px; height:450px;display: none;">
							<img id="imgCredito" src="images/user.jpg"  border="0"  />
						</div>
			       </td>
				</tr>
			</table>
		</fieldset>
	</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;overflow:">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>