<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>     
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/esqComAperNominaServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/comApertConvenioServicio.js"></script>       
		<script type="text/javascript" src="dwr/interface/calendarioProdServicio.js"></script>
		<script type="text/javascript" src="js/nomina/esqComAperNomina.js"></script>   
		   
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="esqComAperNominaBean"> 
	<fieldset class="ui-widget ui-widget-content ui-corner-all">              
		<legend class="ui-widget ui-widget-header ui-corner-all">Esquema Comisión por Apertura</legend>            
		<table border="0"  width="100%">
			<tr>
		     <td class="label"> 
		         <label for="institNominaID">Empresa N&oacute;mina:</label> 
		     </td>
		     <td>
		     	<input type="hidden" id="esqComApertID" name="esqComApertID"  size="8" tabindex="1" maxlength="13"  autocomplete="off"/>  
		     	<input type="text" id="institNominaID" name="institNominaID"  size="8" tabindex="1" maxlength="13"  autocomplete="off"/>  
		     </td>
		     <td class="label"> 
		     	<input type="text" id="nombreInstit" name="nombreInstit" size="40"  disabled/>
		     </td>
		     <td class="label"> 
		         <label for="producCreditoID">Producto de Cr&eacute;dito:</label> 
		     </td> 
		     <td colspan="2"> 
		         <select id="producCreditoID" name="producCreditoID"  tabindex="2">
						<option value="">SELECCIONAR</option>
				</select>  
		     </td> 
		 	</tr>
		 	<tr>
				<td class="label">
					<label for="lblReqVerificacion">Esquema por convenio:</label>
				</td>
				<td>
					<form:radiobutton id="manejaEsqConvenioSi" name="manejaEsqConvenio" path="manejaEsqConvenio" value="S" />
					<label for="S">Si</label>
					<form:radiobutton id="manejaEsqConvenioNo" name="manejaEsqConvenio" path="manejaEsqConvenio" value="N" />
					<label for="N">No</label>
				</td>
		 	</tr>
 		   <tr>
 		   <td></td>
 		   <td></td>
 		   <td></td>
 		   <td></td>
				<td align="right">
					<input type="submit" id="grabarEsq" name="grabarEsq" class="submit" value="Grabar" tabindex="100"/>
				</td>
			</tr>	
		</table>
		<br>
<div id="contenedorEsquema" style="display: none;">   
		<fieldset class="ui-widget ui-widget-content ui-corner-all">          
		<legend class="ui-widget ui-widget-header ui-corner-all">Parametrizaci&oacute;n por convenio</legend>  
				<table border="0" cellpadding="0" cellspacing="5">
					<tr>
						<td>
							<input type="button" id="agregarEsquema" name="agregarEsquema" value="Agregar" class="submit" onclick="funcionAgregarNuevoRegistro()" tabindex="3"/>
						</td>
						<td class="separador">
					</tr>
				</table>
				<div id="formaTablaEsquema" style="display: none;"></div>
				<table border="0" width="100%">
					<tr>
						<td align="right">
							<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="100"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						</td>
					</tr>
				</table>
 </fieldset>
</div>
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