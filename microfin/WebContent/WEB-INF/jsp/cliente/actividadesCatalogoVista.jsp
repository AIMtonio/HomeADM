
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  >		
		<script type='text/javascript' src='js/jquery.js'></script>
		<script type='text/javascript' src='js/jquery.validate.js'></script>
		<script type="text/javascript" src="js/jquery.blockUI.js"></script>	
		<script type="text/javascript" src="js/forma.js"></script>
		
		<script type="text/javascript" src="dwr/engine.js"></script>
		<script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>																		  
		<script type="text/javascript" src="dwr/util.js"></script>						
		<script type="text/javascript" src="js/cliente/actividadesCatalogo.js"></script>		
		
	</head>
<body>
<div id="encabezadoOpcion" ></div>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="actividadBMX">
					
<table cellpadding="0" cellspacing="0" border="0" width="950px">
	<tr>
		<td class="label">
			<label for="actividadBMXID">ActividadBMXID: </label>
		</td>
		<td >
			<form:input id="actividadBMXID" name="actividadBMXID" path="actividadBMXID" size="15" tabindex="1" />
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="descripcion">Descripcion:</label>
		</td>
		<td>
			
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