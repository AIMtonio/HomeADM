<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/parametrosRiesgosServicio.js"></script>  
		<script type="text/javascript" src="js/riesgos/parametrosRiesgos.js"></script> 
	</head>
<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosRiesgos">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Par&aacute;metros de Riesgos</legend>
					<table border="0"  width="100%">
						<tr>
							<td class="label"> 
								<label for="paramRiesgosID">Par&aacute;metros: </label> 
							</td>
							<td> 
				       			 <form:select id="paramRiesgosID" name="paramRiesgosID" path="paramRiesgosID" type="select" >
									<form:option value=" ">SELECCIONAR</form:option>
								</form:select>       					        	
							</td>							
						</tr>						
		 			</table>
		 			<table border="0"  width="100%">
	 	    			<tr>	
							<td>
					 			<div id="divPorcentajes" style="display:none"/>
							</td>		
						</tr> 					
		 			</table>
					<table border="0"  width="100%">
					<tr>
						<td align="right">
							<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex = "30" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
							<input type="hidden" id="riesgosID" name="riesgosID" size="4" />	
						</td>
					</tr>		
				</table>
				</fieldset>
			</form:form>
		</div>
	<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista" ></div>
</div>
</body>
<div id="mensaje" style="display: none;" ></div>
</html>