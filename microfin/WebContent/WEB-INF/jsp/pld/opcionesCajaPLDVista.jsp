<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 
<html>
	<head>		
		<script type="text/javascript" src="dwr/interface/opcionesPorCajaServicio.js"></script> 
     	 <script type="text/javascript" src="js/pld/opcionesCajaPLD.js"></script>     
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="opcionesPorCaja">

<fieldset class="ui-widget ui-widget-content ui-corner-all">	
	<legend class="ui-widget ui-widget-header ui-corner-all">Operaciones de Ventanilla Sujetas a PLD</legend>
		
		<table id="tablaOpcionescaja" border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label">
					<label>Seleccionar Todo:</label>
					<input type="checkbox" id="seleccionaTodos" name="seleccionaTodos" tabindex="2">
				</td>
				<td>					
				</td>
				<td class ="separador"></td>
				<td></td>
			</tr>
		</table>
	<table border="0">	
		<tr><td width="2%"></td>
			<td>
				<div id="gridOperaciones">
					<fieldset class="ui-widget ui-widget-content ui-corner-all" >
						<legend class="label">Operaciones</legend>		
							<input type="hidden" id="lisOperaciones" name="lisOperaciones" />
								<table id="tablaOperaciones" border="0" cellpadding="0" cellspacing="0" width="100%">	
								</table>
					</fieldset>
				</div>				
			</td>
			<td width="2%"></td>
		</tr>
	</table>
	
	
	<table width="100%">
		<tr>
			<td align="left">
				<td class="label">
					<div class="label">
						<label style="width: 520px; text-align:justify; display: inline-block;">&emsp;
							<b>*</b>&nbsp;Requiere Identificación Simplificada del <s:message code="safilocale.cliente"/>.
							&emsp;
							<b>**</b>&nbsp;Requiere Escalamiento Interno.
						</label>
					</div>
				</td>
			</td>
			<td align="right">		
				<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar" tabindex="47"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="listaOpcionesPLD" name ="listaOpcionesPLD" />
			</td>
		</tr>		
	</table>
 </fieldset>		
</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>