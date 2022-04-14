	<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
	<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
	<%@page contentType="text/html"%> 
	<%@page pageEncoding="UTF-8"%>
	<html>	
		<head>    
		   <script type="text/javascript" src="js/regulatorios/contaElecPolizaVista.js"></script>	   
		  
		</head>
		   
		<body>
			<div id="contenedorForma">
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="regulatoriosContabilidadBean"> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Regulatorio Polizas</legend> 
					<table border="0" width="100%">    	
						<tr>	   	
							<td class="label" > 
						        <label for="anio">Año: </label> 
						  	</td>
						 	<td>
								<select id="anio" name="anio" tabindex="1">
								</select>
							</td>	
						</tr>
							
						<tr>	   	
							<td class="label" > 
						         <label for="mes">Mes: </label> 
						  	</td>
						  <td>
								<select id="mes" name="mes" tabindex="2">
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
								</select>
							</td>	
						</tr>
						<tr>	   	
							<td class="label" > 
						         <label for="tipoSolicitud">Tipo de Solicitud: </label> 
						  	</td>
						  <td>
								<select id="tipoSolicitud" name="tipoSolicitud" tabindex="2">
									<option value="">SELECCIONAR</option>
									<option value="AF">ACTO DE FISCALIZACIÓN</option>
									<option value="FC">FISCALIZACIÓN COMPULSA</option>
									<option value="DE">DEVOLUCIÓN</option>
									<option value="CO">COMPENSACIÓN</option>	
								</select>
							</td>	
						</tr>
						<tr>
							<td class="label">
								<label for="numeroOrden">Número de Orden:</label>
							</td>
							<td>
								<input type="text" id="numeroOrden" name ="numeroOrden" size = "15" maxlength="13"	onblur="ponerMayusculas(this), validaNumOrden(this.id)"  tabindex="4">									
								<a href="javaScript:" onClick="ayudanumOrden();">
								  	<img src="images/help-icon.gif" >
								</a>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="numeroTramite">Número de Trámite:</label>
							</td>
							<td>
								<input type="text" id="numeroTramite" name ="numeroTramite" size = "15" maxlength="14" onblur="ponerMayusculas(this),validaNumTramite(this.id)" tabindex="5">							
								<a href="javaScript:" onClick="ayudanumTramite();">
								  	<img src="images/help-icon.gif" >
								</a>
							</td>
						</tr>
						
		
						<tr>
							<td colspan="5" align="right">
								<a id="ligaGenerar" href="generarXmlContaElectro.htm" target="_blank" >  		 
									 <input type="button" id="generar" name="generar" class="submit" tabIndex = "5" value="Generar" />	
								</a>
							</td>
						</tr> 
					</table>
					</fieldset>      
				</form:form>
			</div>
			<div id="cargando" style="display: none;"></div>
			<div id="ContenedorAyuda" style="display: none;">
				<div id="elementoLista"></div>
			</div>
		</body>
		<div id="mensaje" style="display: none;"></div>
	</html>
