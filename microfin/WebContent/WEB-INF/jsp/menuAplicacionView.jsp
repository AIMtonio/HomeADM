<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<title>SAFI</title>
<c:set var="parametrosBean" value="${listaResultado[0]}" />
<c:set var="listaMenu" value="${listaResultado[1]}" />
<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
<!-- CSS ============================================================================= -->
<link rel="stylesheet" type="text/css" href="css/loader.css" />
<link rel="stylesheet" type="text/css" href="css/offline.css" />
<link rel="stylesheet" type="text/css" href="css/template.css" media="screen,print" />
<c:choose>
	<c:when test="${parametrosBean.lookAndFeel >0}">
		<link rel="stylesheet" type="text/css" href="css/lookAndFeel_01.css" media="all" />
	</c:when>
	<c:otherwise>
		<link rel="stylesheet" type="text/css" href="css/menuTree.css" media="screen,print" />
	</c:otherwise>
</c:choose>
<link rel="stylesheet" type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" />
<link rel="stylesheet" type="text/css" href="css/loader.css" />
<c:choose>
	<c:when test="${parametrosBean.lookAndFeel >0}">
		<link rel="stylesheet" type="text/css" href="css/forma_vLookAndFeel.css" media="all" />
	</c:when>
	<c:otherwise>
		<link rel="stylesheet" type="text/css" href="css/forma.css" media="all" />
	</c:otherwise>
</c:choose>
<!-- FIN CSS  ========================================================================  -->
<!-- DWR      ========================================================================  -->
<script type="text/javascript" src="dwr/engine.js"></script>
<script type="text/javascript" src="dwr/util.js"></script>

<script type="text/javascript" src="dwr/interface/paisesGAFIPLDServicio.js"></script>
<script type="text/javascript" src="dwr/interface/alertNotificacionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<!-- FIN DWR  ========================================================================  -->
<!-- JS       ========================================================================  -->
<script type="text/javascript" src="js/loader.js"></script>
<script type="text/javascript" src="js/offline.min.js"></script>
<script type="text/javascript" src="js/jquery-1.5.1.min.js"></script>
<script type="text/javascript" src="js/jquery.ui.datepicker-es.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.13.custom.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.13.min.js"></script>
<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type='text/javascript' src='js/jquery.formatCurrency-1.4.0.min.js'></script>
<script type="text/javascript" src="js/jquery.maskedinput-1.3.min.js"></script>
<script type="text/javascript" src="js/jquery.jmpopups-0.5.1.js"></script>
<script type="text/javascript" src="js/jquery.blockUI.js"></script>
<script type='text/javascript' src='js/jquery.hoverIntent.minified.js'></script>
<script type="text/javascript" src="js/jquery.plugin.menuTree.js"></script>
<script type="text/javascript" src="js/jquery.plugin.tracer.js"></script>


<script type="text/javascript" src="js/listasSAFI.js"></script>
<script type="text/javascript" src="js/forma.js"></script>
<script type="text/javascript" src="js/general.js"></script>

<script type="text/javascript" src="js/utileria.js"></script>
<!-- Esta es la librería para crear pdf's desde javascript. Se usará
     únicamente para contratos. -->
<script type="text/javascript" src="js/pdfmake.min.js"></script>
<script type="text/javascript" src="js/vfs_fonts.js"></script>

<script type="text/javascript" src="js/soporte/menuAplicacion.js"></script>
<c:choose>
	<c:when test="${parametrosBean.lookAndFeel >0}">
		<script type="text/javascript" src="js/util_menu.js"></script>
		<script type="text/javascript" src="js/main_menu.js"></script>
	</c:when>
</c:choose>
<!-- FIN JS       ==================================================================== -->
<script>
	function cargarPantalla(url, requiereCajero, cajaID, estatusCaja, desplegado){
		if(	requiereCajero == 'S' && isNaN(cajaID)){
			alert("El Usuario no tiene una Caja asignada.");
		} else {
			if(requiereCajero == 'S' && estatusCaja!='A'){
				alert('Se Requiere de una Caja Activa para Realizar Operaciones.');
			} else {
				if(desplegado === 'Preinscripción e Inscripción Asambleas'){
					if(!!document.getElementById("apletTicket")){
						cargaCaja();
					}
				}

				$('#Contenedor').load(url,function(response, status, xhr){
					$('#Contenedor').show();
					if(status == 'error') {

						$('#Contenedor').html(response);
					}
				});
				consultaSesion();
			}
		}
	}

	function cargaCaja(){
		var varApplet = document.jzebra;
		if (varApplet == null) {
			data = '<applet id="apletTicket"  name="jzebra" code="jzebra.PrintApplet.class" archive="jzebra.jar" width="1px" height="1px">' + '<param name="printer" id="printer" value="impSAFITicket">' + '</applet>';
			$('#divImpTicket').html(data);
			$('#apletTicket').width(1);
			$('#apletTicket').height(1);
		}
	}
</script>
</head>
<c:choose>
	<c:when test="${parametrosBean.lookAndFeel == '0'}">
<body style="background: #FFF; margin: 0pt;" onload="mostrarAlertaExpiraDocs();">
	<div id="PrincipalHeather" style="margin-left: auto; margin-right: auto; height: 75px;"center">
		<table border="0" width="100%" cellspacing="0" height="75px">
			<tr>
				<td width="180px" height="75px" align="center">
					<div style="width: 180px; height: 75px">
						<img src="images/LogoPrincipal.png" alt="" style="height: 75px; width: 100%; object-fit: contain" />
					</div>
				</td>
				<td class="separador"></td>
				<td valign="middle">
					<div id="Credenciales">
						<c:choose>
							<c:when test="${parametrosBean.cajaID >0}">

								<table border="0" height="75px">
									<tr>
										<td>
											<table border="0" width="100%">
												<tr align="left">
													<td class="label" nowrap="nowrap" valign="bottom"><label>Usuario: </label></td>
													<td class="etiqueta" nowrap="nowrap" valign="bottom"><input type="hidden" id="nuClave" name="nuClave" /> <label>${parametrosBean.nombreUsuario}</label></td>
													<td class="separador"></td>
													<td class="separador"></td>
													<td class="separador"></td>
													<td class="label" nowrap="nowrap" valign="bottom" align="left"><label>Sucursal: </label></td>
															<td class="etiqueta" nowrap="nowrap" valign="bottom" align="left"><input id="sucursalIDSesion" readonly="readonly" size="22" type="hidden" value="${parametrosBean.sucursal}" /> <label>${parametrosBean.nombreSucursal}</label></td>
													<td class="separador"></td>
													<td class="separador"></td>
													<td class="label" nowrap="nowrap" colspan="3" align="right" valign="bottom"><label>Fecha Sistema: </label></td>
													<td class="etiqueta" nowrap="nowrap" valign="bottom"><label>${parametrosBean.fechaSucursal}</label></td>
													<td class="etiqueta" nowrap="nowrap" style="vertical-align: bottom"><span align="right" id="spanPrinter" style="display: none; vertical-align: bottom;"><img src="images/impresora/desconectado_2.png" id="imgPrinterSAFI" title="Desconectado" width="28px"></span> <a id="ligaSalida" href="javascript:" onclick="confirmarCerrar();"> <img src="images/salida_peq.gif" align="bottom" />Salir
													</a></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td>
											<table border="1px" style="border-collapse: collapse; border-color: #e0e0e0" width="100%">
												<tr>
													<td>
														<table width="100%">
															<tr>
																<td class="label" nowrap="nowrap"><label>Caja: </label></td>
																		<td class="etiqueta" nowrap="nowrap"><label>${parametrosBean.cajaID}-${parametrosBean.tipoCajaDes}</label> <input id="cajaIDSesion" readonly="readonly" size="22" type="hidden" value="${parametrosBean.cajaID}" /> <input id="tipoCajaSesion" readonly="readonly" size="22" type="hidden" value="${parametrosBean.tipoCaja}" /> <input id="estatusCajaSesion" readonly="readonly" size="22" type="hidden" value="${parametrosBean.estatusCaja}" /></td>
																<td class="separador"></td>
																<td class="label" nowrap="nowrap"><label>Saldos M.N.:</label></td>
																<td class="etiqueta" nowrap="nowrap" align="left"><label id="saldoMNSesionLabel">${parametrosBean.saldoEfecMN}</label></td>
																<td class="separador"></td>
																<td class="label" nowrap="nowrap"><label>M.E.:</label></td>
																		<td class="etiqueta" nowrap="nowrap" align="left" colspan="3">${parametrosBean.saldoEfecME}<input id="saldoEfecMNSesion" type="hidden" readonly="readonly" size="10" esMoneda="true" value="${parametrosBean.saldoEfecMN}" style="text-align: right" /> <input id="saldoEfecMESesion" type="hidden" readonly="readonly" size="10" esMoneda="true" value="${parametrosBean.saldoEfecME}" style="text-align: right" />
																</td>
																<td class="separador"></td>
																<td class="separador"></td>
																<td class="separador"></td>
															</tr>
														</table>
													</td>
												</tr>

											</table>
										</td>
									</tr>
								</table>
							</c:when>
							<c:otherwise>
								<table border="0" height="75px">
									<tr align="left" valign="bottom">
										<td class="label" nowrap="nowrap"><label>Usuario: </label></td>
										<td class="etiqueta" nowrap="nowrap"><input type="hidden" id="nuClave" name="nuClave" /> <label>${parametrosBean.nombreUsuario}</label></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
									</tr>
									<tr valign="middle">
										<td class="label" nowrap="nowrap"><label>Sucursal: </label></td>
												<td class="etiqueta" nowrap="nowrap"><input id="sucursalIDSesion" readonly="readonly" size="22" type="hidden" value="${parametrosBean.sucursal}" /> <label>${parametrosBean.nombreSucursal}</label></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
									</tr>
								</table>


							</c:otherwise>
						</c:choose>
					</div>
				</td>
				<c:choose>
					<c:when test="${empty parametrosBean.cajaID}">
						<td align="right" valign="middle">
							<div id="Credenciales2">
								<table border="0" height="75px">
									<tr valign="top">
										<td class="label" nowrap="nowrap" valign="bottom"><label>Fecha Sistema: </label></td>
										<td class="etiqueta" nowrap="nowrap" valign="bottom"><label>${parametrosBean.fechaSucursal}</label></td>
										<td class="label" align="right" valign="middle" nowrap="nowrap" rowspan="2"><a id="ligaSalida" href="javascript:" onclick="confirmarCerrar();"> <img src="images/salida_peq.gif" />Salir
										</a></td>
									</tr>
									<tr>
										<td class="separador"></td>
										<td class="separador"></td>
									</tr>
								</table>
							</div>
						</td>
					</c:when>
				</c:choose>
				<td width="180px" height="75px" align="center">
					<div style="width: 180px; height: 75px">
						<img id="imgLogoClientePantalla" src="" alt="" style="height: 90%; width: 100%; object-fit: contain" />
					</div>
				</td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td colspan="5">
					<div id="divHuella"></div>
				</td>
			</tr>

		</table>
	</div>
	<div id="divPrincipalAplicacion" class="divPrincipalAplicacion">
		<div id="divPrincipalMenu" class="divPrincipalMenu">
			<ul id="listaMenu">
				<c:forEach items="${listaMenu.menus}" var="menu">
							<!-- MENU -->
							<li><a href="javascript:">&nbsp;${menu.desplegado}</a>
								<ul>
									<c:forEach items="${listaMenu.gruposMenu[fn:trim(menu.numero)]}" var="grupo">
										<!-- GRUPO -->
										<li><a href="javascript:">&nbsp;${grupo.desplegado}</a>
											<ul>
												<c:forEach items="${listaMenu.opcionesMenu[fn:trim(grupo.numero)]}" var="opcion">
													<!-- OPCION -->
													<li><a id="opcionM" href="javascript: " onclick="cargarPantalla('${opcion.recurso}','${opcion.requiereCajero}','${fn:trim(parametrosBean.cajaID)}','${parametrosBean.estatusCaja}')"> <img src="/microfin/images/opcion.gif" /> ${opcion.desplegado}
													</a></li>
												</c:forEach>
											</ul></li>
									</c:forEach>
								</ul></li>
						</c:forEach>
					</ul>
				</div>
			</div>



	<c:choose>
		<c:when test="${parametrosBean.cajaID >0}">
			<c:if test="${parametrosBean.tipoImpresoraTicket == 'A'}">
				<applet name="jzebra" code="jzebra.PrintApplet.class" archive="jzebra.jar" width="1px" height="1px">
					<param name="printer" id="printer" value="${parametrosBean.impTicket}">
				</applet>
			</c:if>
			<c:if test="${parametrosBean.funcionHuella== 'S'}">
			</c:if>
		</c:when>
	</c:choose>
	<div id="Contenedor" class="ContenedorCaja"></div>
	<div id="ContenedorPass" class="ContenedorCaja"></div>


	<c:if test="${parametrosBean.cambioPassword == 'S'}">
		<script type="text/javascript">
	  $.blockUI({
	          message: $('#ContenedorPass').load('cambioContraseniaUsuarios.htm?user='+${parametrosBean.numeroUsuario}),
	          css: {
					top:  '0px',
					left: '0px',
					width: '1000px'
				}
	  });
	</script>
	</c:if>
	<c:if test="${parametrosBean.estatusCaja != 'A' && parametrosBean.cajaID > 0}">
		<c:if test="${parametrosBean.estatusCaja == 'I'}">
			<script type="text/javascript">
 		  alert('La Caja se encuentra Inactiva.');
 		</script>
		</c:if>
		<c:if test="${parametrosBean.estatusCaja == 'C'}">
			<script type="text/javascript">
 		 alert('La Caja se encuentra Cancelada.');
 		</script>
		</c:if>

	</c:if>
	<input type="hidden" id="safilocaleCTE" name="safilocaleCTE" value="<s:message code="safilocale.cliente"/>" />
	<input type="hidden" id="lookAndFeel" name="lookAndFeel" value="${parametrosBean.lookAndFeel}" />
</body>
	</c:when>
	<c:otherwise>
		<body style="margin: 0pt;" onload="mostrarAlertaExpiraDocs();">
			<div id="PrincipalHeather" style="margin-left: auto; margin-right: auto;"center">
				<table width="100%" cellspacing="0" height="75px">
					<tr>
						<td></td>
						<td></td>
						<td colspan="5" height="30px"></td>
					</tr>
					<tr>
						<td width="210px" height="75px" align="center">

						</td>
						<td class="separador"></td>
						<td valign="middle">
							<div id="Credenciales" style="padding-right: 0px;">
								<c:choose>
									<c:when test="${parametrosBean.cajaID >0}">

										<table height="75px" width="100%">
											<tr>
												<td>
													<table width="100%">
														<tr>
															<td style="width: 30%;">
																<table>
																	<tr>
																		<td class="label" nowrap="nowrap" valign="bottom" style="text-align: right;"><img alt="" src="images/UsuarioHeader.png" style="height: 25px; width: 100%; object-fit: contain"></td>
																		<td class="etiqueta" nowrap="nowrap" valign="bottom"><input type="hidden" id="nuClave" name="nuClave" /> <label>${parametrosBean.nombreUsuario}</label></td>
																	</tr>
																</table>
															</td>
															<td class="separador"></td>
															<td class="separador"></td>
															<td style="width: 30%;">
																<table>
																	<tr>
																		<td class="label" nowrap="nowrap" valign="bottom" align="left" style="text-align: right;"><img alt="" src="images/locationHeader.png" style="height: 25px; width: 100%; object-fit: contain"></td>
																		<td class="etiqueta" nowrap="nowrap" valign="bottom" align="left"><input id="sucursalIDSesion" readonly="readonly" size="22" type="hidden" value="${parametrosBean.sucursal}"></input> <label>${parametrosBean.nombreSucursal}</label></td>
																	</tr>
																</table>
															</td>
															<td class="separador"></td>
															<td class="separador"></td>
															<td style="text-align: left;">
																<table>
																	<tr>
																		<td class="label" nowrap="nowrap" valign="bottom" style="text-align: right;"><img alt="" src="images/CalendarHeader.png" style="height: 25px; width: 100%; object-fit: contain"></td>
																		<td class="etiqueta" nowrap="nowrap" valign="bottom" style="text-align: right;"><label>${parametrosBean.fechaSucursal}</label></td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td>
													<table style="border-collapse: collapse; border-color: #e0e0e0; border-top: 0.5px solid #fff;" width="100%">
														<tr>
															<td>
																<table width="100%">
																	<tr>
																		<td style="width: 30%;">
																			<table>
																				<tr>
																					<td class="label" nowrap="nowrap" style="text-align: right;"><label>Caja: </label></td>
																					<td class="etiqueta" nowrap="nowrap"><label>${parametrosBean.cajaID}-${parametrosBean.tipoCajaDes}</label> <input id="cajaIDSesion" readonly="readonly" size="22" type="hidden" value="${parametrosBean.cajaID}" /> <input id="tipoCajaSesion" readonly="readonly" size="22" type="hidden" value="${parametrosBean.tipoCaja}" /> <input id="estatusCajaSesion" readonly="readonly" size="22" type="hidden" value="${parametrosBean.estatusCaja}" /></td>
																				</tr>
																			</table>
																		</td>
																		<td class="separador"></td>
																		<td class="separador"></td>
																		<td style="width: 30%;">
																			<table>
																				<tr>
																					<td class="label" nowrap="nowrap" style="text-align: right;"><label>Saldos M.N.:</label></td>
																					<td class="etiqueta" nowrap="nowrap" align="left"><label id="saldoMNSesionLabel">${parametrosBean.saldoEfecMN}</label></td>
																				</tr>
																			</table>
																		</td>
																		<td class="separador"></td>
																		<td class="separador"></td>
																		<td>
																			<table>
																				<tr>
																					<td class="label" nowrap="nowrap" style="text-align: right;"><label>M.E.:</label></td>
																					<td class="etiqueta" nowrap="nowrap" align="left" colspan="3">${parametrosBean.saldoEfecME}<input id="saldoEfecMNSesion" type="hidden" readonly="readonly" size="10" esMoneda="true" value="${parametrosBean.saldoEfecMN}" style="text-align: right" /> <input id="saldoEfecMESesion" type="hidden" readonly="readonly" size="10" esMoneda="true" value="${parametrosBean.saldoEfecME}" style="text-align: right" />
																				</tr>
																			</table>
																		</td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</c:when>
									<c:otherwise>
										<table height="75px" width="100%">
											<tr>
												<td>
													<table width="100%">
														<tr>
															<td style="width: 30%;">
																<table>
																	<tr>
																		<td class="label" nowrap="nowrap" valign="bottom" style="text-align: right;"><img alt="" src="images/UsuarioHeader.png" style="height: 25px; width: 100%; object-fit: contain"></td>
																		<td class="etiqueta" nowrap="nowrap" valign="bottom"><input type="hidden" id="nuClave" name="nuClave" /> <label>${parametrosBean.nombreUsuario}</label></td>
																	</tr>
																</table>
															</td>
															<td class="separador"></td>
															<td class="separador"></td>
															<td style="width: 30%;">
																<table>
																	<tr>
																		<td class="label" nowrap="nowrap" valign="bottom" align="left" style="text-align: right;"><img alt="" src="images/locationHeader.png" style="height: 25px; width: 100%; object-fit: contain"></td>
																		<td class="etiqueta" nowrap="nowrap" valign="bottom" align="left"><input id="sucursalIDSesion" readonly="readonly" size="22" type="hidden" value="${parametrosBean.sucursal}"></input> <label>${parametrosBean.nombreSucursal}</label></td>
																	</tr>
																</table>
															</td>
															<td class="separador"></td>
															<td class="separador"></td>
															<td style="text-align: left;">
																<table>
																	<tr>
																		<td class="label" nowrap="nowrap" valign="bottom" style="text-align: right;"><img alt="" src="images/CalendarHeader.png" style="height: 25px; width: 100%; object-fit: contain"></td>
																		<td class="etiqueta" nowrap="nowrap" valign="bottom" style="text-align: right;"><label>${parametrosBean.fechaSucursal}</label></td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td>
													<table style="border-collapse: collapse; border-color: #e0e0e0; border-top: 0.5px solid #fff;" width="100%">
														<tr>
															<td></td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</c:otherwise>
								</c:choose>
							</div>
						</td>

						<c:choose>
							<c:when test="${parametrosBean.cajaID >0}">
								<td class="etiqueta" nowrap="nowrap" style="width: 45px;">
									<span id="spanPrinter" style="">
										<img src="images/impresora/01/desconectado_2.png" id="imgPrinterSAFI" title="Desconectado" width="28px" />
									</span>
								</td>
							</c:when>
						</c:choose>
						<td nowrap="nowrap" style="width: 45px;">
							<div id="SalirSesion" style="margin-top: 10px;">
								<a id="ligaSalida" href="javascript:" onclick="confirmarCerrar();"> <img src="images/LogoutHeader.png" align="bottom" style="height: 35px;"></a>
							</div>
						</td>
						<td width="180px" height="75px" align="center">
							<div style="width: 180px; height: 75px">
								<img id="imgLogoClientePantalla" src="" alt="" style="height: 90%; width: 100%; object-fit: contain" />
							</div>
						</td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td colspan="5">
							<div id="divHuella"></div>
							<div id="divImpTicket"></div>
						</td>
					</tr>
				</table>
			</div>
			<div id="principalMenu"><!-- nuevo div-->
				<div class="page-wrapper chiller-theme toggled">
				<a id="show-sidebar" class="btn btn-sm btn-dark" href="#"> <i class="fas fa-bars"></i>
				</a>
				<nav id="sidebar" class="sidebar-wrapper">
				<div class="sidebar-content">

					<div class="sidebar-header">
						<div class="user-info">
							<div style="width: 180px; height: 75px">
								<img src="images/LogoSAFI_White.png" alt="" style="height: 75px; width: 100%; object-fit: contain" />
							</div>
							<span class="user-name"> <strong>${parametrosBean.nombreUsuario}</strong>
							</span> <span class="user-role"></span>
						</div>
					</div>
					<div class="sidebar-menu">
						<ul class="cd-accordion cd-accordion--animated margin-top-lg margin-bottom-lg">
							<c:forEach items="${listaMenu.menus}" var="menu" varStatus="loop">
								<li class="cd-accordion__item cd-accordion__item--has-children"><input class="cd-accordion__input" type="checkbox" name="group-${loop.index}" id="group-${loop.index}"> <label class="cd-accordion__label cd-accordion__label--icon-folder" for="group-${loop.index}"><span>${menu.desplegado}</span></label> <!-- GRUPOS MENU --> <c:choose>
											<c:when test="${empty listaMenu.gruposMenu[fn:trim(menu.numero)]}"></li>
								</c:when>
								<c:otherwise>
									<!-- GRUPO -->
									<c:forEach items="${listaMenu.gruposMenu[fn:trim(menu.numero)]}" var="grupo" varStatus="grupoloop">
										<ul class="cd-accordion__sub cd-accordion__sub--l1">
											<li class="cd-accordion__item cd-accordion__item--has-children"><input class="cd-accordion__input" type="checkbox" name="sub-group-${loop.index}${grupoloop.index}" id="sub-group-${loop.index}${grupoloop.index}"> <label class="cd-accordion__label cd-accordion__label--icon-folder" for="sub-group-${loop.index}${grupoloop.index}"><span>${grupo.desplegado}</span></label> <!-- OPCIONES MENU --> <c:choose>
														<c:when test="${empty listaMenu.opcionesMenu[fn:trim(grupo.numero)]}">
														</c:when>
														<c:otherwise>
															<ul class="cd-accordion__sub cd-accordion__sub--l2">
																<c:forEach items="${listaMenu.opcionesMenu[fn:trim(grupo.numero)]}" var="opcion">
																	<li class="cd-accordion__item"><label class="cd-accordion__screen cd-accordion__screen--icon-folder"> <label class="cd-separador"></label> <span onclick="cargarPantalla('${opcion.recurso}','${opcion.requiereCajero}','${fn:trim(parametrosBean.cajaID)}','${parametrosBean.estatusCaja}')"> ${opcion.desplegado}</span>
																	</label></li>
																</c:forEach>
															</ul>
														</c:otherwise>
													</c:choose> <!-- FIN OPCIONES MENU-->
										</ul>
									</c:forEach>
									<!-- FIN GRUPO -->
								</c:otherwise>
</c:choose>
</li>
</c:forEach>
<!-- Fin FOREACH MENU-->
</ul>
</div><!-- sidebar-menu  -->

</div><!-- sidebar-content  -->

<div class="sidebar-footer"></div>
</nav>


<!-- </div>page-content" -->

</div><!-- page-wrapper --></div>
			
			<div id="divPrincipalAplicacion" class="divPrincipalAplicacion">


				


<c:choose>
	<c:when test="${parametrosBean.cajaID >0}">
		<c:if test="${parametrosBean.tipoImpresoraTicket == 'A'}">
			<applet name="jzebra" code="jzebra.PrintApplet.class" archive="jzebra.jar" width="1px" height="1px">
				<param name="printer" id="printer" value="${parametrosBean.impTicket}">
			</applet>
		</c:if>
		<c:if test="${parametrosBean.funcionHuella== 'S'}">
		</c:if>
	</c:when>
</c:choose>
			<div id="Contenedor" class="ContenedorCaja" style="display: none;"></div>
			<div id="ContenedorPass" class="ContenedorCaja" style="display: none;"></div>

			
<c:if test="${parametrosBean.cambioPassword == 'S'}">
	<script type="text/javascript">
				  $.blockUI({
				          message: $('#ContenedorPass').load('cambioContraseniaUsuarios.htm?user='+${parametrosBean.numeroUsuario}),
				          css: {
								top:  '0px',
								left: '0px',
								width: '1000px'
							}
				  });
				</script>
</c:if>
<c:if test="${parametrosBean.estatusCaja != 'A' && parametrosBean.cajaID > 0}">
	<c:if test="${parametrosBean.estatusCaja == 'I'}">
		<script type="text/javascript">
 		  alert('La Caja se encuentra Inactiva.');
 		</script>
	</c:if>
	<c:if test="${parametrosBean.estatusCaja == 'C'}">
		<script type="text/javascript">
 		 alert('La Caja se encuentra Cancelada.');
 		</script>
	</c:if>

</c:if>
<input type="hidden" id="safilocaleCTE" name="safilocaleCTE" value="<s:message code="safilocale.cliente"/>" />
<input type="hidden" id="lookAndFeel" name="lookAndFeel" value="${parametrosBean.lookAndFeel}" />
<br>
<div id="Contenedor" class="ContenedorCaja" style="display: none;"></div>
			<div id="ContenedorPass" class="ContenedorCaja" style="display: none;"></div>
</div><!-- End DivPrincipalAplicacion-->
</body>
</c:otherwise>
</c:choose>


</html>
