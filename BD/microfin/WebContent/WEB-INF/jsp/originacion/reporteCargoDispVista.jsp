<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html> 
	<head>	
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
       	<script type="text/javascript" src="js/originacion/reporteCargoDisp.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="esquemaCargoDisp">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Cargo por Disposici&oacute;n de Cr&eacute;dito</legend>
			<table border="0" width="100%">
                  <tr>
                     <td>
                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                           <legend><label>Par&aacute;metros</label></legend>
                           <table border="0" width="560px">
								<tr>
						 			<td class="label">
						 				<label for="institucionID">Instituci&oacute;n: </label> 
									</td>
						     		<td class="label" nowrap="nowrap">  
										<form:input type="text" id="institucionID" name="institucionID" path="institucionID" size="6" tabindex="1" />
						         		<input type= "text" id="nombInstitucion" name="nombInstitucion" size="45" type="text" readonly="true"  />
									</td>
								</tr>
								<tr>
									<td class="label"> 
										<label>Fecha Inicio: </label>
									</td>
									<td>
										<form:input type="text" name="fechaInicio" id="fechaInicio" path="fechaInicio" autocomplete="off" size="12" tabindex="2"  esCalendario="true"/>						
									</td>
								</tr>
								<tr>
									<td class="label"> 
										<label>Fecha Final: </label>
									</td>
									<td>
										<form:input type="text" name="fechaFinal" id="fechaFinal" path="fechaFinal" autocomplete="off" size="12" tabindex="3"  esCalendario="true"/>						
									</td>
								</tr>
                           </table>
                        </fieldset>
                     </td>
                  </tr>
                  <tr>
                     <td>
                        <table>
                           <tr>
                              <td>
                                 <fieldset class="ui-widget ui-widget-content ui-corner-all">
                                    <legend><label>Presentaci&oacute;n</label></legend>
                                       <input type="radio" id="tipoReportePDF" name="tipoReporte" value="1" tabindex="5" checked="checked" />
                                       <label for="tipoReportePDF">PDF</label>
                                       <br>
                                       <input type="radio" id="tipoReporteEXCEL" name="tipoReporte" value="2" tabindex="6"/>
                                       <label for="tipoReporteEXCEL">Excel</label>
                                 </fieldset>
                              </td>
                           </tr>
                        </table>
                     </td>
                  </tr>
                  <tr>
                  	<td>
			            <table align="right" border='0'>
			               <tr>
			                  <td align="right">
			                     <input type="hidden" id="tipoLista" name="tipoLista" />
			                     <input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
			                     <input type="button" id="generar" name="generar" class="submit" tabIndex = "7" value="Generar" />
			                  </td>
			               </tr>
			            </table>
                  	</td>
                  </tr>
           </table>
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