package soporte.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.ParamGeneralesBean;

public class ParamGeneralesDAO extends BaseDAO {

	public ParamGeneralesDAO(){
		super();
	}

	public static interface Enum_Con_ParamGenerales {
		int	KTRCargaListas					= 6;
		int busquedaListasJOB 				= 7;
		int	KTRArchivosPerd					= 15;
		int	RutaPropConexionesSAFI			= 16;
		int	KTRArchivosMonitoreo			= 17;
		int	IPServidorGeneracionEdoCta		= 18;
		int	UsuarioServidorGeneracionEdoCta	= 19;
		int	KTRCondonacionMasiva			= 21;
		int	KTRCastigoMasivo				= 22;

		int RutaArchivosCampania 			= 28;
		int RutaEjecutablesCampania 		= 29;
		int RutaArchivosNomina 				= 47;
		int RutaEjecutablesNomina 			= 48;
		int RutaLogsTomcat 					= 49;
		int RutaArchivosPoliza 				= 51;
		int RutaEjecutablesPoliza 			= 52;
		int RutaMicrofinWSBancas 			= 55;
		int AutentificacionWSBancas 		= 56;

		int RutaArchivoCargaFacturas		= 100;
		int RutaEjecutableCargaFacturas		= 101;
		int ParamBusquedaLV					= 104;
		int ParamPorcentajeMinLV			= 105;
	}

	public static interface Enum_Lis_ParamGenerales{
		int lisParamGeneralesSFTP = 3;
	}

	/* Consuta Principal (por empresaID), obtiene todos los parametros de caja*/
	public ParamGeneralesBean consultaPrincipal(ParamGeneralesBean paramGenerales,int tipoConsulta) {
		ParamGeneralesBean paramGeneralesBean= new ParamGeneralesBean();
		try{
			/*Query con el Store Procedure */
			String query = "call PARAMGENERALESCON(?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO };	//	numTransaccion


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMGENERALESCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
							ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();

							paramGeneralesBean.setLlaveParametro(resultSet.getString("LlaveParametro"));
							paramGeneralesBean.setValorParametro(resultSet.getString("ValorParametro"));
							return paramGeneralesBean;

						}
			});// fin de consulta
			paramGeneralesBean= matches.size() > 0 ? (ParamGeneralesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de parametros caja", e);
		}

		return paramGeneralesBean;
	}// consultaPrincipal


	/* Consulta Parámetros para PDM */
	public Map<String, String> consultaPDM(int tipoConsulta) {
		Map<String, String> parametrosPDM = new HashMap<String, String>();
		try{
			/*Query con el Store Procedure */
			String query = "call PARAMGENERALESCON(?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO };	//	numTransaccion


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMGENERALESCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
							ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();

							paramGeneralesBean.setLlaveParametro(resultSet.getString("LlaveParametro"));
							paramGeneralesBean.setValorParametro(resultSet.getString("ValorParametro"));
							return paramGeneralesBean;

						}
			});// fin de consulta
			for(int i=0; i < matches.size(); i++){
				ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
				paramGeneralesBean = (ParamGeneralesBean)matches.get(i);
				parametrosPDM.put(paramGeneralesBean.getLlaveParametro(), paramGeneralesBean.getValorParametro());
			}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de parametros caja", e);
		}

		return parametrosPDM;
	}

	/**
	 * Modificación de Parámetros.
	 * @param parametroBean {@linkplain ParamGeneralesBean} con los valores de entrada al SP-PARAMGENERALESACT.
	 * @param tipoActualizacion Número de actualización.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la trasacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean actualiza(final ParamGeneralesBean parametroBean,final int tipoActualizacion) {
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
									String query = "call PARAMGENERALESMOD("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_llaveParametro", parametroBean.getLlaveParametro());
									sentenciaStore.setString("Par_ValorParametro", parametroBean.getValorParametro());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							});
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
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Genera el Número de Transacción.
	 * @return el Número de Transacción.
	 * @author pmontero
	 */
	public long getNumTransaccion(){
		return transaccionDAO.generaNumeroTransaccionOut();
	}

	/*************************************************** Consulta de Parametros Generales de Calixta *****************************************************/
	public List listaParamGeneral(ParamGeneralesBean paramGeneralesBean, int tipoLista){
		List lista = null;
		try{
			String query = "CALL PARAMGENERALESLIS(?,			?,?,?,?,?,?,?);";
			Object[] parametros = {
						tipoLista,
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"ParamGeneralesDAO.listaParamGeneral",
						parametrosAuditoriaBean.getSucursal(),
						Constantes.ENTERO_CERO
						};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMGENERALESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();

					paramGeneralesBean.setLlaveParametro(resultSet.getString("LlaveParametro"));
					paramGeneralesBean.setValorParametro(resultSet.getString("ValorParametro"));
					return paramGeneralesBean;
				}
			});
		lista= matches;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de Parametros Calixta ", e);
		}
		return lista;
	}

	/*************************************************** Actualizacion de Parametros Generales  *****************************************************/
	public MensajeTransaccionBean actualizaParamGenerales(final ParamGeneralesBean paramGeneralesBean, final int tipoActualizacion)  {
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		//Abrimos transaccion
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeTransaccionBean = null;
				try {

					if(paramGeneralesBean.getLlavesParametros() == null || paramGeneralesBean.getLlavesParametros().size() == 0||
						paramGeneralesBean.getValoresParametros() == null || paramGeneralesBean.getValoresParametros().size() == 0 ) {
						mensajeTransaccionBean = new MensajeTransaccionBean();
						mensajeTransaccionBean.setNumero(999);
						mensajeTransaccionBean.setDescripcion("Especifique las Respuestas a Actualizar");
						return mensajeTransaccionBean;
					}

					if(paramGeneralesBean.getLlavesParametros().size()  != paramGeneralesBean.getValoresParametros().size()  ) {
						mensajeTransaccionBean = new MensajeTransaccionBean();
						mensajeTransaccionBean.setNumero(999);
						mensajeTransaccionBean.setDescripcion("No Coincide la Cantidad de Respuestas con sus Valores a Actualizar");
						return mensajeTransaccionBean;
					}

					for(int i = 0; i < paramGeneralesBean.getLlavesParametros().size(); i++) {
						String llaveParametro = paramGeneralesBean.getLlavesParametros().get(i);
						String valorParametro = paramGeneralesBean.getValoresParametros().get(i);

						ParamGeneralesBean bean = new ParamGeneralesBean();
						bean.setLlaveParametro(llaveParametro);
						bean.setValorParametro(valorParametro);

						mensajeTransaccionBean =  actualizaParametroGenerales(bean, tipoActualizacion);
						if(mensajeTransaccionBean.getNumero() != 0) {
							throw new Exception(mensajeTransaccionBean.getDescripcion());
						}
					}
				}
				catch (Exception e) {
					if (mensajeTransaccionBean.getNumero() == 0) {
						mensajeTransaccionBean.setNumero(999);
					}
					mensajeTransaccionBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error al actualizar los Parametros  de Configuración", e);
				}

				return mensajeTransaccionBean;
			}
		});
		return mensajeResultado;
	}

	/***************************************************** ACTUALIZA EL VALOR DE PARAMETROS GENERALES **************************************************/
	public MensajeTransaccionBean actualizaParametroGenerales(final ParamGeneralesBean paramGeneralesBean,final int tipoActualizacion) {
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
								String query = "call PARAMGENERALESACT(?,?,?,?,?,	?,?,?,?,?, ?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_LlaveParametro",paramGeneralesBean.getLlaveParametro());
								sentenciaStore.setString("Par_ValorParametro",paramGeneralesBean.getValorParametro());
								sentenciaStore.setInt("Par_NumActualiza",tipoActualizacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","ParamGeneralesDAO.actualizaParametroGenerales");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ParamGeneralesDAO.actualizaParametroGenerales");
								}

								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. Error al actualizar la respuesta.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

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



}//class
