<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/impuestoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosDIOTServicio.js"></script>
		<script type="text/javascript" src="js/tesoreria/parametrosDIOT.js"></script>  
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosDIOT">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Par&aacute;metros DIOT</legend>
					<table border="0"  width="100%">
						<tr>
							<td class="label" align="center">
								<label for="lblConcepto"><strong>Impuesto</strong></label> 
							</td>
							<td class="label" align="center">
								<label for="lblImpuestoID"><strong>Clave Impuesto</strong></label> 
							</td>
							<td class="label" align="center">
								<label for="lblDescImp"><strong>Descripci&oacute;n Impuesto</strong></label> 
							</td>
							
						</tr>						
						<tr>
							<td class="label" >
								<label for="lblIVA">IVA: </label> 
							</td>
							<td align="center"> 
								<input  type="text" id="iva" name="iva" size="10" tabindex="1" /> 							 							
						 	</td> 	
						  	<td > 
								<input  type="text" id="descripIVA" name="descripIVA" size="30" value="" disabled="true"/> 							 							
						  	</td>
						</tr>
						<tr>
							<td class="label" >
								<label for="lblRetIVA">Retenci&oacute;n IVA: </label> 
							</td>
							<td align="center"> 
								<input  type="text" id="retIVA" name="retIVA" size="10" tabindex="2" /> 							 							
						 	</td> 	
						  	<td > 
								<input  type="text" id="descripRetIVA" name="descripRetIVA" size="30" disabled="true"/> 							 							
						  	</td>
						</tr>
					</table>						
					<br>
					<table border="0" width="100%">
						<tr>
							<td align="right">
								<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="3" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1"/>						
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
