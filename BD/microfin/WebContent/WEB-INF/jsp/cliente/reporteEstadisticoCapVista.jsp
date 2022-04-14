<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

<head>
    <script type="text/javascript" src="js/cliente/repEstadistico.js"></script>
</head>

<body>
    <div id="contenedorForma">
        <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="RepEstadisticoBean">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">
                <legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Reporte Estadístico Captación / Cartera</legend>
                <table width="560px">
                    <tr>
                        <td  style="display: block;">
                            <fieldset class="ui-widget ui-widget-content ui-corner-all">
                                <legend><label>Parámetros</label></legend>
                                <table >
                                    <tr>
                                        <td class="label">
                                            <label for="lbtipoRep">Tipo Reporte:</label>
                                        </td>
                                        <td>
                                            <form:select id="tipoRep" name="tipoRep" path="tipoRep" tabindex="1">
                                                <form:option value="0">SELECCIONAR</form:option>
                                                <form:option value="2">CAPTACION</form:option>
                                                <form:option value="1">CARTERA</form:option>
                                            </form:select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label">
                                            <label for="lbfechaCorte">Fecha de Corte:</label>
                                        </td>
                                        <td>
                                            <form:input id="fechaCorte" name="fechaCorte" path="fechaCorte" size="14" tabindex="2" esCalendario="true" />
                                        </td>
                                    </tr>
                                    <tr id ="incluyeGL">
                                        <td class="label">
                                            <label for="lincluyeGL">Incluir Garatía Liq.: </label>
                                        </td>
                                        <td>
                                            <input type="radio" id="incluirGL" checked="true" name="incluirGL" value="S" tabindex="3"/>
                                            <label> SI </label>

                                            <input type="radio" id="incluirGLN" name="incluirGLN" value="N" tabindex="4">
                                            <label> NO </label>
                                        </td>
                                    </tr>
                                    <tr id="saldo">
                                        <td class="label">
                                            <label for="lsaldoMinimo">Saldo Mínimo: </label>
                                        </td>
                                        <td>
                                            <input id="saldoMinimo" name="saldoMinimo" esMoneda="true" size="14" tabindex="5" style="text-align:right;" maxlength="12" />
                                        </td>
                                    </tr>
                                    <tr id="incluyeCuentas">
                                        <td class="label">
                                            <label for="lincluirCuentaSA">Incluir Cuentas <br> sin Autorizar: </label>
                                        </td>
                                        <td>
                                            <input type="radio" id="incluirCuentaSA" checked="true" name="incluirCuentaSA" value="S" tabindex="6"/>
                                            <label> SI </label>

                                            <input type="radio" id="incluirCuentaSAN" name="incluirCuentaSAN" value="N" tabindex="7">
                                            <label> NO </label>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </td>
                        <td>
                            <table width="200px">
                                <tr>
                                    <td class="label">
                                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                                            <legend><label>Presentaci&oacute;n</label></legend>
                                            <input type="radio" id="pdf" checked="true" name="pdf" value="1" tabindex="8" />
                                            <label> PDF </label>
                                            <br>
                                            <input type="radio" id="excel" name="excel" value="2" tabindex="9">
                                            <label> Excel </label>

                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label" >
                                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                                            <legend><label>Nivel de Detalle</label></legend>
                                            <input type="radio" id="detallado" checked="true" name="detallado" value="D" tabindex="10"/>
                                            <label> Detallado</label>
                                            <br>
                                            <input type="radio" id="sumarizado" name="sumarizado" value="G" tabindex="11">
                                            <label> Sumarizado </label>

                                        </fieldset>
                                    </td>
                                </tr>

                            </table>

                        </td>
                    </tr>

                </table>

                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td colspan="4">
                            <table align="right" border='0'>
                                <tr>
                                    <td align="right">
                                        <a id="ligaGenerar" target="_blank">
					                   <input type="button" id="genera" name="genera" class="submit" value="Generar"  tabindex="12"/>
                                       <input type="hidden" id="detReporte" name="detReporte"/>
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

    <div id="cargando" style="display: none;"></div>
    <div id="cajaLista" style="display: none;">
        <div id="elementoLista"></div>
    </div>
</body>
<div id="mensaje" style="display: none;"></div>

</html>