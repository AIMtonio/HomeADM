<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
 	   <script type="text/javascript" src="dwr/interface/creditosMayorInsolutoPMServicio.js"></script>   
      <script type="text/javascript" src="js/riesgos/creditosMayorInsolutoPM.js"></script>  		
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="mayorSaldoInsolutoPM">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Cr&eacute;ditos Mayor Insoluto P.M.</legend>
		<table border="0" width="100%">
			 <tr> <td>        
          <table  border="0"  width="100%">
				<tr>
					<td class="label"><label for="mes">Mes: </label></td>
					<td><select id="mes" name="mes" tabindex="1">
							<option value="1">ENERO</option>
							<option value="2">FEBRERO</option>
							<option value="3">MARZO</option>
							<option value="4">ABRIL</option>
							<option value="5">MAYO</option>
							<option value="6">JUNIO</option>
							<option value="7">JULIO</option>
							<option value="8">AGOSTO</option>
							<option value="9">SEPTIEMBRE</option>
							<option value="10">OCTUBRE</option>
							<option value="11">NOVIEMBRE</option>
							<option value="12">DICIEMBRE</option>
					</select></td>
					<td class="label"><label for="anio">Año: </label></td>
					<td><select id="anio" name="anio" tabindex="2">
					</select></td>
				</tr>
 			</table> 
 			<table>
	 	    	
	 	    	<tr>	
					<td>
					 	<div id="divCredMayorInsolutoPM" style="display:none"/>
					</td>		
				</tr> 	
	 		</table>
 		</td>  
   		 		 
			<table width="100%">
				<tr>
					<td class="label">
					<label for="">Total 20 Cr&eacute;ditos P/Morales: </label>
					</td>
					<td>
						<input id="totalCreditoPM" name="totalCreditoPM" size="20" type="text" readonly="true" style="text-align: right;" />	
					</td>	
				</tr>
				<tr>
					<td class="label">
					<label for="">Capital Neto del Mes:</label>
					</td>
					<td>
						<input id="capitalNetoMensual" name="capitalNetoMensual" size="20" type="text" readonly="true"  style="text-align: right;" />	
					</td>	
				</tr>
				<tr>
					<td class="label">
						<label for="">Resultado: </label>
					</td>
					<td>
						<input id="resultadoPorcentual" name="resultadoPorcentual" size="20" type="text" readonly="true"  style="text-align: right;"/>	
					</td>			
				</tr>
				<tr>
					<td class="label">
						<label for="">Par&aacute;metro de Porcentaje: </label>
					</td>
					<td>
						<input id="parametroPorcentaje" name="parametroPorcentaje" size="12" type="text" readonly="true" style="text-align: right;"/>
		         		<label> %</label>	
					</td>					
				</tr>
			</table>
   		</tr>
		</table>
		
		<table border="0"  width="100%">	
			<tr>
				<td colspan="4">
					<table align="right" border='0'>
						<tr>
							<td align="right">
							<a id="ligaGenerar" href="credMayorInsolutoPMRep.htm" target="_blank" >  		 
								 <input type="button" id="generar" name="generar" class="submit" tabindex = "3" value="Exportar EXCEL" />
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
