<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>

<head>
<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
<script type="text/javascript" src="js/credito/tasasBaseCatalogo.js"></script>
</head>

<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="tasasBaseBean">

			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Tasas
					Base</legend>

				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label"><label for="lbltasaBaseID">Tasa
								Base: </label></td>
						<td><form:input id="tasaBaseID" name="tasaBaseID"
								path="tasaBaseID" size="12" tabindex="1" /></td>
						<td class="separador"></td>
						<td class="label"><label for="lblnombre">Nombre: </label></td>
						<td><form:input id="nombre" name="nombre" path="nombre"
								size="25" tabindex="2" maxlength="45" onBlur=" ponerMayusculas(this)" /></td>

					</tr>
					<tr>
						<td class="label"><label for="lbldescripcion">Descripci&oacute;n:</label>
						</td>
						
						<td><form:input id="descripcion" name="descripcion"
								path="descripcion" size="45" tabindex="3" maxlength="100" onBlur=" ponerMayusculas(this)" /></td>
								
								<td class="separador"></td>
						<td class="label"><label for="lblnombre">Valor: </label></td>
								
						<td><form:input id="valor" name="valor" path="valor" size="12" tabindex="4" esTasa="true" maxlength="15"/>
						
						</td>

					</tr>
					<tr>
						<td class="label"><label for="claveCNBV">Clave CNBV: </label></td>
								
						<td><form:input id="claveCNBV" name="claveCNBV" path="claveCNBV" size="7" tabindex="6" maxlength="3"/>
						
						</td>
					
							
						
						
						<td class="separador"></td>
						
						
						<td class="label">
							<label  id="lblFechaValor" for="fechaValor">Fecha:</label>
						</td>
						<td id="tdFechaValor">
							<form:input id="fechaValor" name="fechaValor" path="fechaValor" size="20" tabindex="5" esCalendario="true"/>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td align="right"><input type="submit" id="agrega"
										name="agrega" class="submit" value="Agregar" tabindex="7" />
										<input type="submit" id="modificar" name="modificar"
										class="submit" value="Modificar" tabindex="8" />
										 <input type="submit" id="cambiaValor" name="cambiaValor" class="submit"
										value="Cambiar Valor" tabindex="9"/>			 							
										 <input type="hidden"
										id="tipoTransaccion" name="tipoTransaccion"
										value="tipoTransaccion" /></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" />
	</div>
</body>
<div id="mensaje" style="display: none;" />
</html>