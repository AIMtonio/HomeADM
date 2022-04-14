<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
      
 	   <script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>   
 	   <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
 	   <script type="text/javascript" src="dwr/interface/rompimientoGrupoServicio.js"></script>   
 	   <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script> 
		      
      <script type="text/javascript" src="js/credito/rompimientoGrupoRep.js"></script>  
				
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="rompimientoGrupoBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Rompimientos</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="600px">
			 <tr> <td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
          <table  border="0"  width="560px">
				<tr>
					<td class="label">
						<label for="lblFechaInicio">Fecha de Inicio: </label>
					</td>
					<td>
						<input id="fechaInicio" name="fechaInicio" size="12" 
		         			tabindex="1" type="text"  esCalendario="true" />	
					</td>					
				</tr>
				<tr>			
					<td>
						<label for="lblFechaFin">Fecha de Fin: </label> 
					</td>
					<td>
						<input id="fechaVencimiento" name="fechaVencimiento" size="12" 
		         			tabindex="2" type="text" esCalendario="true"/>				
					</td>	
				</tr>
				<tr>  
		     		<td class="label"> 
		         		<label for="lblgrupoID">Grupo:</label> 
					</td> 		     		
		     		<td>
		         	 <input id="grupoID" name="grupoID" size="12" tabindex="3"/> 
		         	 <input type="text" id="nombreGrupo" name="nombreGrupo" size="50" readOnly="true" />  
		     		</td> 	 
		 		</tr>
				<tr>
					<td class="label"> 
		         		<label for="lblSucursal">Sucursal: </label> 
		     		</td> 
			     	<td> 
			         	<input id="sucursalID" name="sucursalID" size="12" tabindex="4" /> 
			         	<input type="text" id="nombreSucursal" name="nombreSucursal" size="50"  readOnly="true"/>   
			     	</td> 
 				</tr> 
 				<tr>
					<td class="label"> 
		         		<label for="lblUsuario">Usuario: </label> 
		     		</td> 
			     	<td> 
			         	<input id="usuarioID" name="usuarioID" size="12" tabindex="5" /> 
			         	<input type="text" id="nombreUsuario" name="nombreUsuario" size="50"  readOnly="true"/>   
			     	</td> 
 				</tr> 
 			</table> 
 		</fieldset>
 		</td>  
				<td>
					 <table width="200px"> 
				<tr>
					<td class="label" style="position:absolute;top:9%;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n</label></legend>
							<input type="radio" id="pdf" name="generaRpt" value="pdf" />
							<label> PDF </label>			 	
					</fieldset>
					</td>      
				</tr>			 
					</table> 
				</td>
   			 </tr>
		</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">	
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
									<a id="ligaGenerar" href="rompimientoGrupoRep.htm" target="_blank" >  		 
										 <input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "6" value="Generar" />
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