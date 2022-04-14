<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

<head>
    <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
    <script type="text/javascript" src="js/cliente/reporteIDE.js"></script>
</head>
<body>
    <div id="contenedorForma">
        <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clienteBean">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">
                <legend class="ui-widget ui-widget-header ui-corner-all">Reporte IDE</legend>
                <table width="100%">
                    <tr>
                        <td>
                            <fieldset class="ui-widget ui-widget-content ui-corner-all">
                                <legend><label>Parámetros</label></legend>
                                <table>
                                    <tr>
                                        <td class="label">
                                            <label for="lTipoReporte">Tipo Reporte: </label>
                                        </td>
                                        <td>
                                            <select id="tipoReporte" name="tipoReporte" path="tipoReporte" tabindex="1">
                                            <option value="">SELECCIONAR </option>
                    				     	<option value="M">MENSUAL</option>
                    				     	<option value="A">ANUAL</option>
                    		     		</select>
                                        </td>
                                    </tr>
                                    <tr id="divEjercicio">
                                        <td class="label">
                                            <label for="lEjercicio">Ejercicio: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <select id="ejercicio" name="ejercicio" tabindex="2">
                                            </select>
                                        </td>
                                    </tr>
                                    <tr id="divPeriodo">
                                        <td class="label">
                                            <label for="lPeriodo">Periodo: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <select id="periodo" name="periodo" tabindex="2">
                                                <option value="1">ENERO</option>
                                                <option value="2">FEBRERO</option>
                                                <option value="3">MARZO</option>
                                                <option value="4">ABRIL</option>
                                                <option value="5">MAYO</option>
                                                <option value="6">JUNIO</option>
                                                <option value="7">JULIO</option>
                                                <option value="8">AGOSTO</option>
                                                <option value="9">SEPTIEMBRE</option>
                                                <option value="10">OCTUBRE</option>
                                                <option value="11">NOVIEMBRE</option>
                                                <option value="12">DICIEMBRE</option>
                                            </select>                    
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label">
                                            <label for="lclienteID"><s:message code="safilocale.cliente"/>: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <input id="clienteID" name="clienteID" size="11" tabindex="5" autocomplete="off" />
                                            <input type="text" id="nombreCliente" name="nombreCliente" size="39" readOnly="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label">
                                            <label for="lPeriodo">Sucursal: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <input id="sucursal" name="sucursal" size="11" tabindex="6" autocomplete="off"/>
                                            <input type="text" id="nomSucursal" name="nomSucursal" size="39" readOnly="true" />
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                            <br>
                            <div id="presentacion" style="width: 100px; height: 60px; ">
                                <fieldset class="ui-widget ui-widget-content ui-corner-all">
                                    <legend><label>Presentación</label></legend>
                                    <table>
                                        <tr>
                                            <td>
                                                <input type="radio" id="excel" name="tipoRep" value="1" checked="checked" tabindex="7" />
                                            </td>
                                            <td>
                                                <label for="excel"> Excel </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input type="radio" id="xml" name="tipoRep" value="2" tabindex="8" />
                                            </td>
                                            <td>
                                                <label for="excel"> XML </label>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </div>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="6">
                                        <table align="right">
                                            <tr>
                                                <td align="right">
                                                    <button type="button" class="submit" id="generar" tabindex="9">Generar</button>
                                                </td>
                                            </tr>
                                        </table>
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
    <div id="elementoLista" />
    </div>
</body>
<div id="mensaje" style="display: none;" />
</html>