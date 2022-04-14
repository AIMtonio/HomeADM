<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="application/json"%> 
<%@page pageEncoding="UTF-8"%>

<html>

<head>
    <script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/seguimientoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/segtoRecomendasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/segtoResultadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/segtoRealizadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/segtoManualServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/segtoMotNoPagoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/segtoOrigenPagoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/resultadoSegtoCobranzaServicio.js"></script>		
	<script type="text/javascript" src="js/seguimiento/repSegtoCampo.js"></script>
	<script type="text/javascript" src="js/soporte/gcoordinate.js"></script>
	<script type="text/javascript" src="js/soporte/gcoorMain.js"></script>	
</head>
<body>
	<div id="contenedorForma">
		<form id="formaGenerica" name="formaGenerica" method="post"  
		action="https://www.googleapis.com/coordinate/v1/teams/6YQHJETkADtAdh8OhsDL4g/jobs">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Seguimiento de Campo</legend>			
				<table border="0" cellpadding="0" cellspacing="0" >
					<tr>
	 					<td class="label" nowrap="nowrap">
							<label for="lblsegtoProgra">Fecha Inicio: </label>
						</td>
						<td colspan="">
							<input type="text" id="fechaInicio" name="fechaInicio"  tabindex="" esCalendario="true"/>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblcreditoID">Fecha Fin: </label>
						</td>
						<td colspan="">
						    <input type="text" id="fechaFin" name="fechaFin"  tabindex="" esCalendario="true"/>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblCategoria">Categoria: </label>
						</td>
						<td colspan="4">
							<select id="categoriaID" name="categoriaID"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblPlaza">Plaza:</label>
						</td>
						<td>
							<select id="plazaID" name="plazaID"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblSucursal">Sucursal:</label>
						</td>
						<td>
							<select id="sucursalID" name="sucursalID"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblProducto">Producto de Credito:</label>
						</td>
						<td>
							<select id="prodCreditoID" name="prodCreditoID"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblGestor">Gestor:</label>
						</td>
						<td>
							<select id="gestorID" name="gestorID"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblSupervisor">Supervisor:</label>
						</td>
						<td>
							<select id="supervisorID" name="supervisorID"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblResultados">Resultados:</label>
						</td>
						<td>
							<select id="resultadoID" name="resultadoID"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblRecomendacion">Recomendacion:</label>
						</td>
						<td>
							<select id="recomendacionID" name="recomendacionID"></select>
						</td>
					</tr>
				</table>	
				<table align="right" border='0'>
					<tr>
						<!--td>
							<a id="ligaGenerar" href="segtoCampoRep.htm" target="_blank" >
								<input type="button" id="generar" name="generar" class="submit" tabIndex= "" value="Generar" />
							</a>
						</td-->
						<td>
							<!--input type="text" id="code" name="code" value="4/1oryxaYrVzHh6gfHyrtB5GlNrhW7.okeJWPpMQZAYmmS0T3UFEsMEtmRzgwI" />
							<input type="text" id="client_id" name="client_id"  value="1098697867702-bu4nh43o3fdmsrq7hnjvuefr0u38t1ec.apps.googleusercontent.com" />
							<input type="text" id="client_secret" name="client_secret" value="avfFxPLEt0_E6txsGE5vvfC4" />
							<input type="text" id="redirect_uri" name="redirect_uri" value="https://localhost/oauth2callback" />
							<input type="text" id="grant_type" name="grant_type" value="authorization_code" /-->

							<input type="text" id="address" name="address" value="747+6th+St+S%2C+Kirkland+WA+98033" />
							<input type="text" id="lat" name="lat"  value="47.670188" />
							<input type="text" id="lng" name="lng" value="-122.196335" />
							<input type="text" id="title" name="title" value="Mantenimiento SAFI" />
							<input type="text" id="assignee" name="assignee" value="corpsandy@cordinategrp.mygbiz.com" />
							<input type="text" id="customerName" name="customerName" value="Google+Kirkland" />
							<input type="text" id="customerPhoneNumber" name="customerPhoneNumber" value="951456456" />
							<input type="text" id="note" name="note" value="Try+the+climbing+wall!" />							
							<input type="text" id="key" name="key" value="AIzaSyDIU-qet8e1LUTBdlaVM2Yt4KQk2KaClEc" />						

							<input type="button" id="abrir" name="abrir" class="submit" value="Abrir" />
						</td>
					</tr>
				</table>
			</fieldset>
		</form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display:none;"></div> 
</html>