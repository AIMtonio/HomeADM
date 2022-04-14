package tarjetas.dao;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.net.ssl.HttpsURLConnection;

import mondrian.test.loader.DBLoader.Type;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import originacion.bean.ConsolidacionesBean;

import cliente.bean.ActividadesBMXBean;

import soporte.bean.ParamGeneralesBean;
import soporte.dao.ParamGeneralesDAO;
import tarjetas.bean.ExtraerTarjetasBean;
import tarjetas.servicio.ExtraccionTarjetasServicio;

public class ExtraerTarjetasDAO extends BaseDAO {

	public ExtraerTarjetasDAO(){
		super();
	}
	private ParamGeneralesDAO paramGeneralesDAO;
	ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;

	public MensajeTransaccionBean altaTarDebExtraccion(final int tipoTransaccion, final ExtraerTarjetasBean  extraerTarjetasBean) {
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
								String query = "call TARDEBEXTRACCIONALT(?,?,?,?,       ?,?,?,		?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_Tipo", extraerTarjetasBean.getTipo());
								sentenciaStore.setString("Par_NomArchivo", extraerTarjetasBean.getNomArchivo());
								sentenciaStore.setString("Par_NomArchivoZip", extraerTarjetasBean.getNomArchivoZip());

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_Consecutivo", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta del extracion de tarjetas", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List<ExtraerTarjetasBean> listaRutaFinal(ExtraerTarjetasBean extraerTarjetasBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TARDEBEXTRACCIONDETLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	extraerTarjetasBean.getTarDebExtraccionID(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ActividadesDAO.listaActividadesPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		//logeo de Query a ejecutar
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBEXTRACCIONDETLIS(" + Arrays.toString(parametros) + ")");
		List<ExtraerTarjetasBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ExtraerTarjetasBean bean = new ExtraerTarjetasBean();
				bean.setNomArchivoExt(resultSet.getString("NomArchivoExt"));
				return bean;
			}
		});

		return matches;
	}
	public MensajeTransaccionBean bajaTarDebExtraccion(final ExtraerTarjetasBean extraerTarjetasBean, final int tipoOperacion) {
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
								String query = "CALL TARDEBEXTRACCIONBAJ(?,"
																	   +"?,?,?,"
																	   +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);


								sentenciaStore.setInt("Par_TarDebExtraccionID", Utileria.convierteEntero(extraerTarjetasBean.getTarDebExtraccionID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "ConsolidacionesDAO.bajaConsolidacion");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Baja la extraccion del archivo", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public MensajeTransaccionBean bajaTmpTarDebExtraccion(final ExtraerTarjetasBean extraerTarjetasBean, final int tipoOperacion) {
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
								String query = "CALL TMPTARDEBEXTRACCIONBAJ(?,"
																	   +"?,?,?,"
																	   +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);


								sentenciaStore.setInt("Par_TarDebExtraccionID", Utileria.convierteEntero(extraerTarjetasBean.getTarDebExtraccionID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "ConsolidacionesDAO.bajaConsolidacion");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Baja la extraccion del archivo", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public MensajeTransaccionBean bajaTarDebExtraccionDet(final ExtraerTarjetasBean extraerTarjetasBean, final int tipoOperacion) {
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
								String query = "CALL TARDEBEXTRACCIONDETBAJ(?,"
																	   +"?,?,?,"
																	   +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);


								sentenciaStore.setInt("Par_TarDebExtraccionID", Utileria.convierteEntero(extraerTarjetasBean.getTarDebExtraccionID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "ConsolidacionesDAO.bajaConsolidacion");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Baja la extraccion del archivo", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean procesoEstraccion(ExtraerTarjetasBean extraerTarjetasBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();;
		String consecutivo = "";
		String rutaArchivo = extraerTarjetasBean.getRuta();
		ExtraerTarjetasBean extraerTarjetasBeanrequest = null;
		ExtraerTarjetasBean extraerTarjetasBeanResponse = null;
		String directorio ="";
		boolean comprimido;
		//Ejecucion de respues de buro
				try{
					String nombreArchivo = new File(rutaArchivo).getName();
					if(nombreArchivo.contains("EMI")){
						extraerTarjetasBean.setTipo("E");
					}else{
						extraerTarjetasBean.setTipo("S");
					}
					extraerTarjetasBean.setNomArchivo(nombreArchivo);
					extraerTarjetasBean.setNomArchivoZip(nombreArchivo+".zip");
					mensaje = altaTarDebExtraccion(1, extraerTarjetasBean);
					if(mensaje.getNumero() != 0){
						return mensaje;
					}
					consecutivo = mensaje.getConsecutivoString();
					int consultaRutaAplicacionesFondeo = 41;
					ParamGeneralesBean paramGeneralesBean = paramGeneralesDAO.consultaPrincipal(new ParamGeneralesBean(), consultaRutaAplicacionesFondeo);

					String rutaAplicacionExraccion = paramGeneralesBean.getValorParametro();

					File directorioEjecFondeo = new File(rutaAplicacionExraccion);
					if (!directorioEjecFondeo.exists()) {
						loggerSAFI.info(this.getClass()+" - "+"Configure la Carpeta donde se encuentran los Ejecutables para extraccion tarjetas.");
						throw new Exception("Configure la Carpeta donde se encuentran los Ejecutables para extraer tarjetas.");
					}

					String shProcesaRespuesta = rutaAplicacionExraccion + "ExtraccionArchivoTarjetas" + System.getProperty("file.separator") + "ExtraccionArchivoTarjetas.sh";

					File archivoSH = new File(shProcesaRespuesta);
					if(!archivoSH.exists()) {
						loggerSAFI.info(this.getClass()+" - "+"No se encontro el ejecutable para la extraccion de tarjetas.");
						throw new Exception("No se encontro el ejecutable para la extraccion de tarjetas.");
					}

					loggerSAFI.info(this.getClass()+" - "+"Datos:" + shProcesaRespuesta + "/" + consecutivo );

					String[] command = {"sh", shProcesaRespuesta, consecutivo };
					ProcessBuilder pb = new ProcessBuilder();
					pb.command(command);
					Process p = pb.start();
					p.waitFor();

					//Leemos salida del programa
					InputStream is = p.getInputStream();
					InputStreamReader isr = new InputStreamReader(is);
					BufferedReader br = new BufferedReader(isr);
					String line;
					String respuesta = null;
					while ((line = br.readLine()) != null) {
						respuesta = line;
					}

					String[] partes = respuesta.split("-");
					int codigoRespuesta = Integer.parseInt(partes[0]);
					String mensajeRespuesta = partes[1];

					loggerSAFI.info(this.getClass()+" - "+"Respuesta recibida del SH:" + respuesta);

					mensaje.setNumero(codigoRespuesta);
					mensaje.setDescripcion(mensajeRespuesta);

					if(mensaje.getNumero() == 0){
						ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
						directorio = parametros.getRutaArchivos()+"ExtraerTarjetas/"+nombreArchivo+".zip";

						extraerTarjetasBeanrequest = new ExtraerTarjetasBean();
						extraerTarjetasBeanrequest.setTarDebExtraccionID(consecutivo);
						List<ExtraerTarjetasBean> lista = listaRutaFinal(extraerTarjetasBeanrequest, 1);
						System.out.println("tamanio de l alista "+ lista.size());
						if(lista.size() ==0){
							mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(999);
							mensaje.setDescripcion("No se genero ningun archivo");
							return mensaje;
						}

						List<String> listaStr = new ArrayList<String>();
						for (int i = 0; i < lista.size(); i++) {
							extraerTarjetasBeanResponse = lista.get(i);
							listaStr.add(extraerTarjetasBeanResponse.getNomArchivoExt());
						}


						comprimido = Utileria.zipFiles(directorio, listaStr);

					}

					mensaje.setCampoGenerico(nombreArchivo+".zip");
					mensaje.setConsecutivoString(directorio);

				}catch(Exception e){
					e.printStackTrace();

					if(mensaje != null){
						extraerTarjetasBean.setTarDebExtraccionID(consecutivo);
						mensaje = bajaTarDebExtraccionDet(extraerTarjetasBean, 1);
						mensaje = bajaTmpTarDebExtraccion(extraerTarjetasBean, 1);
						mensaje = bajaTarDebExtraccion(extraerTarjetasBean, 1);
					}



					mensaje.setNumero(999);
					mensaje.setDescripcion("Error al Intentar Extraer ls tarjetas. "+e);
				}

		return mensaje;
	}

	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}

	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}

}
