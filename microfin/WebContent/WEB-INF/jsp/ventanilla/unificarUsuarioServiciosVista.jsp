<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>

<head>
    <script type="text/javascript" src="dwr/interface/usuarioServicios.js"></script>
    <script type="text/javascript" src="js/ventanilla/unificarUsuarioServicios.js"></script>
</head>

<body>
    <div id="contenedorForma">
        <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="usuarioServiciosBean">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">
            <legend class="ui-widget ui-widget-header ui-corner-all">Unificar Usuarios de Servicio</legend>
                <br>
                <fieldset class="ui-widget ui-widget-content ui-corner-all">
                    <legend >Usuario Servicio</legend>
                    <table width="100%">
                        <tr>
                            <td class="label">
                                <label for="usuarioID">N&uacute;mero:</label>
                            </td>
                            <td>
                                <form:input type="text" id="usuarioID" name="usuarioID" path="usuarioID" size="13" tabindex="1" maxlength="40" autocomplete="off"/>
                            </td>
                            <td class="separador"></td>
                            <td class="label">
                                <label for="nombreCompleto">Nombre Completo:</label>
                            </td>
                            <td>
                                <input type="text" name="nombreCompleto" id="nombreCompleto" size="45" disabled="true" readonly="true">
                            </td>
                        </tr>

                        <tr>
                            <td class="label">
                                <label for="RFC">RFC:</label>
                            </td>
                            <td>
                                <input type="text" name="RFC" id="RFC" size="30" disabled="true" readonly="true">
                            </td>
                            <td class="separador"></td>
                            <td class="label">
                                <label for="CURP">CURP:</label>
                            </td>
                            <td>
                                <input type="text" name="CURP" id="CURP" size="30" disabled="true" readonly="true">
                            </td>
                        </tr>

                        <tr>
                            <td class="label">
                                <label for="sexo">Sexo:</label>
                            </td>
                            <td>
                                <input type="text" name="sexo" id="sexo" size="20" disabled="true" readonly="true">
                            </td>
                            <td class="separador"></td>
                            <td class="label">
                                <label for="fechaNacimiento">Fecha Nacimiento:</label>
                            </td>
                            <td>
                                <input type="text" name="fechaNacimiento" id="fechaNacimiento" size="20" disabled="true" readonly="true">
                            </td>
                        </tr>
                    </table>
                </fieldset>

                <br>

                <div id="listaCoincidencias" style="display: none;">
                    <fieldset class="ui-widget ui-widget-content ui-corner-all" style="padding-top: 1em; padding-right: 1.8em;">
                        <legend >Coincidencias</legend>
                        <table style="width: 100%;" id="tblCoincidencias">
                            <thead style="color: rgb(130, 130, 130); font-size: .85em;">
                                <tr style="text-align: left;">
                                    <th class="label">N&uacute;m</th>
                                    <th class="label">Usuario</th>
                                    <th class="label">Nombre</th>
                                    <th class="label">RFC</th>
                                    <th class="label">CURP</th>
                                    <th class="label" style="width: 9em;">% Coincidencia</th>
                                    <th class="label" style="margin-right: 5em;">
                                        <div style="position: absolute; margin: -1.5em 0 0 1em;">
                                            <input type="checkbox" name="todos" id="checkTodos" style="cursor: pointer;" tabindex="2">
                                            <label for="checkTodos" style="cursor: pointer; user-select: none;">Todos</label>
                                        </div>
                                        Unificar
                                    </th>
                                </tr>
                            </thead>
                            <tbody id="tbodyCoincidencias">

                            </tbody>
                        </table>

                        <div style="text-align: center; color:#aaa; font-size: .95em; display: none;" id="sinCoincidencias">
                            <i>Usuario de servicios sin coincidencias</i>
                        </div>
                    </fieldset>
                </div>

                <table style="width: 100%;">
					<tr>
						<td colspan="5" style="text-align: right;">
							<input id="grabar" type="submit" class="submit" value="Grabar"/>
							<input id="tipoTransaccion" name="tipoTransaccion" type="hidden"/>
                            <input id="tipoActualizacion" name="tipoActualizacion" type="hidden"/>
							<input id="usuariosID" name="usuariosID" type="hidden" value=""/>
                            <input id="ctrlUsuarioID" type="hidden" name="ctrlUsuarioID">
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
	<div id="mensaje" style="display: none;"></div>
</body>

</html>