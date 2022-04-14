<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/periodoContableServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
	<script type="text/javascript" src="js/arrendamiento/cargaDepositoArrenda.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form method="POST" commandName="depRefereArrenda" enctype="multipart/form-data" name="formaGenerica" id="formaGenerica">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Carga Archivo Dep&oacute;sito Referenciado</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<table border="0"  width="100%">
								<tr>
								    <td class="label">
								        <label for="institucion">Instituci&oacute;n: </label> 
								    </td>
								    <td >
								        <input type="text" id="institucionID" name="institucionID"  size="24" tabindex="1" autocomplete="off" />
								        <input type="text" id="nombreInstitucion" name="nombreInstitucion" tabindex="2" size="50" disabled="true" readOnly="true"/> 
								    </td>                                            
								</tr>         
								<tr>
								    <td class="label">
								        <label for="cuentaBan">Cuenta Bancaria: </label> 
								    </td>
								    <td>
								    	<input type="text" id="cuentaBancaria" name="cuentaBancaria"  size="24" tabindex="3" autocomplete="off"/>
								    	<input type="hidden" id="cuentaAhoID" name="cuentaAhoID"  size="20" value="s" />
								        <input type="text" id="nombreBanco" name="nombreBanco" tabindex="4" size="50" disabled="true" readOnly="true"/> 
								    </td>
								</tr>
							</table>
							</fieldset>
						</td>
					</tr>			
					<tr>
						<td colspan="3">
							<br/>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend class="label"><label>Rango de Fechas:</label></legend>	
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr> 
									<td class="label"> 
										<label for="lblFechaCarga">Fecha Inicial:</label> 
								   	</td> 
									<td> 
										<form:input type="text" id="fechaCargaInicial" name="fechaCargaInicial"  size="14" tabindex="6" 
											    		path="fechaCargaInicial" esCalendario="true"/> 
									</td>
									<td class="separador"></td>
									<td class="label"> 
										<label for="lblFechaCarga">Fecha Final:</label> 
									</td> 
									<td> 
									  	<form:input type="text" id="fechaCargaFinal" name="fechaCargaFinal"  size="14" tabindex="6" 
											path="fechaCargaFinal" esCalendario="true"/> 
								   </td> 
								</tr>
							</table>
							</fieldset>
						</td>	
					</tr>
					<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td align="right">									
										<input type="button" id="enviar" name="enviar" class="submit" value="Enviar Archivo" tabindex="11" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" />
	</div>
	
</body>
<div id="mensaje" style="display: none;" />
</html>
