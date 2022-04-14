<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head> 
	
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catalogoBloqueoCancelacionTarDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineaTarjetaCreditoServicio.js"></script>
		<script type="text/javascript" src="js/tarjetas/repBloqDesbloqTarDeb.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarjetaDebitoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Bloqueo y Desbloqueo de Tarjetas</legend>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
		  		<legend>Parámetros</legend>
				<table>
					<tr>
						<input type="hidden" name="tipoTarjeta" id="tipoTarjeta" value="1">
						<td class="label">
							<label> Tipo de Tarjeta</label>
						</td>
						<td class="label">
							
							<input type="radio" id="tipoTarjetaDeb" name="tipoTarjetaDeb">
							<label> D&eacute;bito</label>
							<input type="radio" id="tipoTarjetaCred" name="tipoTarjetaCred">
							<label> Cr&eacute;dito </label>
						</td>
					</tr>				
					<tr>
						<td class="label" ><label for="lblFechaRegistro">Fecha Inicio:</label>
				        </td>
				 		<td>					
				 			 <input type="text" id="fechaRegistro" name="fechaRegistro" size="12" esCalendario="true" tabindex="1" />	
				 		</td>
						 	<td class="separador"></td> 	
						<td class="label"><label for="fechaFin">Fecha Fin: </label>
					    </td>
					    <td>
				 		 	<input type="text" id="fechaVencimiento" name="fechaVencimiento" size="12" esCalendario="true" tabindex="2" />	
						</td>
					</tr>
					<tr>
						<td class="label" ><label for="mostrar">Estatus:</label>
			       	    </td>
		       		  <td >
						<select id="estatus" name="estatus"  tabindex="3" >
							<option value='0' >TODOS</option>
							<option value='8'>BLOQUEO</option>
							<option value='7'>DESBLOQUEO</option>
						</select>
						</td>				
					 	<td class="separador"></td> 	
					 	<td   class="label">
						  	<label for="TipoTarjetaDebID">Tipo Tarjeta: </label>
				     	</td>			
						<td>
					  		<select id="tipoTarjetaDebID" name="tipoTarjetaDebID"  path="tipoTarjetaDebID" tabindex="4" >
					  			<option value='0'>TODOS</option>
					  		</select>
			   	  	</td>
					</tr>
		     		<tr>
						<td class="label">
							<label for="fecha">Tarjetahabiente: </label>
						</td>
						<td>
							<input type="text" id="clienteID" name="clienteID"  size="15" tabindex="5" />
							<input type="text" id="nombreCompleto" name="nombreCompleto"  readOnly="true" size="50" />	
						</td>
						<td class="separador"></td>
						<td class="label" ><label for="lblNumeroCuenta">Num. Cuenta:</label>
					</td>
					<td>
						<input  type="text" id="cuentaAhoID" name="cuentaAhID"  size="15" tabindex="6" />
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="mostra">Motivo:</label>
					</td>
			 		<td>
						<select id="motivoBloqID" name="motivoBloqID"  path="motivoBloqID" tabindex="7" >
							<option value='0'>TODOS</option>
					  	</select>
					</td>
				</tr>
	 		</table>
		</fieldset>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="right">
					<a id="ligaGenerar" href="ReporteBloqDesbloqTarDeb.htm" target="_blank">
						<button type="button" class="submit" id="generar" tabindex="8" >Generar</button>
					</a>
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
</body>
<div id="mensaje" style="display: none;"></div>
</html>