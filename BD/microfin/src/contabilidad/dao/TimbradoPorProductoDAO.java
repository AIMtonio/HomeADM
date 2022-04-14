package contabilidad.dao;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;
import contabilidad.bean.TimbradoPorProductoBean;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TimbradoPorProductoDAO extends BaseDAO{
	ParametrosSisServicio parametrosSisServicio;
	ParametrosSisBean parametrosSisBean;

	public TimbradoPorProductoDAO() {
		super();
	}

	public static interface Enum_TipoGeneraEdoCta {
		String mensual 		= "M";
		String semestral	= "S";
	}
	public static interface Enum_MesGeneracionEdoCta {
		int cincoMeses	= 5;
		int junio 		= 6;
		int diciembre	= 12;
	}
	public static interface Enum_Con_EdoCta {
		int principal 	= 1;
		int paramEdoCta	= 5;
	}

	public static interface Enum_Con_Cli {
		int principal 	= 1;
		int foranea 	= 2;
	}
	public static interface Enum_Act_EdoCta {
		int estEdoCtaXCli = 3;
		int estatusTimProdMes = 1;
		int estatusTimProdSem = 2;
		int estEdoCtaXProd  = 5;
	}

	public TimbradoPorProductoBean consultaTimbradoProd(int tipoConsulta, TimbradoPorProductoBean timbradoPorProductoBean){
		TimbradoPorProductoBean timbradoPorProducto = null;
		try{
			String query="CALL EDOCTAESTATUSTIMPRODCON(?,?,?,?,?,	?,?,?,?,?,	?,?,?)";
			Object [] parametros={
					Utileria.convierteEntero(timbradoPorProductoBean.getProductoCredID()),
					Utileria.convierteEntero(timbradoPorProductoBean.getAnio()),
					Utileria.convierteEntero(timbradoPorProductoBean.getMesInicioGen()),
					Utileria.convierteEntero(timbradoPorProductoBean.getMesFinGen()),
					Utileria.convierteEntero(timbradoPorProductoBean.getSemestre()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL EDOCTAESTATUSTIMPRODCON("+Arrays.toString(parametros)+")");
			@SuppressWarnings({ "unchecked", "rawtypes" })
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet,int numRow) throws SQLException{
					TimbradoPorProductoBean timbradoProd=new TimbradoPorProductoBean();
					timbradoProd.setTimbrado(resultSet.getString("Timbrado"));
					return timbradoProd;
				}
			});
			timbradoPorProducto= matches.size() > 0 ? (TimbradoPorProductoBean) matches.get(0) : null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el metodo consultaMetodo de ProrrateoContable "+e);
		}
		return timbradoPorProducto;
	}

	/*PROCESO DE GENERAR CADENA DE CREDICLUB*/
	public MensajeTransaccionBean generacionCadenasCrediClub(final TimbradoPorProductoBean timbradoPorProductoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		try {
			timbradoPorProductoBean.setAnioGeneracion(timbradoPorProductoBean.getAnio());
			if(timbradoPorProductoBean.getTipoGeneracion().equals("M") ){
				timbradoPorProductoBean.setMesInicioGen(timbradoPorProductoBean.getMes());
				timbradoPorProductoBean.setMesFinGen(timbradoPorProductoBean.getMes());
				timbradoPorProductoBean.setFechaProceso(timbradoPorProductoBean.getAnio()+timbradoPorProductoBean.getMesInicioGen());
			}
			else{
				timbradoPorProductoBean.setFechaProceso(timbradoPorProductoBean.getAnio()+timbradoPorProductoBean.getMesInicioGen()+timbradoPorProductoBean.getMesFinGen());
			}

			TimbradoPorProductoBean generaEdoCtaMen = new TimbradoPorProductoBean();
			generaEdoCtaMen = consultaEdoCtaPerMenEjecutado(timbradoPorProductoBean, Enum_Con_EdoCta.principal);
			//if(timbradoPorProductoBean.getTipoGeneracion().equals(Enum_TipoGeneraEdoCta.semestral)){
			if(generaEdoCtaMen == null){
				mensaje.setNumero(999);
				mensaje.setDescripcion("No Existe Información sobre el Semestre Seleccionado");
			} else {
				ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
				parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_EdoCta.paramEdoCta, parametrosSisBean);
				timbradoPorProductoBean.setTimbraEdoCta(parametrosSisBean.getTimbraEdoCta());

				//Editamos los parametros de conexion de ETL
				mensaje = editaParamsConexionETL(timbradoPorProductoBean);
				if(mensaje.getNumero() != 0){
					throw new Exception(mensaje.getDescripcion());
				}

				//Consulta historial de generacion de estados de cuenta
				mensaje = consultaHistorialGenEdoCta(timbradoPorProductoBean);
				if(mensaje.getNumero() != 0){
					throw new Exception(mensaje.getDescripcion());
				}
				//Consulta informacion disponible para la Fecha Seleccionada
				mensaje = validaInfoCliente(timbradoPorProductoBean);

				if(mensaje.getNumero() != 0){
					throw new Exception(mensaje.getDescripcion());
				}

				if(timbradoPorProductoBean.getTimbraEdoCta().equals(timbradoPorProductoBean.TimbraEdoCtaSI)){
					mensaje = consultaInfoClienteCrediclub(timbradoPorProductoBean);
					if(mensaje.getNumero() != 0){
						throw new Exception(mensaje.getDescripcion());
					}
				}


			}
			//}
		} catch (Exception e) {
			if (mensaje.getNumero()==0) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al realizar la Generación de Cadenas");
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la Generación de Cadenas");
		}

		return mensaje;
	}


	/*PROCESO DE TIMBRADO DE CREDICLUB*/
	public MensajeTransaccionBean realizarTimbradoCrediClub(final TimbradoPorProductoBean timbradoPorProductoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		try {
			timbradoPorProductoBean.setAnioGeneracion(timbradoPorProductoBean.getAnio());
			if(timbradoPorProductoBean.getTipoGeneracion().equals("M") ){
				timbradoPorProductoBean.setMesInicioGen(timbradoPorProductoBean.getMes());
				timbradoPorProductoBean.setMesFinGen(timbradoPorProductoBean.getMes());
			}


			TimbradoPorProductoBean generaEdoCtaMen = new TimbradoPorProductoBean();
			generaEdoCtaMen = consultaEdoCtaPerMenEjecutado(timbradoPorProductoBean, Enum_Con_EdoCta.principal);

			if(generaEdoCtaMen == null){

				if(timbradoPorProductoBean.getTipoGeneracion().equals("M") ){
					mensaje.setNumero(999);
					mensaje.setDescripcion("No Existe Información sobre el Mes Seleccionado");
				}
				else{
					mensaje.setNumero(999);
					mensaje.setDescripcion("No Existe Información sobre el Semestre Seleccionado");
				}

			} else  {
				//Valida que el usuario y password para conectar al PAC esten capturados
				ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
				parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_EdoCta.paramEdoCta, parametrosSisBean);
				timbradoPorProductoBean.setUsuarioWS(parametrosSisBean.getUsuarioFactElect());
				timbradoPorProductoBean.setPasswordWS(parametrosSisBean.getPassFactElec());
				timbradoPorProductoBean.setTimbraEdoCta(parametrosSisBean.getTimbraEdoCta());


				//Editamos los parametros de conexion de ETL
				mensaje = editaParamsConexionETL(timbradoPorProductoBean);
				if(mensaje.getNumero() != 0){
					throw new Exception(mensaje.getDescripcion());
				}

				//Realizamos timbrado de Edo De Cuentas
				if (timbradoPorProductoBean.getTimbraEdoCta().equals(timbradoPorProductoBean.TimbraEdoCtaSI)){
					mensaje= realizaTimbradoCrediclub(timbradoPorProductoBean);

					if(mensaje.getNumero() != 0){
						throw new Exception("Error en la realización del Timbrado");
					}else{
						//CONCADENACION DE ANIO Y MES
						String anioMesStr = timbradoPorProductoBean.getAnio() + timbradoPorProductoBean.getMesInicioGen();
						if(Utileria.convierteEntero(timbradoPorProductoBean.getMesInicioGen()) < Utileria.convierteEntero(timbradoPorProductoBean.getMesFinGen())){
							anioMesStr = anioMesStr + timbradoPorProductoBean.getMesFinGen();
						}
						timbradoPorProductoBean.setAnioGeneracion(anioMesStr);

						//Se actualiza el estatus de timbrado del cliente en ENVIOMENSAJECORREO
						mensaje=actualizaEstEdoCtaProducto(timbradoPorProductoBean);

						if(mensaje.getNumero() != 0){
							throw new Exception(mensaje.getDescripcion());
						}else{
							//Obtenemos numero de Timbrados Exitosos
							timbradoPorProductoBean.setTotalTimbrados(mensaje.getConsecutivoInt());
							//ACTUALIZAMOS EL ESTATUS DE TIMBRADO POR PRODUCTO
							if(Utileria.convierteEntero(timbradoPorProductoBean.getSemestre())==0){
								mensaje=actualizaEstPorProd(timbradoPorProductoBean, Enum_Act_EdoCta.estatusTimProdMes);
							}else{
								mensaje=actualizaEstPorProd(timbradoPorProductoBean, Enum_Act_EdoCta.estatusTimProdSem);
							}

							if(mensaje.getNumero() != 0){
								throw new Exception(mensaje.getDescripcion());
							}else{
								mensaje.setNumero(0);
								mensaje.setDescripcion("Se realizo el timbrado de los producto correctamente");
							}
						}

					}
				}
			}
		} catch (Exception e) {
			if(mensaje==null){
				mensaje= new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error en la realización del Timbrado");
			}
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error en la realización del Timbrado");
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la realización del Timbrado");
		}

		return mensaje;
	}


	public TimbradoPorProductoBean consultaEdoCtaPerMenEjecutado(final TimbradoPorProductoBean timbradoPorProductoBean,int tipoConsulta) {
		TimbradoPorProductoBean generaEdo= new TimbradoPorProductoBean();
		try{
			//Query con el Store Procedure
			String query = "call EDOCTAPERMENEJECUTADOSCON(?,?,?,?,		?," +
															"?,?,?,?,?,?,?);";

			Object[] parametros = {
									Utileria.convierteEntero(timbradoPorProductoBean.getAnioGeneracion()),
									Utileria.convierteEntero(timbradoPorProductoBean.getMesInicioGen()),
									Utileria.convierteEntero(timbradoPorProductoBean.getMesFinGen()),
									timbradoPorProductoBean.getTipoGeneracion(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAPERMENEJECUTADOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					TimbradoPorProductoBean generaEdoCta = new TimbradoPorProductoBean();
					generaEdoCta.setAnioGeneracion(resultSet.getString("Anio"));
					generaEdoCta.setMesInicioGen(resultSet.getString("MesInicio"));
					generaEdoCta.setMesFinGen(resultSet.getString("MesFin"));
					generaEdoCta.setTipoGeneracion(resultSet.getString("Tipo"));
					return generaEdoCta;
				}// throws exception
			});//lista

			generaEdo= matches.size() > 0 ? (TimbradoPorProductoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta ", e);
		}
		return generaEdo;
	}

	public MensajeTransaccionBean consultaHistorialGenEdoCta(final TimbradoPorProductoBean timbradoPorProductoBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//Valida que se haya realizado el timbrado correspondiente antes de generar los estados de cuenta
		TimbradoPorProductoBean generaEdoCtaMen = new TimbradoPorProductoBean();
		generaEdoCtaMen = consultaEdoCtaPerMenEjecutado(timbradoPorProductoBean, Enum_Con_EdoCta.principal);
		if(timbradoPorProductoBean.getTipoGeneracion().equals(Enum_TipoGeneraEdoCta.semestral)){
			if(generaEdoCtaMen == null){
				mensaje.setNumero(999);
				mensaje.setDescripcion("No Existe Información sobre el Semestre Seleccionado");
			}
		}
		if(timbradoPorProductoBean.getTipoGeneracion().equals(Enum_TipoGeneraEdoCta.mensual)){
			if(generaEdoCtaMen == null){
				mensaje.setNumero(999);
				mensaje.setDescripcion("No Existe Información sobre el Mes Seleccionado");
			}
			if(Utileria.convierteEntero(timbradoPorProductoBean.getMesFinGen()) == Enum_MesGeneracionEdoCta.junio ||
			   Utileria.convierteEntero(timbradoPorProductoBean.getMesFinGen()) == Enum_MesGeneracionEdoCta.diciembre){
				timbradoPorProductoBean.setTipoGeneracion(Enum_TipoGeneraEdoCta.semestral);
				int mesInicioSemestre = Utileria.convierteEntero(timbradoPorProductoBean.getMesFinGen()) - Enum_MesGeneracionEdoCta.cincoMeses;
				timbradoPorProductoBean.setMesInicioGen(String.valueOf(mesInicioSemestre));
				generaEdoCtaMen = consultaEdoCtaPerMenEjecutado(timbradoPorProductoBean, Enum_Con_EdoCta.principal);
				if(generaEdoCtaMen != null){
					mensaje.setNumero(999);
					mensaje.setDescripcion("No Existe Información sobre el Mes Seleccionado debido a la existencia de Informacion Semestral.");
				}
				timbradoPorProductoBean.setTipoGeneracion(Enum_TipoGeneraEdoCta.mensual);
				timbradoPorProductoBean.setMesInicioGen(timbradoPorProductoBean.getMesFinGen());
			}
		}
		return mensaje;
	}


	//Consulta informacion de todos los clientes para generar CFDI a traves de un ETL para el cliente Crediclub
	public MensajeTransaccionBean editaParamsConexionETL(final TimbradoPorProductoBean generaEdoCtaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String linea;
		List<String> lineas = new ArrayList<String>();
		//Ejecucion de Estado de Cuentas
		try{
			//Se modifica el archivo de conexiones para insertar las sucursales
			//colocadas en la pantalla
			File fichero = new File("/opt/SAFI/EdoCta/Crediclub/Conexiones.properties");
			FileReader freader = new FileReader(fichero);
			BufferedReader archivo = new BufferedReader(freader);
			while ((linea = archivo.readLine()) != null) {
				if (linea.contains("V.SUC.INI=")){
					linea = linea.replaceAll("[0-9]", "");
					linea = linea.concat(""+Constantes.ENTERO_CERO);
					//linea = linea.concat(generaEdoCtaBean.getSucursalInicio());
				}
				if (linea.contains("V.SUC.FIN=")){
					linea = linea.replaceAll("[0-9]", "");
					linea = linea.concat(""+Constantes.ENTERO_CERO);
					//linea = linea.concat(generaEdoCtaBean.getSucursalInicio());
				}
				if (linea.contains("V.CLIENTEID=")){
					linea = linea.replaceAll("[0-9]", "");
					linea = linea.concat(""+Constantes.ENTERO_CERO);
				}

				if (linea.contains("V.PRODUCTOS=")){
					//linea = linea.replaceAll("[0-9]", "");
					linea = linea.replaceAll("[0-9]", "");
					linea = linea.replaceAll("'", "");
					linea = linea.replaceAll(",", "");
					linea = linea.concat(""+generaEdoCtaBean.getProductos());
				}

				linea = linea.concat("\n");
				lineas.add(linea);
			}
			freader.close();
			archivo.close();

			FileWriter fw = new FileWriter(fichero);
			BufferedWriter out = new BufferedWriter(fw);
			for(String s : lineas)
				out.write(s);
			out.flush();
			out.close();
			mensaje.setNumero(0);
			mensaje.setDescripcion("Edicion de parametros de conexion con ETL Finalizado con exito");
		}catch(IllegalThreadStateException e){
			mensaje.setNumero(Integer.valueOf("001"));
			mensaje.setDescripcion("Error al Editar parametros de conexion del ETL");
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en edicion de parametros de conexion ", e);
		}
		return mensaje;
	}


	public MensajeTransaccionBean validaInfoCliente(final TimbradoPorProductoBean generaEdoCtaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					TimbradoPorProductoBean generaEdoCta = new TimbradoPorProductoBean();
					generaEdoCta = consultaClientesPorProd(generaEdoCtaBean, Enum_Con_Cli.foranea);
					if (Integer.valueOf(generaEdoCta.getNumRegistros()) == Constantes.ENTERO_CERO){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("No Existe Información sobre la Fecha Seleccionada");
						throw new Exception(mensajeBean.getDescripcion());
					}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Error en Validacion de Informacion sobre la Fecha Seleccionada");
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					//e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Validacion de Informacion sobre la Fecha Seleccionada", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//TOMAR EL NUMERO DE REGISTROS QUE SE REGISTRARIN
	public TimbradoPorProductoBean consultaClientesPorProd(TimbradoPorProductoBean generaEdoCta, int tipoConsulta) {
		TimbradoPorProductoBean generaEdoCtaBean= new TimbradoPorProductoBean();
		try{
			//Query con el Store Procedure
			String query = "call EDOCTADATOSCTECON(?,?,?,?," +
													"?,?,?," +
													"?,?,?,?,?);";

			Object[] parametros = {
									generaEdoCta.getFechaProceso(),
									Utileria.convierteEntero(generaEdoCta.getSucursalInicio()),
									Utileria.convierteEntero(generaEdoCta.getSucursalFin()),
									generaEdoCta.getProductos(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTADATOSCTECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TimbradoPorProductoBean generaEdoCta = new TimbradoPorProductoBean();
					generaEdoCta.setNumRegistros(resultSet.getString("NumRegistros"));
					return generaEdoCta;
				}// trows ecexeption
			});//lista

			generaEdoCtaBean= matches.size() > 0 ? (TimbradoPorProductoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta ", e);
		}
		return generaEdoCtaBean;
	}


	//Consulta informacion de todos los clientes para generar CFDI a traves de un ETL para el cliente Crediclub
	public MensajeTransaccionBean consultaInfoClienteCrediclub(final TimbradoPorProductoBean generaEdoCtaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//Ejecucion de Estado de Cuentas
		try{
			generaEdoCtaBean.setSucursalInicio("0");

			ProcessBuilder pb = new ProcessBuilder("/bin/bash", "./EdoctaSafi_SoloCadenaCFDI.sh", generaEdoCtaBean.getFechaProceso(),
													generaEdoCtaBean.getSucursalInicio(), generaEdoCtaBean.getSucursalInicio(), Constantes.ENTERO_CERO+"",
													generaEdoCtaBean.getProductos()+"");
			pb.directory(new File("/opt/SAFI/EdoCta/Crediclub/"));
			Process p = pb.start();
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			String line;
			while ((line = br.readLine()) != null) {
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Ejecucion de JOB de generacion de cadenas: " + line);
			}
			mensaje.setNumero(0);
			mensaje.setDescripcion("Generacion de Cadenas CFDI finalizada Correctamente");
		}catch(IllegalThreadStateException e){
			mensaje.setNumero(Integer.valueOf("001"));
			mensaje.setDescripcion("Error al Generar Cadenas CFDI del cliente solicitado");
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de cadena CFDI ", e);
		}
		return mensaje;
	}


	//Realiza el timbrado del rango de sucursales parametrizado en pantalla
	public MensajeTransaccionBean realizaTimbradoCrediclub(final TimbradoPorProductoBean generaEdoCtaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String linea;
		List<String> lineas = new ArrayList<String>();
		//Ejecucion de Estado de Cuentas
		try{
			ProcessBuilder pb = new ProcessBuilder("/bin/bash", "./EdoctaSafi_SoloTimbre.sh");
			pb.directory(new File("/opt/SAFI/EdoCta/Crediclub/"));
			Process p = pb.start();
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader bufferedR = new BufferedReader(isr);
			String line;
			while ((line = bufferedR.readLine()) != null) {
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Ejecucion de JOB de generacion de cadenas: " + line);
			}

			mensaje.setNumero(0);
			mensaje.setDescripcion("Timbrado de Cuentas ha Finalizado Correctamente");
		}catch(IllegalThreadStateException e){
			mensaje.setNumero(Integer.valueOf("001"));
			mensaje.setDescripcion("Error al Timbrar las Cuentas de los Productos Solicitados");
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de cadena CFDI ", e);
			mensaje.setDescripcion("Error al Timbrar las Cuentas de los Productos Solicitados");
		}
		return mensaje;
	}


	/**
	 * Funcion para actualizar el estatus del estado de cuenta de un cliente en base a la tabla EDOCTADATOSCTE.
	 *
	 * @param generaEdoCta: Bean con los datos para actualizar el estatus.
	 * @return MensajeTransaccionBean
	 */
	//ACTUALIZACION DE ESTATUS DE ENVIO DE CORREO
	public MensajeTransaccionBean actualizaEstEdoCtaProducto(final TimbradoPorProductoBean generaEdoCta) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call EDOCTAENVIOCORREOACT(" +
																"?,?,?,?,?, 	?,?,?,?,?," +
																"?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_AnioMes",Utileria.convierteEntero(generaEdoCta.getAnioGeneracion()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(generaEdoCta.getClienteID()));
								sentenciaStore.setString("Par_FechaEnvio",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Productos",generaEdoCta.getProductos());
								sentenciaStore.setInt("Par_NumAct",Enum_Act_EdoCta.estEdoCtaXProd);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","TimbradoPorProductoDAO.actualizaEstEdoCtaProducto");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TimbradoPorProductoDAO.actualizaEstEdoCtaProducto");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .TimbradoPorProductoDAO.actualizaEstEdoCtaProducto");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion estatus de envio de correo" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//ACTUALIZACION DE ESTATUS DE CONTROL DE TIMBRADO POR PRODUCT
	public MensajeTransaccionBean actualizaEstPorProd(final TimbradoPorProductoBean generaEdoCta, final int tipoActualizacion) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call EDOCTAESTATUSTIMPRODACT(" +"?,?,?,?,?,		?,?,?,?,?," +
																				"?,?,?,?,?,		?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(generaEdoCta.getAnio()));
									sentenciaStore.setInt("Par_MesInicio",Utileria.convierteEntero(generaEdoCta.getMesInicioGen()));
									sentenciaStore.setInt("Par_MesFin",Utileria.convierteEntero(generaEdoCta.getMesFinGen()));
									sentenciaStore.setString("Par_Productos",generaEdoCta.getProductos());
									sentenciaStore.setInt("Par_Semestre",Utileria.convierteEntero(generaEdoCta.getSemestre()));
									sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","GeneraEdoCtaDAO.actualizaEstPorProd");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

						        return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TimbradoPorProductoDAO.actualizaEstEdoCtaProducto");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .TimbradoPorProductoDAO.actualizaEstEdoCtaProducto");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de estatus de timbrado por producto" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}


	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}


	public ParametrosSisBean getParametrosSisBean() {
		return parametrosSisBean;
	}


	public void setParametrosSisBean(ParametrosSisBean parametrosSisBean) {
		this.parametrosSisBean = parametrosSisBean;
	}





}
