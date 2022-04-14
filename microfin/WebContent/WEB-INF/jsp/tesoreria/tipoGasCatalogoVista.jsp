<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tipoGasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
	    <script type="text/javascript" src="dwr/interface/tiposActivosServicio.js"></script>
		<script type="text/javascript" src="js/tesoreria/tipoGas.js"></script>  
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tipoGasto">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-header ui-corner-all">Tipo de Gasto</legend>	
					<table>
						<tr>
      						<td class="label"> 
         						<label for="tipoGastoID">Tipo Gasto: </label> 
     						</td>     
     						<td>
								<form:input type="text" id="tipoGastoID" name="tipoGastoID" path="tipoGastoID" size="5" tabindex="1" iniforma="false"/> 
     						</td>
						</tr>
						<tr>
							<td class="label">
								<label for="descripcion">Descripción: </label> 
     						</td>
     						<td>
        						<form:input type="text" id="descripcion" name="descripcion" path="descripcion" size="40" tabindex="2" onBlur=" ponerMayusculas(this)" /> 
     						</td>
     					</tr>     					
     					<tr>
     						<td class="label"> 
					        	<label for="cuentaCompleta">Cuenta Contable:</label> 
					     	</td>
					     	<td>
			         			<form:input  type="text" id="cuentaCompleta" name="cuentaCompletaID" path="cuentaCompleta" size="25" tabindex="3" />
			         	   		<input type="text" id="descripcionCuenta" name="descripcionCuenta"  size="80" disabled="true" readonly="true">
					    	</td>					 				     					     					     	
						</tr>
						<tr>
							<td class="label"> 
						  		<label for="cajaChica">Caja Chica:</label>
						 	</td>
						 	<td>
								<form:select id="cajaChica" name="cajaChica" path="cajaChica"  tabindex="4">
									<form:option value="">SELECCIONAR</form:option>
								  	<form:option value="S">SI</form:option>
								  	<form:option value="N">NO</form:option>
							  	</form:select>
						  	</td>
					 	</tr>			 			
					  	<tr>
							<td class="label" nowrap="nowrap"> 
						  		<label for="representaActivo">Representa Activo:</label>
						 	</td>
						 	<td>
								<form:select id="representaActivo" name="representaActivo" path="representaActivo"  tabindex="5">
									<form:option value="">SELECCIONAR</form:option>
								  	<form:option value="S">SI</form:option>
								  	<form:option value="N">NO</form:option>
							  	</form:select>
							</td>					
						</tr> 						
					  	<tr id="trTipoActivo" style="display: none;">
					  		<td class="label"> 
					    		<label for="tipoActivoID">Tipo Activo:</label> 
					    	</td>
							<td>
				         		<form:input type="text" id="tipoActivoID" name="tipoActivoID" path="tipoActivoID" size="20" tabindex="6" />
				         	   	<input type="text" id="descripcionActivo" name="descripcionActivo"  size="60" disabled="true" readonly="true">
						    </td>
						</tr>
					  	<tr>
							<td class="label"> 
						  		<label for="estatus">Estatus:</label>
						 	</td>
						 	<td>
								<form:select id="estatus" name="estatus" path="estatus"  tabindex="7">
									<form:option value="">SELECCIONAR</form:option>
								  	<form:option value="A">ACTIVO</form:option>
								  	<form:option value="I">INACTIVO</form:option>
							  	</form:select>
						  	</td>					
						</tr>
  					</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="8" />
								<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="9"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							</td>
						</tr>
					</table>	 
  				</fieldset>
  			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;position:absolute; z-index:999;"/>
</html>

  

