<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
<title>Consulta Registros Pademobile</title>	
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasBCAMovilServicio.js"></script>
	<script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosPDMServicio.js"></script> 
	<script type="text/javascript" src="js/cliente/consultaRegBCAMovilPDM.js"></script>
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
	<legend class="ui-widget ui-widget-header ui-corner-all">Consulta Registros <label id="nombreServicio"></label></legend>	
		<form:form id="formaGenerica" name="formaGenerica" commandName="cuentasBCAMovilBean">
			<table border="0" width="100%">	
				<tr>
					<td class="label" nowrap="nowrap"><label for="lblTipoBusqueda">Tipo de Búsqueda: </label></td>
					<td>
				   		<select id="tipoBusqueda" name="tipoBusqueda" tabindex="1">
				   			<option value="1" selected>SELECCIONAR</option>
							<option value="2">NOMBRE CLIENTE</option>
				     		<option value="3">NÚMERO TELÉFONO</option>				     		
						</select>			   		
				   	</td>
				   	<td class="label" style="text-align: right;"><label	for="lblFecha">Fecha: </label></>
					<td>						
						<input type="text" id="fecha" name="fecha" size="12" iniForma="false" disabled="true" readonly="true" style="text-align: right;"/>
					</td>
				</tr>						
				<tr>  				 
				   <td class="label" nowrap="nowrap"><label for="lblClienteID">Socio : </label></td>
				   <td nowrap="nowrap">
				   		<input type="text" id="clienteID" name="clienteID" size="12" readonly="true" disabled="disabled" tabindex="2"/>
				   		<input type="text" id="nombreCompleto" name="nombreCompleto" size="50"  readonly="true" disabled="disabled"/>
				   </td>
				</tr>	
				<tr>
					<td class="label" nowrap="nowrap"><label for="lblFechaInicial">Fecha Inicial : </label></td>
					<td>
						<input type="text" id="fechaInicial" name="fechaInicial" size="12" escalendario="true" tabindex="3"/>
					</td>
				</tr>	
				<tr>
					<td class="label" nowrap="nowrap"><label for="lblFechaFinal">Fecha Final : </label></td>
					<td>
						<input type="text" id="fechaFinal" name="fechaFinal" size="12" escalendario="true" tabindex="4"/>
					</td>
				</tr>	
				<tr>
					<td align="right" colspan="4">
						<input type="button" id="buscar" name="buscar" value="Buscar" class="submit" tabindex="5">
					</td>
				</tr>					
			</table>
				
			<table>
				<tr>
					<td><input type="hidden" id="datosGrid" name="datosGrid"
						size="100" />
						<div id="gridUsuariosPDM"
							style="width: 685px; height: 380px; overflow-y: scroll; display: none;"></div>
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