<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		  <link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  >      
		  <link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />    
        <script type='text/javascript' src='js/jquery-1.5.1.min.js'></script>
        <script type='text/javascript' src='js/jquery.validate.js'></script>
        <script type="text/javascript" src="js/jquery.blockUI.js"></script>
        <script type="text/javascript" src="dwr/engine.js"></script>
 		  <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
        <script type="text/javascript" src="dwr/util.js"></script>       
        <script type="text/javascript" src="js/forma.js"></script> 
        <script type='text/javascript' src='js/jquery-ui-1.8.13.min.js'></script>              
        <script type="text/javascript" src="js/cliente/sucursalesCatalogo.js"></script>  
		
	</head>
<body>
<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Sucursales</legend>	
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="sucursal">
					
<table cellpadding="0" cellspacing="0" border="0" width="950px">
	<tr>
		<td class="label">
			<label for="numero">Numero: </label>
		</td>
		<td >
			<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="15" tabindex="1" />
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="nombre">Nombre:</label>
		</td>
		<td>
			<form:input id="nombreSucurs" name="nombreSucurs" path="nombreSucurs" tabindex="2"/>
		</td>		
	</tr>

	<tr>
		<td class="label">
			<label for="empresaID">Empresa: </label>
		</td>
		<td >
			<form:input id="empresaID" name="empresaID" path="empresaID" tabindex="3"/>	
			<input type="text" id="empresaDes" name="clave" path="clave" tabindex="4" disabled="true" readOnly="true"/>		
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="tipoSucursal">Tipo de Sucursal</label>
		</td>
		<td>
			<form:input id="tipoSucursal" name="tipoSucursal" path="tipoSucursal" tabindex="5"/>
		</td>		
	</tr>
	<tr>
		<td colspan="5">
			<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="agrega" name="agrega" class="submit" value="Agrega"/>
						<input type="submit" id="modifica" name="modifica" class="submit"  value="Modifica"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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
</body>
<div id="mensaje" style="display: none;"/>
</html>