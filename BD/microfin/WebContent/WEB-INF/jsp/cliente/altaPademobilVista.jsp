<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
<title>Alta Pademobile</title>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasBCAMovilServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosPDMServicio.js"></script>
	<script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosPDMServicio.js"></script> 
	<script type="text/javascript" src="js/cliente/altaPademobil.js"></script>
</head>
<body>
	<script>
		var nombreServicio = "";

		var conParametroBean = {  
			'principal' : 1	
		};

		consultaNombreServicio();

		// Funcion pra consultar el nombre del Servicio
		function consultaNombreServicio(){
			var numEmpresaID = 1;
	
			var parametrosBean = {
	  				'empresaID':numEmpresaID	
	  		};
	
			setTimeout("$('#cajaLista').hide();", 200);
			if (numEmpresaID != '' && !isNaN(numEmpresaID)) { 
				
				parametrosPDMServicio.consulta(parametrosBean,conParametroBean.principal,function(data) { 	
					//si el resultado obtenido de la consulta regreso un resultado
					if (data != null) {				
						//coloca los valores del resultado en sus campos correspondientes
						nombreServicio = data.nombreServicio;
						agregaServicio(nombreServicio);
					}
				});
			}
		}

		// Funcion para obtener el nombre del servicio para mostrarlo en el titulo de la Pantalla
		function agregaServicio(nombreServicio){
			document.getElementById('nombreServicio').innerHTML = nombreServicio;
		}
	</script>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Alta <label id="nombreServicio"></label></legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasBCAMovilBean" target="_blank">
			<table border="0" width="100%">							
				<tr>  
				  <td class="label"><label for="lblUsuarioPDMID">N&uacute;mero: </label></td>
				   <td>
				   		<input type="text" id="cuentasBcaMovID" name="cuentasBcaMovID" size="12" iniForma="false" tabindex="1"/>				   		
				   </td>
				   <td class="separador"></td>
				   <td class="label"><label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label></td>
				   <td>
				   		<input type="text" id="clienteID" name="clienteID" size="12" tabindex="2" autocomplete="off"/>
				   		<input type="text" id="nombreCompleto" name="nombreCompleto" size="50"  readonly="true" disabled="disabled"/>
				   </td>
				</tr>			
				<tr>  
				  <td class="label" nowrap="nowrap"><label for="lblCuentaAhoID">Cuenta: </label></td>
				   <td nowrap="nowrap">			   		
				   		<input type="text" id="cuentaAhoID" name="cuentaAhoID" size="25" tabindex="3" autocomplete="off"/>				   		
				   </td>
				   <td class="separador"></td>
				   <td class="label" nowrap="nowrap"><label for="lblTelefono">Tel&eacute;fono: </label></td>
				   <td>
				   		<input type="text" id="telefono" name="telefono" maxlength="15" size="15" readonly="true" disabled="disabled"/>				   		
				   </td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="registroPDM">Registro PDM:</label>
					</td>
					<td nowrap="nowrap">
						<select id="registroPDM" name="registroPDM"  tabindex="4">
							<option value="S">SI</option>
							<option value="N">NO</option>
						</select>
					</td>
					
				</tr>
			</table>	
			<table border="0" width="100%">			
				<tr>
					<td>
						<input type="hidden" id="datosGridPreguntas" name="datosGridPreguntas" size="100" />	
						<div id="gridPreguntasSeguridad" name="gridPreguntasSeguridad" style="display: none;">
						</div>	
					</td>	
				</tr>
				<tr id = "btnGuardar">
				<td align="right">
					<input  type="submit" id="guardar" name="guardar" class="submit" value="Guardar" tabindex="50"  />
				</td>
				
				</tr>
			</table>
			<br>				
			<div id="altaPIN" style="display: none;">
				<fieldset class="ui-widget ui-widget-content ui-corner-all" >
				<legend>Especificaciones</legend>
					<table border="0" width="100%">							
						<tr>  
							<td class="label" nowrap="nowrap"><label for="lblPIN">NIP: </label></td>
							<td nowrap="nowrap">
					   			<input type="password" id="nip" name="nip" size="12" tabindex="51" autocomplete="new-password"/>				   		
					  		</td>
						   	<td class="separador"></td>
						   	<td class="label" nowrap="nowrap"><label for="lblCPIN">Confirmar NIP: </label></td>
						   	<td nowrap="nowrap">
					   			<input type="password" id="cnip" name="cnip" size="12" tabindex="52" autocomplete="new-password"/>				   		
					  		</td>										
						</tr>					
					</table>

				</fieldset>
			</div>		
				
			<table>
				<tr>
					<td><input type="hidden" id="datosGrid" name="datosGrid" size="100" />
						<div id="gridUsuariosPDM"
							style="width: 580px; height: 60px; overflow-y: none; display: none;"></div>
					</td>
				</tr>
			</table>
			
			<div id="usuarioPDM" style="width: 200px; height: 60px; display: none;">
				<fieldset class="ui-widget ui-widget-content ui-corner-all" >
				<legend class="ui-widget ui-widget-header ui-corner-all">Usuario  Autoriza</legend>
					<table border="0" width="100%">							
						<tr>  					   
						   	<td class="label" nowrap="nowrap"><label for="lblNICK">NICK: </label></td>
						   	<td nowrap="nowrap">
					   			<input type="text" id="admin" name="admin" size="12" tabindex="53"/>						   		
					   			<!-- Campos falsos, son una solución para el relleno automático de chrome -->				   			
					   			<input style="visibility: hidden;" type="password" id="usufalse" name="usufalse" size="2"/>						   				   		
					  		</td>					  					  									
						</tr>										
						<tr>
							<td class="label" nowrap="nowrap"><label for="lblPINU">PIN: </label></td>
							<td nowrap="nowrap">								
					   			<input type="password" id="nipadmin" name="nipadmin" size="12" tabindex="54" autocomplete="new-password"/>				   		
					  		</td>								
						</tr>					
					</table>				
				</fieldset>
			</div>					
			
			
			<table align="right">		
			<tr>		
				<td align="right">
					<table align="right" border='0'>
						<tr align="right">					
							<td align="right">
							  <a target="_blank" >
								<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="55"/>
								<input type="submit" id="bloquear" name="bloquear" class="submit" value="Bloquear" tabindex="56"/>
								<input type="submit" id="desbloquear" name="desbloquear" class="submit" value="Desbloquear" tabindex="57"/>	
								<input type="button" id="contrato" name="contrato" class="submit" value="Contrato" tabindex="58"/>	
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>					
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
								<input type="hidden" id="usuarioPDMID" name="usuarioPDMID"/>			             		 
			                  </a>
							</td>
						</tr>
					</table>		
				</td>
			</tr>
			</table>
		</form:form>
	</fieldset>	
</div>
<div id="cargando" style="display: none;">	
</div>				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>	
<div id="mensaje" style="display: none;"/>
</html>
