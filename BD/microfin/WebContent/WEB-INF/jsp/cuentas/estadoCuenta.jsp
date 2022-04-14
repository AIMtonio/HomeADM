<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>

	<head>	
 		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js">		</script>     
 	   <script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js">		</script> 
 	   <script type="text/javascript" src="dwr/interface/clienteServicio.js">			</script>
 	   <script type="text/javascript" src="dwr/interface/monedasServicio.js">			</script>        

	   <script type="text/javascript" src="js/cuentas/consultaSaldoCuenta.js"></script>
	      
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasAhoBean"> 
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Estado de Cuenta</legend> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Datos del <s:message code="safilocale.cliente"/></legend>	
				<table border="0" cellpadding="0" cellspacing="0" width="100%">    	
					<tr>	   	
				     	<td class="label" > <label for="lblNombreCliente"><s:message code="safilocale.cliente"/>: </label> </td> 
				     	<td> 
				        	<input  type="text" id="numCliente" name="numCliente" size="12" iniForma = 'false' tabindex="1" />
				        	<input id="nombreCliente" name="nombreCliente"size="50" iniForma = 'false'  type="text" readOnly="true" disabled="true" />
				     	</td> 		
					</tr>  	
					<tr>
						<td>
							<label for="anio">A&ntilde;o: </label>
							<select name="anio" id="anio">
								<option  value="2010">2010</option>
								<option  value="2011">2011</option>
								<option  value="2012" selected="selected">2012</option>
							</select>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<label for="mes">Mes: </label>
							<select name="mes" id="mes">
								<option value="01">Enero</option>
								<option value="02">Febrero</option>
								<option value="03">Marzo</option>
								<option value="04">Abril</option>
								<option value="05" selected="selected" >Mayo</option>
								<option value="06">Junio</option>
								<option value="07">Julio</option>
								<option value="08">Agosto</option>
								<option value="09">Septiembre</option>
								<option value="10">Octubre</option>
								<option value="11">Noviembre</option>
								<option value="12">Diciembre</option>
							</select>
						</td>
						<td>&nbsp;</td>
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
					<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td align="right">
										<a id="enlaceEdoCta" href="Archivos/EstadosCuenta/Cliente0000001/EdoCtaMicroFin2.pdf" target="_blank">
		                     				<button type="button" class="submit" id="imprimirEdo">Imprime</button>
										</a>			
									</td>
								</tr>
							</table>		
						</td>
					</tr>	
				</table>
		</fieldset>   
	</fieldset>   
</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
