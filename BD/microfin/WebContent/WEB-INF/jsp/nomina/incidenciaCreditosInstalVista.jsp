<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
    <script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/creditoArcInstalServicio.js"></script>
    <script type="text/javascript" src="js/nomina/creditoArcInstal.js"></script>
    
</head>
<body>
    <div id="contenedorForma">
        <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="archivoInstalBean">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">
                <legend class="ui-widget ui-widget-header ui-corner-all">Archivos de Instalación </legend>

                <table border="0" cellpadding="0" cellspacing="0" width="600px">
                    <tr>
                        <td id="lblnomina" class="label" nowrap="nowrap">
                            <label for="lblCalif">Folio: </label>
                        </td>
                        <td id="folio" nowrap="nowrap">
                            <input type="text" id="folioID" name="folioID"  size="11" />
                            <input type="text" id="descripcion" name="descripcion"  size="39" />
                        </td>
                    </tr>
                    <tr>
                        <td id="lblnomina" class="label" nowrap="nowrap">
                            <label for="lblCalif">Institui&oacute;n N&oacute;mina: </label>
                        </td>
                        <td id="institNomina" nowrap="nowrap">
                            <input type="text" id="institNominaID" name="institNominaID"  size="11" />
                            <input type="text" id="nombreInstit" name="nombreInstit"  disabled="disabled" size="39" />
                        </td>
                    </tr>
                    <tr>
                        <td id="lblnomina" class="label" nowrap="nowrap">
                            <label for="lblCalif">Convenio N&oacute;mina: </label>
                        </td>
                        <td id="conveNomina" nowrap="nowrap">
                            <input type="text" id="convenioNominaID" name="convenioNominaID"  size="11" />
                            <input type="text" id="nombreConvenio" name="nombreConve"  disabled="disabled" size="39" />
                        </td>
                    </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td colspan="4">
                            <table align="right" border='0'>
                                <tr>
                                    <td align="right">                                        
                                        <a target="_blank" >									  				
											<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="5"/>							
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>					
											<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>							             		 
						                </a>
                                    </td>
                                </tr>

                            </table>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form:form>
    </div>
    <div id="cargando" style="display: none;">
    </div>
    <div id="cajaLista" style="display: none;">
        <div id="elementoLista"/>
    </div>
</body>
<div id="mensaje" style="display: none;"/>
</html>