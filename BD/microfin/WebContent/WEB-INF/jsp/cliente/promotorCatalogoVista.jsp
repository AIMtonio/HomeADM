<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
 	   <script type="text/javascript"  src="dwr/interface/promotoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/gruposEmpServicio.js"></script> 
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
      <script type="text/javascript" src="js/cliente/promotorCatalogo.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="promotor">


<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Cat&aacute;logo de Promotores</legend>
					
			<table border="0"  width="950px">
				<tr>
					<td class="label">
						<label for="promotorID">N&uacute;mero: </label>
					</td>
					<td >
						<form:input id="promotorID" name="promotorID" path="promotorID" size="7"  iniForma = 'false'  tabindex="1" />
					</td>
					
					<td class="separador"></td>
					
				   <td class="label">
						<label for="usuarioID">N&uacute;mero de Usuario: </label>
					</td>
					<td >
						<form:input id="usuarioID" name="usuarioID" path="usuarioID" size="5" tabindex="2" />
					</td> 
					 			
				</tr>
				
				<tr>
					<td class="label">
						<label for="nombrePromotor">Nombre del Promotor: </label>
					</td>
					<td >
						<form:input id="nombrePromotor" name="nombrePromotor" path="nombrePromotor" onBlur=" ponerMayusculas(this)" size="38" tabindex="3" maxlength="100" />
						<!--<input type="text" id="usuario" name="usuario"size="30" tabindex="12" disabled="true" readOnly="true"/>-->
					</td>
					
					<td class="separador"></td>
					
				   <td class="label">
					 <label for="nombreCoordinador">Nombre del Coordinador: </label>
					</td>
				   <td >
					 	<form:input id="nombreCoordinador" name="nombreCoordinador" path="nombreCoordinador" onBlur=" ponerMayusculas(this)" size="37"  tabindex="4" maxlength="100"/>
					</td>					
				</tr>
			
				<tr>
					<td class="label">
						<label for="telefono">Tel&eacute;fono Particular: </label>
						
					</td>
					<td >
						<form:input id="telefono" name="telefono" maxlength="15" path="telefono" size="15" tabindex="5" />
						<label for="lblExtTelefono">Ext.:</label>
						<form:input id="extTelefonoPart" name="extTelefonoPart" path="extTelefonoPart" size="10" tabindex="6" maxlength="6" />
					</td>
					
					<td class="separador"></td>
					
				   <td class="label">
					 <label for="correo">Correo Electr&oacute;nico: </label>
					</td>
				   <td >
					 	<form:input id="correo" name="correo" path="correo" size="37" tabindex="7" maxlength="50"/>
					</td>					
				</tr>
				
				<tr>
					<td class="label">
						<label for="celular">Tel&eacute;fono Celular: </label>
					</td>
					<td >
						<form:input id="celular" name="celular" maxlength="15" path="celular" size="15" tabindex="8" />
						
					</td>
					
					<td class="separador"></td>
					
				   <td class="label">
					 <label for="correo">N&uacute;mero de Sucursal: </label>
					</td>
				   <td >
					 	<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="5" tabindex="9" maxlength="10"/>
					 	<input id="sucursal" name="sucursal"size="29" tabindex="9" disabled/>
					</td>					
				</tr>
				
				<tr>
				
					<td class="label">
					 <label  for="numeroEmpleado">N&uacute;mero del Empleado: </label>
					</td>
				   <td >
					 	<form:input id="numeroEmpleado" name="numeroEmpleado" path="numeroEmpleado" size="5"  tabindex="10" maxlength="10"/>
					</td>		
										
					<td class="separador"></td>
					
					<td class="label">
						<label for="estatus">Estatus: </label>
					</td>
					<td >
						<form:select id="estatus" name="estatus" path="estatus" disabled="true" tabindex="11" >
							<form:option value="A">ACTIVO</form:option>
				     		<form:option value="B">BAJA</form:option>
							<form:option value="D">DESHABILITADO</form:option>
						</form:select>
					</td>			
				</tr>
			    <tr id="divGestor">
				<td class="label">
					 <label  for="lblGestor">Gestor: </label>
					</td>
				<td>
						<form:input id="gestorID" name="gestorID" path="gestorID" size="5" tabindex="12" />
				</td>
				
				</tr> 
				
		<tr id="aplicaPromotorTr" style="display:none">	
			<td class="label" > 
		    	<label for="aplicaPromotor">Aplica para: </label> 
		   	</td> 
		   	<td  colspan="2">
		   	 	<input type="radio" id="aplicaPromotor1" name="aplicaPromotorOpc" value="CR" tabindex="12" />
				<label >Crédito</label>
				<input type="radio" id="aplicaPromotor2" name="aplicaPromotorOpc" value="CA" tabindex="13"/>
				<label >Captación</label>
				<input type="radio" id="aplicaPromotor3" name="aplicaPromotorOpc" value="A" tabindex="14" />
				<label >Ambos</label>
				<input type="hidden" id="aplicaPromotor" name="aplicaPromotor"   value="N" readonly="true" tabindex="15"/>
		
			</td>
		</tr>
		</table>
	
				
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="16"/>
									<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="17"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" tabindex="18"/>
									<input type="hidden" id ="estatusUsu" name="estatusUsu"	/>
								</td>
							</tr>
						</table>		
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
<div id="mensaje" style="display: none;"/>
<div id="ContenedorAyuda" style="display: none;">
</div>	
</body>
</html>