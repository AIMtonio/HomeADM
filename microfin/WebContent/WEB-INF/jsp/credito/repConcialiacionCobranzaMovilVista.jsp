<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script> 
	<script type="text/javascript" src="js/credito/conciliacionCobranza.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="conciliacionCobranzaBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Conciliacion de Cobranza Movil</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend><label>Parámetros</label></legend>
								<table border="0"  width="100%">
									<tr>
										<td class="label">
											<label for="fecha">Fecha: </label>
											<input id="fecha" name="fecha" path="fecha" size="12" tabindex="1" type="text"esCalendario="true" />
										</td>
										<td class="label" >
											<label for="asesor">Asesor: </label>
											<select name="asesor" id="asesor" path="asesor" tabindex="4" >
												<option value="0">TODOS</option>
											</select>
										</td>		
									</tr>
									<tr>
										<td>
											<input type="checkbox" id="conciliado" name="conciliado" value="N"/>
											<label for="conciliado"> Mostrar registros conciliados </label>
										</td>
									</tr>

									<tr>
										<td colspan="4">
											<table align="right" border='0'>
												<tr>
													<td >
														<input type="button" onclick="buscarPagos()" id="buscar" name="buscar" class="submit" tabIndex = "15" value="Buscar" />
														<a id="ligaGenerar" href="ReporteRazonNoPago.htm" target="_blank" > 
															<input type="button" id="exportar" name="exportar" class="submit" value="Exportar" tabindex="15"/>
														</a>
														<input type="submit" id="guardar" name="guardar" class="submit" tabIndex = "15" value="Guardar" />
													</td>
												</tr>			
											</table>		
										</td>
									</tr>
								</table>
							</fieldset>
						<td>
					</tr>
					<tr id="gridConcialiadoPagos">
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>

	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>