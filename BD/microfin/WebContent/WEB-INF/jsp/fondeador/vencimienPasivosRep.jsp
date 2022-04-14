<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
     <script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script> 
     <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/creditoFondeoServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	  
      <script type="text/javascript" src="js/fondeador/repVencimientosPasivos.js"></script>  
				
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Vencimientos Pasivos</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
			<tr> 
				<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Parámetros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>
								<td class="label"><label for="creditoID">Fecha de Inicio: </label></td>
								<td >
									<input id="fechaInicio" name="fechaInicio"  size="12" 
					         			tabindex="1" type="text"  esCalendario="true" />	
								</td>					
							</tr>
							<tr>			
								<td class="label"><label for="creditoID">Fecha de Fin: </label></td>
								<td>
									<input id="fechaVencimien" name="fechaVencimien"  size="12" 
					         			tabindex="2" type="text" esCalendario="true"/>				
								</td>	
							</tr>
							<tr>
								<td class="label">
									<label for="institucionFondeo">Instituci&oacute;n : </label>
								</td> 
							   	<td>
									<input id="institutFondID" name="institutFondID"  size="3" tabindex="2" value="0"/>
								 	<input type="text" id="nombreInstitFondeo" name="nombreInstitFondeo" tabindex="3"  size="30" disabled="disabled" value="TODOS"/> 	 	
								</td>
							</tr>
							<tr>
							<td class="label"> 
								<label for="calculoInteres">C&aacute;lculo Inter&eacute;s: </label> 
							</td>
					
							<td>	
								<select id="calculoInt" name="calculoInt"  tabindex="9" >
								<option value="P"> PROYECCI&Oacute;N DE INTER&Eacute;S</option> 
				    			<option value="S">SALDO ACTUAL INTER&Eacute;S </option>
								</select>
							</td>		
							</tr>
  						</table> 
  					</fieldset>  
  				</td>  
      			<td> 
					<table width="200px"> 
						<tr>
							<td class="label" style="position:absolute;top:8%;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pdf" name="generaRpt" value="pdf" />
									<label> PDF </label>
				            		<br>
									<input type="radio" id="excel" name="generaRpt" value="excel">
									<label> Excel </label>
					 			</fieldset>
							</td>      
						</tr>
						<tr>
							<td class="separador"><br></td>
						</tr>
						<tr>
							<td class="label" id="tdPresenacion" style="position:absolute;top:40%;">
								<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend><label>Nivel de Detalle</label></legend>
									<input type="radio" id="detallado" name="presentacion" value="detallado" />
									<label> Detallado </label>
							 	</fieldset>
							</td>
						</tr> 
				 	</table> 
				</td>
         	</tr>
     	</table>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td colspan="4" align="right">
					<a id="ligaGenerar" href="repVencimientosPasivos.htm" target="_blank" >  		 
						<input type="button" id="generar" name="generar" class="submit" 
									 tabIndex = "48" value="Generar" />
					</a>
					<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
					<input type="hidden" id="tipoLista" name="tipoLista" />
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