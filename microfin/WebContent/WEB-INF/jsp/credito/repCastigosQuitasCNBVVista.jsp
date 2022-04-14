<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>

	<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/reporteCarteraCNBVServicio.js"></script>
	<script type="text/javascript" src="js/credito/repCastigosQuitasCNBV.js"></script>  

</head>

<body>   
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="CarteraCastigosCNBV">

		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend class="ui-widget ui-widget-header ui-corner-all">Castigos y Quitas CNBV</legend>

			<table border="0" cellpadding="0" cellspacing="0" width="600px">
				<tr> 
					<td> 
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>P&aacute;rametros</label></legend>         
							<table  border="0"  width="560px">
								<tr>
									<td class="label">
										<label for="creditoID">Fecha: </label>
									</td>
									<td colspan="4">
										<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" tabindex="1" type="text"  esCalendario="true" />	
									</td>					
									
								</tr>
								<tr>
									<td class="label">
										<label for="sucursal">Sucursal:</label>
									</td>
									<td nowrap="nowrap">
										<input type="text" id="sucursalID" name="sucursalID" size="6" tabindex="2" autocomplete="off" value="" />
										 <input type="text" id="nombreSucursal" name="nombreSucursal" disabled="disabled" size="39" value="" />
									</td>
								</tr>
								<tr>		
									<td>
										<label>Moneda:</label>
									</td>
									<td colspan="4">
										<select name="monedaID" id="monedaID" path="monedaID" tabindex="3" >	 						
											<option value="0">TODAS</option>
										</select>
									</td>
								</tr>
								<tr>
									<td>
										<label for="producCreditoID">Producto de Cr&eacute;dito:</label>
									</td>
									<td colspan="4">
										<input type="text" id="producCreditoID" name="producCreditoID" size="6" tabindex="4" /> <input type="text" id="nombreProducto" name="nombreProducto" disabled="disabled" size="39" />
									</td>
								</tr>
								<tr> 
									<td class="label">
										<label for="promotorInicial">Promotor:</label>
									</td>
									<td colspan="4" >
										<form:input id="promotorID" name="promotorID" path="promotorID" tabindex="5"	size="6" value="0"/>
										<input type="text"id="nombrePromotorI" name="nombrePromotorI" size="39"  disabled= "true" readOnly="true" value="TODOS"/>
									</td>

								</tr>
								<tr>
									<td class="label">
										<label for="sexo"> G&eacute;nero:</label>
									</td>
									<td colspan="4">
										<form:select id="sexo" name="sexo" path="sexo" tabindex="6">
										<form:option value="0">TODOS</form:option>
										<form:option value="M">MASCULINO</form:option>
										<form:option value="F">FEMENINO</form:option>
									</form:select>
								</td>		

							</tr>	
							<tr>
								<td class="label"> 
									<label for="estado">Estado: </label> 
								</td> 
								<td colspan="4"> 
									<form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="7" value="0" /> 
									<input type="text" id="nombreEstado" name="nombreEstado" size="39" tabindex="8" value="TODOS" disabled ="true"  readOnly="true"/>   
								</td> 
							</tr> 

							<tr> 
								<td class="label"> 
									<label for="municipio">Municipio: </label> 
								</td> 
								<td colspan="4"> 
									<form:input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="9" value="0" /> 
									<input type="text" id="nombreMuni" name="nombreMuni" size="39" value="TODOS" tabindex="10" disabled="true"  readOnly="true"/>   
								</td> 
							</tr>
						</table> 
					</fieldset> 
				</td>  
				<td>
					<table width="200px"> 
						<tr>
							<td class="label" style="position:absolute;top:9%;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="excel" name="generaRpt" checked="checked" tabindex="11" value="excel">
									<label> Excel </label>
									<br>
									<input type="radio" id="csv" name="generaRpt" tabindex="12" value="csv" />
									<label> Csv </label>

								</fieldset>
							</td>      
						</tr>
					</table> 
				</td>
			</tr>

		</table>
		
		<table border="0" cellpadding="0" cellspacing="0" width="100%">

			<tr>
				<td colspan="4">
					<table align="right" border='0'>
						<tr>
							<td align="right">


								<a id="ligaGenerar" href="ReporteCastigosQuitasCNBV.htm" target="_blank" >  		 
									<input type="button" id="generar" name="generar" class="submit" 
									tabIndex = "48" value="Generar" />
								</a>

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