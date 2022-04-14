<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		<script type="text/javascript" src="dwr/interface/catalogoRemesasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>
		
		
		<script type="text/javascript" src="js/ventanilla/catalogoRemesas.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="catalogoRemesasBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Catálogo de Remesadoras</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="500">
	 	<tr>
	 		<td class="label">
	 			<label for="lblCaja">Número:</label>
	 		</td>
	 		<td>
				<form:input 			id="remesaCatalogoID"	name="remesaCatalogoID" path="remesaCatalogoID" 						size="11"	maxlength="11"	tabindex="1" />
	 		</td>
	 	</tr>
		<tr id="trSucursal">
	 		<td class="label">
	 			<label for="lblSucursal">Nombre:</label>
	 		</td>
	 		<td >
				<form:textarea			id="nombre"				name="nombre"			path="nombre" 						size="11"	maxlength="200"	tabindex="2" cols="47"  onBlur="ponerMayusculas(this);"/>
	 		</td>
		</tr>
		<tr>
	 		<td class="label">
	 			<label for="lblUsuario">Nombre Corto:</label>
	 		</td>
	 		<td >
	 			<form:input	type="text"	id="nombreCorto"		name="nombreCorto"		path="nombreCorto" 					size="50"	maxlength="50"	tabindex="3" 			onBlur="ponerMayusculas(this);"/>
	 		</td>
	 	</tr>
	 	
		<tr>
			<td class="label">
	 			<label for="lblLimite">Cuenta Contable:</label>
	 		</td>
	 		<td >
	 			<form:input type="text"	id="cuentaCompleta" 	name="cuentaCompleta" 	path="cuentaCompleta" 				size="35"	maxlength="25" tabindex="4" />
	 			<input type="text" 		id="descripcionCuentaContable" 					name="descripcionCuentaContable" 	size="50"	disabled/>
	 		</td>
		</tr>
		<tr>
				<td class="label">
					<label>Nomenclatura Centro de Costos:</label>
				</td>
				<td>
					<form:input id="cCostosRemesa" name="cCostosRemesa" path="cCostosRemesa" size="25" tabindex="10"  maxlength="30"  onblur="ponerMayusculas(this)"/>
					<a href="javaScript:" onClick="ayuda();"><img src="images/help-icon.gif" ></a>  		
				</td>
		</tr>
		<tr id="trEstatus">
			<td class="label" nowrap="nowrap">
				<label for="estatus">Estatus</label>
			</td>	
			<td nowrap="nowrap">
				<form:select id="estatus" name="estatus" path="estatus" tabindex="11">
					<form:option value="A">ACTIVO</form:option>
				   	<form:option value="I">INACTIVO</form:option>
				</form:select>
			</td>	
		</tr>
	</table>
	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="grabar" name="grabar" class="submit" value="Agregar" 															tabindex="11" />
				<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" 													tabindex="12" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="tipoLista" name="tipoLista"/>
				<input type="hidden" id="tipoConsulta" name="tipoConsulta"/>
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
<div id="ContenedorAyuda" style="display: none;">
	<div id="elemento"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>