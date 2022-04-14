<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
					 	<script type="text/javascript" src="js/regulatorios/regulatorioA1713Socap.js"></script>
	</head>
<body>
<div id="contenedorForma" style="
    width: 100%; 
">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="regulatorioA1713">
	
	 		<table border="0" cellpadding="0" cellspacing="0" width="">    	
					<tr>
			<td  class="label">
				<label for="lblFecha">Fecha: </label>
			</td>
			<td >
				<input  id="fecha" name="fecha" path="fecha" size="12" 
         			tabindex="1" type="text"  esCalendario="true" />	

         			    
			</td>	
				<td class="label" colspan="2">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Presentaci&oacute;n</label></legend>
							<table>
								<tbody>
									<tr>
										<td><input type="radio" id="excel" checked="checked" name="tipoRep" tabindex="2"></td><td>
											<label> Excel </label>	</td>
										<td class="separador"> </td> 
										<td><input type="radio" id="csv" name="tipoRep" tabindex="3"></td><td>
											<label> CSV </label>	</td>
										<td class="separador"> </td> 										
									</tr>
								</tbody>
							</table>
						</fieldset>
						</td>
											
		</tr>

			 </table>
			
					<div id="divRegulatorioA1713" style="display: none;"></div>		
					<input type="hidden" id="tipoInstitID" name="tipoInstitID" value="6" />
		
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