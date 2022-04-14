<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/avalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/garantesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/inconsistenciasServicio.js"></script>
<script type="text/javascript" src="js/originacion/inconsistencias.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica"  method="POST" commandName="inconsistenciasServicio">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Inconsistencias</legend>
	<table >
		<tr>
			<td class="label" nowrap="nowrap">
				<label for="producCreditoID">Cliente: </label>
			</td>
			<td>
				<input id="clienteID" name="clienteID" path="clienteID" size="10" autocomplete="off"  tabindex="1"  />
				<input type="text" id="nombreCliente" name="nombreCliente" path="nombreCliente" size="40"  disabled="true" readOnly="true" iniForma="false"/>
			</td>
			<td class="separador"></td>
			<td class="label" nowrap="nowrap">
				<label for="prospectoID">Prospecto: </label>
			</td>
			<td>
				<input id="prospectoID" name="prospectoID" path="prospectoID" size="10" autocomplete="off" tabindex="2"  />
				<input type="text" id="nombreProspecto" name="nombreProspecto" path="nombreProspecto" size="40" disabled="true" readOnly="true" iniForma="false"/>
			</td>
			
		</tr>
		<tr>
			<td class="label" nowrap="nowrap">
				<label for="avalID">Aval: </label>
			</td>
			<td>
				<input id="avalID" name="avalID" path="avalID" size="10" autocomplete="off" tabindex="3"  />
				<input type="text" id="nombreAval" name="nombreAval" path="nombreAval" size="40" tabindex="3" disabled="true" readOnly="true" iniForma="false"/>
			</td>
			<td class="separador"></td>
			<td class="label" nowrap="nowrap">
				<label for="garanteID">Garante: </label>
			</td>
			<td>
				<input id="garanteID" name="garanteID" path="garanteID" size="10" autocomplete="off" tabindex="4"  />
				<input type="text" id="nombreGarante" name="nombreGarante" path="nombreGarante" size="40" disabled="true" readOnly="true" iniForma="false"/>
			</td>
			
		</tr>
	</table>
	<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<table >
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="nombreCompleto">Nombre: </label>
					</td>
					<td>
						<input type="text" id="nombreCompleto" name="nombreCompleto" path="nombreCompleto" size="40"  maxlength="200" onblur=" ponerMayusculas(this)" tabindex="5" iniForma="false"/>
					</td>
					<td class="separador"></td>
					<td class="label" nowrap="nowrap">
						<label for="comentarios">Comentarios: </label>
					</td>
					<td>
						<textarea id="comentarios" name="comentarios" tabindex="6" rows="2" maxlength="200" cols="38" size="45" onblur=" ponerMayusculas(this)"></textarea>
					</td>
					
				</tr>
		</table>
		</fieldset>
		
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="grabar" name="grabar" class="submit" value="Agregar" tabindex="7"/>
					<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="8"/>
					<input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" tabindex="9"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				</td>
			</tr>
		</table>

		
</fieldset>
</form:form>
</div> 
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"></div>
</body>
</html>