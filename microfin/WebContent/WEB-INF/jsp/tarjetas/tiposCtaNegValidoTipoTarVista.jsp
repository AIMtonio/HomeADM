<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>      
 <script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>                                   
<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposCuentaValidoTipoTarjetaServicio.js"></script>
<script type="text/javascript"	src="js/tarjetas/tiposCtaNegValidoTipoTar.js"></script>


</head>
	<body>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposCuentaValidoTipoTarjetaBean">
					<legend class="ui-widget ui-widget-header ui-corner-all">Tipo de Cuenta por Tipo de Tarjeta</legend>
						<br>
							<table border="0" width="100%">
								<tr>
									<td   class="label">
										<label for="TipoTarjetaDebID">Tipo Tarjeta: </label>
									</td>
									<td>
										<select id="tipoTarjetaDebID" name="tipoTarjetaDebID"  path="tipoTarjetaDebID" tabindex="1" >
									 		<option value='0'>TODOS</option>
									  	</select>
									 </td>
					  			</tr>
								<tr>
									<td class="label">
				 						<label for="lblTipoCuenta">Tipo de Cuenta:</label>
				 					</td>
									<td>
							 			<select multiple id="tipoCuenta" name="tipoCuenta" tabindex="2" size="6">
											<option value=1>Eje Acreditados</option>
											<option value=2>Cuenta Eje Global</option>
											<option value=3>Cuenta de Tesoreria</option>
											<option value=4>Cuenta Garantia Exhibida</option>
											<option value=5>TipoCuentas</option>
											<option value=6>Cuenta Ahorro 2</option>
											<option value=7>Efisys</option>
										</select>
									</td>
					  			</tr>
			  			</table>
						<br>
						<br>
					
					 <table align="right">
						<tr>
						  <td align="right">
							<input type="submit" id="grabar" name="grabar" class="submit" value="Agregar" tabindex="3" />
							<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="4" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						 </td>
					   </tr>
				  </table>
				</form:form>
			</fieldset>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
		<div id="mensaje" style="display: none;"></div>
</html>