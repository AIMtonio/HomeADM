<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="css/template.css" media="screen,print"  />
		<link rel="stylesheet" type="text/css" href="css/menuTree.css" media="screen,print"  />
		<link rel="stylesheet" type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" />
		<link rel="stylesheet" type="text/css" href="css/forma.css" media="all" />
		<script type="text/javascript" src="dwr/engine.js"></script>
 		<script type="text/javascript" src="dwr/util.js"></script>
 		<script type="text/javascript" src="dwr/interface/controlClaveServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script> 		
 		<script type="text/javascript" src="js/jquery-1.5.1.min.js"></script>
 		<script type="text/javascript" src="js/jquery.ui.datepicker-es.js"></script>
		<script type="text/javascript" src="js/jquery-ui-1.8.13.custom.min.js"></script>
		<script type="text/javascript" src="js/jquery-ui-1.8.13.min.js"></script>
		<script type="text/javascript" src="js/jquery.validate.js"></script>
		<script type="text/javascript" src="js/jquery.jmpopups-0.5.1.js"></script>
		<script type="text/javascript" src="js/jquery.blockUI.js"></script>
		<script type="text/javascript" src="js/jquery.hoverIntent.minified.js"></script>	
		<script type="text/javascript" src="js/jquery.plugin.tracer.js" ></script>
 		<script type="text/javascript" src="js/formaPLD.js"             ></script>
 		<script type="text/javascript" src="js/soporte/capturaClaves.js"></script>
 		<script type="text/javascript" src="dwr/interface/companiasServicio.js"></script>	
	</head>
	<body>
		<div id="contenedorForma">
	<label for="desplegado1" style="color:999999;font-size:13px">Origen Datos: </label>
	<select id="desplegado1" name="desplegado1" style="font-size:12px" iniforma="false" >
         <option value="">SELECCIONA</option>
         <br></br><br></br>
     </select>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="controlClaveBean">  
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Captura de Claves Mensual</legend>
					<table>
						<tr>
							<td>
								<label for="cliente">Cliente: </label>
							</td>
							<td>	
								<form:input id="clienteID" name="clienteID" path="clienteID" size="20" readonly="true" />
							</td>
							<td>
								<input id="nombreCliente" name="nombreCliente" size="80" readonly="true" />
							</td>

						</tr>
						<tr>
							<td>
								<label for="lblAnio">Año:</label>
							</td>
							<td>
								<select id="anio" name="anio" tabindex="">
									<option value="">SELECCIONA</option>
								</select>
							</td>
						</tr>
					</table>
					<br>
					<div id="gridClaves"></div>
					<table width="100%">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Guardar" tabindex="" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
								<input type="hidden" id="desplegado" name="desplegado"/>
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