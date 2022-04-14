<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html> 
	<head>	
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
	   	<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/calendarioMinistracionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catFrecuenciasServicio.js"></script>
       	<script type="text/javascript" src="js/fira/calendarioMinistraciones.js"></script>    
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="calendarioMinistra">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Calendario de Desembolso por Prod. de Cr&eacute;dito</legend>
			<table border="0" width="100%">
				<tr>
					<td class="label"> 
		         		<label for="lblProducto">Producto de Cr&eacute;dito: </label> 
		     		</td> 
		     		<td colspan="4"> 
		         		<form:input id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="6" 
		         			tabindex="2" />
		         		<input type= "text" id="descripProducto" name="descripProducto"size="45" type="text" 
		         			readonly="true"  />
		     		</td> 
				</tr>
				<tr>
				   <td class="label"> 
						<label for="tomaFechaInhabilSig">En Fecha Inh&aacute;bil Tomar: </label> 
				   </td>
		     		<td class="label">  
						<form:radiobutton id="tomaFechaInhabilSig" name="tomaFechaInhabil" path="tomaFechaInhabil" value="S" tabindex="4" checked="checked" />
							<label for="tomaFechaInhabilSig">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
						<form:radiobutton id="tomaFechaInhabilAnt" name="tomaFechaInhabil" path="tomaFechaInhabil" value="A" tabindex="5"/>
							<label for="tomaFechaInhabilAnt">D&iacute;a H&aacute;bil Anterior</label>
					</td>
		     		<td class="separador"></td>
					<td class="label" id="lblIrregular"> 
		 				<label for="permiteCalIrregularSi">Permite Calendario Irregular: </label> 
					</td>
		     		<td class="label" id="radioIrregular">
						<input type="radio" id="permiteCalIrregularSi" name="permiteCalIrregular" path="permiteCalIrregular" value="S" tabindex="10" checked="checked" />
						<label for="permiteCalIrregularSi">Si</label>&nbsp;
						<input type="radio" id="permiteCalIrregularNo" name="permiteCalIrregular" path="permiteCalIrregular" value="N" tabindex="11" />
						<label for="permiteCalIrregularNo">No</label>
					</td>
				</tr> 
		 		<tr> 
		 			<td class="label"> 
		 				<label for="diasCancelacion">D&iacute;as Cancelací&oacute;n Ministrac&oacute;n: </label> 
					</td>
		     		<td class="label">  
						<form:input type="text" id="diasCancelacion" name="diasCancelacion" path="diasCancelacion" value="" tabindex="12" />
					</td>
		     		<td class="separador"></td>
		 			<td class="label" nowrap="nowrap">
		 				<label for="diasMaxMinistraPosterior">D&iacute;as M&aacute;x. Desembolso Posterior: </label> 
					</td>
		     		<td class="label">  
						<form:input type="text" id="diasMaxMinistraPosterior" name="diasMaxMinistraPosterior" path="diasMaxMinistraPosterior" value="" tabindex="13" />
					</td>
				</tr> 
				<tr> 
					<td>
			     		<label for="tipoCancelacion">Tipo Cancelaci&oacute;n Ministrac&oacute;n: </label> 
					</td>
					<td> 
			     		<select id="tipoCancelacion" name="tipoCancelacion" path="tipoCancelacion" tabindex="14">
			     			<option value="">SELECCIONAR</option>
			     			<option value="U">&Uacute;ltimas Cuotas</option>
					      	<option value="I">Cuotas Siguientes Inmediatas</option>
							<option value="V">Prorrateo Cuotas Vigentes</option>
					     </select>
					 </td>
				</tr> 
				<tr> 
		 			<td class="label">
						<label for="frecuencias">Frecuencias: </label> 
					</td>
		   			<td> 
		   				<select MULTIPLE id="frecuencias" name="frecuencias" path="frecuencias" tabindex="15" size="11">
				     		<option value="S">SEMANAL</option>
				     		<option value="D">DECENAL</option>
				     		<option value="C">CATORCENAL</option>
							<option value="Q">QUINCENAL</option> 
							<option value="M">MENSUAL</option>
							<option value="B">BIMESTRAL</option>
							<option value="T">TRIMESTRAL</option>
							<option value="R">TETRAMESTRAL</option>
							<option value="E">SEMESTRAL</option>
							<option value="A">ANUAL</option>
							<option value="P">PERIODO</option>
							<option value="U">PAGO &Uacute;NICO</option>
					     </select>
					</td>
		     		<td class="separador"></td> 
					<td class="label"> 
				   		<label for="plazos">Plazo: </label> 
				   	</td>   	
				   <td> 
		         	<select MULTIPLE id="plazos" name="plazos" path="plazos" tabindex="16" size="11">
					      </select>	
		     		</td> 
		     	</tr>
				<tr>
					<td colspan="5" align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="26"  />
						<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="27"  />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>				
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
</body>
<div id="mensaje" style="display: none;"></div>
</html>