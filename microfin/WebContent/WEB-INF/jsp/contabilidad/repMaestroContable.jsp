<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>	
	<script type="text/javascript" src="js/contabilidad/reporteMaestroContable.js"></script>
	
</head>
<body>
</br>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Maestro Contable</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasContablesBean"
					  target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<label>Concepto:</label>
					</td>
					<td>
						<form:select id="tipoCuenta" name="tipoCuenta" path="tipoCuenta" tabindex="1">
							<form:option value="0">TODAS</form:option>
							<form:option value="1">ACTIVO</form:option>
							<form:option value="2">PASIVO</form:option>
							<form:option value="3">COMPLEMENTARIA DE ACTIVO</form:option>
							<form:option value="4">CAPITAL Y RESERVA</form:option>
							<form:option value="5">RESULTADOS INGRESOS</form:option>
							<form:option value="6">RESULTADOS EGRESOS</form:option>
							<form:option value="7">ORDEN DEUDORA</form:option>
							<form:option value="8">ORDEN ACREDORA</form:option>
						</form:select></td>						
					</td>
					<td colspan="3"></td>
				</tr>
				<tr>
					<td>
						<label>Moneda:</label>
					</td>
					<td>
						<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="2">
							<form:option value="0">TODAS</form:option>
						</form:select></td>
					</td>
					<td colspan="3"></td>
				</tr>				
				<tr>		
					<td colspan="5">
						</br>
						<table align="left" border='0'>
							<tr>
								<td width="350px">
									&nbsp;					
								</td>								
								<td align="right">
								<a id="enlacePantalla" href="MaestroContableRepPDF.htm" target="_blank">
	                     		<button type="button" class="submit" id="pantalla">
	                              Pantalla
	                      		</button>
									</a>
								</td>
								<td align="right">
									<a id="enlaceExcel" href="MaestroContableRepPDF.htm" target="_blank">
	                     		<button type="button" class="submit" id="excel">
	                              Ver Excel
	                      		</button>
									</a>		
								</td>
								<td align="right">
									<a id="enlacePDF" href="MaestroContableRepPDF.htm" target="_blank">
	                     		<button type="button" class="submit" id="pdf">
	                              Ver PDF
	                      		</button>
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
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>