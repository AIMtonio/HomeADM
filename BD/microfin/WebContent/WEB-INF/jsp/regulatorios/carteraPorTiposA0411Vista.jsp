<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
      
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
        <script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script> 
        <script type="text/javascript" src="dwr/interface/regulatorioInsServicio.js"></script>      
      	<script type="text/javascript" src="js/regulatorios/repCarteraTipoA0411.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Cartera por Tipo Cr&eacute;dito (A-0411) </legend>
    <div id="tblRegulatorio">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="lblFecha">Fecha: </label>
			</td>
			<td >
				<input id="fecha" name="fecha" path="fecha" size="12" 
         			tabindex="3" type="text"  esCalendario="true" />	
			</td>						
		</tr>
		<tr id="version">
			<td class="label" colspan="2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Versi&oacute;n</label></legend>
					<input type="radio" id="año13" name="año13" value="año13" checked="checked">
					<label> 2013 </label>	
					 <br>
				 	<input type="radio" id="año14" name="año14" value="año14">
					<label> 2014 </label>
			</fieldset>
			</td>
		</tr>
		<tr id="div2013">
			<td class="label" colspan="2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentaci&oacute;n</label></legend>
					<input type="radio" id="excel" name="excel" value="excel" checked="checked">
					<label> Excel </label>	
					 <br>
				 	<input type="radio" id="csv" name="csv" value="csv">
					<label> Csv </label>
			</fieldset>
			</td>
		</tr>
		<tr id="div2014">
			<td class="label" colspan="2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentaci&oacute;n</label></legend>
					<input type="radio" id="excel2" name="excel2" value="excel2" checked="checked">
					<label> Excel </label>	
			</fieldset>
			</td>
		</tr>
        <tr id="version2017">
        <td class="label" colspan="2">
        <fieldset class="ui-widget ui-widget-content ui-corner-all">                
            <legend><label>Versi&oacute;n</label></legend>
                <input type="radio" id="anio2017" name="anio2017" value="anio2017" checked="checked">
                <label> 2017 </label>   
        </fieldset>
        </td>
        </tr>
        <tr id="div2017">
            <td class="label" colspan="2">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">                
                <legend><label>Presentaci&oacute;n</label></legend>
                    <input type="radio" id="excel2017" name="excel2017" value="excel2017" checked="checked">
                    <label> Excel </label>  
                     <br>
                    <input type="radio" id="csv2017" name="csv2017" value="csv2017">
                    <label> Csv </label>
            </fieldset>
            </td>
        </tr>
		<tr>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td colspan="2">
						<table align="right" border='0'>
							<tr>
								<td align="right"">
									<a id="ligaGenerar">
										<input type="button" id="generar" name="generar" class="submit"
										 tabindex="7" value="Generar" />
									</a>
								</td>	
							</tr>
						</table>		
					</td>
				</tr>					
			</table>
		</tr>
	</table>
    </div>
	<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
	<input type="hidden" id="tipoEntidad" name="tipoEntidad" class="submit" />
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