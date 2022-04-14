<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head> 
		<script type="text/javascript"	src="dwr/interface/tarDebMovimientosServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	    <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>  
	    <script type="text/javascript"	src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="js/tarjetas/exportMovsTarCta.js"></script>  

</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarDebMovimientosBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Exportar Movimientos por Cuenta</legend>
	
			
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
		  		<legend>Par&aacute;metros</legend>
				<table>
				  <tr>
				  <tr>
					<tr>
						<td class="label" ><label for="lblFechaInicio">Fecha Inicio: </label>
				        </td >
				 		<td >					
				 			 <input type="text" id="fechaInicio" name="fechaInicio" size="12" esCalendario="true"  tabindex="1" />	
				 		</td >
				 	</tr>

				 	<tr>
						<td   class="label"><label for="lblFechaVencimiento">Fecha Fin:</label>
					    </td>
					    <td>
				 		 	<input type="text" id="fechaVencimiento" name="fechaVencimiento" size="12" esCalendario="true"  tabindex="2" />	
						</td>					
					</tr>
				  </tr>
				  <tr>
                    <tr>
						<td>
							<label>Num Cuenta:</label>
						</td>
						<td>
							<input type="text" id="cuentaAhoID" name="cuentaAhoID"  path="cuentaAhoID" value="0" tabindex="3"  size="17" maxlength="50" />	
							<input type="text" id="tipoCuenta" name="tipoCuenta"  value="TODAS" readOnly="true" size="50"/>									 
						</td>
				
					</tr>
					<tr>
						<td>
							<label>Num Tarjeta:</label>
						</td>
						<td>
							<input type="text" id="tarjetaDebID" name="tarjetaDebID"  size="17"  path="tarjetaDebID"   value="0" tabindex="4" maxlength="50" />
							<input type="text" id="nombreCliente" name="nombreCliente"  value="TODAS" readOnly="true" size="50"/>														 
						</td>
					</tr>	
				   </tr>

					</tr>
	 		</table>
		    </fieldset>
		    <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
				<tr>
					<td align="right">			
						<a id="ligaGenerar" href="reporteExportaMovCtaRep.htm" target="_blank" > 
					<button type="button" class="submit" id="generar" tabindex="4" >Exportar</button> 	
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