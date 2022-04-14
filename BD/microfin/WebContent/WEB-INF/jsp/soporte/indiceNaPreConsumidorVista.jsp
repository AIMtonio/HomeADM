<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/indiceNaPreConsumidorServicio.js"></script>
      	<script type="text/javascript" src="js/soporte/indiceNaPreConsumidor.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="indiceNaPreConsumidorBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">&Iacute;ndice Nacional de Precios al Consumidor</legend>
					<table>
						<tr>
							<td class="label">
								<label for="anio">Año:</label>
							</td>
							<td>					
								<form:select id="anio" name="anio" path="anio" tabindex="1">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
								<a href="javaScript:" onClick="ayudaRegistro();">
									<img src="images/help-icon.gif" >
								</a> 
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="mes">Mes:</label>
							</td>
							<td>	
								<form:select id="mes" name="mes" path="mes" tabindex="2">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="1">ENERO</form:option>
									<form:option value="2">FEBRERO</form:option>
									<form:option value="3">MARZO</form:option>
									<form:option value="4">ABRIL</form:option>
									<form:option value="5">MAYO</form:option>
									<form:option value="6">JUNIO</form:option>
									<form:option value="7">JULIO</form:option>
									<form:option value="8">AGOSTO</form:option>
									<form:option value="9">SEPTIEMBRE</form:option>
									<form:option value="10">OCTUBRE</form:option>
									<form:option value="11">NOVIEMBRE</form:option>
									<form:option value="12">DICIEMBRE</form:option>
								</form:select>	
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="valorINPC">Valor:</label>
							</td>
							<td>
								<input type="text" id="valorINPC" name="valorINPC" size="16" autocomplete="off" tabindex = "3"  maxlength = "7" />
							</td>
						</tr>
					</table>
					<br>
					<table width="100%">
						<tr>
							<td align="right">
		    					<input type="submit" class="submit" id="grabar" name="grabar" tabindex="3" value="Grabar"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								<input type="hidden" id="existeValor" name="existeValor"/>
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
		<div id="mensaje" style="display: none;"></div>
		<div id="ContenedorAyuda" style="display:none">
		</div>
	</body>
</html>