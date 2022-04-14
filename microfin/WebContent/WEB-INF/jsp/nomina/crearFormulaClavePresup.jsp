<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />     
		<link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  >   
		<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
	
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Crear Formula Clave Presupuestal</title>

		<style>
			.myDiv {
				text-align: center;
			}

			.myDiv2 {
				text-align: center;
				float:left; 
			}

			.myDiv3 {
				text-align: center;
				float:right;
			}

			.botonVerde {
				background-color: green;
			}

			.operador {
				background-color: white;
				color: black;
				font-size: large;
				padding: 8px;
				width: 80px;
				height: 60px;
				font-weight: bold;
			}

			.formula {
				text-align: center;
				background-color: white;
				color: black;
				padding: 8px;
				width: 600px;
				height: 250px;
			}

			.botonIzquierda {
				float: left;
			}

			.botonDerecha {
				float: right;
			}

			.cambioColor:hover {
				background-color: powderblue;
				transition: background-color .5s;
			}

			.cambioColorBoton:hover {
				background-color: #ff7373;
				transition: background-color .5s;
			}

			.label {
				font-size:40px;
				font-weight: bold;
			}

			.label2 {
				font-size:20px;
				font-weight: bold;
			}

		</style>
	</head>
		<script type="text/javascript" src="dwr/engine.js"></script>
		<script type="text/javascript" src="dwr/util.js"></script>
		<script type='text/javascript' src='js/jquery-1.5.1.min.js'></script>
		<script type='text/javascript' src='js/jquery.jmpopups-0.5.1.js'></script>
		<script type="text/javascript" src="js/jquery.blockUI.js"></script>
		<script type='text/javascript' src='js/jquery.validate.js'></script>
		<script type="text/javascript" src="js/forma.js"></script>
		<script type="text/javascript" src="js/general.js"></script>
		<script type="text/javascript" src="js/nomina/crearFormulaClavePresup.js"></script>


	<body>
		<div id="contenedorForma">
			<form method="post" id="formaGenerica" name="formaGenerica" action="/microfin/crearFormulaClavePresupVista.htm" enctype="multipart/form-data"> 

				<fieldset class="ui-widget ui-widget-content ui-corner-all">

					<div class="myDiv">
						<div class="myDiv">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<br><label class="label">Crear Fórmula </label>
							</fieldset>
						</div>
						<br>

						<div class="myDiv2">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<br><label class="label2"> Variable</label>
								<table>
									<br>
									<br>
									<div align="center" id="gridClasifClave" style="display: none;" ></div>
									<tr align="center">
										<td nowrap="nowrap">
											<input type="hidden" id="resguardo" name="resguardo" value="RG"></input>
											<input type="button" class="botonVerde cambioColor" id="desResguardo"  name="desResguardo" value="RESGUARDO"></input>
										</td>
									</tr>
									
									<tr align="center">
										<td nowrap="nowrap">
											<input type="hidden" id="deudaCasaComercial" name="deudaCasaComercial" value="DC"></input>
											<input type="button" class="botonVerde cambioColor" id="descDeudaCasaComer" name="descDeudaCasaComer" value="DEUDA CASA COMERCIAL"></input>
										</td>
									</tr>
									<tr align="center">
										<td nowrap="nowrap">
											<input type="hidden" id="porcentajeCapacidad" name="porcentajeCapacidad" value="PC"></input>
											<input type="button" class="botonVerde cambioColor" id="descPorcCapaci" name="descPorcCapaci" value="PORCENTAJE CAPACIDAD" ></input>
										</td>
									</tr>

								</table>
							</fieldset>
						</div>

						<div class="myDiv3">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<br><label class="label2">Operadores</label>
							<div align="center">
								<table>
									<br>
									<br>
									<tr align="center">
										<td>
											<input type="button" style="font-size:40px" id="operadorMas" name="operadorMas" class="operador cambioColor" value="+"></input>
										</td>
										<td>
											<input type="button" style="font-size:40px" id="operadorMeno" name="operadorMeno" class="operador cambioColor" value="-"></input>
										</td>
										<td>
											<input type="button" style="font-size:40px" id="operadorMult" name="operadorMult" class="operador cambioColor" value="*"></input>
										</td>
										<td>
											<input type="button" style="font-size:40px" id="operadorDiv" name="operadorDiv" class="operador cambioColor" value="/"></input>
										</td>
										<td>
											<input type="button" style="font-size:40px" id="operadorParantesi" name="operadorParantesi" class="operador cambioColor" value="("></input>
										</td>
										<td>
											<input type="button" style="font-size:40px" id="operadorParantesi2" name="operadorParantesi2" class="operador cambioColor" value=")"></input>
										</td>
									</tr>
								</table>
							</div>
							<br>
							<br>

							<div>
								<input type="hidden" id="formula" name="formula" readonly="true"></input>
								<textarea id="desFormula" name="desFormula" class="formula" style="font-size:25px" rows="4" cols="50" placeholder="Captura la Fórmula" readonly="true"></textarea>
							</div>
							<br>
							<br>

							<div>
								<input type="button" class="boton botonIzquierda cambioColor" style="font-size:30px" id="limpiar" name="limpiar" value="Limpiar Fórmula"></input>
							</div>
							<div>
								<input type="submit" class="submit botonDerecha" style="font-size:30px" id="grabar" name="grabar" value="Grabar" ></input>
								<input type="hidden" id="control" name="control" value="${param.control}"/>
							</div>
							</fieldset>
						</div>
					</div>
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

