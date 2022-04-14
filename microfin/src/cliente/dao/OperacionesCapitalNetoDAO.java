package cliente.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
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


import cliente.bean.OperacionesCapitalNetoBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class OperacionesCapitalNetoDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;

	public OperacionesCapitalNetoDAO(){
		super();
	}

	/* Lista de Solicitude por cliente para grid*/
	public List listaPrincipal(OperacionesCapitalNetoBean operCapitalNeto, int tipoLista) {
		String query = "call OPERCAPITALNETOLIS(?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = {
								operCapitalNeto.getPantallaOrigen(),
								operCapitalNeto.getOperacionID(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPERCAPITALNETOLIS(" + Arrays.toString(parametros) + ")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				OperacionesCapitalNetoBean operacionCapitalNeto= new OperacionesCapitalNetoBean();
				operacionCapitalNeto.setOperacionID(resultSet.getString("OperacionID"));
				operacionCapitalNeto.setFechaOperacion(resultSet.getString("FechaOperacion"));
				operacionCapitalNeto.setNombreCompleto(resultSet.getString("NombreCompleto"));
				operacionCapitalNeto.setEstatusOper(resultSet.getString("EstatusOper"));

				return operacionCapitalNeto;
			}
		});
		return matches;
	}

	//CONSULTA PRINCIPAL
	public OperacionesCapitalNetoBean consultaPrincipal(OperacionesCapitalNetoBean operCapitalNeto,int tipoConsulta) {
		OperacionesCapitalNetoBean operacionesCapitalNetoBea= new OperacionesCapitalNetoBean();
		try{
			/*Query con el Store Procedure */
			String query = "call OPERCAPITALNETOCON(?,?,?,?,?, 	"+
												   "?,?,?,?,?,	"+
												   "?	);";

			Object[] parametros = { operCapitalNeto.getPantallaOrigen(),
									Utileria.convierteEntero(operCapitalNeto.getOperacionID()),
								    Utileria.convierteEntero(operCapitalNeto.getInstrumentoID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,		//	aud_empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO };	//	numTransaccion

			/*Registra el  inf. del log */
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPERCAPITALNETOCON(" + Arrays.toString(parametros) + ")");


			/*E]ecuta el query y setea los valores al bean para obtener los datos de la consulta*/
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
						/*bean para setear los valores obtenidos de la ejecucion de la consulta */
						OperacionesCapitalNetoBean operacionCapitalNeto= new OperacionesCapitalNetoBean();
						operacionCapitalNeto.setOperacionID(resultSet.getString("OperacionID"));
						operacionCapitalNeto.setClienteID(resultSet.getString("ClienteID"));
						operacionCapitalNeto.setFechaOperacion(resultSet.getString("FechaOperacion"));
						operacionCapitalNeto.setProductoID(resultSet.getString("ProductoID"));
						operacionCapitalNeto.setCapitalNeto(resultSet.getString("CapitalNeto"));
						operacionCapitalNeto.setPorcentaje(resultSet.getString("Porcentaje"));
						operacionCapitalNeto.setMontoOper(resultSet.getString("MontoOper"));
						operacionCapitalNeto.setEstatusOper(resultSet.getString("EstatusOper"));
						operacionCapitalNeto.setComentario(resultSet.getString("Comentario"));
						operacionCapitalNeto.setOrigenOperacion(resultSet.getString("OrigenOperacion"));
						operacionCapitalNeto.setPantallaOrigen(resultSet.getString("PantallaOrigen"));
						operacionCapitalNeto.setInstrumentoID(resultSet.getString("InstrumentoID"));
						operacionCapitalNeto.setMensaje(resultSet.getString("Mensaje"));
						operacionCapitalNeto.setSucursalID(resultSet.getString("SucursalCliID"));

						return operacionCapitalNeto;
				}// trows ecexeption
			});//lista
			operacionesCapitalNetoBea= matches.size() > 0 ? (OperacionesCapitalNetoBean) matches.get(0) : null;

			/*Maneja la exception y registra el log de error */
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal Solicitud de Apoyo Escolar", e);
		}
		/*Retorna un objeto cargado de datos */
		return operacionesCapitalNetoBea;

	}


	//CONSULTA POR INSTRUMENTO
		public OperacionesCapitalNetoBean consultaInstrumento(OperacionesCapitalNetoBean operCapitalNeto,int tipoConsulta) {
			OperacionesCapitalNetoBean operacionesCapitalNetoBea= new OperacionesCapitalNetoBean();
			try{
				/*Query con el Store Procedure */
				String query = "call OPERCAPITALNETOCON(?,?,?,?,?, 	"+
													   "?,?,?,?,?,	"+
													   "?	);";

				Object[] parametros = { operCapitalNeto.getPantallaOrigen(),
										Utileria.convierteEntero(operCapitalNeto.getOperacionID()),
									    Utileria.convierteEntero(operCapitalNeto.getInstrumentoID()),
										tipoConsulta,
										Constantes.ENTERO_CERO,		//	aud_empresaID
										Constantes.ENTERO_CERO,		//	aud_usuario
										Constantes.FECHA_VACIA,		//	fechaActual
										Constantes.STRING_VACIO,	// 	direccionIP
										Constantes.STRING_VACIO, 	//	programaID
										Constantes.ENTERO_CERO,		// 	sucursal
										Constantes.ENTERO_CERO };	//	numTransaccion

				/*Registra el  inf. del log */
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPERCAPITALNETOCON(" + Arrays.toString(parametros) + ")");


				/*E]ecuta el query y setea los valores al bean para obtener los datos de la consulta*/
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
							/*bean para setear los valores obtenidos de la ejecucion de la consulta */
							OperacionesCapitalNetoBean operacionCapitalNeto= new OperacionesCapitalNetoBean();
							operacionCapitalNeto.setOperacionID(resultSet.getString("OperacionID"));
							operacionCapitalNeto.setClienteID(resultSet.getString("ClienteID"));
							operacionCapitalNeto.setFechaOperacion(resultSet.getString("FechaOperacion"));
							operacionCapitalNeto.setProductoID(resultSet.getString("ProductoID"));
							operacionCapitalNeto.setCapitalNeto(resultSet.getString("CapitalNeto"));
							operacionCapitalNeto.setPorcentaje(resultSet.getString("Porcentaje"));
							operacionCapitalNeto.setMontoOper(resultSet.getString("MontoOper"));
							operacionCapitalNeto.setEstatusOper(resultSet.getString("EstatusOper"));
							operacionCapitalNeto.setComentario(resultSet.getString("Comentario"));
							operacionCapitalNeto.setOrigenOperacion(resultSet.getString("OrigenOperacion"));
							operacionCapitalNeto.setPantallaOrigen(resultSet.getString("PantallaOrigen"));
							operacionCapitalNeto.setInstrumentoID(resultSet.getString("InstrumentoID"));
							operacionCapitalNeto.setMensaje(resultSet.getString("Mensaje"));
							operacionCapitalNeto.setSucursalID(resultSet.getString("SucursalCliID"));

							return operacionCapitalNeto;
					}// trows ecexeption
				});//lista
				operacionesCapitalNetoBea= matches.size() > 0 ? (OperacionesCapitalNetoBean) matches.get(0) : null;

				/*Maneja la exception y registra el log de error */
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal Solicitud de Apoyo Escolar", e);
			}
			/*Retorna un objeto cargado de datos */
			return operacionesCapitalNetoBea;

		}


		// METODO PARA EVALUAR EL PROCESO DE OPERACION DEL CAPITAL NETO
		public MensajeTransaccionBean evaluaProcesoOperCapital(final OperacionesCapitalNetoBean operCapitalNeto) {
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
										String query = "call OPERCAPITALNETOVALPRO( ?,?,?,?,?,   	"+
																				"?,?,?,?,?,		"+
																				"?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_InstrumentoID",Utileria.convierteEntero(operCapitalNeto.getInstrumentoID()));
										sentenciaStore.setDouble("Par_MontoMov", operCapitalNeto.getMontoMov());
										sentenciaStore.setString("Par_Origen",operCapitalNeto.getOrigenOperacion());
										sentenciaStore.setString("Par_PantallaOrigen",operCapitalNeto.getPantallaOrigen());

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPERCAPITALNETOVALPRO "+ sentenciaStore.toString());
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
											mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OperacionesCapitalNetoDAO.evaluaProcesoOperCapital");
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
								throw new Exception(Constantes.MSG_ERROR + " .OperacionesCapitalNetoDAO.evaluaProcesoOperCapital");
							}else if(mensajeBean.getNumero()!=0 && mensajeBean.getNumero()!=333){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al evaluar la operacion de capital neto" + e);
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


		// METODO PARA AUTORIZAR LOS PROCESOS DETECTADO DEL CAPITAL NETO
		public MensajeTransaccionBean autorizaOperCapitalNeto(final OperacionesCapitalNetoBean operCapitalNeto, final int numeroAct) {
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
										String query = "call OPERCAPITALNETOPRO( ?,?,?,?,?,   	"+
																				"?,?,?,?,?,		"+
																				"?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_OperacionID",Utileria.convierteEntero(operCapitalNeto.getOperacionID()));
										sentenciaStore.setInt("Par_InstrumentoID",Utileria.convierteEntero(operCapitalNeto.getInstrumentoID()));
										sentenciaStore.setString("Par_PantallaOrigen",operCapitalNeto.getPantallaOrigen());
										sentenciaStore.setString("Par_Montivo",operCapitalNeto.getComentario());
										sentenciaStore.setInt("Par_NumAct", numeroAct);

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPERCAPITALNETOPRO "+ sentenciaStore.toString());
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
											mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OperacionesCapitalNetoDAO.autorizaOperCapitalNeto");
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
								throw new Exception(Constantes.MSG_ERROR + " .OperacionesCapitalNetoDAO.autorizaOperCapitalNeto");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al autorizar la operacion de capital neto" + e);
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


		public ParametrosSesionBean getParametrosSesionBean() {
			return parametrosSesionBean;
		}

		public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
			this.parametrosSesionBean = parametrosSesionBean;
		}



}
