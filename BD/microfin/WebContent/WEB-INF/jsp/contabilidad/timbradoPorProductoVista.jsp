<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
   	<script type="text/javascript" src="dwr/interface/timbradoPorProductoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/frecTimbradoProducServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
    <script type="text/javascript" src="js/contabilidad/timbradoPorProductoVista.js"></script>
    <title>Generación de Estado de Cuenta por Producto</title>
</head>

<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="timbradoPorProductoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Generación de Estado de Cuenta por Producto</legend>
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget"></legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
			<td class="label">
				<label for="observacion">Tipo Generación</label>
				</td>
				<td class="separador"></td>
			<td>
				<input id="tipoGeneracion" name="tipoGeneracion" type="radio" value="M">
				<label for="observacion">Mensual</label>
				<input id="tipoGeneracion1" name="tipoGeneracion" type="radio" value="S">
				<label for="observacion">Semestral</label>
				</td>
				<input type="hidden" id="mesInicioGen" name="mesInicioGen" value="" size="16"/>
    			<input type="hidden" id="mesFinGen" name="mesFinGen" value="" size="16"/>
			</tr>
	</table>
</fieldset>
<br>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td class="label">
        	<label for="observacion">Año</label>
     	</td>
    	<td>
    		<select id="anio" name="anio">
			</select>
      	</td>
      	<td class="separador"></td>
      	<td class="label mes">
        	<label for="observacion">Mes</label>
     	</td>
      	<td class="mes">
    		<select id="mes" name="mes">
				<option value="">SELECCIONAR</option>
				<option value="01">Enero</option>
			    <option value="02">Febrero</option>
			    <option value="03">Marzo</option>
			    <option value="04">Abril</option>
			    <option value="05">Mayo</option>
			    <option value="06">Junio</option>
			    <option value="07">Julio</option>
			    <option value="08">Agosto</option>
			    <option value="09">Septiembre</option>
			    <option value="10">Octubre</option>
			    <option value="11">Nobiembre</option>
			    <option value="12">Diciembre</option>
			</select>
      	</td>
      	<td class="label semestre">
        	<label for="semestre">Semestre</label>
     	</td>
      	<td  class="semestre">
    		<select id="semestre" name="semestre">
				<option value="">SELECCIONAR</option>
				<option value="1">1</option>
			    <option value="2">2</option>
			</select>
      	</td>

   </tr>
   <tr class="semestre1">
   		<td class="label semestre1">
        	<label for="observacion">Mes Inicio</label>
     	</td>
    	<td class="semestre1">
    		<input type="text" id="mesEnero" value="Enero" disabled="true" size="16"/>
      	</td>
      	<td class="separador"></td>
      	<td class="label semestre1">
        	<label for="observacion">Mes Fin</label>
     	</td>
    	<td class="semestre1">
    		<input type="text" id="mesJunio" value="Junio" disabled="true" size="16"/>

      	</td>
   </tr>
   <tr class="semestre2">
   		<td class="label semestre2">
        	<label for="observacion">Mes Inicio</label>
     	</td>
    	<td class="semestre2">
    		<input type="text" id="mesJulio"  value="Julio" disabled="true" size="16"/>
      	</td>
      	<td class="separador"></td>
      	<td class="label semestre2">
        	<label for="observacion">Mes Fin</label>
     	</td>
    	<td class="semestre2">
    		<input type="text" id="mesDiciembre" name="mesDiciembre" value="Diciembre" disabled="true" size="16"/>
      	</td>
   </tr>

</table>
<br>
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">

		<legend class="ui-widget">Productos</legend>
		<tr>
			<input type="button" id="agregarFila" name="agregarFila" class="submit" value="Agregar">
		</tr>
		<tr>
			<table id="miTablaProductos" border="0" cellpadding="0" cellspacing="1" width="100%">
				<tbody>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="anio">Producto</label>
						</td>
						<td class="label" nowrap="nowrap">
							<label for="marca">Descripción</label>
						</td>
					</tr>
				</tbody>

			</table>
		</tr>
	</table>
	</fieldset>

<table align="right">
	<tr>
	   	<td>
       		<input type="submit" id="generaCadena" name="generaCadena" class="submit" value="Generar Cadena"   />
       		<input type="submit" id="timbrar" name="timbrar" class="submit" value="Timbrar"   />
      		<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="" />
      	</td>
	</tr>
</table>

</fieldset>
</form:form>
</div>

<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display:none;"></div>

</html>