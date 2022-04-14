<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/repSaldoBancosCCServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script> 
	<script type="text/javascript" src="js/tesoreria/repSaldoBancosCC.js"></script>

</head>
<body>
<br>

<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repSaldoBancosCCBean"  target="_blank">
		<fieldset class="ui-widget ui-widget-content ui-corner-all" >
			<legend class="ui-widget ui-widget-header ui-corner-all">Saldo en Bancos por CC</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">  
						<legend><label>Parámetros</label></legend>				
						<table width="100%">
							<tr>
								<td><label>Fecha:</label></td>
								<td><form:input type="text" name="fecha" id="fecha" path="fecha"
								 autocomplete="off" esCalendario="true" size="14" tabindex="1" /></td>
								<td colspan="3"></td>
							</tr>				
						
							<tr><td><label>Institución Bancaria:</label></td>
								<td><form:input type="text" name="institucionID" id="institucionID" path="institucionID" size="5" 
								 tabindex="2" />
								 <form:input type="text" name="desnombreInstitucion" id="desnombreInstitucion" path="desnombreInstitucion" size="57" disabled="true" tabindex="3" />
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td><label>Cuenta Bancaria:</label></td>
								<td><form:input type="text" name="cuentaBancaria" id="cuentaBancaria" path="cuentaBancaria" 
								autocomplete="off" size="12" tabindex="4" />
								 <input type="text" name="nombreSucurs" id="nombreSucurs" size="50" disabled="true" path="nombreSucurs" tabindex="5" />	 
						
								</td>
								
								<td colspan="3"></td>
							</tr>
							<tr>
									<td><label>	Sumarizado </label>
									<input type="radio" id="sumarizado" name="claseReporte"  tabindex="6" /></td>
										
									<td><label> Detallado </label>	
									<input type="radio" id="detallado" name="claseReporte"  tabindex="7" /></td>
							</tr>
						</table>
						</fieldset>
					</td>
					<td>
						<br>
						<table width="110px" >
								<tr>
									<td class="label" style="position: absolute; top:12%;">								
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend><label>Presentación: </label></legend>
											<input type="radio" id="excel" name="tipoReporte"  tabindex="8" />
											<label> Excel </label>																			
										</fieldset>
									</td>
								</tr>
						</table>
					</td>
				</tr>						
			</table>
			<div>
				<table  width="595px">
				<tr>
							<td align="right">
								<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
								<input type="hidden" id="tipoLista" name="tipoLista" />
								<input type="hidden" id="tipoRep" name="tipoRep" />
								<input type="hidden" id="formaRep" name="formaRep" />
								<a id="ligaGenerar" href="/SaldoBancosCCRep" target="_blank" >  		 
									 <input type="button" id="generar" name="generar" class="submit"  tabIndex = "9"  style="" value="Generar"/>
									
								</a>
							</td>
				</tr>
				</table>
		</div>		
		</fieldset>			
	</form:form>
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>