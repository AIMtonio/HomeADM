<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
      <script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>   
      <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>        
      <script type="text/javascript" src="dwr/interface/clientesPROFUNServicio.js"></script>    
	  <script type="text/javascript" src="dwr/interface/parametrosCajaServicio.js"></script>                                                                                                                                     
      <script type="text/javascript" src="js/cliente/clientesPROFUN.js"></script>
          
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clientesPROFUN">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">Protecci&oacute;n Funeraria PROFUN</legend>  
	<table>
		<tr>
			<td class="label">
				<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
			</td>
			<td>
				<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="1"/>
				<input type="text" id="nombreCliente" name="nombreCliente" size="50" tabindex="2" disabled= "true" readOnly="true" />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="cuentaAhoID">Sucursal Registro:</label>
			</td>
			<td>
				<form:input type="text" id="sucursalReg" name="sucursalReg" path="sucursalReg" size="4" tabindex="3" disabled="true" readOnly="true"/>
				<input type="text" id="desSucursalRegistro" name="desSucursalRegistro" size="40" tabindex="4" disabled="true" readOnly="true"/>
			</td>		
		</tr>
<!-- 		<tr> -->
<!-- 			<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 			<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td>		 -->
<!-- 		</tr> -->
		
		<tr>
			<td class="label">
				<label for="fechaRegistro">Fecha Registro:</label>
			</td>
			<td nowrap="nowrap">
				<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" tabindex="5" disabled ="true"/>
			</td>
			<td class="separador"></td>	
			<td class="label">
				<label for="usuarioReg">Usuario Registro:</label>
			</td>
			<td nowrap="nowrap">
				<form:input type="text" id="usuarioReg" name="usuarioReg" path="usuarioReg" size="4" tabindex="6" disabled="true"/>
				<input type="text" id="nombreUsuario" name="nombreUsuario" size="40" tabindex="7" disabled="true" readOnly="true"/>
			</td>					
		</tr>	
		<tr>
			<td class="label">
				<label for="lblpromotor">Promotor:</label>
			</td>
			<td>
				<input type="text" id="promotorID" name="promotorID" size="4" tabindex="8" disabled ="true" esCalendario="false"/>
				<input type="text" id="nombrePromotorID" name="nombrePromotorID" size="40" tabindex="9" disabled="true" readOnly="true"/>
			</td>
			<td class="separador"></td>	
			<td class="label">
				<label for="lbltipoPersona">Tipo de Persona:</label>
			</td>
			<td>
				<input type="text" id="tipoPersonaID" name="tipoPersonaID"  size="30" tabindex="10" disabled="true"/>
			</td>					
		</tr>
		<tr>
			<td class="label">
				<label for="lblfechaIngreso">Fecha de Ingreso:</label>
			</td>
			<td>
				<input type="text" id="fechaIngresoID" name="fechaIngresoID"  size="12" tabindex="11" disabled ="true" esCalendario="false"/>
			</td>
			<td class="separador"></td>	
			<td class="label">
				<label for="lblfechaNacimiento">Fecha de Nacimiento:</label>
			</td>
			<td>
				<input type="text" id="fechaNacimientoID" name="fechaNacimientoID"  size="12" tabindex="12" disabled="true"/>
			</td>					
		</tr>
		<tr>
			<td class="label">
				<label for="lblsucursal">Sucursal <s:message code="safilocale.cliente"/>:</label>
			</td>
			<td>
				<input type="text" id="sucursalID" name="sucursalID" size="4" tabindex="13" disabled="true"/>
				<input type="text" id="nombreSucursalID" name="nombreSucursalID" size=40 tabindex="14" disabled="true" readOnly="true"/>
			</td>			
			<td class="separador"></td>		
			<td class="label" >
				<label for="estatus" id="lblEstatus" style="display: none;">Estatus:</label>
			</td>
			<td>
				<form:select id="estatus" name="estatus" path="estatus"  tabindex="15" disabled="true" style="display: none;">
					<form:option value="R">REGISTRADO</form:option>
			     	<form:option value="C">CANCELADO</form:option>
			     	<form:option value="A">AUTORIZADO</form:option>
			     	<form:option value="E">RECHAZADO</form:option>
			     	<form:option value="I">INACTIVO</form:option>
			     	<form:option value="P">PAGADO</form:option>
				</form:select>
			</td>	
		</tr>
		<tr id="filaCancelar" style="display: none;">
			<td class="label">
				<label for="fechaCancela">Fecha de Cancelaci&oacute;n:</label>
			</td>
			<td nowrap="nowrap">
				<form:input type="text" id="fechaCancela" name="fechaCancela" path="fechaCancela" size="12" tabindex="16" disabled ="true"/>
			</td>
			<td class="separador"></td>	
			<td class="label">
				<label for="usuarioReg">Sucursal Cancela:</label>
			</td>
			<td nowrap="nowrap">
				<input type="text" id="sucursalCan" name="sucursalCan" size="4" tabindex="17" disabled="true"/>
				<input type="text" id="nombreSucursalCan" name="nombreSucursalCan" size=40 tabindex="18" disabled="true" readOnly="true"/>
			</td>					
		</tr>	
		<tr>
			<td align="right" colspan="5">
				<input type="submit" id="guardar" name="guardar" class="submit" value="Registrar"  tabindex="19"/>
				<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar"  tabindex="20"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
				<input type="hidden" id="clienteCta" name="clienteCta"/>
				<input type="hidden" id="usuarioCan" name="usuarioCan"/>
				<input type="hidden" id="perfilCancelPROFUN" name="perfilCancelPROFUN"/>
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
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>


