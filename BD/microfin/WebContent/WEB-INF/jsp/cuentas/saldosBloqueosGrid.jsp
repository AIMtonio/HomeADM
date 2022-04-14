<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="listaPaginada" value="${listaBloqueados[0]}" />
<c:set var="listaBloqueados" value="${listaPaginada.pageList}"/>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Desbloqueos</legend>
		<table id="miTabla"  border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label"> 
					<label for="lblEdoCta">Fecha:</label> 
				</td>
			  	<td class="label">    
					<label for="lblEdoCta">Cuenta:</label> 
				</td>
				<td></td>
				<td class="label"> 
					<label for="lblEdoCta">Saldo<br>Bloqueado:</label> 
		     	</td>
				<td class="label"> 
					<label for="lblEdoCta">Descripci&oacute;n:</label> 
				</td>
				<td class="label"> 
			      <label for="lblReferencia">Referencia:</label> 
			   </td> 
			   	<td class="label"> 
					<label for="lblEdoCta">Motivo Desbloqueo:</label> 
				</td>		
   				<td class="label"> 
					<label for="lblEdoCta">Tipo Desbloqueo:</label> 
				</td>	
				<td>
					<input type="checkbox" id="selecTodas" name="selecTodas" onclick="seleccionaTodas()" value="" />
				</td>
	 		</tr>
			<c:forEach items="${listaBloqueados}" var="saldosBloq" varStatus="status">
			<tr id="renglon${status.count}" name="renglon">
				
				<td> 
					<input type="text" id="fecha${status.count}"  name="fecha" value="${saldosBloq.fechaMov}" size="10"  readonly="true" />
				</td> 
				<td> 
					<input type="hidden" id="idBloqueo${status.count}"  name="idBloqueo" value="${saldosBloq.bloqueoID}" readonly="true" />
					<input type="text" id="cuentaAho${status.count}"  name="cuentaAho" value="${saldosBloq.cuentaAhoID}" size="13" readonly="true" />
				</td>
				<td>
					<input type="text" id="cuentaDescrip${status.count}"  name="cuentaDescrip" value="${saldosBloq.descripcionCta }" size="23" readonly="true"/>
				</td>
				<td>
					<input type="text" id="saldoBloq${status.count}" style="text-align:right;" value="${saldosBloq.montoBloq}" esmoneda="true" size="12" name="lsaldoBloq" readonly="true"/>
				</td>
				<td>
					<input type="text" id="descripcionmov${status.count}" name="ldescripcion" value="${saldosBloq.descripcion}" size="30" readonly="true"/>
				</td>
				<td>
					   <input type="text" id="referencia${status.count}" name="lreferencia"  style="text-align:right;" value="${saldosBloq.referencia}" size="23" readonly="true"/>
				</td>
				<td>
					<input type="text" id="descripcion${status.count}" name="ldescripcion" size="30" maxlength="140" onBlur="ponerMayusculas(this); limpiarCajaTexto(this.id);" />
				</td>
				<td>
					<script type="text/javascript">
						var idtipoBlo = "<c:out value="tiposBloqueoID${status.count}"/>";
						var idBloqueo = ${saldosBloq.tiposBloqID};
						buscaTiposBloqueos(idtipoBlo,idBloqueo);
					</script> 
					<select id="tiposBloqueoID${status.count}" name="tiposBloqueoID" >
						<option value="1">ERROR</option>
					</select>
				</td>
				<td>
					<input type="checkbox" id="desbloquea${status.count }" name="desbloquea" onclick="siguiente(this.id)"></input>
   			</td>
			</tr>
			</c:forEach>
		</table>
		<c:if test="${!listaPaginada.firstPage}">
			<input onclick="generaSeccion('previous')" type="button" id="anterior" value="" class="btnAnterior" />
		</c:if>
		<c:if test="${!listaPaginada.lastPage}">
			<input onclick="generaSeccion('next')" type="button" id="siguient" value="" class="btnSiguiente" />
		</c:if>
		<table>
			<tr>
				<td>
					<div id="usuarioContrasenia">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Usuario  Autoriza</legend>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lblUsuario">Usuario:</label>
									</td>
									<td>
										<input id="claveUsuarioAut" name="claveUsuarioAut" size="20" type="password" tabindex="6" onblur="validaUsuario()"/>
										<input type="hidden" id="cajaID" name="cajaID"/>
										<input type="hidden" id="sucursalID" name="sucursalID"/>
									</td>
								</tr>
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lblContrasenia">Contrase&ntilde;a:</label>
									</td>
									<td>
										<input id="contraseniaAut" name="contraseniaAut" size="20" type="password" iniForma="false" tabindex="7"/>
									</td>
									<span id="statusSrvHuella" style="float: right; display: none;"></span>
								</tr>	
								<input type="hidden" id="descripcionOper" name="descripcionOper" size="50" tabindex="2" iniForma="false"/>
								<input type="hidden" id="usuarioAutID" name="usuarioAutID" size="50" tabindex="2" iniForma="false"/>
							</table>
						</fieldset>
					</div>
				</td>
			</tr>
		</table>
	</fieldset>
