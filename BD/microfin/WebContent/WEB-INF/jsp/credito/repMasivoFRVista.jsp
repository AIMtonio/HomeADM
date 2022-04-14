<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
  <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
  		      
      <script type="text/javascript" src="js/credito/reporteMasivoFR.js"></script>  
				
	</head>
       
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Masivo de Financiera Rural</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="250px">
				<tr>
					<td class="label">
						<label for="creditoID">Fecha: </label>
					</td>
					<td >
						<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" 
		         			tabindex="3" type="text"  esCalendario="true" />	
					</td>					
								
				</tr>

			</table>

 <br>			<table>	
				<tr>
				
					
					<td class="label">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n</label></legend>
					 		
							<input type="radio" id="aTxt" name="radioGenera" value="aTxt" />
							<label> txt </label><br>

					
							<input type="radio" id="excel" name="radioGenera" value="excel" />
						<label> Excel </label>
					
						</fieldset>
					</td>
				</tr>
				
		</table>
				<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
				<input type="hidden" id="tipoLista" name="tipoLista" />
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">

									<a id="ligaGenerar" href="ReporteMasivoFR.htm" target="_blank" >  		 
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