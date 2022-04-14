<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
	<script type="text/javascript" src="js/inversiones/repHistoricoTasas.js"></script>
</head>
<body>
</br>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Histórico de Tasas</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="historicoTasasInv" target="_blank" >
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<label>Fecha:</label>
					</td>
					<td><form:input type="text" name="fecha" id="fecha" path="fecha"
										 autocomplete="off" esCalendario="true" size="12" tabindex="1" />						
					</td>
					<td colspan="3"></td>
				</tr>				
				<tr>
					<td>
						<label>Tipo Inversión:</label>
					</td>
					<td><form:input type="text" name="tipoInversionID" id="tipoInversionID"
										 path="tipoInversionID" autocomplete="off" size="8" tabindex="2"/>
						<form:input type="text" id="descripcionTipoInversion" name="descripcionTipoInversion"
										path="descripcionTipoInversion" size='40' readOnly="true" class="desplegado"/>										 
					</td>
					<td colspan="3"></td>
				</tr>
				<tr>		
					<td colspan="5">
						</br>
						<table align="left" border='0'>
							<tr>
								<td width="350px">
									&nbsp;					
								</td>								
								<td align="right">
									<input type="submit" id="pantalla" name="pantalla" class="submit"
											 tabindex="7" value="Consultar" />
								</td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</form:form>
	</fieldset>
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>