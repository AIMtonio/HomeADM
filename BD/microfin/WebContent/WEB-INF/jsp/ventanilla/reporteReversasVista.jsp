<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
    <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/catalogoGastosAntServicios.js"></script>
	  
      <script type="text/javascript" src="js/ventanilla/reporteReversas.js"></script>  
				
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reversasOperCajaBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Reversa de Operaciones de Caja</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="750px">
			<tr> 
				<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Parámetros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>
								<td class="label"><label for="lblfechaIni">Fecha Inicio: </label></td>
								<td >
									<input id="fechaIni" name="fechaIni"  size="12" 
					         			tabindex="1" type="text"  esCalendario="true" />	
								</td>					
							</tr>
							<tr>			
								<td class="label"><label for="lblfechaFin">Fecha Fin: </label></td>
								<td>
									<input id="fechaFin" name="fechaFin"  size="12" 
					         			tabindex="2" type="text" esCalendario="true"/>				
								</td>	
							</tr>
						
							<tr>
								<td>
									<label>Sucursal:</label>
								</td>
								<td colspan="4">
									<select id="sucursal" name="sucursal" path="sucursal" tabindex="3" >
				         			<option value="0">TODAS</option>
					     		 	</select>									 
								</td>
							</tr>
							
							<tr>
								<td class="label">
									<label for="lblcajaID">Caja: </label>
								</td> 
							   	<td>
									<input type="text" id="cajaID" name="cajaID"  size="3" value="0" tabindex="4"/>
								 	<input type="text" id="nombreCaja" name="nombreCaja"  size="30" value="TODAS" readOnly="true" /> 	 	
								</td>
							</tr>
						</table> 
  					</fieldset>  
  				</td>  
  				<td> 
					<table width="200px"> <tr>
				
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
					</table>
				</td>
      		
         	</tr>
     	</table>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td colspan="4" align="right">
					<a id="ligaGenerar" href="repReversasOperCaja.htm" target="_blank" >  		 
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